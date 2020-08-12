library(ggplot2)
library(rgdal)
library(gridExtra)

# https://www1.nyc.gov/site/planning/data-maps/open-data/districts-download-metadata.page
# EPSG 2263
boro <- readOGR(dsn = "nybb_19d", layer = "nybb")
boro.df <- fortify(boro)
# Export shapefile to csv for use in python
write.csv(boro.df, "boro_shape.csv")

data <- read.csv("nycrimemap.csv")
pl <- data[data$OFNS_DESC == 'PETIT LARCENY',]
h2 <- data[data$OFNS_DESC == 'HARRASSMENT 2',]
a3 <- data[data$OFNS_DESC == 'ASSAULT 3 & RELATED OFFENSES',]
cm <- data[data$OFNS_DESC == 'CRIMINAL MISCHIEF & RELATED OF',]
gl <- data[data$OFNS_DESC == 'GRAND LARCENY',]
dd <- data[data$OFNS_DESC == 'DANGEROUS DRUGS',]
po <- data[data$OFNS_DESC == 'OFF. AGNST PUB ORD SENSBLTY &',]
fa <- data[data$OFNS_DESC == 'FELONY ASSAULT',]
rob <- data[data$OFNS_DESC == 'ROBBERY',]
burg <- data[data$OFNS_DESC == 'BURGLARY',]

pl.coord <- ggplot(data = pl, aes(x = SPAT_LON, y = SPAT_LAT))
h2.coord <- ggplot(data = h2, aes(x = SPAT_LON, y = SPAT_LAT))
a3.coord <- ggplot(data = a3, aes(x = SPAT_LON, y = SPAT_LAT))
cm.coord <- ggplot(data = cm, aes(x = SPAT_LON, y = SPAT_LAT))
gl.coord <- ggplot(data = gl, aes(x = SPAT_LON, y = SPAT_LAT))
dd.coord <- ggplot(data = dd, aes(x = SPAT_LON, y = SPAT_LAT))
po.coord <- ggplot(data = po, aes(x = SPAT_LON, y = SPAT_LAT))
fa.coord <- ggplot(data = fa, aes(x = SPAT_LON, y = SPAT_LAT))
rob.coord <- ggplot(data = rob, aes(x = SPAT_LON, y = SPAT_LAT))
burg.coord <- ggplot(data = burg, aes(x = SPAT_LON, y = SPAT_LAT))

boro.fill <- geom_polygon(data = boro.df,
                          aes(x = long, y = lat, group = group),
                          color = "black", fill = "#949494", alpha = 0.3)

pl.label <- labs(x = NULL, y = NULL, title = "Mapping of NYC Petit Larceny Crimes")
h2.label <- labs(x = NULL, y = NULL, title = "Mapping of NYC Harrassment 2 Crimes")
a3.label <- labs(x = NULL, y = NULL, title = "Mapping of NYC Assault 3 Crimes")
cm.label <- labs(x = NULL, y = NULL, title = "Mapping of NYC Criminal Mischief Crimes")
gl.label <- labs(x = NULL, y = NULL, title = "Mapping of NYC Grand Larceny Crimes")
dd.label <- labs(x = NULL, y = NULL, title = "Mapping of NYC Dangerous Drugs Crimes")
po.label <- labs(x = NULL, y = NULL, title = "Mapping of NYC Offenses Against Public Order Crimes")
fa.label <- labs(x = NULL, y = NULL, title = "Mapping of NYC Felony Assault Crimes")
rob.label <- labs(x = NULL, y = NULL, title = "Mapping of NYC Robbery Crimes")
burg.label <- labs(x = NULL, y = NULL, title = "Mapping of NYC Burglary Crimes")

themes <- theme_void() + theme(legend.position = "none",
                               panel.background = element_rect(fill = "#2D2D2D"),
                               plot.background = element_rect(fill = "#949494"),
                               legend.key = element_rect(fill = "#2D2D2D"),
                               plot.title = element_text(face = "bold", hjust = 0.5, size = rel(1.5))) 

pl.map <- pl.coord + geom_point(color = "#9D00FF", shape = ".", alpha = 0.1) + boro.fill + pl.label + themes
h2.map <- h2.coord + geom_point(color = "#E6FB04", shape = ".", alpha = 0.1) + boro.fill + h2.label + themes 
a3.map <- a3.coord + geom_point(color = "#00FF33", shape = ".", alpha = 0.1) + boro.fill + a3.label + themes 
cm.map <- cm.coord + geom_point(color = "#FF0099", shape = ".", alpha = 0.1) + boro.fill + cm.label + themes
gl.map <- gl.coord + geom_point(color = "#00FFFF", shape = ".", alpha = 0.1) + boro.fill + gl.label + themes
dd.map <- dd.coord + geom_point(color = "#FF0000", shape = ".", alpha = 0.1) + boro.fill + dd.label + themes
po.map <- po.coord + geom_point(color = "#FF6600", shape = ".", alpha = 0.1) + boro.fill + po.label + themes
fa.map <- fa.coord + geom_point(color = "#0033FF", shape = ".", alpha = 0.1) + boro.fill + fa.label + themes
rob.map <- rob.coord + geom_point(color = "#097A25", shape = ".", alpha = 0.1) + boro.fill + rob.label + themes
burg.map <- burg.coord + geom_point(color = "#FFE5B4", shape = ".", alpha = 0.1) + boro.fill + burg.label + themes

ny.map <- grid.arrange(pl.map, h2.map, a3.map, cm.map, gl.map, dd.map, po.map, fa.map, rob.map, burg.map, ncol = 2, nrow = 5)

final <- ggsave("gradient.png", plot = burg.map, width = 20, height = 12)

ggsave("ny_map.png", plot = ny.map , width = 22, height = 30)
