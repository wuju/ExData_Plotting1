
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

## set margin to allow all of y axis to be displayed
par(mar = c(2,4,1,1))

## open PNG file
png("./figure/plot3.png")

## plot
with(dt, plot(strptime(paste(Date, Time), "%Y-%m-%d %H:%M:%S"), Sub_metering_1, 
              type="l", xlab="", ylab="Energy sub metering"))
with(dt, lines(strptime(paste(Date, Time), "%Y-%m-%d %H:%M:%S"), Sub_metering_2, 
               type="l", col="red"))
with(dt, lines(strptime(paste(Date, Time), "%Y-%m-%d %H:%M:%S"), Sub_metering_3, 
               type="l", col="blue"))
legend("topright", lty = 1, col = c("black", "red", "blue"), 
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))

## close file
dev.off()
