## code to prepare `DATASET` dataset goes here

library(dplyr)
library(stringr)
library(xml2)
library(purrr)
library(stringi)

unescape_html <- function(str){
  xml2::xml_text(xml2::read_html(paste0("<x>", str, "</x>")))
}


# underlying query used on data.stackexchange.com:
# SELECT DISTINCT
#   p.Id,
#   p.PostTypeId,
#   p.Body,
#   p.CreationDate
# FROM
# Posts p
# INNER JOIN PostTags pt ON p.Id = pt.PostId
# INNER JOIN Tags t ON pt.TagId = t.Id
# WHERE
# (UPPER(t.TagName) LIKE UPPER('R'))
# AND
# (p.Score >= 3)
# AND
# (p.CreationDate > '2013-01-01')

so_questions <- read.csv("data-raw/so-query-results.csv")
so_questions <- so_questions |> filter(grepl("<pre><code>", Body))

matches <- str_match_all(so_questions$Body,
                         regex("<pre><code>(.*?)</code></pre>", dotall = TRUE))
matches <- map(matches, \(x) x[, 2, drop = TRUE])
matches <- map(matches, \(x) map_chr(x, unescape_html))

so_questions$code <- matches
so_questions <- tidyr::unnest_longer(so_questions, code)

is_interesting <- function (x) {
  parse <- tryCatch(rlang::parse_exprs(x),
                    error = function (e) NULL)
  if (is.null(parse)) return(FALSE)
  if (length(parse) < 5) return(FALSE)
  return(TRUE)
}

interesting <- map_lgl(so_questions$code, is_interesting)
so_questions <- so_questions |> filter(interesting,
                                       stringi::stri_enc_isascii(code))

so_questions <- so_questions |> select(post_id = Id,
                                       creation_date = CreationDate,
                                       snippet = code)

# regex to match e.g. DESCRIPTION files or simple lists of data
not_r_code <- str_detect(so_questions$snippet,
                         regex("^([A-Za-z0-9:\\. \\t]*\\n)+$"))
so_questions <- so_questions[! not_r_code, ]

# almost all of these were not R; the remainder were typically not R
# that anyone was actually writing "in production"
no_bracket <- str_detect(so_questions$snippet, "\\(.*\\)", negate = TRUE)
so_questions <- so_questions[! no_bracket, ]

usethis::use_data(so_questions, overwrite = TRUE)
