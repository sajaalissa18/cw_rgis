# vector1

if (!require(pacman)) install.packages("pacman")

pacman::p_load(tidyverse,
               sf,
               mapview)



# how to read vector data

sf_nc_county<-st_read(dsn = "data/nc.shp",
        quiet = TRUE) 

# how to export shape files
st_write(sf_nc_county,
         dsn = "data/sf_nc_county.shp",
         append = FALSE)

## RDS format

saveRDS(sf_nc_county,
        file = "data/sf_nc_county.rds")


sf_nc_county <- readRDS(file = "data/sf_nc_county.rds")

# point

sf_site <- readRDS("data/sf_finsync_nc.rds")


mapview(
  sf_site,
     col.regions = "black",# point's fill color
  legend = FALSE
  
  )






