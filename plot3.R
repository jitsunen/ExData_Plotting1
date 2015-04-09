# Read table
data <- read.table('household_power_consumption.txt', sep=';', header = TRUE,
                   colClasses = rep("character", 7),
                   nrows=2100000, comment.char="")
# add date time
data$DateTime <- paste(data$Date, data$Time, sep = " ")
data$DateTime <- as.POSIXct(strptime(data$DateTime, format="%d/%m/%Y %H:%M:%S"))

# filter by date
min.date <- as.POSIXct("2007-02-01", format="%Y-%m-%d")
max.date <- as.POSIXct("2007-02-03", format="%Y-%m-%d")
data.filtered <- data[data$DateTime >= min.date & data$DateTime < max.date, ]

# convert to numeric
data.filtered$Global_active_power <- as.numeric(data.filtered$Global_active_power)

# open PNG graphics device
png("plot3.png", width=480, height=480, units="px")
# draw plot for sub_metering_1
plot(data.filtered$DateTime, 
     data.filtered$Sub_metering_1, 
     xlab="", 
     type="l", 
     ylab="Energy sub metering")
# add sub_metering_2
lines(data.filtered$DateTime, data.filtered$Sub_metering_2, col="red")
# add sub_metering_3
lines(data.filtered$DateTime, data.filtered$Sub_metering_3, col="blue")
# add legend
legend("topright", 
       c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), 
       col=c("black", "red", "blue"), 
       lwd = 1)
# Add the labels for x axis
daterange=c(min.date, max.date)
axis.POSIXct(1, at=seq(daterange[1], daterange[2], by="day"), format="%a")
# close the graphics device
dev.off()