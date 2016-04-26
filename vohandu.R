library(XML)
final.url <- "http://www.vohandumaraton.ee/maraton/index2016.php?act=finish"
tables <- readHTMLTable(final.url)

final.table.df <- tables[[2]]
names(final.table.df) <- c("Koht","Koht klassis" ,"Klass", "Kood", "Riik", "Nimed", "Tiim", "Aeg", "Kaotus", "Diplom")
final.table.df        <- final.table.df[-c(10, 9, 7)] # mõnda veergu pole vaja

split.url  <- 
