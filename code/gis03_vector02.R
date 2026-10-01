#'Vector 2: spatial join

if (!require(pacman)) install.packages("pacman") 
 
pacman:: p_load(tidyverse,
        sf, mapview)

 # erase all objects in the environment
 rm(list = ls())
#read data
 sf_site <- readRDS("data/sf_finsync_nc.rds")
 sf_nc_county <- readRDS("data/sf_nc_county.rds")
# visualize
  mapview(sf_nc_county, legend = FALSE) + mapview(sf_site, legend = FALSE)
  
# join county information to sf_site
sf_site_join <- st_join(x = sf_site,
                        y = sf_nc_county)

    
  #join county information to sf_site
  
  sf_site_join <- st_join(x = sf_site,
                          y = sf_nc_county)

# count the number of fish survey sites within guilford county 

sf_site_guilford <- sf_site_join %>%
  filter(county == "guilford")


# count # sites in clay county

sf_site_clay <- sf_site_join %>%
  filter(county == "clay")

# re-read stream layer

sf_str <- readRDS("data/sf_stream_gi.rds")


#prduce a map withg guilford county polygon, sites within Guilford,
#and stream lines in guilford
#use ggplot() mapping functions 

sf_gi_county <- sf_nc_county %>%
  filter(county == "guilford")

ggplot()+
  geom_sf(data = sf_gi_county) +
  geom_sf(data = sf_str,
          color = "blue") +
  geom_sf(data = sf_site_guilford,
          color = "tomato")


# geometric analysis ------------------------------------------------------

sf_str_proj <- st_transform(sf_str, crs = 32617)

#caculate the length of each stream line segment

v_str_l  <- st_length(sf_str_proj)
head(v_str_l)

sf_str_w_len <- sf_str %>%
  mutate(length = v_str_l)



#area #

sf_nc_county_proj <- st_transform(sf_nc_county, crs = 32617)

#caculate the area of county

v_area <- st_area(sf_nc_county_proj)

# create a column "area in sf_nc_county_proj, and identify which county is largest
sf_nc_county_w_area <- sf_nc_county_proj %>%
  mutate(area = as.numeric(v_area) / 1E+6)%>% #unit conversion from m^2 to km^2
  arrange(desc(area))


#subset polygons for mapping 
sf_gi_county1k <- sf_nc_county_w_area %>%
  filter(area > 1000) #1000 km^2

# map the subset of counties

ggplot() +
  geom_sf(data = sf_county1k)



# exercise ----------------------------------------------------------------

#1 Spatial join of survey sites and counties (ref: Section 3.3.1)
#Load sf_quakes.rds from the data folder using readRDS(). This file should have been created through the exercise in Chapter 2.
#Assign the loaded object to sf_quakes.

sf_quakes <- readRDS("data/sf_quakes.rds")

#Read (a polygon for New Zealand) with readRDS(data/sf_nz.rds) and assign the resulting object to sf_nz.
#Visualize the point and polygon layers with mapview(sf_nz) + mapview(sf_quakes).

sf_nz <- readRDS("data/sf_nz.rds")

#Perform a spatial join between the quake object sf_quakes and the New Zealand polgyon object sf_nz.
#Assign the resulting joined object to sf_quakes_join.

sf_quakes_join <- st_join(sf_quakes, sf_nz)

#In sf_quakes_join, earthquake events that occurred outside New Zealand should have NA in the fid column. Use drop_na(sf_quakes_join, fid) to remove quakes that occurred outside New Zealand, and assign the resulting object to sf_quakes_nz.
#Count the number of earthquake events in New Zealand by counting the number of rows in sf_quakes_nz. Use nrow() function to count.
sf_quakes_join <- sf_quakes_join %>%
  drop_na(fid)

#2 Count survey sites per county (ref: group operation)
#Using sf_site_join, calculate the number of survey sites in each county. Use as_tibble() to make it a regular tibble, then use dplyr::group_by() to group by county.
#Then use dplyr::summarize() to create a new column n containing the count of survey sites.
#Assign the resulting object to df_n.

df_n <- sf_site_join %>%
  as_tibble() %>%
  group_by(county) %>%
  summarize(n = n())



#3 Subset counties with more than ten sites (ref: Section 3.3)
#Join df_n to sf_nc_county by using left_join(). Assign the resulting object to sf_n_site.
#From sf_n_site, retain only counties with more than 10 survey sites using dplyr::filter().
#Assign the subsetted object to sf_n10.

sf_n10 <- sf_n_site %>%
  filter(n > 10)
  
#4 Visualize the distribution on a stacked map (ref: Section 3.2.6)
#Create a layered (stacked) map showing sf_nc_coundy, sf_n_site and sf_n10. Use geom_sf() function.
#Plot sf_n_site polygons in grey to show all counties with at least one site.
#Overlay sf_n10 polygons in salmon to highlight counties with more than three sites.

ggplot() +
  geom_sf(data = sf_nc_county) +
  geom_sf(data = sf_n_site %>%
            filter(n > 1),
          fill = "grey") +
  geom_sf(data = sf_n10,
           fill = "salmon")





