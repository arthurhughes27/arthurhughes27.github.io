# Arthur Hughes' personal website

Source code for my personal website, <https://arthurhughes27.github.io/>: a short biography, teaching
materials, publications, software, conference talks and internship offers.

The site is written in R Markdown with the R packages [distill](https://rstudio.github.io/distill/)
and [postcards](https://github.com/seankross/postcards), and is hosted on GitHub Pages.

## Contents

| Path | What it is |
|---|---|
| `index.Rmd`, `teaching.Rmd`, `publications.Rmd`, `software.Rmd`, `communications.Rmd`, `jobs.Rmd` | one page each |
| `_site.yml` | site title and navigation |
| `postcards.css` | the visual theme (colours, fonts, dark mode) |
| `includes/`, `fonts/`, `images/` | shared page elements, fonts and pictures |
| `slides/`, `practicals/`, `publications/`, `internships/` | the files the pages link to |
| `scripts/` | small checks for broken links and page size |
| `docs/` | the generated website (do not edit by hand) |

## Building the site

Open `distill-postcards-arthur-hughes.Rproj` in RStudio and choose **Build > Build Website**
(or run `rmarkdown::render_site()`). The result is written to `docs/`, which GitHub Pages serves.
