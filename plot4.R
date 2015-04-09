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

# Open PNG graphics device
png("plot4.png", width=480, height=480, units="px")
par(mfcol=c(2,2))

# Add global active power plot
plot(data.filtered$DateTime, 
     data.filtered$Global_active_power, 
     xlab="", 
     type="l", 
     ylab="Global Active Power (kilowatts)")
daterange=c(min.date, max.date)
axis.POSIXct(1, at=seq(daterange[1], daterange[2], by="day"), format="%a")

# Add sub metering time plot
plot(data.filtered$DateTime, 
     data.filtered$Sub_metering_1, 
     xlab="", 
     type="l", 
     ylab="Energy sub metering")
lines(data.filtered$DateTime, data.filtered$Sub_metering_2, col="red")
lines(data.filtered$DateTime, data.filtered$Sub_metering_3, col="blue")
legend("topright", 
       c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), 
       col=c("black", "red", "blue"), 
       lwd = 1)
axis.POSIXct(1, at=seq(daterange[1], daterange[2], by="day"), format="%a")

# Add Voltage time plot
plot(data.filtered$DateTime, 
     data.filtered$Voltage, 
     xlab="datetime", 
     ylab="Voltage", 
     type="l")
axis.POSIXct(1, at=seq(daterange[1], daterange[2], by="day"), format="%a")

# Add Global reactive power time plot
plot(data.filtered$DateTime, 
     data.filtered$Global_reactive_power, 
     ylab="Global_reactive_power",
     xlab="datetime", 
     type="l")
axis.POSIXct(1, at=seq(daterange[1], daterange[2], by="day"), format="%a")

# Close the graphics device
dev.off()