#chapter 4 & 5 exercises answers in this file 

# initilize some pakages 
import math
import numpy as np
import pandas as pd
from scipy import stats
from scipy.stats import ttest_ind
from statsmodels.stats.multicomp import pairwise_tukeyhsd
from statsmodels.formula.api import ols
import seaborn as sns
import matplotlib.pyplot as plt

heights = [167, 188, 178, 194, 171, 169]
np.std(heights)

# Ex : Calculate 95% CI
m =  np.mean(heights)
std = np.std(heights)
n = len(heights)
print(m,std,n)
CiH = m + 1.96 * std / math.sqrt(n)
print(CiH)
CiL = m - 1.96 * std / math.sqrt(n)
print(CiL)

# direct fun in equation 
#CiHF = np.mean(heights) + 1.96 * np.std(heights) / math.sqrt(len(heights))
#print(CiHF)
# better use obj so we can use them later 

# Ans Q :
cities = ['Munich', 'Paris', 'Amsterdam', 'Madrid', 'Istanbul']
dist = [584, 1054, 653, 2301, 2191]
# Q1 : How many observation are there?
len(cities)
len(dist)
# Q2 : What is the longest and shortest distance?
min(dist)
max(dist)
# Q3 : Get the average distance ?
np.mean(dist)

# Ex:Visualize the values in the dist list as a univariate strip plot or a histogram
sns.histplot(dist) # easy way
sns.stripplot(dist) # easy way

# make own fun & class
def addNumbs(x, y):
    z = x + y
    return z

addNumbs(4, 6)

# define my own Ci fun
def confInt(x):
    m =  np.mean(x)
    std = np.std(x)
    n = len(x)
    CiH = m + 1.96 * std / math.sqrt(n)
    CiL = m - 1.96 * std / math.sqrt(n)
    return CiL , CiH

confInt(heights)
    
# lamda function 
raise_to_power =  lambda x, y: x ** y
raise_to_power(2, 3)

# list practice 
l = [1, "2", True]
l.append('appended value')
l
dist = [584, 1054, 653, 2301, 2191]

dist.append(560)
dist
dist.sort()
dist
dist.pop(2) #delete 653
dist
dist.remove(560)
dist
dist.count(2191)#return how many of this value repeted 
dist.index(1054)
dist.insert(1,999)
#append add at the end ,insert add at specific index
dist
dist.pop(1)
dist
dist.sort()
dist
dist.reverse()
dist

l.__len__

# dictionary
d = {'int_value':3, 
     'bool_value':False, 
     'str_value':'hello'}

print(d)

d['str_value']
#add value using list
organizations = {'name': ['Volkswagen', 'Daimler', 'Allianz', 'Charite'],
                 'structure': ['company', 'company', 'company', 'research']}
print(organizations['name'])
organizations['name']

# dictionary + Zip
heights = [167, 188, 178, 194, 171, 169]
persons = ["Mary", "John", "Kevin", "Elena", "Doug", "Galin"]
# combine 2 lists in one dictionary
heights_persons = dict(zip(persons, heights))
heights_persons

# Ex  3.16 combine list to dic
cities = ['Munich', 'Paris', 'Amsterdam', 'Madrid', 'Istanbul']
dist = [584, 1054, 653, 2301, 2191]
distDict = dict(zip(cities, dist))
distDict

#ndarray
xx = [3, 8, 9, 23]
print(xx)
type(xx)
xx = np.array([3, 8, 9, 23])
xx
type(xx)

yy =np.array([[5,7,8,9,3], 
          [0,3,6,8,2],
          range(5)])
yy

my_list = [1,6,9,36]

my_list + 100 #error
my_list + [100] #correct add 100 to array

# DF and Pandas

foo1 = [True, False, False, True, True, False]
foo2 = ["Liver", "Brain", "Testes", "Muscle", "Intestine", "Heart"]
foo3 = [13, 88, 1233, 55, 233, 18]

type(foo1)
type(foo2)
type(foo3)

