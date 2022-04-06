library(tidyverse)

# read data
loans <- read.csv('data/loans.csv')
head(loans)
# Tidy the data
loans1<-loans %>% pivot_longer(cols = 6:25) # melt the cols 6-25, the A_XX
head(loans1)
loans2<-loans1 %>%filter(value == "X") # remove the rows with dashes, keep the X's
head(loans2)
loans3<-loans2 %>%separate(name, into = c("loan_term", "info"), sep = "_")
head(loans3)
loans4<-loans3 %>% mutate(
  loan_status = ifelse(info %in% c("A", "B"), 
                       "expired",
                       "current"),
  loan_default = info %in% c("B", "D")
)
head(loans4)
#loans5<-loans%>%select(-info)
#head(loans5)
# select data needed and delete the info and value column
loans5 <- loans4[loans4$value == "X",]
loans5 <- subset(loans4, select = -info)
head(loans5)

write.csv(loans5, file = "loans_r.csv", row.names = FALSE)
