
#load the library with the decision tree stuff
library("party")

##read our dataset
ContributorSet <- read.csv("C:\\Users\\Mark\\Documents\\GitHub\\Mark-Simility\\HIgh Risk Contributions.csv");
nsamples <- nrow(ContributorSet)

##make a new table of the relevant columns and the calculated columns we'll use
#put the unique ID here, to use as a check that we're comparing the same rows across different tables
DataSet2 <- data.frame(ContributorSet$Event.ID) 

##these are the columns that we'll be predicting
DataSet2$Fraud <- ContributorSet$Fraud. #Y/N/G - the original

#the rest of these are booleans and split up
DataSet2$Fraud_Y <- ContributorSet$Fraud. == "Y"
DataSet2$Fraud_N <- ContributorSet$Fraud. == "N"
DataSet2$Fraud_G <- ContributorSet$Fraud. == "G"
DataSet2$Fraud_YG <- ContributorSet$Fraud. == "Y" || ContributorSet$Fraud. == "G"
DataSet2$Fraud_NG <- ContributorSet$Fraud. == "N" || ContributorSet$Fraud. == "G"

#add the policy score too - it's unclear whether this is coming strictly from the data in the .xls file or if it's calculated with other data too
#either way, it can't hurt to add
DataSet2$Policy.Score <- ContributorSet$Policy.Score

##calculated rows

#1: EmailsPerDeviceID
#uniqe email addresses associated with the deviceID for this row
DataSet2$EmailsPerDeviceID <- 0 
for(i in 1:nsamples){
  n <- DataSet2$EmailsPerDeviceID[i]
  if(n == 0){ #if n > 0, we've already counted this deviceid and we can skip it
    id <- ContributorSet$Smart.ID[i]
    sset <- subset(ContributorSet,Smart.ID==id)
    nemails <- length(unique(sset$Account.Email))
    
    #set all rows in DataSet2 that have this smart id
    DataSet2$EmailsPerDeviceID[ContributorSet$Smart.ID == id] <- nemails
  }
}

#2: ContributionsPerDeviceID
#unique contributions made by this device
DataSet2$ContributionsPerDeviceID <- 0
for(i in 1:nsamples){
  n <- DataSet2$ContributionsPerDeviceID[i]
  if(n==0){
    id <- ContributorSet$Smart.ID[i]
    sset <- subset(ContributorSet,Smart.ID==id)
    ncontrib <- length(sset) #each row is a unique transaction
    
    #set all rows in DataSet2 that have this smart id
    DataSet2$ContributionsPerDeviceID[ContributorSet$Smart.ID == id] <- ncontrib
  }
}

#3: DollarsContributedPerDeviceID
#total amount contributed by this device
DataSet2$DollarsContributedPerDeviceID <- 0
for(i in 1:nsamples){
  n <- DataSet2$DollarsContributedPerDeviceID[i]
  if(n==0){
    id <- ContributorSet$Smart.ID[i]
    sset <- subset(ContributorSet,Smart.ID==id)
    dollarscontrib <- sum(as.numeric(sset$Transaction.Amount)) #each row is a unique transaction
    
    #set all rows in DataSet2 that have this smart id
    DataSet2$DollarsContributedPerDeviceID[ContributorSet$Smart.ID == id] <- dollarscontrib
  }
}

#4: 



