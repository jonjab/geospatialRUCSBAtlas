# this script

library(tidyverse)
library(rgdal)
library(RColorBrewer)
library(raster)

# ep 1.

# downsizing the campus DEM so that it's more usable
campus_DEM <- raster("source_data/greatercampusDEM/greatercampusDEM_1_1.tif")
campus_DEM_downsampled <- aggregate(campus_DEM, fact = 4,
                                    filename = "output_data/campus_DEM.tif",
                                    overwrite = TRUE)


# create a hillshade for our area of an appropriate resolution
aspect <- terrain(campus_DEM_downsampled, 
        opt="aspect", unit="radians", neighbors=8, 
        filename="output_data/aspect.tiff", overwrite = TRUE)
slope <- terrain(campus_DEM_downsampled, 
        opt="slope", neighbors=8, 
        filename="output_data/slope.tiff", overwrite = TRUE)

hillShade(slope, aspect, angle=260, direction=0, 
          filename="output_data/hillshade.tiff", overwrite = TRUE, 
          normalize=FALSE)


# ep 3 

# needs a raster in a different projection. let's try this

download.file("https://pubs.usgs.gov/ds/781/OffshoreCoalOilPoint/data/Bathymetry_OffshoreCoalOilPoint.zip", "source_data/Bathymetry_OffshoreCoalOilPoint.zip")

unzip("source_data/Bathymetry_OffshoreCoalOilPoint.zip",
      overwrite = TRUE, 
      exdir = "source_data/Bathymetry_OffshoreCoalOilPoint")

bathymetry <- 
  raster("source_data/Bathymetry_OffshoreCoalOilPoint/Bathymetry_2m_OffshoreCoalOilPoint.tif")

# downsample it so it's runnable
bathymetry_downsample <- aggregate(bathymetry, fact = 4)
writeRaster(bathymetry_downsample, "output_data/SB_bath.tif", format="GTiff", overwrite=TRUE)

