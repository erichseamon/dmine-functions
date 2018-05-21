getPR <- function(states, startDate, endDate){
  library(geoknife)
  scen_state = c("Washington")
  #scen_state = paste(states,sep="", collapse="|")
  
  setwd("/dmine/data/counties/")
  
  counties_palouse <- readShapePoly('threestate_palouse.shp', 
                            proj4string=CRS
                            ("+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0"))
  projection = CRS("+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0")
  
  counties_palouse@data$FIPS <- paste(counties_palouse@data$STATEFP, counties_palouse@data$COUNTYFP, sep="")
  
  
  counties_willamette <- readShapePoly('threestate_willamette.shp', 
                                    proj4string=CRS
                                    ("+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0"))
  projection = CRS("+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0")
  
  counties_willamette@data$FIPS <- paste(counties_willamette@data$STATEFP, counties_willamette@data$COUNTYFP, sep="")
  
  
  counties_snake <- readShapePoly('threestate_southernID.shp', 
                                    proj4string=CRS
                                    ("+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0"))
  projection = CRS("+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0")
  
  counties_snake@data$FIPS <- paste(counties_snake@data$STATEFP, counties_snake@data$COUNTYFP, sep="")
  
  
  #counties <- counties[grep("Idaho|Washington|Oregon|Montana", counties@data$STATE_NAME),]
  
  #counties <- counties[grep(scen_state, counties@data$STATE_NAME),]
  
  
  # use fips data from maps package
  #  counties_fips <- maps::county.fips %>% 
  #    mutate(statecounty=as.character(polyname)) %>% # character to split into state & county
  #    tidyr::separate(polyname, c('statename', 'county'), ',') %>%
  #    mutate(fips = sprintf('%05d', fips)) %>% # fips need 5 digits to join w/ geoknife result
  #    filter(statename %in% states) 
  
  stencil <- webgeom(geom = 'derivative:US_Counties',
                     attribute = 'FIPS',
                     values = counties_palouse$FIPS)
  
  fabric <- webdata(url = 'http://thredds.northwestknowledge.net:8080/thredds/dodsC/MET/pr/pr_2009.nc', 
                    variables = "precipitation_amount", 
                    times = c('2009-01-01', '2009-12-31'))
  
  job <- geoknife(stencil, fabric, wait = TRUE, REQUIRE_FULL_COVERAGE=FALSE)
  check(job)
  precipData_result <- result(job, with.units=TRUE)
  precipData_result_frame <- data.frame(colMeans(precipData_result[sapply(precipData_result, is.numeric)]))
  colnames(precipData_result_frame) <- c("precipitation_amount")
  precipData_result_frame$FIPS <- rownames(precipData_result_frame)
  
  #average by  month
  
datez <- do.call(rbind, strsplit(as.character(precipData_result$DateTime), '\\-'))
colnames(datez) <- c("Year", "Month", "Day")
precipData_result2 <- cbind(datez, precipData_result)
 
precipData_month_result <- aggregate(precipData_result[,5:27], by = list(precipData_result2$Month), FUN = "mean")
precipData_month_result <-  precipData_month_result[,2:23]
matplot(precipData_month_result, type = "l", las = 3, ylab = "Precipitation (Inches)", xlab = "Months", main = "Monthly Average Precipitation, Palouse 26 County region \n 2009")


  
  # precipData <- precipData_result_frame %>% 
  #  select(-precipitation_amount) %>% 
  #  gather(key = FIPS, value = precipitation_amount) %>%
  #  left_join(counties, by="FIPS") #join w/ counties data
  
  PRData <- merge(counties_palouse, precipData_result_frame, by="FIPS")
  
  return(PRData)
  
}