
# read in the data and store in variable x
x <- read.csv('hw1_data.csv')
#check for the names
names(x) 
#check out the first two rows of the data set
head(x,2)
#check out the last two rows of the data set
tail(x, 2)  
# read data at 47th row observation
x[47,] 

#extract observations where ozone and temp is greater than 31 and 90 respectively
#then calculate the mean value of solar.R observations
subset_x <- subset(x, Ozone > 31 & Temp > 90)
mean(subset_x$Solar.R)

#determine the mean value of Temp for the month of June
subset_temp <- subset(x, Month == 6)
mean(subset_temp$Temp)

#determine the max ozone recording in the month of May
subset_oz <- subset(x, Month == 5)
max(subset_oz$Ozone, na.rm = TRUE)

