#proof of concecpt script for decision trees


#install.packages("XML")
#install.packages("party")
library(XML)
library(party)

#read our dataset
ContributorSet = read.csv("C:\\Users\\Mark\\Documents\\Simility\\HIgh Risk Contributions.csv");
nsamples = nrow(ContributorSet)

#train our trees on the first tenth of the data
tsize = floor(nsamples/10)
Trainingset = ContributorSet[1:tsize,]

#test the tree's prediction using the other 9/10ths of the data
TestSet = ContributorSet[tsize+1:nsamples,]

#read the rules XML file
xmlfilename = "C:\\Users\\Mark\\Documents\\Simility\\default-v1056792.xml"

xmldoc <- xmlParse(xmlfilename)
rules <- getNodeSet(xmldoc,"/policy/rules/rule")
nrules <- length(rules)
nrules <- 1 #debug

for(i in 1:nrules){
  rule <- rules[[i]]
  attrs <- xmlAttrs(rule)
  #if(attrs[["active"]]){ #if it's not active, don't worry about it
  
    if(TRUE){ #debug
    descr <- rule[["description"]]
    parameters <- rule[["parameters"]]
    lt <- parameters[["LogicType"]]
    ltstr <- xmlValue(lt)
    if(ltstr == "AND" || ltstr == "OR"){ #let's only worry about Boolean conditions right now
      #iterate over all the attributes and create the Boolean string 
      
      #boolean string is of the form attribute_n operation_n value_n lt attribute_n+1 operation_n+1 value_n+1
      
      eqnsize <- (xmlSize(parameters)-1)/3 #1 logic type + one of more sets of (attribute, operation, value) 
      
      eqnstr <- "";
      
      ctr_form_str <- "Fraud. ~" #our formula string to train our ctree
      
      for(j in 1:eqnsize){
        #get the attribute
        attrstr <- xmlValue(parameters[[paste("Attribute",j,sep="")]])
      
        #get the operation
        operstr <- xmlValue(parameters[[paste("Operation",j,sep="")]])
        
        #get the value
        valstr <- xmlValue(parameters[[paste("Value",j,sep="")]])
        
        #alter the strings
        if(operstr =="equal-to"){
          operstr <- "="
        } else if(operstr =="not-equal-to"){
          operstr <- "!="  
        } else if(operstr =="greater-than"){
          operstr <- ">"  
        } else if(operstr =="greater-than-or-equal-to"){
          operstr <- ">="  
        } else if(operstr =="less-than"){
          operstr <- "<"  
        } else if(operstr =="less-than-or-equal-to"){
          operstr <- "<="  
        } else if(operstr =="is_present"){
          operstr <- "!="
          valstr <= ""
        } else if(operstr =="is_absent"){
          operstr <- "=="
          valstr <= ""
        } else if(operstr =="contains"){
          #this will have to be implemented somehow with a call to grep(). I'll probably have to strip out {} characters first.
        }        
  
        if(attrstr == "tmx_summary_reason_code"){
          newstr <- "TMX.Summary.Reason.Code" #kludgey way to go between the different versions of these strings in the XML file and the ContributorSet dataset. I shouldn't need to worry about this for long because we'll be reading from a databse instead.
        }  
        if(!grepl(ctr_form_str,newstr)){ #don't add variables more than once
            ctr_form_str <- paste(ctr_form_str, newstr)  
          }
        }
        
        #build the simpler formula for training the ctree
        
        if(j < eqnsize){
          eqnstr <- paste(eqnstr, attrstr, operstr, valstr, ltstr)
          ctr_form_str <- paste(ctr_form_str, "+")
        } else{
          eqnstr <- paste(eqnstr, attrstr, operstr, valstr)
        }
        
        
      }
      
      #build the ctree
      test_ctree <- ctree(formula(ctr_form_str),data=Trainingset) 
      
      #look at the structure of the tree
      plot(test_ctree)
      
      prediction <- predict(test_ctree,TestSet)
      
      #look at the table. It will be of the form:
     
      #prediction    G    N    Y
      #         G 1359  710  388
      #         N    0    0    0
      #         Y    6   16   58
      table(prediction, TestSet$Fraud)
    }
  }
}

