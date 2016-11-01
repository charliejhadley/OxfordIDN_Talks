setwd("/Users/martinjohnhadley/Desktop/temp")

long.df <- worldbank_wide_to_long(file = "target.csv")

write.csv(file = "long-export.csv", long.df)
