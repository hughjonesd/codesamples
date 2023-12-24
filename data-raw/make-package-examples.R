## code to prepare `package_examples` dataset goes here

library(purrr)
library(dplyr)
library(stringi)

set.seed(10271975)
pkgs <- sample(rownames(available.packages()), 500)

tmp_lib_path <-"tmp-library"

dir.create(tmp_lib_path)
install.packages(pkgs, lib = tmp_lib_path)

pkgs <- setNames(pkgs, pkgs)
topics <- map(pkgs, \(pkg) {
  hs <- help.search("*", package = pkg, lib.loc = tmp_lib_path)
  topics <- unique(hs$matches$Topic)
  setNames(topics, topics)
})

package_examples <- data.frame(package = pkgs)
package_examples$topic <- topics

examples <- map(pkgs, \(pkg) {
    topics <- package_examples$topic[package_examples$package == pkg]
    topics <- topics[[1]]
    ex <- map(topics, example, give.lines = TRUE,
                 package = pkg, lib.loc = tmp_lib_path, character.only = TRUE)
    ex <- map_chr(ex, paste, collapse = "\n")
    ex
})
package_examples$example <- examples

package_examples <- tidyr::unnest_longer(package_examples,
                                         c(topic, example),
                                         indices_include = FALSE)
package_examples <- package_examples |>
  rename(snippet = example) |>
  filter(nchar(snippet) > 0) |>
  filter(stringi::stri_enc_isascii(snippet))

remove.packages(pkgs, lib = tmp_lib_path)
system2("rm", c("-rf", tmp_lib_path))

usethis::use_data(package_examples, overwrite = TRUE)
