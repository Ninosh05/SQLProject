import pandas as pd

# Load the data
covid_death_df = pd.read_csv('/Users/ninosh/Downloads/Analysis Project/csv/Coviddeathfixed.csv')


# Replace "0" with a space for both location and continent
covid_death_df['continent'] = covid_death_df['continent'].replace('0', ' ', regex=True)
covid_death_df['location'] = covid_death_df['location'].replace('0', ' ', regex=True)


# Save cleaned data back to CSV
covid_death_df.to_csv('cleaned_coviddeathsfixed.csv', index=False)

print("Data cleaned and saved to 'cleaned_coviddeathsfixed.csv'")
