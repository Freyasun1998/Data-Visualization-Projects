#Does the number of credit cards for an account affect the maximum balance in the account?
library(ggplot2)
library(ggpubr)
set.seed(123)
analytical<-read.csv("analytical_r.csv")

boxplot(analytical$max_balance)
out<-boxplot(analytical$max_balance)$out
analytical_c<-analytical[!analytical$max_balance %in% out,]
boxplot(analytical_c$max_balance)

table(analytical_c$credit_cards)

credit_cards_0<-sample(which(analytical_c$credit_cards==0),size = 200)
credit_cards_1<-sample(which(analytical_c$credit_cards==1),size = 200)
credit<-analytical_c[credit_cards_1,]
no_credit<-analytical_c[credit_cards_0,]

credit_plot<-ggplot(data = credit, aes(x=max_balance))
credit_plot<-credit_plot+geom_histogram(aes(y=..density..),fill='darkgreen',color='orange',alpha=0.7)+theme_bw()+geom_density(alpha = 0.1, color = 'black') +
  labs(title = 'max_balance of credit card users')
credit_plot

no_credit_plot<-ggplot(data = no_credit, aes(x=max_balance))
no_credit_plot<-no_credit_plot+geom_histogram(aes(y=..density..),fill='darkblue',color='orange',alpha=0.7)+theme_bw()+geom_density(alpha = 0.1, color = 'black') +
  labs(title = 'max_balance of non-credit card users')
no_credit_plot
