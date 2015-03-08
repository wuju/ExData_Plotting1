
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

## add combined datetime column
dt <- dt[, datetime:=paste(Date,Time)]

## open PNG file
png("./figure/plot4.png")

## set margin and columns for multiple plots
par(mfcol = c(2, 2), mar = c(4, 4, 4, 2))

## plot
## top left plot
with(dt, plot(strptime(datetime, "%Y-%m-%d %H:%M:%S"), 
              Global_active_power, 
              type="l", xlab="", ylab="Global Active Power"))

## bottom left plot
with(dt, plot(strptime(datetime, "%Y-%m-%d %H:%M:%S"), Sub_metering_1, 
              type="l", xlab="", ylab="Energy sub metering"))
with(dt, lines(strptime(datetime, "%Y-%m-%d %H:%M:%S"), Sub_metering_2, 
               type="l", col="red"))
with(dt, lines(strptime(datetime, "%Y-%m-%d %H:%M:%S"), Sub_metering_3, 
               type="l", col="blue"))
legend("topright", lty = 1, bty = "n", col = c("black", "red", "blue"), 
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))

## top right plot
with(dt, plot(strptime(datetime, "%Y-%m-%d %H:%M:%S"), Voltage, 
              type="l", xlab="datetime"))

## bottom right plot
with(dt, plot(strptime(datetime, "%Y-%m-%d %H:%M:%S"), Global_reactive_power,
              type="l", xlab="datetime"))

## close file
dev.off()
