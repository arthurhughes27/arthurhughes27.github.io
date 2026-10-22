# Arthur Hughes' personal website

Source for https://arthurhughes27.github.io/, written in R Markdown with the R packages
[`distill`](https://rstudio.github.io/distill/) and [`postcards`](https://github.com/seankross/postcards).
GitHub Pages serves the rendered site from the `docs/` folder.

## Building the site

1. Install the packages once: `install.packages(c("distill", "postcards"))`.
2. Open `distill-postcards-arthur-hughes.Rproj` in RStudio (this loads `.Rprofile`, see below; restart R
   if the project was already open) and use **Build > Build Website** (or run `rmarkdown::render_site()`).
3. Run `Rscript scripts/check_links.R` and `Rscript scripts/check_page_size.R` to make sure no link is
   broken and the pages are small enough for search engines.
4. Commit the changes **and the regenerated `docs/` folder**, then push.

## What is where

| Path | Purpose |
|---|---|
| `index.Rmd`, `teaching.Rmd`, `publications.Rmd`, `software.Rmd`, `communications.Rmd`, `jobs.Rmd` | one page each (the home page is `index.Rmd`; `blog.Rmd` is built but hidden from the navbar) |
| `_site.yml` | site title, navbar (the search box is turned off here with `navbar: search: false`) and theme |
| `postcards.css` | the whole theme: colour tokens (light and dark), fonts, components, motion |
| `fonts/` | the self-hosted font files used by `postcards.css` |
| `.Rprofile` | keeps the rendered pages small (see "Page size and search engines") |
| `robots.txt`, `sitemap.xml` | for search engines; add new pages to `sitemap.xml` |
| `includes/` | `theme.html` (dark-mode toggle and active nav item), `footer.html`, `site_includes.R` (emits both at the end of every page), `helpers.R` (link rows on the Teaching page), `head.html` (author, social card and structured data about me, on every page), `meta/<page>.html` (description and canonical link of each page) |
| `slides/`, `practicals/`, `publications/`, `internships/`, `images/` | files the pages link to |
| `scripts/` | `check_links.R` (broken links) and `check_page_size.R` (page size, description, canonical link); both run on every pull request (`.github/workflows/check-site.yml`) |
| `docs/` | rendered site, generated: do not edit by hand |

## Adding content

Pages use a few small building blocks; copy an existing one.

- **Card** (course, talk, offer, publication): a fenced div, `:::: {.entry}` ... `::::`, with a heading
  and, optionally, `[Seoul, July 2026]{.meta}` for the line under the title.
- **Short remark inside a card** (for example the private-data note on the genomics courses): `::: {.note}` ... `:::`.
- **Link button**: `[Slides](slides/communications/file.pdf){.pill target="_blank" rel="noopener noreferrer"}`.
- **Teaching**: inside a course card use `slides("slides/teaching/file.pdf")` and
  `practical("Practical work (questions)", "file_stem")` in a `results='asis'` chunk
  (see `includes/helpers.R`).
- **New talk or poster**: add the PDF to `slides/communications/` and a card to `communications.Rmd`;
  keep each group ordered from most to least recent.
- **New publication**: add the PDF to `publications/` and a card at the top of `publications.Rmd`.
- **New page**: add its `.Rmd`, an `includes/meta/<page>.html` (copy an existing one and change the description and URL), point to it from the front matter (`output: postcards::solana: includes: in_header:`), add it to the navbar in `_site.yml` and to `sitemap.xml`.
- **New package**: add a `.software-item` block to `software.Rmd` with its hex sticker in `images/`.
- **Home page buttons** (Curriculum Vitae, Google Scholar, ...): the `links:` list in the front matter of `index.Rmd`.

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

## Page size and search engines

Google only reads the first 2 MB of an HTML file and ignores the rest. R Markdown pages from
`postcards` are rendered self-contained, so everything the page needs is embedded in its `<head>`,
before the text. By default this made every page about 6 MB (4 MB of Font Awesome icon fonts, which
`distill` always adds and this site does not use, plus 1.4 MB of Google Fonts), so Google never saw
the text of the site. Two things keep the pages small (about 0.7 MB):

- `.Rprofile` drops the Font Awesome dependency from `distill` when R starts in this folder.
- The fonts are self-hosted (`fonts/`, Latin subsets) and declared in `postcards.css`; this also means
  visitors' browsers do not contact Google to load the site.

`scripts/check_page_size.R` fails if a page gets too large (for example if `.Rprofile` was not loaded
when the site was built). It also checks that every page has a meta description and a canonical link.
The canonical links carry `data-external="1"`: without it, pandoc replaces them by an embedded copy
of the live page when it renders the site.

Each page gets its own description and canonical link from `includes/meta/<page>.html`. They cannot
be written as `header-includes:` in the front matter: pandoc ignores that field when R Markdown
also passes `--include-in-header` files.

To be found by Google, the site also has to be known to it: verify
`https://arthurhughes27.github.io/` in [Google Search Console](https://search.google.com/search-console),
submit `sitemap.xml` and use **URL inspection > Request indexing** for the home page, and link to the
site from other places (GitHub profile and repositories, LinkedIn, Google Scholar, ORCID, the
laboratory page).
