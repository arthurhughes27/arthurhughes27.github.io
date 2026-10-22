# Project start-up code (loaded when the RStudio project is opened or Rscript runs from this folder).
#
# Keep the rendered pages small. distill always adds Font Awesome to a website, and
# postcards pages are rendered self-contained, so every page ended up with about 4 MB of
# icon fonts embedded in its <head>. Google only reads the first 2 MB of an HTML file, so the
# actual text of the page (which comes after the <head>) was never seen. This site uses no
# icons, so the Font Awesome dependency is dropped. scripts/check_page_size.R checks the result.
local({
  drop_font_awesome <- function() {
    ns <- asNamespace("distill")
    original <- get("site_dependencies", envir = ns)
    keep <- function(dep) !identical(dep$dep$name, "font-awesome")
    utils::assignInNamespace("site_dependencies",
                             function(site_config) Filter(keep, original(site_config)),
                             ns = "distill")
  }
  patch <- function(...) {
    tryCatch(drop_font_awesome(),
             error = function(e) warning("Could not drop Font Awesome from distill: ", conditionMessage(e),
                                         "\nPages will be much larger than needed.", call. = FALSE))
  }
  if (isNamespaceLoaded("distill")) patch() else setHook(packageEvent("distill", "onLoad"), patch)
})
