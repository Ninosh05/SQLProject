import pandas as pd

# File paths
input_file = "/Users/ninosh/Downloads/Analysis Project/csv/coviddeathfixed1.csv"  # Change to actual file name
output_file = "/Users/ninosh/Downloads/modifiedcoviddeath_file.csv"

# Chunk size (adjust if needed)
chunk_size = 5000  

# List of numeric columns that should NOT have empty strings
numeric_columns = [
    "population", "new_cases", "new_cases_smoothed", "total_deaths", "new_deaths",
    "new_deaths_smoothed", "total_cases_per_million", "new_cases_per_million",
    "new_cases_smoothed_per_million", "total_deaths_per_million", "new_deaths_per_million",
    "new_deaths_smoothed_per_million", "reproduction_rate", "icu_patients",
    "icu_patients_per_million", "hosp_patients", "hosp_patients_per_million",
    "weekly_icu_admissions", "weekly_icu_admissions_per_million", "weekly_hosp_admissions",
    "weekly_hosp_admissions_per_million", "new_tests"
]

# Process CSV in chunks
with pd.read_csv(input_file, chunksize=chunk_size, dtype=str) as reader:  
    for i, chunk in enumerate(reader):
        # Replace empty strings with NaN (NULL)
        chunk.replace({"": pd.NA}, inplace=True)

        # Convert numeric columns to numbers, forcing NULL for empty/non-numeric values
        for col in numeric_columns:
            if col in chunk.columns:
                chunk[col] = pd.to_numeric(chunk[col], errors="coerce")  

        # Append chunk to file (write header only for the first chunk)
        chunk.to_csv(output_file, mode="a", header=(i == 0), index=False, na_rep="NULL")  

print("✅ Processing complete! Modified CSV is ready for MySQL import.")

