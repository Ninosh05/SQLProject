# SQLProject
This repository provides a comprehensive approach to tracking the global impact of COVID-19 and the progress of vaccination efforts.

This repository contains SQL scripts designed to clean, analyze, and visualize COVID-19 data. It focuses on two key datasets: coviddeathfixed (COVID-19 cases and deaths) and covidvaccinationscleaned (vaccination statistics). The scripts perform the following:

Data Cleanup:

Standardizes continent and location fields by removing unwanted characters and filling in missing values.
Vaccination and Case Analysis:

Joins data from both datasets, computes running totals of vaccinations (RollingPeopleVaccinated), and calculates the percentage of the population vaccinated.
Aggregated Metrics:

Computes key metrics such as death percentages, and infection rates, and identifies locations with the highest infection rates.
Temporary Table & View Creation:

Creates a temporary table and a view (PercentPopulationVaccinated) for storing and querying vaccination progress over time.
