
#load the library with the decision tree stuff
library("party")

#read our dataset
ContributorSet = read.csv("C:\\Users\\Mark\\Documents\\Simility\\HIgh Risk Contributions.csv");
nsamples = nrow(ContributorSet)

#make a formula to train a tree
#here we're just going to predict fraud based on transaction amount
formula <- Fraud. ~ Transaction.Amount

#train a tree on the first tenth of the data
tsize = floor(nsamples/10)
Trainingset = ContributorSet[1:tsize,]
test_ctree <- ctree(formula,data=Trainingset) 

#look at the structure of the tree
plot(test_ctree)

#test the tree's prediction using the other 9/10ths of the data
TestSet = ContributorSet[tsize+1:nsamples,]
prediction <- predict(test_ctree,TestSet)

#look at the table. 
#We see that it's not great

#prediction    G    N    Y
#         G 1359  710  388
#         N    0    0    0
#         Y    6   16   58
table(prediction, TestSet$Fraud)

