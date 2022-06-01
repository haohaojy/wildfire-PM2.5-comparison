# wildfire-PM2.5-comparison

## Generating figures:
* Make_scatterplots.Rmd -- create scatterplots of the observations in the validation set, colored by year and by state; make a map of the locations of the monitors in the validation set (colored by how many days each monitor was collecting data)
* Pie_charts.R -- creating the pie charts to show proportions of observations by season, year, and state
* Spatial-temporal_plots.Rmd -- plotting spatial and temporal metrics by subset (year, state, season)

## Calculating results:
* Investigate_peak_months.R -- analyze the mean and maximum values in the Reid and Di datasets, across state-month-year combinations
* Summary-stats_validation-set.R -- Generating Tables 1 and 2 (summary statistics of the validation set)
* Metrics.Rmd -- Calculating the results in Table 3
* Spatial-temporal_metrics.Rmd -- Calculating spatial and temporal metrics by subset (year, state, season), and comparing the Reid and Di results
* AQI_table.R -- Calculating the AQI classification results

## Data processing:
*Note: though the validation monitor observations were obtained using the R package PWFSLSmoke, we actually were sent the data resulting from this query by a member of the AirFire research team.*
* Reid_processing.Rmd -- Aggregates any duplicated observations in the Reid dataset.
* Monitor_processing.Rmd -- Combines Airsis and WRCC (smoke validation monitor) data. Data points from this validation set are removed if they are over 1,000 $\mu g / m^3$ or if they overlap with the Reid training observations. Later, we determined that this was insufficient for removing all overlapping points, so the final cleaning steps are shown in Removing-overlap_validation-set.Rmd
* Nearest points.Rmd -- For each monitor observation, finds the nearest Reid and Di observations.
* Add_covariates.R -- Making sure the spatial and temporal covariates (e.g. "GEOID" and "warm season") were filled in and consistent throughout the main validation set (2008-2016).
* combine.rds data -- oldest script, used to merge the Reid data and validation monitor observations
 