foo_df = pd.DataFrame({'healthy': foo1, 'tissue': foo2, 'quantity': foo3})
foo_df

# EX : 4.1
# Exercise 4.1: Make a dictionary manually, then a DF
pd.DataFrame({'cities':cities,
              'dist':dist})

# Exercise 4.2: 
list_names = ['cities', 'dist']
list_values = [cities, dist]

pd.DataFrame(dict(zip(list_names, list_values)))


# names
list_names = ['healthy', 'tissue', 'quantity']

# columns are a list of lists
list_cols = [foo1, foo2, foo3]

zip_list = list(zip(list_names, list_cols))
print(zip_list)
zip_dict = dict(zip_list)
zip_df = pd.DataFrame(zip_dict)
print(zip_df)

# Exercise 4.2 (List to DataFrame)
list_names = ['cities', 'dist']
list_names
# Exercise 4.1: Make a dictionary manually, then a DF
pd.DataFrame({'cities':cities,
              'dist':dist})

# Exercise 4.2: 
list_names = ['cities', 'dist']
list_values = [cities, dist]

pd.DataFrame(dict(zip(list_names, list_values)))

#4.3 Accessing columns by name
foo_df['healthy']
foo_df[['healthy']]
foo_df.healthy

#Exercise 4.3 - What’s the difference between these two methods?
# one return dataframe the other return list
#Exercise 4.4 Select both the quantity and tissue columns.


##4.4 Broadcasting
foo_df['new'] = 0
foo_df
# creating a completely new DataFrame.
results = pd.DataFrame({'ID': 'A', 'value': range(10)})
results

#We can also drop columns by name using a drop method. Remember axis 1 refers to columns.
foo_df = foo_df.drop('new', axis = 1)
foo_df

#Exercise 4.5 Make a copy of foo_df, called foo_df_2. Access the .columns and .index attributes and change them to ['A', 'B', 'C'] and ['H', 'I', 'J', 'K', 'L', 'M'], 
foo_df_2 = foo_df.copy()
foo_df_2.columns = ['A', 'B', 'C']
foo_df_2.index = ['H', 'I', 'J', 'K', 'L', 'M']
print(foo_df_2)#copy
print(foo_df)#orginal 

#4.6 Change data types
df['A'] = df['A'].astype(str)
df.info()

#4.7 Accessors
df = pd.DataFrame({'name': ['Daniel  ','  Eric', '  Julia  ']})
df['name_strip'] = df['name'].str.strip()
df

df = pd.DataFrame({'name': ['Daniel','Eric', 'Julia'],
                   'gender':['Male', 'Male', 'Female']})

df['gender_cat'] = df['gender'].astype('category') 
df['gender_cat'].cat.categories
df.gender_cat.cat.codes

df = pd.DataFrame({'name': ['Rosaline Franklin', 'William Gosset'], 
                   'born': ['1920-07-25', '1876-06-13']})

df['born_dt'] = pd.to_datetime(df['born'])
df
#access date components with the dt accesso
df['born_dt'].dt.day
df['born_dt'].dt.month
df['born_dt'].dt.year

#4.8 Exercise = Exercise 4.6(in seperate file)

#4.9 Further Pandas
df = pd.DataFrame({
            'name': ["John Smith", "Jane Doe", "Mary Johnson"],
            'treatment_a': [None, 16, 3], 
            'treatment_b': [2, 11, 1]})

df

#How to replace the NaN with the mean of the row?
a_mean = df['treatment_a'].mean()
a_mean
df['a_fill'] = df['treatment_a'].fillna(a_mean)
df


#Ch5 Parsing Data

# 5.0.1 Indexing
foo_df

foo_df['tissue']
foo_df.tissue

# select items using using position
#this will show first row
foo_df.iloc[0]
foo_df.iloc[[0]]
foo_df.iloc[[0, 1]] #row 0&1
foo_df.iloc[0, :] #row 0 & all columns
foo_df.iloc[:, 0] #all row & col0
foo_df.iloc[[0, 1], :]#row0&1 & there all col
foo_df.iloc[:,:2]#all row & first 2 col all sol till 2 so 0,1 & exclude 2
foo_df.iloc[:,1:2]#all row & col 1
#countreverse direction -1 last row
foo_df.iloc[-1,]
foo_df

