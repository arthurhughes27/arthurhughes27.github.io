#!/usr/bin/env Rscript
# Check that every local link in the site resolves to an existing file.
#
#   Rscript scripts/check_links.R
#
# Checks the .Rmd sources (relative to the repo root) and the built pages in
# docs/ (relative to each page). The check is case-sensitive on purpose:
# GitHub Pages is, but macOS and Windows are not, so a link such as
# "supervisedLearning" to a file called "supervisedlearning" works locally and
# 404s once deployed. Uses base R only. Exits with status 1 if anything is missing.

# does `path` exist, matching the case of every path component?
exists_exact <- function(path) {
  parts <- strsplit(normalizePath(path, winslash = "/", mustWork = FALSE), "/", fixed = TRUE)[[1]]
  current <- if (nzchar(parts[1])) parts[1] else "/"      # "/" on unix, "C:" on windows
  for (part in parts[-1]) {
    if (!nzchar(part)) next
    if (!part %in% list.files(current, all.files = TRUE, no.. = TRUE)) return(FALSE)
    current <- file.path(current, part)
  }
  TRUE
}

# local link targets found in a file's text
link_targets <- function(text, is_html) {
  if (is_html) text <- gsub("(?s)<(script|style)\\b.*?</\\1>", "", text, perl = TRUE)
  found <- character()
  for (pattern in c("(?:href|src)=\"([^\"]+)\"", "\\]\\(([^)\\s]+)\\)")) {
    m <- regmatches(text, gregexpr(pattern, text, perl = TRUE))[[1]]
    found <- c(found, sub(pattern, "\\1", m, perl = TRUE))
  }
  found <- found[!grepl("^(https?:|mailto:|javascript:|data:|#|\\{)", found)]
  unique(utils::URLdecode(sub("[#?].*$", "", found)))
}

files <- c(list.files(".", pattern = "\\.Rmd$", full.names = TRUE),
           list.files("docs", pattern = "\\.html$", full.names = TRUE),
           list.files("docs/posts", pattern = "\\.html$", full.names = TRUE, recursive = TRUE))
files <- files[!grepl("^\\./(practicals|docs/practicals)/", files)]   # course material links to its own data

missing <- character()
for (f in files) {
  text <- paste(readLines(f, warn = FALSE, encoding = "UTF-8"), collapse = "\n")
  base <- dirname(f)
  for (target in link_targets(text, grepl("\\.html$", f))) {
    if (!nzchar(target)) next
    # a leading "/" means "from the site root": docs/ for built pages, the repository root for sources
    root <- if (grepl("\\.html$", f)) "docs" else "."
    path <- if (startsWith(target, "/")) file.path(root, sub("^/+", "", target)) else file.path(base, target)
    if (!exists_exact(path)) missing <- c(missing, sprintf("%s -> %s", f, target))
  }
}

if (length(missing)) {
  cat("Broken local links:\n", paste0("  ", missing, collapse = "\n"), "\n", sep = "")
  quit(status = 1)
}
cat("All local links resolve (", length(files), " files checked).\n", sep = "")
