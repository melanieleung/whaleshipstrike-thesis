# load packages
install.packages('readr')
library(readr)
library(tidyverse)
library(dplyr)
library(plyr)
library(readr)
library(lubridate)

# set workspace/directory
getwd() #see where you're at 
setwd("C:/Users/leung/OneDrive/Desktop/thesis/csvFiles")

# download batches of csv files? 
download.file()

# load in relevant files
data_0426_2018 <- read.csv("AIS_2018_04_26.csv")

# preview the data
head(data_0426_2018) #first few rows of dataset
str(data_0426_2018) #variable types
summary(data_0426_2018) #statistical summary of data
names(data_0426_2018) #first row (attributeNames)

arrange( ) #order rows by values of columns: use this to order rows by speed?

# subset rows using dplyr
vesselPairs <- group_by( ) #use this to group vessels of the same manager?
filter( ) #extract rows meeting certain logical criteria: 
          # use this to identify vessels traveling at certain speeds or in certain areas?

# parse dates and times
dates <- data_0426_2018$BaseDateTime
data_0426_2018$day <- day(dates)
data_0426_2018$month <- month(dates)
data_0426_2018$year <- year(dates)

# look at specific time periods. see: https://rawgit.com/rstudio/cheatsheets/master/lubridate.pdf
timePeriod <- years(1) + months(3) + weeks(12) 


# unzip 2018 files
file_names <- list.files("C:/Users/leung/OneDrive/Desktop/thesis/zipfiles/2018")
walk(file_names, ~ unzip(zipfile = "C:/Users/leung/OneDrive/Desktop/thesis/zipfiles/2018/", 
                         exdir = "C:/Users/leung/OneDrive/Desktop/thesis/unzipped"))

# second attempt to unzip 2018 files
i <- 1
for (i in 1:364) {
  csvFiles <- unz(paste("AIS_2018_01_0", i, ".zip", sep = ""),
              paste("AIS_2018_01_0", i, ".csv", sep = ""))
}
AIS_CSV <- read.csv(csvFiles)

# split CSVs into smaller files
setwd("C:/Users/leung/OneDrive/Desktop/thesis/")
mydata <- read.csv(
  "C:/Users/leung/OneDrive/Desktop/thesis/unzipped/2018/AIS_2018_01_01.csv",
  header = FALSE,
  quote = "")
nrow(mydata) # see how many rows there are 
chunks <- split(mydata, sample(rep(1:37, 195499)))  # 37 Chunks of 195499 lines each

# save individual chunks as csv files
write.csv(chunks[[1]], file="C:/Users/leung/OneDrive/Desktop/thesis/unzipped/january2018/AIS_20180101_1.csv")

# If you want to write these chunks out in a csv file:
write.csv(First_chunk,file="First_chunk.csv",quote=F,row.names=F,col.names=T)
write.csv(Second_chunk,file="Second_chunk.csv",quote=F,row.names=F,col.names=T)

# merge csv files - process monthly AIS csv files
# JANUARY 2018
january2018 <- list.files(path = "C:/Users/leung/OneDrive/Desktop/thesis/unzipped/2018",
                       pattern = "AIS_2018_01_*", full.names = TRUE) %>% 
  lapply(read_csv) %>%                                            # Store all files in list
  bind_rows

january2018_df <- as.data.frame(january2018)
write.csv(january2018_df, "C:/Users/leung/OneDrive/Desktop/thesis/unzipped/2018/january")