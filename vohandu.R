library(XML)
library(lubridate)

git2r::branch_target(git2r::head(git2r::repository(getwd())))

final.url <- "http://www.vohandumaraton.ee/maraton/index2016.php?act=finish"
tables <- readHTMLTable(final.url)

final.table.df <- tables[[2]]
names(final.table.df) <- c("Koht","Koht klassis" ,"Klass", "Stardinr", "Riik", "Nimed", "Tiim", "Aeg", "Kaotus", "Diplom")
final.table.df        <- final.table.df[-c(10, 9, 7)] # mõnda veergu pole vaja

split.url  <- "http://www.vohandumaraton.ee/maraton/index2016.php?act=vahed"
tables <- readHTMLTable(split.url)
split.table.df <- tables[[2]]
split.table.df <- split.table.df[-3] # drop first instance of class

compl.df <- merge(final.table.df, split.table.df, by = "Stardinr")

compl.df$Koht <- ifelse(compl.df$Koht == "", NA, compl.df$Koht)
compl.df$`Koht klassis` <- ifelse(compl.df$`Koht klassis`  == "", NA, compl.df$`Koht klassis`)
compl.df$Jrk <- ifelse(compl.df$Jrk  == "", NA, compl.df$Jrk)

compl.df <- compl.df[order(compl.df$Jrk),]

names.df <- compl.df[c(1,6)]
compl.df$Nimed <- substr(compl.df$Nimed, 1, 30) 

K2MIX <- compl.df[which(compl.df$Klass == "K2MIX"),]
K2MIX$Aeg <- K2MIX$FINISH

K2MIX$Aeg <- hms(as.character(K2MIX$Aeg))

drops <- c("Koht","Koht klassis", "Jrk")
K2MIX <- K2MIX[, !(names(K2MIX) %in% drops)]

K2MIX[,6:12] <- hms(as.character(K2MIX[,6:12]))
