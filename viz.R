#####################
# Install/load Libs #
#####################

pkgs = c(
  "devtools",       # for install_github
  "sf",             # spatial data classes
  "rgeos",          # spatial data classes
  "rnaturalearth",  # world map data
  "purrr",          # visualisation
  "ggplot2",        # visualisation
  "animation"
)
to_install = !pkgs %in% installed.packages()
if(any(to_install)) {
  install.packages(pkgs[to_install])
}
devtools::install_github("thomasp85/transformr")

library(sf)
library(rnaturalearth)
library(purrr)
library(animation)


##################
# WORLD GEOMETRY #
##################

scaler = function(x, y, z) {
  (x - z) * y + z
}

world_orig = ne_countries(returnclass = "sf")
retain = which(world_orig$region_wb != 'Antarctica')
world_cc = world_orig$iso_a2[retain]
world_orig = world_orig$geometry[retain]

scaled_geo = function(world_orig, world_cc, iso_code, s) {
  country_sel = world_orig[which(world_cc==iso_code)]
  country_poly = st_cast(country_sel, "POLYGON")
  country_geom = st_geometry(country_poly) 
  country_center = st_centroid(country_geom)
  country_transf = st_sf(st_sfc(pmap(list(country_geom, s, country_center), scaler), crs = st_crs(world_orig)))
    
  return(country_transf)
}


################################
# GET INFO FROM GOOGLE REPORTS #
################################


USE_DATA = 0 # 0 is Retail & recreation
DATA_DESC = "Mobility trends for places like restaurants,\ncafes, shopping centers, theme parks,\nmuseums, libraries, and movie theaters"
DATA_TITLE = 'Stopped Going Out'
YLIM = c(-75, 20)

# USE_DATA = 1 # 1 is Grocery & pharmacy
# DATA_DESC = "Mobility trends for places like grocery markets,\nfood warehouses, farmers markets, specialty\nfood shops, drug stores, and pharmacies"
# DATA_TITLE = 'Stopped Shopping'
# YLIM = c(-70, 40)

# USE_DATA = 2 # 2 is Parks -- weird data, why is UK missing?
# DATA_DESC = "Mobility trends for places like national parks,\npublic beaches, marinas, dog parks, plazas,\nand public gardens"
# DATA_TITLE = 'Stopped Breathing'
# YLIM = c(-70, 80)

# USE_DATA = 3 # 3 is Transit stations
# DATA_DESC = "Mobility trends for places like public transport\nhubs such as subway, bus, and train stations"
# DATA_TITLE = 'Stopped Moving'
# YLIM = c(-75, 20)

# USE_DATA = 4 # 4 is Workplaces
# DATA_DESC = "Mobility trends for places of work"
# DATA_TITLE = 'Stopped Working'
# YLIM = c(-75, 20)

# USE_DATA = 5 # 5 is Residentials - weird data, why is UK missing? Also kind of funky with this visualization
# DATA_DESC = "Mobility trends for places of residence"
# DATA_TITLE = 'Stayed Home'
# YLIM = c(-10, 40)

countries = list()
for (f in list.files('reports_2020-03-29/')) {
  if (endsWith(f, '_0.csv')) {
    cc = substr(f, start = 1, stop = 2)
    try({
      mobile_data = read.csv(paste0('reports_2020-03-29/', cc, '_',USE_DATA, '.csv'), header=0, sep=' ')
      countries[[cc]] = (60 - mobile_data$V2)/100 + 1
      if (any(is.na(countries[[cc]]))) {
        countries[[cc]] = NULL
      }
    })
  }
}

dates = list()
for (i in seq_along(countries[[1]])) {
  dates[[i]] = as.Date('15/02/2020', format = "%d/%m/%y") + i
}

country_continent = read.csv('country_continent.csv', na.strings='')
get_col = function(col) {
  cols = list(
    `Africa` = 'red3',
    `South America` = 'green4',
    Oceania = 'yellow',
    Asia = 'purple',
    Antarctica = 'black',
    Europe = 'blue',
    `North America` = 'orange'
  )
  if (cc %in% c('GE','KZ','TR')) {
    # a few countries missing in that list
    col = cols[['Asia']]
  } else {
    col = cols[[as.character(country_continent$Continent_Name[country_continent$Two_Letter_Country_Code == cc])]]
  }
  return (col)
}

known_world_poly = st_cast(world_orig[which(world_cc %in% names(countries))], "POLYGON")
unknown_world_poly = st_cast(world_orig[which(!(world_cc %in% names(countries)))], "POLYGON")

# we start at day=14 (not much interesting variations before)
d1 = 14

# output and animate the map
worlds_animate = saveGIF({
  for (d in d1:(length(dates)+10)) {
    if (d > length(dates)) {
      d = length(dates)
    }
    par(mar=c(0,0,0,0), fig=c(0,1,0,1))
    plot(known_world_poly, col = 'grey', border = 'darkgrey', bg='lightblue')
    plot(unknown_world_poly, col='grey93', border = 'darkgrey', bg=NA, add=T)
    for (cc in names(countries)) {
      f = countries[[cc]][d]
      plot(scaled_geo(world_orig, world_cc ,cc, f),
           col = get_col(cc),
           add = T)
    }
    text(-180, 110, paste0('COVID-19:\nHow The World ',DATA_TITLE), adj = c(0,0.5), xpd=T, cex = 2.5)
    text(180, 110, paste0("* ",DATA_DESC,"\naggregated by Google"), adj = c(1,0.5), xpd=T, cex = 1)
    text(190,-105, "github.com/jealie/google_covid19", srt=90, cex=0.8, adj=c(0,0))
    par(mfg = c(1, 1), fig=c(0,1,0,0.2), mar=c(2,5,0,2))
    plot(1, 1, type='n', xlim=c(d1+0.5,43+0.5), ylim=YLIM, xlab='', ylab='  % CHANGE', bty='n', xaxt='n', yaxt='n', bg=NA, cex.lab=1.25)
    axis(2, at=pretty(YLIM), las=2, cex=1.1, xpd=T)
    axis(1, at=c(14,21,28,35,43), labels=c(dates[[14]], dates[[21]], dates[[28]], dates[[35]], dates[[43]]), las=1, cex.axis=1.25)
    for (cc in names(countries)) {
      points(d1:d,(countries[[cc]][d1:d]-1)*100, type='l', col=get_col(cc), xpd=T)
      points(d,(countries[[cc]][d]-1)*100, type='p', col=get_col(cc), pch=20, cex=2, xpd=T)
    }
  }
}, paste0("Google_",USE_DATA," ",DATA_TITLE,".gif"), ani.width=952, ani.height=629)
