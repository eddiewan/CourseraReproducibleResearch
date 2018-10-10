##### INITIALIZING #####

##### Retrieve data #####

## Download the zip file containing the data, if it has not been downloaded yet.

urlZip          <- "https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2Factivity.zip"
fileZip         <- "repdata%2Fdata%2Factivity.zip"

if(!file.exists(fileZip)) {
        download.file(urlZip, fileZip, mode = "wb")
}

dataFolder <- ""

if(!file.exists(dataFolder)) {
        unzip(fileZip)
}

