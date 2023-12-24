
<!-- README.md is generated from README.Rmd. Please edit that file -->

# codesamples

<!-- badges: start -->
<!-- badges: end -->

A large database of R snippets from Stack Overflow, Github and package
examples.

## Installation

You can install the development version of codesamples from
[GitHub](https://github.com/) with:

``` r
# install.packages("remotes")
remotes::install_github("hughjonesd/codesamples")
```

## Example

``` r
library(codesamples)
dim(github_data)
#> [1] 9738    4
dim(so_questions)
#> [1] 11333     3
dim(package_examples)
#> [1] 6323    3

first_lines <- strsplit(github_data$snippet[[1]], "\n")[[1]][1:23] 
cat(first_lines, sep = "\n")
#> #' Extract out common by variables
#> #'
#> #' @export
#> #' @keywords internal
#> common_by <- function(by = NULL, x, y) UseMethod("common_by", by)
#> 
#> #' @export
#> common_by.character <- function(by, x, y) {
#>   by <- common_by_from_vector(by)
#>   common_by.list(by, x, y)
#> }
#> 
#> common_by_from_vector <- function(by) {
#>   by <- by[!duplicated(by)]
#>   by_x <- names(by) %||% by
#>   by_y <- unname(by)
#> 
#>   # If x partially named, assume unnamed are the same in both tables
#>   by_x[by_x == ""] <- by_y[by_x == ""]
#> 
#>   list(x = by_x, y = by_y)
#> }

cat(package_examples$snippet[[1]])
#> ### Name: densify
#> ### Title: Densify spatial lines or polygons
#> ### Aliases: densify
#> 
#> ### ** Examples
#> 
#> library(sf)
#> l <- jagged_lines$geometry[[2]]
#> l_dense <- densify(l, n = 2)
#> plot(l, lwd = 5)
#> plot(l_dense, col = "red", lwd = 2, lty = 2, add = TRUE)
#> plot(l_dense %>% st_cast("MULTIPOINT"), col = "red", pch = 19,
#>      add = TRUE)

# Not all data is guaranteed valid!
cat(so_questions$snippet[[1]])
#> Package: foo
#> Version: 0.0
#> Title: Foo
#> Imports:
#>     memisc
#> Collate:
#>     'foo.R'

cat(so_questions$snippet[[2]])
#> dyn.load("power.dll") # dll created with gfortran -shared -fPIC -o power.dll power.f90
#> x <- 3.0
#> foo <- .C("square_",as.double(x),as.double(0.0))
#> print(foo)
#> bar <- .C("pow_",as.character("c"),as.double(x),as.double(0.0))
#> print(bar)
```
