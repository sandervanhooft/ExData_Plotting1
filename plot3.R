path <- "household_power_consumption.txt"
script.dir <- dirname(sys.frame(1)$ofile)
setwd(script.dir)
library(data.table) # For fread()

loadData <- function (filename)
{  
  # read data from filename
  df <- fread(filename, na.strings=c("?"), colClasses="character")
  
  # limit to dates 2007-02-01 and 2007-02-02
  df <- df[ df$Date == "1/2/2007" | df$Date == "2/2/2007", ]
  
  # convert Date
  df$Date <- as.Date(df$Date , "%d/%m/%Y") 
  
  # Apply other conversions *after* subsetting for performance reasons
  
  # Convert YYYY-MM-DD HH:MM:SS to POSIXct
  df$DateTime <- as.POSIXct(paste(df$Date, df$Time), "%Y-%m-%d %H:%M:%S", tz="")
  
  # Convert no Date/Time columns to numeric
  df$Global_active_power <- as.numeric(df$Global_active_power)
  df$Global_reactive_power <- as.numeric(df$Global_reactive_power)
  df$Voltage <- as.numeric(df$Voltage)
  df$Global_intensity <- as.numeric(df$Global_intensity)
  df$Sub_metering_1 <- as.numeric(df$Sub_metering_1)
  df$Sub_metering_2 <- as.numeric(df$Sub_metering_2)
  df$Sub_metering_3 <- as.numeric(df$Sub_metering_3)
  
  # Return df
  df
}

df <- loadData(path)
png(file="plot3.png", width = 480, height = 480, type="quartz")
plot(df$DateTime, df$Sub_metering_1, type="l", xlab = "", ylab = "Energy sub metering")
lines(df$DateTime, df$Sub_metering_2, col="red")
lines(df$DateTime, df$Sub_metering_3, col="blue")
legend("topright", col=c("black", "red", "blue"), legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), lty="solid")
dev.off()
