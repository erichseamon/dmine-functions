setwd("/dmine/data/USDA/agmesh-scenarios/palouse/summaries3/monthly-summaries")
temp = list.files(pattern = "Monthly_count")
myfiles = lapply(temp, read.csv, header = TRUE)
ziggy.df <- do.call(rbind , myfiles)
xrange <- as.data.frame(ziggy.df)
colnames(xrange) <- c("ID", "month", "year", "count", "commodity", "damagecause", "county", "state")

setwd("/dmine/data/USDA/agmesh-scenarios/palouse/summaries3/monthly-summaries")
temp = list.files(pattern = "Monthly_loss")
myfiles = lapply(temp, read.csv, header = TRUE)
ziggy.df <- do.call(rbind , myfiles)
xrange2 <- as.data.frame(ziggy.df)
xrange2 <- xrange2[, -c(5)]
colnames(xrange2) <- c("ID", "month", "year", "loss", "commodity", "damagecause", "county", "state")

setwd("/dmine/data/USDA/agmesh-scenarios/palouse/summaries3/monthly-summaries")
temp = list.files(pattern = "Monthly_mean")
myfiles = lapply(temp, read.csv, header = TRUE)
ziggy.df <- do.call(rbind , myfiles)
xrange3 <- as.data.frame(ziggy.df)
colnames(xrange3) <- c("ID", "month", "year", "meanloss", "commodity", "damagecause", "county", "state")

xrange4 <- merge(xrange, xrange2, by = c("state", "county", "year", "month", "commodity", "damagecause"))
xrange5 <- merge(xrange4, xrange3, by = c("state", "county", "year", "month", "commodity", "damagecause"))
xrange5 <- xrange5[, -c(7,9,11)]
