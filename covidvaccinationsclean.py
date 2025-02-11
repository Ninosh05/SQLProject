import pandas as pd

# File paths
input_file = "/Users/ninosh/Downloads/Analysis Project/csv/covidvaccinationscleaned.csv"  # Change to actual file name
output_file = "/Users/ninosh/Downloads/Analysis Project/csv/modifiedcovidvaccinations.csv"

# Chunk size (adjust if needed)
chunk_size = 5000  

# List of numeric columns that should NOT have empty strings (updated with your column names)
numeric_columns = [
    "total_tests", "total_tests_per_thousand", "new_tests_per_thousand", "new_tests_smoothed",
    "new_tests_smoothed_per_thousand", "positive_rate", "tests_per_case", "total_vaccinations",
    "people_vaccinated", "people_fully_vaccinated", "new_vaccinations", "new_vaccinations_smoothed",
    "total_vaccinations_per_hundred", "people_vaccinated_per_hundred", "people_fully_vaccinated_per_hundred",
    "new_vaccinations_smoothed_per_million", "stringency_index", "population_density", "median_age",
    "aged_65_older", "aged_70_older", "gdp_per_capita", "extreme_poverty", "cardiovasc_death_rate",
    "diabetes_prevalence", "female_smokers", "male_smokers", "handwashing_facilities", "hospital_beds_per_thousand",
    "life_expectancy", "human_development_index"
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
