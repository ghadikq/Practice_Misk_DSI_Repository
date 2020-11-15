#e-book Chapter 4 DataFrames in pandas Ex 4.6
import matplotlib.pyplot as plt
import pandas as pd
import numpy as np
import seaborn as sns
from scipy import stats
import statsmodels.api as sm
import math
from statsmodels.formula.api import ols

#Q1:Import the data set and assign it to the variable mtcars.
mtcars = pd.read_csv('C:\\Users\\ghadi\\Documents\\DataSet\\mtcars.csv')

#Q2 :Calculate the correlation between mpg and wt and test if it is significant.
cor = mtcars.corr()#all corr
cor
mtcars['mpg'].corr(mtcars['wt']) # good but its not test significant
#correct answer
import scipy.stats as stats
stats.pearsonr(mtcars['mpg'],mtcars['wt'])

#Q3 :Visualize the relationship in an XY scatter plot.
sns.scatterplot(x='wt', y='mpg' , data=mtcars)
sns.regplot(mtcars['wt'],mtcars['mpg'],ci=None)

#Q4 :Convert weight from pounds to kg.
mtcars['wt'] = mtcars['wt'] / 2.2046
mtcars['wt']
mtcars['wt_kg'] = mtcars['wt'] / 2.2046
mtcars['wt_kg']#new col with kg values 
mtcars['wt_kg_2'] = mtcars['wt'] * 0.453592
mtcars['wt_kg_2'] #same result
mtcars.head()

# Extra Fit Model

mtcars.head()
# specify model
mtcarsmodel = ols("mpg ~ wt", mtcars)
results = mtcarsmodel.fit()# fit model
# extract coefficients
results.params.Intercept
results.summary() # show model results
