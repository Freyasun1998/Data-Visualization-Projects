library(tidyverse)

#read data
account <- read.csv('data/accounts.csv')
card <- read.csv('data/cards.csv')
district <- read.csv('data/districts.csv')
link <- read.csv('data/links.csv')
loan <- read.csv('Result/loans_r.csv')
transaction <- read.csv('data/transactions.csv')

# rename colname
head(account)
colnames(account)[1] <- 'account_id'
colnames(account)[3] <- 'open_date'

# join account with district name by district_id
head(account)
head(district)
account <- left_join(account, district[, 1:2], c("district_id"="id"))
colnames(account)[5] <- 'district_name'
account <- subset(account, select = -district_id)
head(account)

# join links and cards with client_id
link_card <- left_join(link, card, c("client_id"="link_id"))

# calculate the num_customers and join with account
num_customers <- link_card %>% group_by(account_id) %>% count(account_id, name = "num_customers") 
account<- left_join(account, num_customers)
head(account)

# calculate the credit_cards and join with account and set 0 for none
credit_cards <- link_card %>% group_by(account_id) %>% filter(!is.na(id.y)) %>% count(account_id, name = "credit_cards")
account<- left_join(account, credit_cards)
account[is.na(account$credit_cards),]$credit_cards <- 0

# create column that T/F if the loan is in default and join with account, set loan column for T/F whether the account has loan or not
loan$loan_default <- ifelse(loan$status == "B", T, F)
loan <- subset(loan, select = -c(date, id))
colnames(loan)[2:5] <- paste("loan", colnames(loan)[2:5], sep = "_")
account<- left_join(account, loan)
account$loan <- !is.na(account$loan_amount)


# group transaction data by account_id
transaction_acc <- transaction %>% group_by(account_id)
# get max and min balance data, withdrawal data and count of credit payments
max_balance = max(balance)
min_balance = min(balance)
balance <- transaction_acc %>% summarise(max_balance, min_balance)

withdrawal <- transaction_acc %>% filter(type == "debit") %>% summarise(max_withdrawal = max(amount), min_withdrawal = min(amount))
payment <- transaction_acc %>% filter(method == "credit card") %>% count(account_id, name="cc_payments")

# for join_all function. it cannot be library at the beginning otherwise count function can have errors
library(plyr)

# join all variables
analytical <- join_all(list(account, withdrawal, payment, balance), by = 'account_id', type = 'left')
analytical <- analytical[,c(1,4,2:3,5:6,12,7:11, 13:17)]

write.csv(analytical, file = "analytical_r.csv", row.names = FALSE)
