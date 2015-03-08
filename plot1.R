
## Download file if it doesn't already exist
if (!file.exists("./household_power_consumption.txt")) {
  fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
  download.file(fileUrl, destfile="./household_power_consumption.zip", method="curl")
  unzip("./household_power_consumption.zip")  
}

## ensure figure directory exists for output
if (!file.exists("./figure/")) dir.create("./figure/")

## read all data and convert ? to NA
dtall <- fread("./household_power_consumption.txt", na.strings=c("?"))

## convert Date column for accurate comparison
dtall <- dtall[, Date:=as.Date(Date, "%d/%m/%Y")]

## read subset of data for exercise
dt <- dtall[dtall$Date==as.Date("2007-02-01", "%Y-%m-%d") | 
              dtall$Date==as.Date("2007-02-02", "%Y-%m-%d"), ]

## convert Global_active_power to numeric for plotting
dt <- dt[, Global_active_power:=as.numeric(Global_active_power)]

## open PNG file
png("./figure/plot1.png")

## set margin to allow all of y axis to be displayed
par(mar = c(5, 4, 3, 2), bg = rgb(0, 0, 0, 0))

## plot histogram
with(dt, hist(Global_active_power, 
              main="Global Active Power",
              xlab="Global Active Power (kilowatts)", 
              col="red"))

## close file
dev.off()
