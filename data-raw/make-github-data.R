
library(gh)
library(purrr)
library(tibble)
library(dplyr)
library(stringi)

save_file <- "github-r-snippets.rds"

warning("make-github-data.R is nondeterministic.")
warning("If you rerun it you won't get the same snippets!")

code_snippets <- if (file.exists(save_file)) {
  readRDS(save_file)
} else {
  tibble(starter = character(0), repo = character(0),
         path = character(0), snippet = character(0))
}

base_funcs <- ls("package:base")

while (TRUE) {
  starter <- sample(base_funcs, 1L)

  res <- gh("GET /search/code",
            q = paste("language:r extension:R", starter),
            .token = gh_token(),
            .limit = 100)

  while (TRUE) {
    new_snippets <- purrr::map(res$items, function (x) {
      repo <- x$repository$full_name
      path <- x$path
      snippet_res <- gh(paste("GET", x$url),
                        .token = gh_token(),
                        .max_rate = 4)
      content <- snippet_res$content |>
                 base64enc::base64decode() |>
                 rawToChar()
      tibble(starter = starter, repo = repo, path = path, snippet = content)
    })
    new_snippets <- list_rbind(new_snippets)
    code_snippets <- rbind(code_snippets, new_snippets)
    message(".")
    res <- try(gh_next(res), silent = TRUE)
    if (inherits(res, "try-error")) break # no next page (probably)
  }

  code_snippets <- distinct(code_snippets, snippet, .keep_all = TRUE)
  message(nrow(code_snippets), "/", length(unique(code_snippets$starter)))
  saveRDS(code_snippets, file = save_file)
}

save_file <- "data-raw/github-r-snippets.rds"
github_data <- as.data.frame(readRDS(save_file))
github_data <- filter(github_data,
                      grepl("\\.R$", path),
                      stringi::stri_enc_isascii(snippet))
usethis::use_data(github_data, overwrite = TRUE)

