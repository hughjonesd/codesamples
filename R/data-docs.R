#' Github R Snippets
#'
#' R snippets from Github.
#'
#' These were created by using the github search API
#' with `language:R` and a "starter"
#' string chosen randomly from `ls("package:base")`.
#'
#' **Obviously, don't run any code on your machine without
#' checking it manually first!**
#'
#' @format ## `github_data`
#' A data frame with 10,528 rows and 4 columns:
#' \describe{
#'   \item{starter}{Starter for the github search}
#'   \item{repo}{Github repo name}
#'   \item{path}{Path within the repo}
#'   \item{snippet}{The R snippet itself}
#' }
"github_data"


#' Stack Overflow R Snippets
#'
#' R snippets from Stack Overflow questions.
#'
#' Questions were from 2013 onwards, with a
#' minimum score of 3 and the `R` tag.
#'
#' Note that not all code that parses is guaranteed
#' to be valid R. For example, a R `DESCRIPTION` file
#' may parse as R code.
#'
#' **Obviously, don't run any code on your machine without
#' checking it manually first!**
#'
#' Here is the original SQL
#' query on <data.stackexchange.com>:
#'
#' ```
#' SELECT DISTINCT
#'   p.Id,
#'   p.PostTypeId,
#'   p.Body,
#'   p.CreationDate
#' FROM
#' Posts p
#' INNER JOIN PostTags pt ON p.Id = pt.PostId
#' INNER JOIN Tags t ON pt.TagId = t.Id
#' WHERE
#' (UPPER(t.TagName) LIKE UPPER('R'))
#' AND
#' (p.Score >= 3)
#' AND
#' (p.CreationDate > '2013-01-01')
#' ```
#'
#' @format ## `so_questions`
#' A data frame with 11,333 rows and 3 columns:
#' \describe{
#'   \item{post_id}{SO post ID}
#'   \item{creation_date}{Question creation date}
#'   \item{snippet}{The R code itself}
#' }
"so_questions"
