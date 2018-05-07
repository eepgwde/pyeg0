## weaves
##
## Visual validation using Recursive Partition Trees.
##
## @note
## Uses older version of R, so no caret.

rm(list = ls())
if (!is.null(dev.list())) {
    lapply(dev.list(), function(x) dev.off())
}
gc()

## "shiny.launch.browser" is TRUE or FALSE

## "shiny.host" "0.0.0.0"

library(shiny)

runExample("01_hello")

runApp("App-1")

## An app can be run in the background

library("future")
plan(multiprocess)

future(runApp("App-1", port=4097))

