# load required libraries 

library(raster)
library(ncdf4)
library(data.table)

# aim: convert temp netcdf file to data.table with cols:lon,lat,date, value

##step1:
#define file path

raw_path <- "data/raw/"
processed_path <- "data/processed/"
#step2:
#brick 

temp_brick <- brick(paste0(raw_path,"phyda_temp_degC_land_1_2000_1_yearly.nc"))
##step3:
# tidy up data

temp_df <- as.data.frame(temp_brick, xy=TRUE)
temp_df
temp_dt <- as.data.table(temp_df)
rm(temp_df)
temp_dt <- melt(temp_dt, id.vars = c("x","y"))
temp_dt[, variable := as.Date(variable, format = "X%Y.%m.%d")]
setnames(temp_dt, c("x","y","variable","value"),c("lon","lat","date","value"))
#step4:
#save processed data

saveRDS(temp_dt,paste0(processed_path,"temp_tidy.rds"))
