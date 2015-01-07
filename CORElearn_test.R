install.packages("CORElearn")
library("CORElearn")

#read our dataset
ContributorSet = read.csv("C:\\Users\\Mark\\Documents\\GitHub\\Mark-Simility\\HIgh Risk Contributions.csv");
nsamples = nrow(ContributorSet)

#train our trees on the first tenth of the data
tsize = floor(nsamples/10)
Trainingset = ContributorSet[1:tsize,]

#test the tree's prediction using the other 9/10ths of the data
TestSet = ContributorSet[tsize+1:nsamples,]

fit.rand.forest = CoreModel(frmla, data=raw, model="rf", selectionEstimator="MDL", minNodeWeightRF=5, rfNoTrees=100)
plot(fit.rand.forest)