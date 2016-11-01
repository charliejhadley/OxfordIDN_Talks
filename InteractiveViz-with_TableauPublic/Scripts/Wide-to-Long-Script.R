## =============================== License ========================================
## ================================================================================
## This work is distributed under the MIT license, included in full within the parent directory
## Copyright Owner: University of Oxford
## Date of Authorship: 2016
## Author: Martin John Hadley (orcid.org/0000-0002-3039-6849)
## ======= Description
## Purpose: Processing Files from http://databank.worldbank.org/
## This code file will import an exported dataset from the worldbank,
## Convert the file to long format and drop unnecessary information
## ================================================================================

worldbank_wide_to_long <- function(file = NA){
  
  if(!file.exists(file)){
    stop('A valid file path must be provided to the named argument, file')
  }
  
  ## Fill out empty rows that are at the bottom of the data file
  imported.data <- read.csv(file,
                            fill = TRUE, na.strings = c("",".."))
  
  ## Check for expected column headings
  missing.expected.cols <- setdiff(c("Country.Name","Country.Code","Series.Name"),
                                   colnames(imported.data))
  
  ## If missing columns are found then stop and return an error
  if(length(missing.expected.cols) >= 1){
    missing.expected.cols <- paste(missing.expected.cols, collapse = ", ")
    
    stop(c("The following column headings were expected but were not found: ",
           missing.expected.cols))
  }
  
  ## Identify the empty bottom rows by the Country.Code being obmitted
  imported.data <- imported.data[!is.na(imported.data$Country.Code),]
  ## Load reshape2 for melt and reshape
  library(reshape2)
  ## Melt year columns to one one column
  melted.df <- suppressWarnings(melt(data = imported.data, 
                    ## Find columns that are dates
                    measure.vars = c(colnames(imported.data)[grepl("[..]YR",colnames(imported.data))]),
                    variable = "Year"
  ))
  
  ## Drop Series.Code column as can only have one timevar
  melted.df <- melted.df[,colnames(melted.df) != "Series.Code"]
  ## Reshape into wide format
  reshaped.df <- reshape(melted.df,
                         direction = "wide",
                         timevar = c("Series.Name"),
                         idvar = c("Country.Name","Country.Code","Year")
  )
  ## Load plyr for mapvalues function
  library(plyr)
  ## Update years using mapvalues
  reshaped.df$Year <- mapvalues(as.character(reshaped.df$Year),
                                from = unique(as.character(reshaped.df$Year)),
                                to = substring(sapply(
                                  strsplit(x = unique(as.character(reshaped.df$Year)), split = "[..]"),
                                  "[[", 1),2)
  )
  ## Replace .. representing missing values with empty string
  reshaped.df[reshaped.df == ".."] <- NA
  reshaped.df[is.na(reshaped.df)] <- ""
  reshaped.df
  
}

