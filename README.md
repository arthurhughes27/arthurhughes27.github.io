# Arthur Hughes' personal website

Source for https://arthurhughes27.github.io/, written in R Markdown with the R packages
[`distill`](https://rstudio.github.io/distill/) and [`postcards`](https://github.com/seankross/postcards).
GitHub Pages serves the rendered site from the `docs/` folder.

## Building the site

1. Install the packages once: `install.packages(c("distill", "postcards"))`.
2. Open `distill-postcards-arthur-hughes.Rproj` in RStudio and use **Build > Build Website**
   (or run `rmarkdown::render_site()`).
3. Run `Rscript scripts/check_links.R` to make sure no link is broken.
4. Commit the changes **and the regenerated `docs/` folder**, then push.

## What is where

| Path | Purpose |
|---|---|
| `index.Rmd`, `teaching.Rmd`, `publications.Rmd`, `software.Rmd`, `communications.Rmd`, `jobs.Rmd` | one page each (the home page is `index.Rmd`; `blog.Rmd` is built but hidden from the navbar) |
| `_site.yml` | site title, navbar, search (off) and theme |
| `postcards.css` | the whole theme: colour tokens (light and dark), fonts, components, motion |
| `includes/` | `theme.html` (dark-mode toggle and active nav item), `footer.html`, `site_includes.R` (emits both at the end of every page), `helpers.R` (link rows on the Teaching page), `head.html` (meta description) |
| `slides/`, `practicals/`, `publications/`, `internships/`, `images/` | files the pages link to |
| `scripts/check_links.R` | link checker, also run on every pull request (`.github/workflows/check-links.yml`) |
| `docs/` | rendered site, generated: do not edit by hand |

## Adding content

Pages use a few small building blocks; copy an existing one.

- **Card** (course, talk, offer, publication): a fenced div, `:::: {.entry}` ... `::::`, with a heading
  and, optionally, `[Seoul, July 2026]{.meta}` for the line under the title.
- **Link button**: `[Slides](slides/communications/file.pdf){.pill target="_blank" rel="noopener noreferrer"}`.
- **Teaching**: inside a course card use `slides("slides/teaching/file.pdf")` and
  `practical("Practical work (questions)", "file_stem")` in a `results='asis'` chunk
  (see `includes/helpers.R`).
- **New talk or poster**: add the PDF to `slides/communications/` and a card to `communications.Rmd`;
  keep each group ordered from most to least recent.
- **New publication**: add the PDF to `publications/` and a card at the top of `publications.Rmd`.
- **New package**: add a `.software-item` block to `software.Rmd` with its hex sticker in `images/`.

### File names

GitHub Pages is **case-sensitive**, while macOS and Windows are not: a link to `supervisedLearning.html`
for a file called `supervisedlearning.html` works on your machine and 404s once deployed.
`scripts/check_links.R` checks case exactly, so run it before pushing.

## Colours and dark mode

The colours are CSS variables at the top of `postcards.css`. Dark values are given with `light-dark()`,
so the site follows the operating system setting and the moon/sun button in the navbar overrides it
(the choice is stored in the browser). To change the palette, edit the variables in that one block.

## Notes

- The template reads its fonts from `--body-font`, `--heading-font` and `--navbar-font`; set those
  variables rather than overriding rules with `!important`.
- Site-wide includes only reach the postcards pages when `includes` is declared under
  `output: distill::distill_article:` in `_site.yml`. The footer and theme script are emitted from each
  page instead, by the last chunk of the `.Rmd`.
