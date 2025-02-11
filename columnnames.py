import pandas as pd

csv_file = "/Users/ninosh/Downloads/CovidVaccinations.csv"

# Load a small part of the file to check column names
df_sample = pd.read_csv(csv_file, nrows=5)
print(df_sample.columns)
