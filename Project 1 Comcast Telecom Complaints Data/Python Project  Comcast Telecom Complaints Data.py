# import libraries 
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
import numpy as np 

#import dataset 
df_telecom = pd.read_csv('C:\\Users\\ghadi\\Documents\\DataSet\\Comcast_telecom_complaints_data.csv')


# preform EDA 
df_telecom.dtypes


df_telecom.head()


df_telecom.info()


df_telecom.shape


df_telecom.columns


# orginize date & time
df_telecom["Date Index"] = df_telecom["Date_month_year"] + " " + df_telecom["Time"]


df_telecom["Date Index"]


df_telecom.dtypes


# now change Date col to datetime type
df_telecom["Date Index"] = pd.to_datetime(df_telecom["Date Index"])
df_telecom["Date_month_year"]=pd.to_datetime(df_telecom["Date_month_year"])

df_telecom.dtypes



df_telecom.head()



# set date index as index col
df_telecom=df_telecom.set_index(df_telecom["Date Index"])


df_telecom.head()


# Provide the trend chart for the number of complaints 
# at monthly and daily granularity levels.
# top 5 complains 
df_telecom["Date_month_year"].value_counts()[:5]


# plot daily level
df_telecom["Date_month_year"].value_counts().plot();

df_telecom["Date_month_year"].dt.month.value_counts()


# plot monthly level
df_telecom["Date_month_year"].dt.month.value_counts().plot();


#- Provide a table with the frequency of complaint types.
pd.crosstab(index=df_telecom['Received Via'], columns='frequency')


# Which complaint types are maximum i.e., around internet, network issues, or across any other domains
df_telecom.groupby(["Received Via"]).size().sort_values(ascending=False).to_frame().idxmax()


#- Create a new categorical variable with value as Open and Closed.
#  Open & Pending is to be categorized as Open and
#  Closed & Solved is to be categorized as Closed.
df_telecom.Status.unique()

#categorical variable Open
df_telecom["NewStatus"] = ["Open" if (status == "Open" or status == "Pending")
                           else "Closed" for status in df_telecom["Status"]]



df_telecom['NewStatus'].unique()


# Provide state wise status of complaints in a stacked bar chart.
# Use the categorized variable from Q3.
# Provide insights on:
#     1-Which state has the maximum complaints
#     2-Which state has the highest percentage of unresolved complaints
# Provide the percentage of complaints resolved till date, 
# which were received through the Internet and customer care calls.


#df_telecom.groupby(["State"]).size()
# sort & use to frame to change it to df
df_telecom.groupby(["State"]).size().sort_values(ascending=False).to_frame().reset_index().rename({0:"Count"},axis=1)[:10]


status_complaints = df_telecom.groupby(["State","NewStatus"]).size().unstack().fillna(0)
status_complaints


# now plot bar chart 
status_complaints.plot(kind="barh",figsize=(20,30),stacked=True)
plt.rcParams.update({"font.size":30})


# state has the maximum complaints
df_telecom.groupby(["State"]).size().sort_values(ascending=False).to_frame().idxmax()


# state with high pre of unresolved complaints
status_complaints["Open"].idxmax()

#- Provide the percentage of complaints resolved till date, which were received through the Internet and customer care calls.
ICCount = df_telecom[(df_telecom['NewStatus'] == 'Closed') & (df_telecom['Received Via'] == 'Internet') | (df_telecom['Received Via'] == 'Customer Care Call')]	
len(ICCount)
len(df_telecom)
percentagecres =  (len(ICCount)/len(df_telecom))*100
percentagecres


# Try to apply LDA to this dataset 
get_ipython().system('pip install wordcloud')


from wordcloud import WordCloud,STOPWORDS


txt = df_telecom["Customer Complaint"].values


wc = WordCloud(width=200 , height=100 , background_color="black",stopwords=STOPWORDS).generate(str(txt))


fig = plt.figure(figsize=(10,10),facecolor='k',edgecolor='w')
#plt.imshow(wc,interpolation="bicubic")
plt.imshow(wc,interpolation="bilinear")

plt.axis("off")
plt.tight_layout()
plt.show()
# display most used words in complaint so we get idea at what they complaint about 
# comcast = comanpy name since its not complimaint


#NLP 
from nltk.corpus import stopwords
from nltk.stem.wordnet import WordNetLemmatizer
import string

stop = set(stopwords.words('english'))#import en dic
exclude = set(string.punctuation)
lemma = WordNetLemmatizer()


# create fun to clean data
def clean(doc):
    stop_free = " ".join([i for i in doc.lower().split() if i not in stop])
    punc_free = "".join([ch for ch in stop_free if ch not in exclude])
    normalised = " ".join(lemma.lemmatize(word) for word in punc_free.split())
    return normalised


import nltk
nltk.download('wordnet')


doc_complete = df_telecom["Customer Complaint"].tolist()#transform to list to preform LDA
doc_clean = [clean(doc).split() for doc in doc_complete]


get_ipython().system('pip install gensim')


import gensim
from gensim import corpora


#create dictionary
dictionary = corpora.Dictionary(doc_clean)
print(dictionary)


# convert to doc matrix [doc2bow count words]
doc_term_matrix = [dictionary.doc2bow(doc) for doc in doc_clean]
doc_term_matrix


from gensim.models import LdaModel


NUM_TOPICS = 9
ldamodel = LdaModel(doc_term_matrix, num_topics=NUM_TOPICS, id2word=dictionary,passes=30)


topics = ldamodel.show_topics()
for topic in topics:
    print(topic)
    print()


word_dict = {}
for i in range(NUM_TOPICS):
    words = ldamodel.show_topic(i, topn = 20)
    word_dict["Topics #" + "{}".format(i)] = [i[0] for i in words]


#ldamodel.show_topics(1, topn = 20)
pd.DataFrame(word_dict)


ldamodel.show_topic(0, topn = 20)


get_ipython().system('pip install pyldavis')


# Q can search for how to plot ?
import pyLDAvis.gensim

Lda_display = pyLDAvis.gensim.prepare(ldamodel,doc_term_matrix,dictionary,sort_topics=False)
pyLDAvis.display(Lda_display)

#df_telecom['Correspond'] = df_telecom.lookup(df_telecom.index, df_telecom['Customer Complaint'].map())
ldamodel.show_topic(0, topn =10)

# now since i know the word that most repeated in Customer Complaint i can explor 
# the Customer Complain Description to see the Complaint i need to obtain
# top 5 complaint types 
b = df_telecom[df_telecom['Customer Complaint'].str.contains("billing")]
b
s = df_telecom[df_telecom['Customer Complaint'].str.contains("service")]
s
d = df_telecom[df_telecom['Customer Complaint'].str.contains("data")]
d
e= df_telecom[df_telecom['Customer Complaint'].str.contains("speed")]
e
i = df_telecom[df_telecom['Customer Complaint'].str.contains("internet")]
i



