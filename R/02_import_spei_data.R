# load required libraries 

library(raster)
library(ncdf4)
library(data.table)

# aim: convert spei netcdf file to data.table with cols:lon,lat,date, value

##step1:
#define file path

raw_path <- "data/raw/"
processed_path <- "data/processed/"
#step2:
#brick 

spei_brick <- brick(paste0(raw_path,"phyda_spei_land_1_2000_1_yearly.nc"))
##step3:
# tidy up data

spei_df <- as.data.frame(spei_brick, xy=TRUE)
spei_df
spei_dt <- as.data.table(spei_df)
rm(spei_df)
spei_dt <- melt(spei_dt, id.vars = c("x","y"))
spei_dt[, variable := as.Date(variable, format = "X%Y.%m.%d")]
setnames(spei_dt, c("x","y","variable","value"),c("lon","lat","date","value"))
#step4:
#save processed data

saveRDS(spei_dt,paste0(processed_path,"spei_tidy.rds"))
