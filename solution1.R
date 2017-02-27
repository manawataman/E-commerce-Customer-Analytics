#change the directory to location where you have credr dataset 
setwd("/users/amanmanawat/documents/customerlabs_assignment/")
#jsonlite is the package to handle data in json format 
install.packages("jsonlite")
library(jsonlite)
#here i have used stream_in as we have nested data in  our json 
#also i have changed the file name from credr_dataset to credrdtaset
credr <- stream_in(file("credr_dataset.json"))
head(credr, 10)
str(credr)
credr_flat <- flatten(credr)
str(credr_flat)
#tibble is package in R to display the datatype of attributes
install.packages('tibble')
library(tibble)
#change the data to data_frame format for analysis 
credr_tbl <- as_data_frame(credr_flat)
#dplyr package in r to perform operation like select,filter,etc on data framee
install.packages('dplyr')
library(dplyr)
#here '_' has been removed from infront of all the attributes as '_' creates confusion in R
names(credr_tbl) <- gsub("_", "", names(credr_tbl), fixed = TRUE)
#here the coloumns useful for analysis are selected like which browser the user used, what is type of user, what device he has used, what timezone he is in, etc which will help us understand will he add the item to cart or not
credr_sel <- select(credr_tbl,score,source.vtyp,source.platform,source.country,source.device,source.timezone,source.continent,source.action,source.actiontype)
head(credr_sel,10)
str(credr_sel)

#here is the function which converts the fields in action to 0 or 1, that is, if the user has added to cart we assign it as 1 and for all the other cases 0 
transform_action <- function(action){
  out <- action
  for (i in 1:length(action)){
    if (action[i]=="Added to cart"){
      out[i] <- 1
    }
    else {
      out [i] <- 0
    }
  }
  return(out)
}

action <- transform_action(credr_sel$source.action)
#adding the transdormed coloumn to our data frame 
credr_sel$source.action = action
#here all the coulumns with categorical data are converted into factor for analysis 
credr_sel$source.action <- factor(credr_sel$source.action)
credr_sel$source.platform <- factor(credr_sel$source.platform)
credr_sel$source.actiontype <- factor(credr_sel$source.actiontype)
credr_sel$source.continent <- factor(credr_sel$source.continent)
credr_sel$source.country <- factor(credr_sel$source.country)
credr_sel$source.device <- factor(credr_sel$source.device)
credr_sel$source.vtyp <- factor(credr_sel$source.vtyp)
credr_sel$source.platform <- factor(credr_sel$source.platform)
credr_sel$source.timezone <- factor(credr_sel$source.timezone)
#on doing the summary it tell us about our attributes what is the their data type and if it is a factor then how many levels it has
summary(credr_sel)

#ggplot2 is the library for displaying the results in graph format 
install.packages('ggplot2')
library(ggplot2)
# this graph tell us that what device the user has has used the most in both addiding and not adding to cart.
pl <- ggplot(credr_sel,aes(x=source.action))
pl <- pl + geom_bar(aes(fill=source.device),color='black',alpha=0.5)
pl

#caTools is the package used to split our data in trainig set and test set 
install.packages('caTools')
library(caTools)
set.seed(101)
#here the data is splitted in the ratio of 70:30, that is, 70% is the training data and 30% is the test data  
sample <- sample.split(credr_sel,SplitRatio = 0.70)
train = subset(credr_sel,sample==TRUE) 
test = subset(credr_sel,sample==FALSE)
head(train)

#here I have used randomForest classification algoritghm as it best to deal with categorical data 
install.packages('randomForest')
library(randomForest)
set.seed(123)
#here train[-8] is the source.action column on which we are performing are classification, with ntree value as 500 
classifier = randomForest(x=train[-8],y=train$source.action,ntree=500)
#plot(classifier) tells us that after ntree=100 our classifier becomes constant
y_pred <- predict(classifier,newdata = test[-8])
cm <- table(test[[8]],y_pred) 
cm
#If you look at the results it predicts the result with 99.6% accurary ((18297/18362)*100), that with these attributes we can decide if the user will add the item to cart or not

#e1071 is the library used for perfomrming svm(support vector machine) classification algorithm. 
library(e1071)
model <- svm (source.action ~ . , data=train)
summary(model)
predicted.values <- predict(model,test[-8])
table(predicted.values,test$source.action)
#here the results shows us that the model is not tuned perfectly 
#tuning model the model as the results obtained are not effecient 
model <- svm (source.action ~ . , data=train,cost=20,gamma= 0.5)
predicted.values <- predict(model,test[-8])
table(predicted.values,test$source.action)
# after tuning we get better results with 99.71% accuracy, which is better than our random forest prediction 



#some additional insights related to those who have added to cart  
#selecting only the data who have added the item to cart 
credr_added <- subset(credr_sel,subset = source.action=='1')
credr_added
#this graph tells us that what all devices the users have used who added the item to cart 
pl <- ggplot(credr_added,aes(x=source.action))
pl <- pl + geom_bar(aes(fill=source.device),color='black',alpha=0.5)
pl
#this graph tells us users from which coutry has added the item to cart the most
pl <- ggplot(credr_added,aes(x=source.action))
pl <- pl + geom_bar(aes(fill=source.country),color='black',alpha=0.5)
pl
#this graph tells us that how many returning users and how many new users have added the item to the cart 
pl <- ggplot(credr_added,aes(x=source.action))
pl <- pl + geom_bar(aes(fill=source.vtyp),color='black',alpha=0.5)
pl



