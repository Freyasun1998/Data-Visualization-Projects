library(tidyverse)

# read data
district <- read.csv('data/districts.csv')
head(district)

district<- district %>% mutate(
  across(c(municipality_info, unemployment_rate, commited_crimes),
         function(x) gsub("\\[|\\]", "", x))
)
district1 <- district %>% separate(col=municipality_info, into = 
                                   c("municipality_population<500","municipality_population_500-1999",
                                     "municipality_population_2000-9999","municipality_population>=10000"),sep = ",")
head(district1)

district2 <- district1 %>% separate(col=unemployment_rate, into = 
                                    c("unemployment_rate_95","unemployment_rate_96"), sep = ",")
head(district2)

district3 <- district2 %>% separate(col=commited_crimes, into = 
                                    c("commited_crimes_95","commited_crimes_96"), sep = ",")
head(district3)

write.csv(district3, file = "district_r.csv", row.names = FALSE)
