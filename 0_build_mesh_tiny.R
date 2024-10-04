
# Some librarires might not be required
library(dplyr)
library(DataExplorer)
library(ggplot2)
library(gstat)
library(INLA)
library(maptools)
# library(osmar)
library(osmdata)
library(plotly)
library(raster)
library(rgdal)
library(rgeos) #https://www.rdocumentation.org/packages/rgeos/versions/0.5-2/topics/gBuffer
library(sf)
library(sp)
library(spatialEco)
library(tidyverse)
library(spatstat)
library(stplanr)

# Import accident data and roads
load("roads_and_pts.RData")

# accident points
df2
df_sp1 <- df2

#######################################################
#######################################################
####################################################### Convert projection to UTM
#######################################################
#######################################################
coordinates(df_sp1) <- c("on_road_lon", "on_road_lat")
proj4string(df_sp1) <- CRS("+proj=longlat +datum=WGS84")  


# EPSG 23031 (Barcelona)
df_sp <- spTransform(df_sp1, CRS("+init=epsg:23031 +proj=utm +zone=31 +ellps=intl +units=m +no_defs")) 
df_sp

# Save as Data frame
df.utm <- as.data.frame(df_sp)

### Getting coordinates (UTM Coordinates)
coords2 <- as.matrix(df.utm[,40:41])



########################################################
########################################################
######################################################## Network Mesh
########################################################
########################################################

# Road network
osm1

osm2 <- spTransform(osm1, CRS("+init=epsg:4326"))

# Convert to UTM Projection
osm.utm <- spTransform(osm2, CRS("+init=epsg:23031 +proj=utm +zone=31 +ellps=intl +units=m +no_defs"))

plot(osm.utm)
points(coords2, pch = 8, col = "red", cex = 0.8)

# Creating buffer 10m 
line_buff <- gBuffer(osm.utm, width = 10, 
                     capStyle="SQUARE",
                     joinStyle="BEVEL")

osm_buff <- line_buff


plot(line_buff, main="Road Network with Buffer")
points(coords2, pch = 19, col = "red", cex = 0.8)



# Build Network Mesh (adjust max.edge and cutoff according to your dataset range values)
max.edge = diff(range(df.utm$UTM_on_road_lon))/15
cutoff = max.edge/100

mesh2 <- inla.mesh.2d(loc = coords2, 
                      boundary = osm_buff,  
                      max.edge = max.edge, 
                      cutoff = cutoff)

mesh2$n 

mesh.nw2 <- mesh2
plot(mesh.nw2)
points(coords2, col = "red", pch = 19, cex = 0.5)

