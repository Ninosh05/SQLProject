import pandas as pd

# Load the CSV
df = pd.read_csv("/Users/ninosh/Downloads/modifiedcoviddeath_file.csv")

# Ensure population is a number (convert invalid values to NaN)
df["population"] = pd.to_numeric(df["population"], errors="coerce")

# Save back to CSV with NULL values correctly formatted
df.to_csv("Coviddeathfixed.csv", index=False, na_rep="NULL")