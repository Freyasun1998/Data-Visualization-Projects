#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sun Jan 30 19:59:54 2022

@author: jieyisun
"""

import pandas as pd
import numpy as np

account = pd.read_csv('accounts.csv')
card = pd.read_csv('cards.csv')
loan = pd.read_csv('loans_py.csv')
district = pd.read_csv('districts.csv')
link = pd.read_csv('links.csv')
transaction = pd.read_csv('transactions.csv')

account_district = pd.merge(account, district.iloc[:, 0:2], left_on='district_id', right_on='id', how='left')
account_district = account_district.rename(columns={'id_x': 'account_id', 'date': 'open_date', 'name': 'district_name'}).drop(['district_id', 'id_y'], axis=1)

link_card = pd.merge(link, card, left_on='client_id', right_on='link_id', how='left')
num_customers = link_card.groupby(['account_id'])['client_id'].count().reset_index(name='num_customers')
credit_cards = link_card.groupby(['account_id'])['id_y'].count().reset_index(name='credit_cards')

df1 = pd.merge(pd.merge(account_district, num_customers, on='account_id', how='left'), credit_cards, on='account_id', how='left')
loan = loan.drop(['id', 'date'], axis=1)
loan.columns = 'loan_' + loan.columns
loan['loan_default'] = np.where((loan['loan_status'] == 'B'), True, False)

df2 = pd.merge(df1, loan, left_on='account_id', right_on='loan_account_id', how='left').drop('loan_account_id', axis=1)

df2['loan'] = np.where((df2["loan_amount"].isnull().values == True), False, True)

max_withdrawal = transaction[transaction.type == "debit"].groupby(['account_id'])['amount'].max().reset_index(name='max_withdrawal')
min_withdrawal = transaction[transaction.type == "debit"].groupby(['account_id'])['amount'].min().reset_index(name='min_withdrawal')
df3 = pd.merge(df2, pd.merge(max_withdrawal, min_withdrawal, on="account_id", how="outer"), on="account_id", how="outer")

cc_payment = transaction[transaction.method == "credit card"].groupby(['account_id'])['method'].count().reset_index(name='cc_payments')
df4 = pd.merge(df3, cc_payment, on='account_id', how='left')

max_balance = transaction.groupby(['account_id'])['balance'].max().reset_index(name='max_balance')
min_balance = transaction.groupby(['account_id'])['balance'].min().reset_index(name='min_balance')
df5 = pd.merge(df4, pd.merge(max_balance, min_balance, on="account_id", how="outer"), on="account_id", how="outer")

df5.to_csv("analytical_py.csv", index=0)
