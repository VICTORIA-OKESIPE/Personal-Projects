# This is an
library(plyr)
library(corrplot)
library(ggplot2)
library(gridExtra)
library(ggthemes)
library(caret)
library(MASS)
library(randomForest)
library(party)
#library(caret)
#library(rpart)
#library(rpart.plot)
 

churn <- read.csv('https://raw.githubusercontent.com/VICTORIA-OKESIPE/Datasets_for_Education/main/Business/customer_churn_data.csv')k

attach(churn)


sapply(churn, function(x) sum(is.na(x)))

churn <- churn[complete.cases(churn), ]


for(i in 1:ncol(churn[,10:15])) {
        churn[,10:15][,i] <- as.factor(mapvalues(churn[,10:15][,i], from =c("No internet service"),to=c("No")))
}


churn$MultipleLines <- as.factor(mapvalues(churn$MultipleLines, 
                                           from=c("No phone service"),
                                           to=c("No")))



min(churn$tenure); max(churn$tenure)


group_tenure <- function(tenure){
    if (tenure >= 0 & tenure <= 12){
        return('0-12 Months')
    }else if(tenure > 12 & tenure <= 24){
        return('12-24 Months')
    }else if (tenure > 24 & tenure <= 48){
        return('24-48 Months')
    }else if (tenure > 48 & tenure <=60){
        return('48-60 Months')
    }else if (tenure > 60){
        return('> 60 Months')
    }
}

churn$tenure_group <- sapply(churn$tenure,group_tenure)
churn$tenure_group <- as.factor(churn$tenure_group)


churn$SeniorCitizen <- as.factor(mapvalues(churn$SeniorCitizen,
                                      from=c("0","1"),
                                      to=c("No", "Yes")))


numeric.var <- sapply(churn, is.numeric) ## Find numerical variables
corr.matrix <- cor(churn[,numeric.var])  ## Calculate the correlation matrix
corrplot(corr.matrix, main="\n\nCorrelation Plot for Numeric Variables", method="number")


churn$TotalCharges <- NULL


p1 <- ggplot(churn, aes(x=gender)) + ggtitle("Gender") + xlab("Gender") +
  geom_bar(aes(y = 100*(..count..)/sum(..count..)), width = 0.5) + ylab("Percentage") + coord_flip() + theme_minimal()
p2 <- ggplot(churn, aes(x=SeniorCitizen)) + ggtitle("Senior Citizen") + xlab("Senior Citizen") + 
  geom_bar(aes(y = 100*(..count..)/sum(..count..)), width = 0.5) + ylab("Percentage") + coord_flip() + theme_minimal()
p3 <- ggplot(churn, aes(x=Partner)) + ggtitle("Partner") + xlab("Partner") + 
  geom_bar(aes(y = 100*(..count..)/sum(..count..)), width = 0.5) + ylab("Percentage") + coord_flip() + theme_minimal()
p4 <- ggplot(churn, aes(x=Dependents)) + ggtitle("Dependents") + xlab("Dependents") +
  geom_bar(aes(y = 100*(..count..)/sum(..count..)), width = 0.5) + ylab("Percentage") + coord_flip() + theme_minimal()
