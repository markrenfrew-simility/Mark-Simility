install.packages("party")
library("party")
install.packages("rpart")
library("rpart")
install.packages("plyr")
library("plyr")

ContributorSet = read.csv("C:\\Users\\Mark\\Documents\\Simility\\HIgh Risk Contributions.csv");

testdata = ContributorSet[1:10,]

formula <- Fraud. ~ count(Exact.ID) #+ Account.Email.1 + Transaction.ID

#test_ctree <- ctree(formula,data=ContributorSet) #this never terminates, or at least it takes a long time
test_ctree <- ctree(formula,data=trainingdata) #this never terminates, or at least it takes a long time

plot(test_ctree)
