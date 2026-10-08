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


# POINT -------------------------------------------------------------------
#read point vector data

sf_site <- readRDS("data/sf_finsync_nc.rds")

# visualize

mapview(
  sf_site,
  col.regions = "black",# point's fill color
  legend = FALSE
  
)
# select the first 10 sites

sf_site_f10 <- sf_site %>%
  slice(1:10)


mapview(
  sf_site_f10,
  col.regions = "pink",
  legend = FALSE
)


#line -------------------------------------------------------------------

sf_str <- readRDS("data/sf_stream_gi.rds")



mapview(
  sf_str,
  color = "blue ",
  legend = FALSE
)



# polygon -----------------------------------------------------------------

sf_nc_county <- readRDS("data/sf_nc_county.rds")


mapview(
  sf_nc_county,
  col.regions = "yellow ",
  legend = FALSE
)

# choose "guilford" county , then map


sf_nc_gi <- sf_nc_county %>%
  filter(county == "guilford")

mapview(
  sf_nc_gi,
  col.regions = "grey",
  legend = FALSE
)



# static map in ggplot format ---------------------------------------------
# section label is crt + shift + R

ggplot() +
  geom_sf(data = sf_nc_county)

ggplot() +
  geom_sf(data = sf_nc_county) +
  geom_sf(data = sf_str)


ggplot() +
  geom_sf(data = sf_nc_county) +
  geom_sf(data = sf_str) +
  geom_sf(data = sf_site)




# EXERCISE ----------------------------------------------------------------

#1
#Read stream line data for Ashe county (ref: Section 3.2.2)
#Load the stream line data file sf_stream_as.rds located in the data folder. Use readRDS().
#Assign the loaded object to sf_str_as.

sf_str_as <- readRDS(file = "data/sf_stream_as.rds")

#2
#Check coordinate reference systems (CRS) (ref: Section 3.2.2)
#Print objects tocheck the CRS for both sf_str_as and sf_nc_county.
#Determine whether they share the same CRS.
sf_str_as
sf_nc_county



#3
#Map streams and county boundaries (ref: Section 3.2.6)
#Create a map displaying both: North Carolina county boundaries from sf_nc_county, and Ashe County stream lines from sf_str_as. Use ggplot2::ggplot() with multiple geom_sf() layers.

ggplot() +
  geom_sf(data = sf_nc_county) +
  geom_sf(data = sf_str_as) 


#4 
#Subset county layer to Ashe county and remap (ref: Section 3.2.5 and Section 3.2.6)
#Subset the sf_nc_county object to include only Ashe County. Use dplyr::filter() for subsetting. Assign the result to sf_nc_as.
#Then, recreate the map showing only sf_nc_as and sf_str_as.

sf_nc_as <- sf_nc_county %>%
  filter(county == "ashe")

ggplot() +
  geom_sf(data = sf_nc_as) +
  geom_sf(data = sf_str_as) 