#Exercise 5.1 Using foo_df, what commands would I use to get:
#Q1 :The 2nd to 3rd rows?
foo_df.iloc[2:4,:]# NO 3 & 4
foo_df.iloc[[1,2]]
foo_df.iloc[[1,3],:]


#Q2 :The last 2 rows?
foo_df.iloc[4:6,:]#hard code
foo_df.iloc[-2:]#auto method
#Q3 :A random row in foo_df?
foo_df
foo_df.sample(axis='rows')

#Q4 :From the 4th to the last row? But without hard-coding, i.e. regardless of how many rows my data frame contains
foo_df.iloc[3:]
foo_df.iloc[3:,:]


#Exercise 5.2 List all the possible objects we can use inside iloc[]
foo_df.iloc[4]#int-yes
foo_df.iloc[4.1]#float-no
foo_df.iloc['A']#char-no
foo_df.iloc['Brain']#char-no
foo_df.iloc[,'tissue']#char-no

foo_df.iloc[:,[1,'quantity']]#heterogeneous list
foo_df.iloc[[1,2,3,1,5,1,1,3,-1,-4]]#homogeneous list

#Exercise 5.3(Indexing at intervals) Use indexing to obtain all the odd and even rows only from the foo_df data frame
#even rows 2nd,2th,6th
foo_df.iloc[1:2:end-1,:]
#odd rows 1st,3rd,5th
foo_df.iloc[::2, 1::2] #odd row & col
foo_df.iloc[::2]#odd row only 

foo_df.iloc[lambda x: x.index % == 2 ]#good solution but above easer 
foo_df[foo_df.index % 2 !=0] #??:P

#5.1 Logical Expressions
#5.1.1 Relational Operators & 5.1.2 Logical Operators just info
#5.1.3 Conditional sub-setting
foo_df[foo_df.quantity == 233]
foo_df[(foo_df.tissue == "Heart") | (foo_df.quantity == 233)]

foo_df
#5.2 Exercises for Parsing data

#For the following exercises, find all rows in foo_df that contain:
#Exercise 5.4 Subset for boolean data:
#Only “healthy” samples.
foo_df[foo_df.healthy == True] #no need for() cuz it boolean
foo_df[foo_df.healthy]#auto true better
#Only “unhealthy” samples.
foo_df[foo_df.healthy == False]
foo_df[-foo_df.healthy]
foo_df[~foo_df.healthy]

#Exercise 5.5 Subset for numerical data:
#Only low quantity samples, those below 100.
foo_df[(foo_df.quantity < 100)]
#Quantity between 100 and 1000,
foo_df[(foo_df.quantity > 100) & (foo_df.quantity < 1000)]

#Quantity below 100 and beyond 1000.
foo_df[(foo_df.quantity < 100) | (foo_df.quantity > 1000)]

#Exercise 5.6 Subset for strings:
#Only “heart” samples.
foo_df[(foo_df.tissue == 'Heart')]
#“Heart” and “liver” samples
foo_df[(foo_df.tissue == 'Heart') | (foo_df.tissue == 'Liver') ]
#Everything except “intestines”
foo_df[(foo_df.tissue != 'Intestine')]

#5.3 Other common operators
cities = ['Munich', 'Paris', 'Amsterdam', 'Madrid', 'Istanbul']
dist = [584, 1054, 653, 2301, 2191]

'Paris' in cities #True
'Tehran' in cities #False
'Paris' not in cities#False
'Tehran' not in cities#True

#5.3.2 Using and / or
'Paris' in cities and 'Tehran' not in cities#True
'Paris' in cities and 'Tehran' in cities#False
'Paris' in cities or 'Tehran' not in cities#True
'Paris' in cities or 'Tehran' in cities#True





