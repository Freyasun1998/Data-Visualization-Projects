# -*- coding: utf-8 -*-
"""
Spyder Editor

This is a temporary script file.
"""

    
import pandas as pd


loan = pd.read_csv('loans.csv')
print(loan.head(5))

loan1 = pd.melt(loan, id_vars = ['id','account_id','date','amount','payments'], var_name = 'info', value_name='X')
print(loan1.head(5))

loan2 = loan1[loan1['value'] == 'X']
loan3 = loan2.drop(['value'],axis=1)

df_info = loan3['info'].str.split('_', expand = True)
df_info.columns = ["term", "status"]

loan4 = loan3.drop(["info","X"], axis = 1).join(df_info)
loan4.sort_values('id',inplace=True)
print(loan4.head(3))

loan4.to_csv("loans_py.csv", index=0)