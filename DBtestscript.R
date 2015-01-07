#load library for OrientDB connection
#make sure to install package RJDBC
library("RJDBC")

#connect to OrientDB
dbjarpath <- "C:/Users/Mark/Documents/GitHub/Mark-Simility/orientdb-jdbc-1.7-all.jar" #change this to the correct path on the local machine
drv <- JDBC("com.orientechnologies.orient.jdbc.OrientJdbcDriver",dbjarpath, "`")
conn <- dbConnect(drv, "jdbc:orient:local:GratefulDeadConcerts",'admin','admin')
res<-dbGetQuery(conn, "select * from V")  
close(dbconnection)


#get the rules

#get a chunk of data from the pledges table

#for each rule, train a tree

#combine trees into a forest


#another thing to try - get all the column headers from all the rules and train one big tree using that
