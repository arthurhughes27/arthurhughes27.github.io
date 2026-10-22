# Emit the shared footer and theme script at the end of a page.
# Called from the last chunk of every page: source("includes/site_includes.R"); site_includes()
site_includes <- function() {
  read_include <- function(f) paste(readLines(f, warn = FALSE, encoding = "UTF-8"), collapse = "\n")
  footer <- read_include("includes/footer.html")
  footer <- sub("{{year}}", format(Sys.Date(), "%Y"), footer, fixed = TRUE)
  footer <- sub("{{date}}", format(Sys.Date(), "%Y-%m-%d"), footer, fixed = TRUE)
  cat(footer, "\n\n", read_include("includes/theme.html"), "\n", sep = "")
}
