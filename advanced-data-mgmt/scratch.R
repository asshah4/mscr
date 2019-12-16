#!/bash/bin/env Rscript

# Get libraries uploaded
source("0_libraries.R")

# Create facet wrapped grid
# Group by type
# Use built in x and y axis

ggplot(data = rop, aes(x = x, y = y, color = type)) + 
  geom_point() +
  geom_smooth(method = "lm") +
  scale_color_viridis_d() +
  labs(
    x = "The X Axis",
    y = "The Y Axis",
    title = "The Title"
  )
