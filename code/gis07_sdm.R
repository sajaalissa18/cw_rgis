#' rastert/ vector interaction 
if (!require(pacman)) install.packages("pacman")

pacman::p_load(tidyverse,
               ggeffects,
               sf,
               terra,
               tidyterra,
               exactextractr,
               mapview)



# linking gis to ecology --------------------------------------------------

df_finsync <- read_csv("data/data_finsync_nc.csv")

## this returns 1426 rows
nrow(df_finsync)

df_st1 <- df_finsync %>% 
    filter(site_id == "finsync_nrs_nc-10013")


## manipulate data format

df_rbs <- df_finsync %>% 
    mutate(presence = 1) %>% 
    pivot_wider(id_cols = c(site_id, lon, lat),
                names_from = latin,
                values_from = presence,
                values_fill = 0) %>% 
    select(site_id,
           lon,
           lat,
           "Lepomis auritus") %>% 
    rename(y = "Lepomis auritus")


## assciate environmental factors 

sf_rbs <- df_rbs %>% 
  st_as_sf(coords = c("lon", "lat"),
           crs = 4326)


## read temperature raster
spr_tmp_nc <- rast("data/spr_tmp_nc.tif")

## extract values at the survey sites
sf_rbs_tmp <- extract(x = spr_tmp_nc,
                      y = sf_rbs,
                      bind = TRUE) %>% 
  st_as_sf()

df_rbs_tmp <- as_tibble(sf_rbs_tmp) %>% 
    select(-geometry)

## draw a figure that relate y (fish 1/0) to temperature
## y is on y-axis
## temperature on x-axis 


df_rbs_tmp %>%
  ggplot(aes(y = y, 
             x = temperature)) +
  geom_point() +
  theme_bw() 

## mapping 

ggplot() +
  geom_spatraster(data = spr_tmp_nc) + 
  geom_sf(
    data = sf_rbs,
          aes(color = factor(y))
    )+ 
  scale_fill_viridis_c() +   
  theme_bw()   


# statistical analysis ----------------------------------------------------


m <- glm(y ~ temperature,
          data = df_rbs_tmp,
          family = "binomial")





summary(m)


## visualize model output

df_pred <- ggpredict(m,
                     terms = "temperature [9.35:17.35, by = 0.01]")

ggplot() +
  geom_point(data = df_rbs_tmp,
             aes(x = temperature,
                 y = y
                 )
             ) +
  geom_line(
    data = df_pred,
            aes(
              x = x,
                y = predicted
              )
    ) +
  geom_ribbon(
    data = df_pred,
              aes(x = x,
                  ymin = conf.low,
                  ymax = conf.high
                  ),
              fill = "grey",
              alpha = 0.2
    ) +
  labs(
    x = "Air temperature",
       y = "Probability of occurrence"
       ) +
  theme_bw()


# plan for data analysis --------------------------------------------------

unique(df_finsync$latin)


df_finsync %>%
  group_by(latin) %>%
  summarize(n_present = n_distinct(site_id)) %>%
  view()






