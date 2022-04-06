#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sun Jan 30 18:57:17 2022

@author: jieyisun
"""

import pandas as pd
import re  

# read data
district = pd.read_csv('districts.csv')
print(district.head(5))
#rename id
district=district.rename(columns={"id":"district_id"})
# split
x = []
y = []
z = []
for i in range(len(district)):
    x.append(district.municipality_info[i][1:-1].split(','))
    y.append(district.unemployment_rate[i][1:-1].split(','))
    z.append(district.commited_crimes[i][1:-1].split(','))
# y = re.split('\[|,|\] ',district.municipality_info[i])

info = pd.DataFrame(x)
unemployment = pd.DataFrame(y)
crimes = pd.DataFrame(z)

# create new columns and remove old columnd
district1 = district.assign(
    municipality_pop_500=info[0],
    municipality_pop_500_1999=info[1],
    municipality_pop_2000_9999=info[2],
    municipality_pop_10000=info[3],
    unemployment_rate_95=unemployment[0],
    unemployment_rate_96=unemployment[1],
    commited_crimes_95=crimes[0],
    commited_crimes_96=crimes[1]
).drop(['municipality_info', 'unemployment_rate', 'commited_crimes'], axis=1)


district1.to_csv("district_py.csv", index=0)

