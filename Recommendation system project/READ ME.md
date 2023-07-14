Project Guideline: Nintendo Switch Game Recommendation System

1/ Web Scraping: 
1.1/ 
Start by using the Beautiful Soup library in Python to extract data from websites related to Nintendo Switch games.Identify suitable websites that provide information about game titles,descriptions, reviews, ratings, and other relevant details. 
1.2/ 
Once the data is extracted, perform data cleaning to ensure the extractedtext is in a usable format. Remove any unnecessary HTML tags, specialcharacters, or irrelevant information. Additionally, drop any null entries to ensure data quality.

2/ Clustering Analysis: 
2.1/ Apply unsupervised learning techniques,including K-means clustering, DBSCAN, hierarchical clustering, andnatural language processing (NLP), to group the Nintendo Switch games based on their textual features. These techniques will help identifyclusters of similar games. 
2.2/ Preprocess the textual data by tokenizing it into individual words or phrases, stemming the tokens to their root form, and then vectorizing them using NLTK\'s TF-IDF vectorizer. This process converts the textual data into numericalrepresentations suitable for clustering analysis. 
2.3/ Compute thesimilarity distances between the games using the TF-IDF matrix. This is achieved by subtracting the cosine similarity of the vectorizedrepresentations from 1. The resulting similarity distances provide a measure of dissimilarity between games. 
2.4/ Implement the recommendation system by querying the similarity matrix. When a user
selects a specific game, retrieve the top 5 closest games based on their
similarity distances. These recommended games will be similar in terms
of textual features and can be suggested to the user.

3/ Web App Development: 
3.1/ Utilize Streamlit, a Python library forbuilding interactive web applications, to develop a local webapplication for the Nintendo Switch game recommendation system. Design a user-friendly interface that allows users to input their preferred game title or select from a list of available games.
