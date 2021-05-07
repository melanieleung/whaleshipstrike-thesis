###### unzipping files ######
# did not run this for 2018 data, could be used for 2019 data though
file <- sub(".gz$", "", file)
tmpfile <- tempfile()
remove_tmpfile <- FALSE
if(!file.exists(file)) { # need to unzip
  system(paste0("gunzip -c ", file, ".gz > ", tmpfile))
  remove_tmpfile <- TRUE
  file <- tmpfile
}

###### load packages & setup working directory #####
library(readr)
library(tidyverse)
library(dplyr)
library(plyr)
library(readr)
library(lubridate)
library(glue)

getwd()
setwd("D:/melThesis/")

##### test run for first 3 data files ######
# load files with read.table()
dataFiles <- list.files(path = "D:/melThesis/2018/", pattern = "*.csv")  # Identify file names
i <- 1
for(i in 1:3) {                              
  assign(paste("data2018_01_0", i, sep = ""),                                   
         read.table(paste("D:/melThesis/2018/",
                           dataFiles[i], sep = ""),
                    header = T,
                    sep = ",",
                    quote = "\n",
                    comment.char = ""))
} # output: "data2018_01_0i" with 17 variables

# select() to keep: MMSI, BaseDateTime, Lat, Lon, SOG, VesselName, IMO
i <- 1
for(i in 1:3) {                              
  assign(paste("data2018_01_0", i, sep =""),                                 
         eval(as.name(paste("data2018_01_0", i, sep = ""))) %>%
           select(MMSI, BaseDateTime, LAT, LON, SOG, VesselName, IMO))
} # output: "data2018_01_0i" with 7 variables

# remove empty IMO rows & filter to split east/west coast

# i <- 1
# for (i in 1:3) {AIS2018_EAST <- filter(IMOattribute, IMO != "" & LON >= -82 & LAT <= -67)
#     AIS2018_WEST <- filter(IMOattribute, IMO != "" & LON >= -125 & LAT <= -117) }

# East coast:
i <- 1
for (i in 1:3) {
  assign(paste("data2018_east_01_0", i, sep = ""),                                   
         eval(as.name(paste("data2018_01_0", i, sep = ""))) %>%
           filter(IMO != "" & LON >= -67 & LON <= -82))
} # output: "data2018_east_01_0i"

# West coast: 
i <- 1
for (i in 1:3) {
  assign(paste("data2018_west_01_0", i, sep = ""),                                   
         eval(as.name(paste("data2018_01_0", i, sep = ""))) %>%
           filter(IMO != "" & LON >= -117 & LON <= -125))
} # output: "data2018_west_01_0i"

# join Melanie_shipList.csv
shipList <- as.data.frame(read.csv('Melanie_shipList_IMO.csv', header = T)) # you can change this out for "shipList_processed.csv" now

i <- 1
for (i in 1:1981) {
  shipList$IMO[i] <- paste("IMO", shipList$IMO[i], sep = "")
}

write.csv(shipList, "D:/melThesis/shipList_processed.csv")

# join/merge function:
i <- 1
for (i in 1:3) {
  assign(paste("data2018_west_01_0", i, sep = ""),
         merge(x = eval(as.name(paste("data2018_west_01_0", i, sep = ""))),
               y = shipList,
               by.x = "IMO",
               by.y = "IMO"))
}

i <- 1
for (i in 1:3) {
  assign(paste("data2018_east_01_0", i, sep = ""),
         merge(x = eval(as.name(paste("data2018_east_01_0", i, sep = ""))),
               y = shipList,
               by.x = "IMO",
               by.y = "IMO"))
}

### SAVE processed data into CSVs
i <- 1
for (i in 1:3) {
  write.csv(eval(as.name(paste("data2018_east_01_0", i, sep = ""))),
            paste("D:/melThesis/2018east/AIS_2018_01_0", i, ".csv", sep = ""))
}

i <- 1
for (i in 1:3) {
  write.csv(paste("data2018_west_01_0", i),
            paste("D:/melThesis/2018west/AIS_2018_01_0", i, ".csv", sep = ""))
}


###### read in 2018 data ######

# JANUARY2018
i <- 1
for (i in 1:9) {
  data2018[i] <-
    read.table(paste('D:/melThesis/2018/AIS_2018_01_0', i, '.csv', sep = ""), header = T, sep = ",", fill = T, quote = "")
}

