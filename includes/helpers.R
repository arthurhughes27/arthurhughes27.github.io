# Helpers that generate the repeated link markup on the Teaching page.
# Use them from a chunk with results = 'asis', after source("includes/helpers.R").

# markdown for one pill link; download = TRUE gives a download link, otherwise opens in a new tab
pill <- function(label, href, download = FALSE) {
  href <- utils::URLencode(href)
  href <- gsub("(", "%28", href, fixed = TRUE)
  href <- gsub(")", "%29", href, fixed = TRUE)
  attrs <- if (download) 'download=""' else 'target="_blank" rel="noopener noreferrer"'
  sprintf("[%s](%s){.pill %s}", label, href, attrs)
}

# one labelled row of pills
resource <- function(label, ...) {
  cat("::: {.resource}\n",
      sprintf("[%s]{.resource-label} %s\n", label, paste(c(...), collapse = " ")),
      ":::\n", sep = "")
}

# a PDF: download + open in new tab
slides <- function(path, label = "Slides") {
  resource(label, pill("Download (PDF)", path, download = TRUE), pill("Open in new tab", path))
}

# a practical: the .Rmd (download) and the rendered .html (open in new tab), given the file name without extension
practical <- function(label, stem) {
  resource(label,
           pill("Download (.Rmd)", paste0("practicals/", stem, ".Rmd"), download = TRUE),
           pill("Open in new tab (.html)", paste0("practicals/", stem, ".html")))
}
