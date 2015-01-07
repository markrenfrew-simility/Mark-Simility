
#load the library with the decision tree stuff
library("party")

#read our dataset
ContributorSet = read.csv("C:\\Users\\Mark\\Documents\\GitHub\\Mark-Simility\\HIgh Risk Contributions.csv");
nsamples = nrow(ContributorSet)

#make a formula to train a tree
# the formulas for fraud that we got from the XML file
# these are all the features that are not computed

#formula.1 <- Fraud. ~ TMX.Summary.Reason.Code #uid=1
#formula.2 <- Fraud. ~ Policy.Score #uid=11
#formula.3 <- Fraud. ~ True.IP.Geo #uid=15
#formula.4 <- Fraud. ~ Transaction.Amount#uid=17
#formula.5 <- Fraud. ~ Exact.ID + Smart.ID#uid=25 #these have too many unique values to be useful
#formula.6 <- Fraud. ~ Time.spent.on.page.1#uid=37
#formula.7 <- Fraud. ~ Condition.Attribute.5 #this one doesn't make sense to use as-is


formula.1 <- Fraud. ~ TMX.Summary.Reason.Code + Policy.Score + True.IP.Geo + Transaction.Amount #+ Time.spent.on.page.1#+ Exact.ID + Smart.ID + 
formula.2 <- Fraud. ~ Policy.Score + True.IP.Geo + Transaction.Amount + Time.spent.on.page.1 + Cookies.Enabled + Flash.Enabled + Images.Enabled + Javascript.Enabled + Screen.Res + UA.Browser + UA.OS + Policy.Score + Risk.Rating + Browser.Language + Time.Zone 
#formula.2 takes an intractably long time to train

formula <- formula.1

#train a tree on the first portion of the data
tsize = floor(nsamples/10)
TrainingSet <- ContributorSet[1:tsize,]
test_ctree <- ctree(formula,data=TrainingSet) 

#look at the structure of the tree
plot(test_ctree)

#test the tree's prediction using the other portion of the data
TestSet = ContributorSet[tsize+1:nsamples,]
prediction <- predict(test_ctree,TestSet)

#look at the table. 
#We can calculate precision/recall easily enough from this

table(prediction, TestSet$Fraud)

