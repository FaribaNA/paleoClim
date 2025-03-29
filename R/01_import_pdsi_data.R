# load required libraries 

library(raster)
library(ncdf4)
library(data.table)

# aim: convert pdsi netcdf file to data.table with cols:lon,lat,date, value

##step1:
#define file path

raw_path <- "data/raw/"
processed_path <- "data/processed/"
#step2:
#brick 

pdsi_brick <- brick(paste0(raw_path,"phyda_pdsi_land_1_2000_1_yearly.nc"))
##step3:
# tidy up data

pdsi_df <- as.data.frame(pdsi_brick, xy=TRUE)
pdsi_df
pdsi_dt <- as.data.table(pdsi_df)
rm(pdsi_df)
pdsi_dt <- melt(pdsi_dt, id.vars = c("x","y"))
pdsi_dt[, variable := as.Date(variable, format = "X%Y.%m.%d")]
setnames(pdsi_dt, c("x","y","variable","value"),c("lon","lat","date","value"))
#step4:
#save processed data

saveRDS(pdsi_dt,paste0(processed_path,"pdsi_tidy.rds"))
