
par(mfrow = c(3,1))
##Read data
steps <- read.csv("activity.csv")

## transform date column to be of type 'date'
steps$date <- as.Date(steps$date)

## calculate steps per day (ignore NA)
stepsPerDay <- aggregate(steps ~ date,data = steps, FUN = sum, na.action = na.omit )
hist(stepsPerDay$steps,
     main = "Number of steps per day",
     xlab = "Number of steps", 
     breaks = 10, 
     col = "grey",
     xlim = c(0,25000))

stepsMean   <- aggregate(steps ~ date,data = steps, FUN = mean, na.action = na.omit )
stepsMedian <- aggregate(steps ~ date,data = steps, FUN = median, na.action = na.omit )
merged <- merge(stepsMean, stepsMedian, by = "date")
names(merged) <- c("date","mean","median")
merged
## Calculate the mean and median daily number of steps


## Calculate and plot the average number of steps per 5-minute interval
stepsPerInterval <- aggregate(steps~interval, data = steps, FUN = mean, na.action = na.omit)
with(stepsPerInterval, plot(interval, steps, type = "l", col = "red", xlab = "5-minute interval", main = "Average number of steps per 5-minute interval"))

##Find which interval the highest average number of steps has
maxInterval <- stepsPerInterval[which.max(stepsPerInterval$steps),1]
abline(v= maxInterval, lwd = 3, lty = 2)

## NA only occur in the 'steps' column. Calculate the number of NA in the column 'steps'
sum(is.na(steps$steps))

##Fill in the mean number of steps in that interval (over all days)
idNA <- which(is.na(steps$steps))
stepsFilled <- steps
for( i in 1:length(idNA)) {
        stepsFilled[idNA[i],1] <- stepsPerInterval[which(stepsPerInterval$interval == steps[idNA[i],3]),2]        
}

## calculate steps per day (ignore NA)
stepsPerDayFilled <- aggregate(steps ~ date,data = stepsFilled, FUN = sum, na.action = na.omit )
hist(stepsPerDayFilled$steps,
     main = "Number of steps per day",
     xlab = "Number of steps", 
    ## breaks = 10, 
     col = "grey",
     xlim = c(0,25000))

## Calculate the mean and median daily number of steps
stepsFilledMean   <- aggregate(steps ~ date,data = stepsFilled, FUN = mean, na.action = na.omit )
stepsFilledMedian <- aggregate(steps ~ date,data = stepsFilled, FUN = median, na.action = na.omit )
mergedFilled <- merge(stepsFilledMean, stepsFilledMedian, by = "date")
names(mergedFilled) <- c("date","mean","median")
mergedFilled

## Fill in Weekday/Weekend
stepsFilled$Weekday <- weekdays(stepsFilled$date)
stepsFilled$daytype <- as.factor(ifelse(stepsFilled$Weekday %in% c("Saturday","Sunday"), "Weekend","Weekday"))

## create plot
library(ggplot2)

stepsIntervalDaytype <- aggregate(steps~interval+daytype, data = stepsFilled, FUN = mean, na.action = na.omit)
ggplot(stepsIntervalDaytype, aes(interval, steps,daytype)) +
        geom_line() +
        facet_wrap(~daytype, ncol =1) +
        labs(y = "number of steps", x = "5-minute interval")
