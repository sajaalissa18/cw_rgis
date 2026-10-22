#' rater 2 
if (!require(pacman)) install.packages("pacman")

pacman::p_load(tidyverse,
               terra,
               tidyterra,
               mapview,
               stars)


#erase existing objects 
rm(list = ls())

(spr_prec <- rast("data/spr_prec_us.tif"))          
ext(spr_prec)

# precipitation exapmle ---------------------------------------------------

ggplot()+
  geom_spatraster(data = spr_prec)

spr_prec_crop <- crop(x = spr_prec,
                      y = c(-80, -75, 34, 37))

sf_nc_county <- readRDS("data/sf_nc_county.rds")

## a map of cropped data
ggplot() + geom_spatraster(data = spr_prec)


ggplot() +
  geom_spatraster(data = spr_prec_crop) +
  geom_sf(data = sf_nc_county,
          alpha = 0.25)

## use polygon layer to crop raster
spr_prec_nc <- crop(x = spr_prec,
                    y = sf_nc_county)


## map spr_prec_nc with sf_nc_county

ggplot() +
  geom_spatraster(data = spr_prec_nc) +
  geom_sf(data = sf_nc_county,
          alpha = 0.25)


# merge -------------------------------------------------------------------

spr_nw <- rast("data/spr_prec_ncnw.tif") 
spr_ne <- rast("data/spr_prec_ncne.tif") 
spr_sw <- rast("data/spr_prec_ncsw.tif") 
spr_se <- rast("data/spr_prec_ncse.tif") 

## north west portion of nc  
ggplot() +
  geom_spatraster(data = spr_nw) +
  geom_sf(data = sf_nc_county,
          alpha = 0.25)


## south west portion of NC 

ggplot() +
  geom_spatraster(data = spr_sw) +
  geom_sf(data = sf_nc_county,
          alpha = 0.25)


## merge() function to combine two panels , then map

spr_n <- merge(spr_nw, spr_ne)

ggplot() +
  geom_spatraster(data = spr_n) +
  geom_sf(data = sf_nc_county,
          alpha = 0.25)

## merge more then two panels into one 

list_spr <- list(spr_ne,
                 spr_nw,
                 spr_se,
                 spr_sw) 

# convert from list to spatraster collection

spr_col <- sprc(list_spr)

## merge more then two panels

spr_merge <- merge(spr_col)

# map spr_merge and sf_nc_county  

ggplot() +
  geom_spatraster(data = spr_merge) +
  geom_sf(data = sf_nc_county,
          alpha = 0.25,
          fill ="tomato")


writeRaster(spr_merge, 
            filename = "data/spr_prec_nc.tif",
            overwrite = TRUE) 
# stack -------------------------------------------------------------------

spr_prec_nc <- rast("data/spr_prec_nc.tif")
spr_tmp_nc <- rast("data/spr_tmp_nc.tif")


ggplot() +
  geom_spatraster(data = spr_tmp_nc) +
  geom_sf(data = sf_nc_county,
          alpha = 0.25)


# create a multi-layer raster ("stack")

(spr_pt_nc <- c(spr_prec_nc,
                spr_tmp_nc))

## access one layer
## - precipitation

spr_pt_nc$precipitation


## - temperature

spr_pt_nc$temperature
## try to stack "spr_ne" and "spr_tmp_nc"
# c(spr_ne, spr_tmp_nc)
# this would not work because of spatial extent mismatch

# reprojection ------------------------------------------------------------

# reprojection - tranform CRS from one to another
# most cases, from geodetic to projected CRS
spr_prec_nc_proj <- project(x = spr_prec_nc,
                            y = "EPSG: 32617") # 32617 UTM Zone 17N



# exercise ----------------------------------------------------------------

#1Merge raster files (ref: Section 4.3.2)
#Load four regional temperature tiles: spr_tmp_ncnw.tif (Northwest), spr_tmp_ncne.tif (Northeast), spr_tmp_ncsw.tif (Southwest), spr_tmp_ncse.tif (Southeast). Assign them to separate objects (object names of your choice).
#Merge all four using:
#A list of rasters.
#terra::sprc() to create a SpatRasterCollection.
#merge() to combine all tiles into spr_merge.
#Plot spr_merge over sf_nc_county to confirm coverage. Use ggplot2::ggplot() with geom_spatraster() and geom_sf() (Tip: Use alpha = 0.25 in geom_sf() to make the polygons transparent.)


##1. merge raster files
spr_tmp_ncnw <- rast("data/spr_tmp_ncnw.tif")
spr_tmp_ncne <- rast("data/spr_tmp_ncne.tif")
spr_tmp_ncsw <- rast("data/spr_tmp_ncsw.tif")
spr_tmp_ncse <- rast("data/spr_tmp_ncse.tif")

list_tmp <-list( 
  spr_tmp_ncnw,
  spr_tmp_ncne,
  spr_tmp_ncsw,
  spr_tmp_ncse
)
  
tmp_sprc <-  sprc(list_tmp) 
spr_merge < merge(tmp_sprc)

 ggplot() +
geom_spatraster(data= spr_merge)+
geom_sf(data = sf_nc_county,
          fill = "green",
          alpha = 0.25)

#2Crop raster to a defined extent (ref: Section 4.3.1)
#Select county camden from sf_nc_county (from data/sf_nc_county.rds) and assign it to sf_camden.
#Inspect its spatial extent (sf_camden) using terra::ext().
#Crop spr_merge to the extent of the camden county using sf_camden (use terra::crop())
#Assign the cropped raster to spr_tmp_camden.
#Plot spr_tmp_camden over sf_nc_county to confirm coverage. Use ggplot2::ggplot() with geom_spatraster() and geom_sf() (Tip: Use alpha = 0.25 in geom_sf() to make the polygons transparent.)

 sf_camden <- sf_nc_county %>%
   filter(county == "camden")
 
 ext(sf_camden)
 
 spr_tmp_camden <- crop(x = spr_merge,
                        y = sf_camden)
 
 ggplot() +
   geom_spatraster(data = spr_tmp_camden) +
   geom_sf(data = sf_nc_county,
           alpha = 0.25) 
 
 
#3 Reproject raster and explore resampling (ref: Section 4.3.4)
#Reproject spr_tmp_camden to a projected CRS: UTM Zone 18N (EPSG:32618). Use terra::project() with y = "EPSG:32618". Given the data type of the temperature layer, choose an appropriate method of resampling (either method = "near" or method = "bilinear").
#Assign to spr_tmp_camden_proj.
#Inspect the new CRS and resolution by printing the projected object.

 spr_tmp_camden_proj <- project(x = spr_tmp_camden,
                             y = "EPSG: 32618",
                             method = "bilinear") 
 

#for the last exercise of reprojection,
# use the following criterion
# if the data represents a continuous variable (1.2, 1.5, 100.2 etc
#then method = "bilinear"
#if the data represents a discrete variable (1, 1001, 1010, 1100, etc -e.g., land use classification)
#then method = "near"] exercise :Search
