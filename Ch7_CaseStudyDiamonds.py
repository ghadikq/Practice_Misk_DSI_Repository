# Chapter 7 Case-study: Diamonds

import pandas as pd
import numpy as np
import seaborn as sns
from scipy import stats
import statsmodels.api as sm
import math
from statsmodels.formula.api import ols

#Exercise 7.1 (Import and Examine)
jems = pd.read_csv('C:\\Users\\ghadi\\Documents\\DataSet\\diamonds.csv')
jems

#Exercise 7.2 (Examine structure) 
#Can you examine the structure of the DataFrame? 
#What type of data is contained in each column?
#Let’s begin exploring our data by looking
# at some basic plots and doing some transformations.

jems.shape
type(jems)
jems.columns
jems.info()
jems.describe()
jems.head()
jems.tail()
jems.sample(n=10)

#check data col correlation 
jems.corr()

# plot the data:
sns.boxplot(x="cut", y="price", data=jems)
sns.catplot(x="cut", y="price", data=jems)
sns.pointplot(x="cut", y="price", data=jems, join=False)
sns.catplot(x="cut", y="price", data=jems, kind="point")


#7.1 Exercises for Plotting, transforming and EDA

#Exercise 7.3 (Counting individual groups) 
# - How many diamonds with a clarity of category “IF” are present in the data-set?
clarity_IF = (jems['clarity'] == 'IF').value_counts()
clarity_IF[True]
#  - What fraction of the total do they represent?
clarity_IF[False]
len(diamonds[(diamonds.clarity == 'IF')])/len(diamonds)


#Exercise 7.4 (Summarizing proportions)
# - What proportion of the whole is made up of each category of clarity?
import sidetable
jems.stb.freq(['clarity'])

#Exercise 7.5 (Find specific diamonds prices) 
# - What is the cheapest diamond price overall?
jems['price'].min()
# - What is the range of diamond prices? 
print('Range for prices','(',jems['price'].min(),'-', jems['price'].max(),')') #long i can do the same with function
#can i short it like this ? YES!!
#create fun for range
def MyRange(x):
    return x.min() , x.max()
MyRange(jems['price'])

# - What is the average diamond price in each category of cut and color?
jems.groupby('cut')[['price']].mean() #wrong answer for Q / This for avg of price only for each Cut
jems.groupby('color')[['price']].mean()#wrong answer for Q /This for avg of color only for each Cut

# Correct answer is the intersection of both cut & color 
jems.groupby(['cut','color'])['price'].mean()#correct answer for Q

#Exercise 7.6 (Basic plotting) 
# Make a scatter plot that shows the diamond price described by carat.
sns.scatterplot(x="carat", y="price", data=jems)

#Exercise 7.7 (Applying transformations)
#  Apply a log10 transformation to both the price and carat and store these 
#  as new columns in the DataFrame: price_log10 and carat_log10.
jems['price_log10'] = np.log10(jems['price']) 
jems['carat_log10'] = np.log10(jems['carat']) 

#Exercise 7.8 (Basic plotting) 
# Redraw the scatterplot using the transformed values.
sns.scatterplot(x="carat_log10", y="price_log10", data=jems)

#Exercise 7.9 (Viewing models) 
# Define a linear model that describes the relatioship shown in the plot.
import statsmodels.api as sm
X = jems["carat_log10"]
y = jems["price_log10"]
# fit model on variabels 
model = sm.OLS(y, X).fit()
predictions = model.predict(X) # make the predictions by the model
# Print out the statistics for the model
model.summary()


#Exercise 7.10 (Export data) 
# Refer to the following table and save your data with 
# transformed values on your computer.
jems.to_csv('C:\\Users\\ghadi\\Documents\\Python_P\\diamonds.csv')	