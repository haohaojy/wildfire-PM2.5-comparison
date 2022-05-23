# wildfire-PM2.5-comparison

## Generating figures:
* Make_scatterplots.Rmd -- create scatterplots of the observations in the validation set, colored by year and by state; make a map of the locations of the monitors in the validation set (colored by how many days each monitor was collecting data)
* Spatial-temporal_plots.Rmd -- plotting spatial and temporal metrics by subset (year, state, season)

## Calculating results:
* Summary-stats_validation-set.R -- Generating Tables 1 and 2 (summary statistics of the validation set)
* Metrics.Rmd -- Calculating the results in Table 3
* Spatial-temporal_metrics.Rmd -- Calculating spatial and temporal metrics by subset (year, state, season), and comparing the Reid and Di results
* AQI_table.R -- Calculating the AQI classification results

## Data processing:
* Note: though the validation monitor observations were obtained using the R package PWFSLSmoke, we actually were sent the data resulting from this query by a member of the AirFire research team.
* Reid_processing.Rmd -- Aggregates the duplicated observations in Reid data.
* Monitor_processing.Rmd --Combine Airsis and WRCC data. Data points from each validation set are removed (separately because they are over 1,000 and if they overlap with the Reid training data).
* Nearest points.Rmd -- Uses knnx function to find the pair of nearest points of two datasets and then combin them. 
* combine.rds data
_Colnames reference:_
For WRCC/Airsis data: "date"        "monitor"     "PM2.5"      "longitude"   "latitude"    "timezone"   "stateCode"   "monitorType" 

"X2": The distance between monitor and its nearest Reid data         

For Reid data: "DF_Lon"      "DF_Lat"  "County_FIPS" "Tract_code"  "Ens_pred"    "state"       "stateID"     "dataset"         
For Di data : "Lon"         "Lat"         "PM_grid"  "state_id" 
  
"diff_mo_ct" monitor-Reid 
"diff_mo_po" monitor-Di
"diff"  Reid-Di    