grid.arrange(p1, p2, p3, p4, ncol=2)
```


p5 <- ggplot(churn, aes(x=PhoneService)) + ggtitle("Phone Service") + xlab("Phone Service") +
  geom_bar(aes(y = 100*(..count..)/sum(..count..)), width = 0.5) + ylab("Percentage") + coord_flip() + theme_minimal()
p6 <- ggplot(churn, aes(x=MultipleLines)) + ggtitle("Multiple Lines") + xlab("Multiple Lines") + 
  geom_bar(aes(y = 100*(..count..)/sum(..count..)), width = 0.5) + ylab("Percentage") + coord_flip() + theme_minimal()
p7 <- ggplot(churn, aes(x=InternetService)) + ggtitle("Internet Service") + xlab("Internet Service") + 
  geom_bar(aes(y = 100*(..count..)/sum(..count..)), width = 0.5) + ylab("Percentage") + coord_flip() + theme_minimal()
p8 <- ggplot(churn, aes(x=OnlineSecurity)) + ggtitle("Online Security") + xlab("Online Security") +
  geom_bar(aes(y = 100*(..count..)/sum(..count..)), width = 0.5) + ylab("Percentage") + coord_flip() + theme_minimal()
grid.arrange(p5, p6, p7, p8, ncol=2)


p9 <- ggplot(churn, aes(x=OnlineBackup)) + ggtitle("Online Backup") + xlab("Online Backup") +
  geom_bar(aes(y = 100*(..count..)/sum(..count..)), width = 0.5) + ylab("Percentage") + coord_flip() + theme_minimal()
p10 <- ggplot(churn, aes(x=DeviceProtection)) + ggtitle("Device Protection") + xlab("Device Protection") + 
  geom_bar(aes(y = 100*(..count..)/sum(..count..)), width = 0.5) + ylab("Percentage") + coord_flip() + theme_minimal()
p11 <- ggplot(churn, aes(x=TechSupport)) + ggtitle("Tech Support") + xlab("Tech Support") + 
  geom_bar(aes(y = 100*(..count..)/sum(..count..)), width = 0.5) + ylab("Percentage") + coord_flip() + theme_minimal()
p12 <- ggplot(churn, aes(x=StreamingTV)) + ggtitle("Streaming TV") + xlab("Streaming TV") +
  geom_bar(aes(y = 100*(..count..)/sum(..count..)), width = 0.5) + ylab("Percentage") + coord_flip() + theme_minimal()
grid.arrange(p9, p10, p11, p12, ncol=2)


p13 <- ggplot(churn, aes(x=StreamingMovies)) + ggtitle("Streaming Movies") + xlab("Streaming Movies") +
  geom_bar(aes(y = 100*(..count..)/sum(..count..)), width = 0.5) + ylab("Percentage") + coord_flip() + theme_minimal()
p14 <- ggplot(churn, aes(x=Contract)) + ggtitle("Contract") + xlab("Contract") + 
  geom_bar(aes(y = 100*(..count..)/sum(..count..)), width = 0.5) + ylab("Percentage") + coord_flip() + theme_minimal()
p15 <- ggplot(churn, aes(x=PaperlessBilling)) + ggtitle("Paperless Billing") + xlab("Paperless Billing") + 
  geom_bar(aes(y = 100*(..count..)/sum(..count..)), width = 0.5) + ylab("Percentage") + coord_flip() + theme_minimal()
p16 <- ggplot(churn, aes(x=PaymentMethod)) + ggtitle("Payment Method") + xlab("Payment Method") +
  geom_bar(aes(y = 100*(..count..)/sum(..count..)), width = 0.5) + ylab("Percentage") + coord_flip() + theme_minimal()
p17 <- ggplot(churn, aes(x=tenure_group)) + ggtitle("Tenure Group") + xlab("Tenure Group") +
  geom_bar(aes(y = 100*(..count..)/sum(..count..)), width = 0.5) + ylab("Percentage") + coord_flip() + theme_minimal()
grid.arrange(p13, p14, p15, p16, p17, ncol=2)


intrain<- createDataPartition(churn$Churn,p=0.7,list=FALSE)
set.seed(2019)
training<- churn[intrain,]
testing<- churn[-intrain,]


dim(training); dim(testing)

# normalise data
norm_data <- new_list %>% mutate(

#LogModel <- glm(churn$Churn ~ tenure_group,family=binomial(link="logit"),data=training)
LogModel <- glm(Churn ~. ,data=training)
summary(LogModel))
print(LogModel, signif.stars = TRUE)
# S3 method for glm
#odd.ratioa(LogModel, level = 0.95, ...)
```

#Feature analysis:

#1. The top three most-relevant features include Contract, Paperless #Billing and tenure group, all of which are categorical variables.

anova(LogModel, test="Chisq")


