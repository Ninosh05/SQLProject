import pandas as pd

# Load the COVID deaths CSV file
deaths_df = pd.read_csv('/Users/ninosh/Downloads/Analysis Project/csv/CovidDeaths.csv')  # Replace with the actual file path

# Convert 'date' column to datetime format
deaths_df['date'] = pd.to_datetime(deaths_df['date'], errors='coerce', format='%m/%d/%Y')

# Check for rows with missing values in the 'date' or 'location' columns
missing_data_deaths = deaths_df[deaths_df['date'].isna() | deaths_df['location'].isna()]

# Handle missing data for 'new_vaccinations' or 'date' if necessary
# You can fill or drop NaN values depending on your data
deaths_df['population'] = deaths_df['population'].fillna(0)

# Save the cleaned data to a new CSV file
deaths_df.to_csv('coviddeathsfixed.csv', index=False)

# Optionally print out the cleaned data or missing data
print("Missing data in COVID deaths file:")
print(missing_data_deaths)

print("Cleaned COVID deaths data saved to 'cleaned_covid_deaths.csv'")
