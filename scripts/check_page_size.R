#!/usr/bin/env Rscript
# Check that the built pages can be read completely by search engines (size, description, canonical link).
#
#   Rscript scripts/check_page_size.R
#
# Googlebot only fetches the first 2 MB of an HTML file (uncompressed) and ignores the rest.
# The <body> comes after everything that is embedded in the <head>, so a page that is too big
# is indexed as if it had no text, no links and no description. Self-contained R Markdown pages
# can easily reach 6 MB (embedded fonts, Font Awesome, images), which is what .Rprofile and the
# self-hosted fonts in fonts/ prevent. Exits with status 1 if a page is too large.
limit_mb <- 2.0     # Google's limit
fail_mb  <- 1.9     # fail a little below it, so there is some margin
warn_mb  <- 1.0     # worth a look above this

pages <- list.files("docs", pattern = "\\.html$", full.names = TRUE)
pages <- pages[!grepl("^docs/(practicals|slides|posts)/", pages)]   # course material and the blog example are not indexed content

report <- data.frame(page = basename(pages), mb = file.size(pages) / 1e6)
for (i in seq_len(nrow(report))) {
  bytes <- readBin(pages[i], "raw", file.size(pages[i]))
  text <- rawToChar(bytes[bytes != as.raw(0)]); Encoding(text) <- "bytes"
  body <- regexpr("<body", text, fixed = TRUE)
  report$body_mb[i] <- if (body > 0) (body - 1) / 1e6 else NA
}
report$status <- ifelse(report$mb > fail_mb, "TOO BIG", ifelse(report$mb > warn_mb, "large", "ok"))
report$mb <- round(report$mb, 2); report$body_mb <- round(report$body_mb, 2)
print(report, row.names = FALSE)

# Search-engine basics: every page needs a description and a canonical link that is a plain https URL.
# (pandoc's --embed-resources would replace a canonical link with a data: URI of the fetched page,
# which is why the links carry data-external="1".)
problems <- character()
for (page in pages) {
  html <- paste(readLines(page, warn = FALSE, encoding = "UTF-8"), collapse = "\n")
  html <- gsub("(?s)<(script|style)\\b.*?</\\1>", "", html, perl = TRUE)
  if (basename(page) == "blog.html") next    # distill listing page, hidden from the navbar
  if (!grepl("<meta name=\"description\" content=\"[^\"]+\"", html)) problems <- c(problems, paste(basename(page), "has no meta description"))
  if (!grepl("<link rel=\"canonical\" href=\"https://[^\"]+\"", html)) problems <- c(problems, paste(basename(page), "has no https canonical link"))
}
if (length(problems)) cat("\nSearch-engine checks failed:\n", paste0("  ", problems, collapse = "\n"), "\n", sep = "")

too_big <- any(report$status == "TOO BIG")
if (too_big) {
  cat("\nSome pages are larger than ", fail_mb, " MB (Google reads ", limit_mb, " MB). ",
      "Check that .Rprofile was loaded (restart R in the project) and that no large file is embedded.\n", sep = "")
}
if (too_big || length(problems)) quit(status = 1)
cat("\nAll pages are well within Google's ", limit_mb, " MB limit and have a description and a canonical link.\n", sep = "")
