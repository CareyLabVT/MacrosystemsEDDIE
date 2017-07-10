# Details of preparation and data wrangling for Macrosystems EDDIE
# Lake Sunapee

# Target simulation year: 2012

# Modifications of glm2.nml
- Start date: '2011-09-01 00:00:00' to have full ice-on period before 2012 simulation period
- End date: '2012-12-31 23:00:00'

- Output variables: 'temp', 'OXY_oxy', 'PHY_TCHLA', 'TOT_tp', 'TOT_tn'

- Initial water temperatures ("the_temps") are values from 9/17/2012  in 
	NKW's "temp.csv" file because temperatures down to 20m were not 
	available in 2011
- lake_depth set according to start date using NKW's "field_stage.csv" file
 
- In init_profiles section, modify num_wq_vars and wq_names to match current run
	(e.g., TOT_tn and TOT_tp when using "Sunapee2012_one_inflow_summed_nutrients.csv" inflow
	Estimates of wq_init_values based on NKW values, but summed for TN, TP
! LIES! Can't have TN, TP in initial conditions/inflow... used values from NKW 6/7/2017 calibration
	
- In inflows section, reduce to 1 inflow
modify num_wq_vars and wq_names to match current run
	(e.g., TOT_tn and TOT_tp when using "Sunapee2012_one_inflow_summed_nutrients.csv" inflow
