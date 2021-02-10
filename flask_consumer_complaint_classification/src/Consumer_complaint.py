# Importing libraries
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from nltk.stem import SnowballStemmer
from nltk.corpus import stopwords
from sklearn.feature_extraction.text import CountVectorizer, TfidfVectorizer
from sklearn.model_selection import train_test_split
from textblob import TextBlob
from nltk.stem import PorterStemmer
from textblob import Word
from sklearn import model_selection, preprocessing, linear_model, metrics
from sklearn.linear_model import LogisticRegression
import seaborn as sns
import pandas as pd
import pickle
import nltk
import re
from bs4 import BeautifulSoup
from wordcloud import WordCloud
import os

# import data: sourced from kaggle
data = pd.read_csv('../data/consumer_complaints.csv', encoding='latin-1')
pd.set_option('display.max_columns', 500)
pd.set_option('display.max_rows', 100)
pd.set_option('display.max_colwidth', -1)
# print(data)


## Data understanding
pd.notnull(data['consumer_complaint_narrative']).value_counts()

# selecting needed columns
data = data[['product', 'consumer_complaint_narrative']]
data = data[pd.notnull(data['consumer_complaint_narrative'])]
# print(data)

# missing heat map
sns.heatmap(data.isnull(), cbar=False)
plt.title('Heatmap of missingness')
plt.show()
np.sum(data.isnull())

# remove na from consumer_complaint_narrative
data = data[pd.notnull(data['consumer_complaint_narrative'])]

np.sum(data.isnull())
print(data.head())
# factorize product column into categories
data['category_id'] = data['product'].factorize()[0]
print(data.head())

print(data['category_id'].nunique())
print(data.groupby('product').count())

# Visualizing data distribution on pie chart
fig = plt.figure(figsize=(8, 6))
data.groupby('product').consumer_complaint_narrative.count().plot.pie(ylim=0)
plt.show()

# Visualizing data distribution on bar plot
fig = plt.figure(figsize=(10, 8))
data.groupby('product').consumer_complaint_narrative.count().plot.bar(ylim=0)
plt.show()

# Futher analysis of product using Wordcloud
categ = data.groupby('product').agg({"consumer_complaint_narrative": ' | '.join})
#print(categ)

# modelling


# splitting the data
x_train, x_test, y_train, y_test = model_selection.train_test_split(data['consumer_complaint_narrative'],
                                                                    data['product'])
# word emedding using term frequency - inverse document frequency TFIDF
encoder = preprocessing.LabelEncoder()
y_train = encoder.fit_transform(y_train)
y_test = encoder.fit_transform(y_test)

tfidf_vec = TfidfVectorizer(analyzer='word',
                            token_pattern=r'\w{1,}',
                            max_features=5000)
tfidf_vec.fit(data['consumer_complaint_narrative'])
xtrain_tfidf = tfidf_vec.transform(x_train)
xtest_tfidf = tfidf_vec.transform(x_test)

# modelling
model = linear_model.LogisticRegression(solver='newton-cg',
                                        multi_class='multinomial').fit(xtrain_tfidf,
                                                                       y_train)

# save the model to disk
filename = '../data/finalized_model.sav'
pickle.dump(model, open(filename, 'wb'))
# Save vectorizer
pickle.dump(tfidf_vec, open("../data/vectorizer.pickle", "wb"))

# checking accuracy
accuracy = metrics.accuracy_score(model.predict(xtest_tfidf), y_test)
print("Accuracy: ", accuracy)

# classification report
print(metrics.classification_report(y_test, model.predict(xtest_tfidf),
                                    target_names=data['product'].unique()))

complain = ["I am writing to your company about a problem with my Hoverbike, a 2012 Skylark model. I began to have trouble staying aloft a few months ago, and this week the height control module completely failed. While the bicycle is a few months out of warranty, I believe that this occurred because of a design flaw in the Skylark, and I am asking that your company cover or share with me the cost of the required repair."]

text_features = tfidf_vec.transform(complain)
predictions = model.predict(text_features)
print(predictions[0])
print(complain)
print('Is predicted as: {}'.format(data.loc[data['category_id'] == predictions[0],
                                            'product'].iloc[0]))
