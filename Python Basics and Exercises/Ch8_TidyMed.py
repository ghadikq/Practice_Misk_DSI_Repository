import pandas as pd
import numpy as np
import seaborn as sns
from scipy import stats
import statsmodels.api as sm
import math
from statsmodels.formula.api import ols



df = pd.DataFrame({
            'name': ["John Smith", "Jane Doe", "Mary Johnson"],
            'treatment_a': [None, 16, 3], 
            'treatment_b': [2, 11, 1]})
print(df)
#why not tidy ? one variable seberate treatment has catigory a & b

df_melt = pd.melt(df, id_vars='name')
print(df_melt)#kinda like pivot in R

# Tidy pivot_table
df_melt_pivot = pd.pivot_table(df_melt,
                               index='name',
                               columns='variable',
                               values='value')
                               
print(df_melt_pivot)

#hierarchical index
df_melt_pivot.reset_index()
print(df_melt_pivot)

# groupby operations
print(df_melt)

df_melt.groupby('name')['value'].mean()

# Exercise 8.2 (Import data)
#  Import Expression.txt. Save it as an object called medi.
medi = pd.read_table('C:\\Users\\ghadi\\Documents\\DataSet\\Expression.txt',sep='\t')
medi.columns # this help us detect _ in col names
medi_index = medi.reset_index()
medi_index

#Exercise 8.3 (Tidy data) 
# Convert the data set to a tidy format.
# Below is wrong since there is 3 var in var col ([ gene , treatment , time])
medi_melt = pd.melt(medi_index,id_vars='index')
medi_melt
# we need to splet into col 
medi_melt['treatment'] = medi_melt['variable'].str.split('_').get(0)
medi_melt['treatment'] , medi_melt['gene']



# chapter 9
# Ex 9.1
plant_growth = pd.read_csv('C:\\Users\\ghadi\\Documents\\DataSet\\plant_growth.csv')
plant_growth.columns
# return groups without group by  [ctrl,trl1,trl2]
treatment_groups = plant_growth.group.unique()

for value in treatment_groups:
    #print(f"The value is {value} ")
    result = np.mean(plant_growth.weight[plant_growth.group == value])
    print(f"the mean of {value} is {result}.")

