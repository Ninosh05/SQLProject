import pandas as pd

# Load the COVID vaccinations CSV file
vaccinations_df = pd.read_csv('/Users/ninosh/Downloads/Analysis Project/csv/CovidVaccinationscleaned.csv')  # Replace with the actual file path

# Convert 'date' column to datetime format
vaccinations_df['date'] = pd.to_datetime(vaccinations_df['date'], errors='coerce', format='%m/%d/%Y')

# Handle any missing data for 'new_vaccinations'
vaccinations_df['new_vaccinations'] = vaccinations_df['new_vaccinations'].fillna(0)

# Check for rows with missing 'location' or 'new_vaccinations'
missing_data_vaccinations = vaccinations_df[vaccinations_df['location'].isna() | vaccinations_df['new_vaccinations'].isna()]

# Calculate total vaccinations per 'location' and 'date'
vaccinations_df['total_vaccinations'] = vaccinations_df.groupby(['location', 'date'])['new_vaccinations'].transform('sum')

# Save the cleaned data to a new CSV file
vaccinations_df.to_csv('cleaned_covid_vaccinations.csv', index=False)

# Optionally print out missing data or the cleaned dataset
print("Missing data in COVID vaccinations file:")
print(missing_data_vaccinations)

print("Cleaned COVID vaccinations data saved to 'cleaned_covid_vaccinations.csv'")
