import sys
import pickle
import re
import os

# Define the absolute paths to your files
base_dir = 'C:\\Users\\greet\\OneDrive\\Desktop\\Projectt\\tacaServer\\scripts'
model_path = os.path.join(base_dir, 'dummy_review_classifier.pkl')
vectorizer_path = os.path.join(base_dir, 'dummy_vectorizer.pkl')

# Load the model and vectorizer
with open(model_path, 'rb') as f:
    loaded_model = pickle.load(f)
with open(vectorizer_path, 'rb') as f:
    loaded_vectorizer = pickle.load(f)

# Text cleaning function
def preprocess_text(text):
    text = text.lower()
    text = re.sub(r'\W', ' ', text)
    text = re.sub(r'\s+', ' ', text)
    return text

# Function to classify using the loaded model
def classify_review_with_loaded_model(review_text):
    processed_text = preprocess_text(review_text)
    vectorized_text = loaded_vectorizer.transform([processed_text])
    prediction = loaded_model.predict(vectorized_text)[0]
    return 'good' if prediction == 1 else 'bad'

# Read the review text from the command line arguments
if __name__ == "__main__":
    review_text = sys.argv[1]
    classification = classify_review_with_loaded_model(review_text)
    print(classification)
