#e-book Chapter 6  Data Visualization
import pandas as pd
import numpy as np
import seaborn as sns
from scipy import stats
import statsmodels.api as sm
import math
from statsmodels.formula.api import ols

mtcars = pd.read_csv('C:\\Users\\ghadi\\Documents\\DataSet\\mtcars.csv')
print(mtcars.info())
mtcars.head()

#6.1 Plotting packages
import matplotlib.pyplot as plt
import seaborn as sns

#6.2 matplotlib
#6.2.1 Scatter plots
plt.scatter(mtcars["wt"], mtcars["mpg"], alpha=0.65)
plt.title('A basic scatter plot')
plt.xlabel('weight')
plt.ylabel('miles per gallon')
#plt.show()

# Create a Figure and an Axes with plt.subplots
fig, ax = plt.subplots(1, 3, sharex=True, sharey=True)
print(ax.shape)
# Make plot
for key, value in enumerate(mtcars["cyl"].unique()):
    ax[key].scatter(mtcars["wt"][mtcars["cyl"] == value], mtcars["mpg"][mtcars["cyl"] == value], alpha=0.65)
plt.show()

##still missing 


#6.3 seaborn
#6.3.1 Scatter plots

sns.scatterplot(x="wt", y="mpg", data = mtcars)
# Alternatively, using pandas Series:
sns.scatterplot(mtcars["wt"], mtcars["mpg"])

# prior to v0.9.0
sns.regplot(mtcars["wt"], mtcars["mpg"])

sns.scatterplot(x="wt", y="mpg", hue="cyl", data = mtcars)

#mtcars = mtcars.astype({"cyl": category}) didnt work
mtcars = mtcars.astype({"cyl": 'category'})
sns.scatterplot(x="wt", y="mpg", hue="cyl", data = mtcars)
# ^^ has problems cyl numeric & this work for char only so need to be cafefull from mismatch

mtcars['cyl'] = mtcars['cyl'].astype(object) #this solve type problem
sns.scatterplot(x='wt', y='mpg', hue='cyl', data = mtcars)

sns.scatterplot(x='wt', y='mpg', hue='cyl', palette=["r", "b", "g"], data = mtcars)

sns.scatterplot(x='wt', y='mpg', hue='cyl', palette=['#fc9272', '#ef3b2c', '#a50f15'], data = mtcars)
#add an aditional variable using the size:
sns.scatterplot(x='wt', y='mpg', hue='cyl', size='disp', palette=['#fc9272', '#ef3b2c', '#a50f15'], data = mtcars)
#multi plots
fig, ax = plt.subplots()
ax = sns.relplot(x='wt', y='mpg', hue='cyl', size='disp', col='gear', palette=['#fc9272', '#ef3b2c', '#a50f15'], data = mtcars)
plt.show()

#6.3.2 Bar charts
sns.countplot(x="cyl", data =mtcars)
sns.countplot(mtcars["cyl"])# direct to col 

# plot the means and error bars
sns.barplot(x="cyl", y="wt", hue="am", data=mtcars)

#6.3.3 Dot plots
fig, ax = plt.subplots()
ax = sns.catplot(x="cyl", y="wt", hue="am", kind="swarm", data=mtcars)
plt.show()