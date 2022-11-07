# wildfire-PM2.5-comparison

## Generating figures:
* Make_scatterplots.Rmd -- create scatterplots of the observations in the validation set, colored by year and by state; make a map of the locations of the monitors in the validation set (colored by how many days each monitor was collecting data)
* Map_county_averages.Rmd -- show overall and seasonal county averages (maps) for the Di and Reid datasets as well as the differences between them
* Spatial-temporal_plots.Rmd -- plotting spatial and temporal metrics by subset (year, state, season)

## Calculating results:
* Investigate_peak_months.R -- analyze the mean and maximum values in the Reid and Di datasets, across state-month-year combinations
* Summary-stats_validation-set.R -- Generating summary statistics of the validation set
* Metrics.Rmd -- Calculating the main comparison results (i.e. Di vs Monitor and Reid vs Monitor)
* Spatial-temporal_metrics.Rmd -- Calculating spatial and temporal metrics by subset (e.g. warm season vs cold season), and comparing the Reid and Di results
* AQI_table.R -- Calculating the AQI classification and binary classification results

## Data processing:
* Process_raw_smoke_data.Rmd -- Extracts data from the raw Airsis and WRCC (smoke validation monitor) files.
* Monitor_processing.Rmd -- Combines Airsis and WRCC data. Data points from this validation set are removed if they are over 1,000 $\mu g / m^3$ or if they overlap with the Reid training observations. Later, we determined that this was insufficient for removing all overlapping points, so the final cleaning steps are shown in Removing-overlap_validation-set.Rmd
* Reid_processing.Rmd -- Aggregates any duplicated observations in the Reid dataset.
* Nearest points.Rmd -- For each monitor observation, finds the nearest Reid and Di observations.
* Add_covariates.R -- Making sure the spatial and temporal covariates (e.g. "GEOID" and "warm season") were filled in and consistent throughout the main validation set (2008-2016).
* get_Pop-density.R -- obtaining and merging in population density data to enable weighting by population density
 
## Obtaining data:
* Although the validation monitor observations were obtained using the R package PWFSLSmoke, we actually were sent the data resulting from this query by a member of the AirFire research team.
* The Di data can be accessed on the [NASA SEDAC website](https://sedac.ciesin.columbia.edu/data/set/aqdh-pm2-5-concentrations-contiguous-us-1-km-2000-2016) 
* The Reid data can be accessed on [Figshare](https://figshare.com/articles/dataset/Machine_learning_derived_daily_PM2_5_concentration_estimates_from_by_County_ZIP_code_and_census_tract_in_11_western_states_2008-2018/12568496/1). 
