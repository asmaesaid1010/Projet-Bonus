import re
import nltk
import pickle
import gensim
import warnings
import numpy as np
import pandas as pd
import pickle
import os

warnings.filterwarnings("ignore")


def process_text(complaint):
    print("Inside prediction")
    # Loading the saved model
    Project_path = "C:/Users/KVIP/Desktop/consumer_complaint_classification_exam/app//trained_models"
    model_path = Project_path + "/finalized_model.sav"
    model = pickle.load(open(model_path, 'rb'))
    vectorizer_path = Project_path + "/vectorizer.pickle"
    vectorizer = pickle.load(open(vectorizer_path, 'rb'))

    # complain = ["This company refuses to provide me verification and validation of debt""per my right under the FDCPA.I do not believe this debt is mine."]
    complaint = [complaint]
    text_features = vectorizer.transform(complaint)
    prediction = model.predict(text_features)
    rf_pred_prob = model.predict_proba(text_features)
    print("Result=", prediction[0], np.amax(rf_pred_prob))
    data = ["Bank account or service", "Consumer Loan", "Credit card", "Credit reporting", "Debt collection",
            "Money transfers", "Mortgage", "Other financial service", "Payday loan", "Prepaid card", "Student loan"]

    return data[prediction[0]], round(np.amax(rf_pred_prob), 2)
