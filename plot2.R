# Download data
if( !file.exists("household_power_consumption.txt") ) {
  temp <- tempfile()
  download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip", 
                temp, 
                method="curl")
  file <- unzip(temp)
  unlink(temp)
}

# Read table
data <- read.table('household_power_consumption.txt', 
                   sep=';', 
                   header = TRUE,
                   colClasses = c(rep("character", 2), rep("numeric", 7)),
                   nrows=2100000, 
                   comment.char="",
                   na.strings="?")
# add date time
data$DateTime <- paste(data$Date, data$Time, sep = " ")
data$DateTime <- as.POSIXct(strptime(data$DateTime, format="%d/%m/%Y %H:%M:%S"))

#filter by date
min.date <- as.POSIXct("2007-02-01", format="%Y-%m-%d")
max.date <- as.POSIXct("2007-02-03", format="%Y-%m-%d")
data.filtered <- data[data$DateTime >= min.date & data$DateTime < max.date, ]

# convert to numeric
data.filtered$Global_active_power <- as.numeric(data.filtered$Global_active_power)

#open PNG graphics device
png("plot2.png", width=480, height=480, units="px")
#draw plot
plot(data.filtered$DateTime, 
     data.filtered$Global_active_power, 
     xlab="", 
     type="l", 
     ylab="Global Active Power (kilowatts)")
# Add the labels for x axis
daterange=c(min.date, max.date)
axis.POSIXct(1, at=seq(daterange[1], daterange[2], by="day"), format="%a")
# close the graphics device
dev.off()