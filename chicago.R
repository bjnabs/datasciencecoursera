

library(dplyr)

chicago <- readRDS("chicago.rds")
head(chicago)

str(chicago)
names(chicago)

c_subset <- select(chicago, city:dptp)
c_subset
tail(c_subset)

chic.f <- filter(chicago, pm25tmean2 > 30)
str(chic.f)
summary(chic.f$pm25tmean2)

max(chic.f$date)

min(chic.f$date)


chic.fi <- filter(chicago, pm25tmean2 > 30 & tmpd > 80)

chic.d <- arrange(chicago, date)

arrange(chic.d, date)
head(select(chic.d, date, pm25tmean2), 3)
tail(select(chic.d, date, pm25tmean2), 3)


arrange(chicago, desc(date))
head(chicago, 3)

chicago <- rename(chicago, dewpoint = dptp, pm25 = pm25tmean2)
chicago <- mutate(chicago, pm25detrend = pm25 - mean(pm25, na.rm = TRUE))
head(chicago)


head(transmute(chicago,  pm10detrend = pm10tmean2 - mean(pm10tmean2, na.rm = TRUE),o3detrend = o3tmean2 - mean(o3tmean2, na.rm = TRUE)))

mutate(chicago, pm25_quint = cut(pm25, qq)) %>%    
                 group_by(pm25_quint) %>% 
                 summarize(o3 = mean(o3tmean2, na.rm = TRUE),  no2 = mean(no2tmean2, na.rm = TRUE))
