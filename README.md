# spde-network-mesh
SPDE Network Mesh Design

# SPDE Network Triangulation for Traffic Accident Prediction

This repository contains the methodology and implementation for creating a network mesh specifically designed for traffic accident prediction using the Stochastic Partial Differential Equation (SPDE) approach. The following instructions outline the steps necessary to create the SPDE network triangulation based on road networks.

## Overview

The traditional methods of model prediction using a region mesh are not suitable for traffic accident data, as they may predict accidents in areas without road networks. To address this, we introduce a novel SPDE triangulation approach that focuses on road networks. The process involves several key steps:

1. Access the OSM road network.
2. Create a buffer for each road segment.
3. Generate a clipped buffer polygon.
4. Apply network triangulation.

## Prerequisites

- R programming environment
- Required R packages: `osmdata`, `stplanr`, and `INLA`

## Instructions

### Step 1: Access OSM Road Network

Utilize the `osmdata` R package to extract the road network for your study region. 

```r
# Install and load the necessary package
install.packages("osmdata")
library(osmdata)

# Access road network
# Define your area of interest and fetch the OSM data
# Example: region <- opq(bbox = "Your bounding box here") %>% osmdata_sf()

### Step 2: Create Buffer for Each Road Segment

Create a buffer around each road segment to account for GPS inaccuracies.

```r
# Load the stplanr package for geo_buffer function
install.packages("stplanr")
library(stplanr)

# Create a 20-meter buffer around each road segment
buffered_roads <- geo_buffer(your_osm_data, dist = 20)

### Step 3: Generate Clipped Buffer Polygon

Merge the individual buffer segments into a single polygon that is clipped within your study area's bounding box.

```r
# Create a bounding box for clipping
bounding_box <- st_as_sfc("Your bounding box here")

# Clip the buffered segments
clipped_polygon <- st_intersection(buffered_roads, bounding_box)

### Step 4: Apply Network Triangulation

Aggregate traffic accident events within the buffer area of each road segment and use the centroids for triangulation.

```r
# Use INLA to create the SPDE mesh
library(INLA)

# Define the maximum edge length and cutoff
max.edge <- c(50, 100)  # adjust as necessary
cutoff <- 10             # adjust as necessary

# Apply triangulation
spde_mesh <- inla.mesh.2d(clipped_polygon, max.edge = max.edge, cutoff = cutoff)

Step 5: Visualization and Finalization

Visualize the created network mesh along with the traffic accident locations.

```r
# Plotting the results
plot(spde_mesh)
points(traffic_accident_locations, col = "red", pch = 19)  # Adjust as necessary


## Results
The final SPDE network mesh is tailored to the road network, containing 12666 vertices and visualized along with 84360 traffic accident events.

## Conclusion
This methodology enables a more realistic prediction of traffic accidents by focusing solely on areas where they can realistically occur. The triangulation process, in combination with appropriate buffer sizes, leads to effective modeling and prediction.

## References

- Blangiardo, M., & Cameletti, M. (2015). Spatial and spatio-temporal Bayesian models with R-INLA. John Wiley & Sons.

- Lindgren, F. (2012). Continuous domain spatial models in R-INLA. The ISBA Bulletin, 19(4), 14-20.

- Lindgren, F., & Rue, H. (2015). Bayesian spatial modelling with R-INLA. Journal of statistical software, 63(19).

- Rue, H., Martino, S., & Chopin, N. (2009). Approximate Bayesian inference for latent Gaussian models by using integrated nested Laplace approximations. Journal of the Royal Statistical Society Series B: Statistical Methodology, 71(2), 319-392.

- Chaudhuri, S., Juan, P., & Mateu, J. (2022). Spatio-temporal modeling of traffic accidents incidence on urban road networks based on an explicit network triangulation. Journal of Applied Statistics, 1– 22. 

- Chaudhuri, S., Juan, P., Saurina, L. S., Varga, D., & Saez, M. (2023a). Modeling spatial dependencies of  natural hazards in coastal regions: a nonstationary approach with barriers. Stochastic Environmental  Research and Risk Assessment, 37(11), 4479-4498.

- Chaudhuri, S., Saez, M., Varga, D., & Juan, P. (2023b). Spatiotemporal modeling of traffic risk mapping:  A study of urban road networks in Barcelona, Spain. Spatial Statistics, 53, 100722.