# Analyzing the deviance table we can see the drop in deviance when # adding each variable one at a time. Adding InternetService, # Contract and tenure_group significantly reduces the residual # deviance. The other variables such as PaymentMethod and Dependents # seem to improve the model less even though they all have low p-# values.

## Assessing the predictive ability of the model


testing$Churn <- as.character(testing$Churn)
testing$Churn[testing$Churn=="No"] <- "0"
testing$Churn[testing$Churn=="Yes"] <- "1"
fitted.results <- predict(LogModel,newdata=testing,type='response')
fitted.results <- ifelse(fitted.results > 0.5,1,0)
misClasificError <- mean(fitted.results != testing$Churn)
print(paste('Logistic Regression Accuracy',1-misClasificError))
```

## Confusion Matrix 


print("Confusion Matrix for Logistic Regression"); table(testing$Churn, fitted.results > 0.5)

## Odds Ratio

# One of the interesting perfomance measurements in logistic # regression is Odds Ratio.Basically, Odds retios is what the odds # of an event is happening?



exp(cbind(OR=coef(LogModel), confint(LogModel)))


# For each unit increase in Monthly Charge, there is a 2.4% decrease # in the likelihood of a customer's churning.

## Decision Tree
getwd()
```{r}
churn <- read.csv('Telco-Customer-Churn.csv')
churn <- churn[complete.cases(churn), ]
```

```{r}
for(i in 1:ncol(churn[,10:15])) {
        churn[,10:15][,i] <- as.factor(mapvalues
                                              (churn[,10:15][,i], from =c("No internet service"),to=c("No")))
}
```


```{r}
churn$MultipleLines <- as.factor(mapvalues(churn$MultipleLines, 
                                           from=c("No phone service"),
                                           to=c("No")))
```

```{r}
group_tenure <- function(tenure){
    if (tenure >= 0 & tenure <= 12){
        return('0-12 Months')
    }else if(tenure > 12 & tenure <= 24){
        return('12-24 Months')
    }else if (tenure > 24 & tenure <= 48){
        return('24-48 Months')
    }else if (tenure > 48 & tenure <=60){
        return('48-60 Months')
    }else if (tenure > 60){
        return('> 60 Months')
    }
}
```

```{r}
churn$tenure_group <- sapply(churn$tenure,group_tenure)
churn$tenure_group <- as.factor(churn$tenure_group)
```
churn$tenure_group
summary(churn$tenure_group)

```{r}
churn$SeniorCitizen <- as.factor(mapvalues(churn$SeniorCitizen,
                                      from=c("0","1"),
                                      to=c("No", "Yes")))
```

```{r}
churn$customerID <- NULL
churn$tenure <- NULL
churn$TotalCharges <- NULL
```

```{r}
intrain<- createDataPartition(churn$Churn,p=0.7,list=FALSE)
set.seed(2019)

training<- churn[intrain,]
testing<- churn[-intrain,]
```

# For illustration purpose, we are going to use only three #variables, they are "Contract", "tenure_group" and # "PaperlessBilling".



tree <- ctree(Churn~Contract+tenure_group+PaperlessBilling, training)


plot(tree, type="simple")



prp(tree, box.palette = "Reds", tweak = 1.2)


#Out of three variables we use, Contract is the most important #variable to predict customer churn or not churn.

#If a customer in a one-year contract and not using PapelessBilling, #then this customer is unlikely to churn.

#On the other hand, if a customer is in a month-to-month contract, #and in the tenure group of 0-12 months, and using PaperlessBilling, #then this customer is more likely to churn. 


pred_tree <- predict(tree, testing)
print("Confusion Matrix for Decision Tree"); table(Predicted = pred_tree, Actual = testing$Churn)




p1 <- predict(tree, training)
tab1 <- table(Predicted = p1, Actual = training$Churn)
tab2 <- table(Predicted = pred_tree, Actual = testing$Churn)


print(paste('Decision Tree Accuracy',sum(diag(tab2))/sum(tab2)))

