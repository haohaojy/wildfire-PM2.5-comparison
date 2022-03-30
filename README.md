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
* Removing-overlap_validation-set.Rmd -- Removes overlap in the validation observations with observations used to train the Reid model
* combine.rds data
_Colnames reference:_
For WRCC/Airsis data: "date"        "monitor"     "PM2.5"      "longitude"   "latitude"    "timezone"   "stateCode"   "monitorType" 

"X2": The distance between monitor and its nearest Reid data         

For Reid data: "DF_Lon"      "DF_Lat"  "County_FIPS" "Tract_code"  "Ens_pred"    "state"       "stateID"     "dataset"         
For Di data : "Lon"         "Lat"         "PM_grid"  "state_id" 
  
"diff_mo_ct" monitor-Reid 
"diff_mo_po" monitor-Di
"diff"  Reid-Di    
