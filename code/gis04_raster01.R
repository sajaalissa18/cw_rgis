# Raster 1: Basic terra operations

if (!require(pacman)) install.packages("pacman")

pacman::p_load(tidyverse,
               terra,
               tidyterra,
               mapview,
                stars)

# raster data format ------------------------------------------------------

# rast() is a function to read data from your directory 
spr_ex <- rast("data/spr_example.tif")

# writeRaster() is a function to export raster data

writeRaster(x = spr_ex,
            filename = "data/spr_elev.tif",
            overwrite = TRUE)


# visualize raster data; geom_spatraster() (from "tidyterre" package)

ggplot() + 
  geom_spatraster(
    data = spr_ex)


# if you want mapview() function to work
star_ex <- st_as_stars(spr_ex)
mapview(star_ex)


# data type in raster -----------------------------------------------------

# continuous
v_elev <- values(spr_ex)

# extract elevation value at a given location
extract(spr_ex, y = cbind(6.0000, 50.0000))

# pick three spots from the map
# try to get the highest 
extract(spr_ex, y = cbind(5.9, 49.85))

# lowest
extract(spr_ex, y = cbind(6.1, 49.7))

# random
extract(spr_ex, y = cbind(6.4, 49.8))

# extract data at multiple points
df_point <- tibble(
  lon = c(6, 5.9),
  lat = c(50, 49.96)
  )

extract(spr_ex, y = df_point)


# discrere data
# -0, 1 binary representation 
spr_for <- rast("data/spr_forest_nc.tif")

ggplot() +
  geom_spatraster(data = spr_for)

unique(spr_for)

v_binary <- values(spr_for)
mean(v_binary) * 100


# multiple classes - code values with multiple categories 

spr_land <- rast("data/spr_land_reclass.tif")

#1001 = forest
#1010 = crop
#1100 = urban 

unique(spr_land)

# coordinate, lon -79.8063 lat 36.0701
extract(spr_land, cbind(-79.8063, 36.0701))

#reclass
# -matrix for category mappig
cm <- cbind(
  c(0, 1001, 1010, 1100),
  c(0, 1, 0, 0)
)

spr_bin <- classify(spr_land,
                    rcl = cm)

unique(spr_bin)
v_bin <- values(spr_bin)
mean(v_bin) * 100

# calculate % cropland
cm_crop <- cbind(
  c(0, 1001, 1010, 1100),
  c(0, 0,1, 0)
)

# calculate % urban 

cm_urban <- cbind(
  c(0, 1001, 1010, 1100),
  c(0, 0,1, 0)
)

spr_urban <- classify(spr_land,
                      rcl = cm_urban)

unique(spr_urban)
v_urban <- values(spr_urban)
mean(v_urban) * 100



# exercise ----------------------------------------------------------------

#1 Read a GeoTIFF file (ref: Section 4.2.1)
#Load the raster file spr_prec_ncne.tif from the data folder using the terra::rast() function.
#Assign the result to a new object named spr_prec_ncne.


spr_prec_ncne <-rast("data/spr_prec_ncne.tif")

spr_prec_ncne <- terra::rast("data/spr_prec_ncne.tif")

#2 Inspect raster properties (ref: Section 4.2.1)
#In your own words, describe the following based on the output:
#Number of rows and columns (i.e., the raster dimensions)
#Resolution (size of each cell in degrees)
#Spatial extent (minimum and maximum coordinates)
#Coordinate Reference System
#Minimum and maximum precipitation values

# num rows = 162, num columns = 532
#resolution = -79.89181, -75.45847
# long extent = -79.89181, -75.45847
# lat extent = 35.24153, 36.59153
# CRS = WGS84
# min max precipitation = 1063.1 - 1501.5


#3 Visualize the raster (ref: Section 4.2.3)
#Use ggplot2 with tidyterra::geom_spatraster() to create a basic map of the precipitation raster.

 
ggplot() +
  geom_spatraster(data = spr_prec_ncne)

#4 Extract values (ref: Section 4.2.4)
#Read the fish sampling site data from data/sf_finsync_nc.rds and assign it to sf_site.
#st_coordinates(sf_site) will extract coordinates from the sf object as a dataframe. Assign this data frame to df_xy.
#Using terra::extract() function with inputs spr_land and df_xy, identify land use type at each sampling site. Assign the result to df_land.
#Identify the most common land use type at these sampling sites.

sf_site <- readRDS("data/sf_finsync_nc.rds")

df_xy <- st_coordinates(sf_site) 

df_land <- extract(spr_land, df_xy)

# forest
 df_land %>%
 filter(code == 1001) %>%
   nrow()
 
# cropland
    df_land %>%
      filter(code == 1010) %>%
     nrow()
    
 # urban
   df_land %>%
          filter(code == 1100) %>% 
     nrow()
   
 # quicker approach
    table(df_land)








