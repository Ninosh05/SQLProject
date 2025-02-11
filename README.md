# SQLProject
This repository contains a project for cleaning and analyzing COVID-19 data, which includes files for both Python and SQL-based workflows. The data is sourced from two primary CSV files: coviddeathfixed and covidvaccinationscleaned. The project consists of the following steps:

Step 1: Data Cleaning (Python)
Cleaning the CSV Files: The initial step involves using Python to clean the coviddeathfixed and covidvaccinationscleaned CSV files.
Date Formatting: I created a Python file that handles date formatting to ensure consistency between the two datasets.
Handling Population Issues: There was an issue with the population column in the coviddeathfixed dataset, where missing or incorrect values needed correction. I’ve added a file named secondround to address these specific issues.
Data Import: Once cleaned using Python, the data is ready for analysis and further processing.


Step 2: SQL Data Handling (MySQL Workbench)
After cleaning the data, the next step involves importing the data into MySQL Workbench for analysis.

Handling NULL and Empty Values: The coviddeathfixed and covidvaccinationscleaned tables required specific updates to handle cases where the continent field was missing or where '0' or empty values existed.



SQL Operations:
I performed a variety of SQL operations to analyze COVID cases, death rates, population data, and vaccination data.
Several queries were used to calculate death likelihood, infection rates, and vaccination percentages across locations.
This included creating views to store data for visualization purposes and calculating rolling vaccinations to estimate the proportion of the population vaccinated over time.
Key Features:
Python Files: Used for data cleaning, handling date formats, and fixing population column issues.
CSV Files: The cleaned datasets are saved as CSV files for easy reuse.
SQL Queries: The main analysis is done in SQL Workbench, with the code adjusted for MySQL Workbench rather than other SQL environments.
Visualizations: The final analysis can be used to generate insights on COVID vaccination rates, death rates, and infection rates across different locations.



Step-by-Step Workflow:
Use the Python files to clean the data, starting with date formatting and handling any population column issues using the secondround file.
Import the cleaned data into MySQL Workbench.
Perform SQL queries to clean up any remaining inconsistencies in the data.
Conduct various analyses on the COVID data to derive insights on cases, deaths, and vaccination rates.
Optionally, create views in SQL to store data for future visualizations.
