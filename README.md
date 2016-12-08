# Student Performance Evaluation

This problem aims at predicting students learning based on logs of tutoring systems. Here we have to find if a student can give correct answer to a problem on the first attempt. So, our target/response variable here is Correct.First.Attempt, according to our dataset. As it has a binary output, 0 or 1, we can define it as a classification problem.
Very large datasets and highly categorical features are the two main aspects of this project. Missing values are also a challenging problem when we are dealing with a very large training datasets. Moreover, most classifiers are not performing efficiently on large datasets. So far in this project I have tried to fit a model using Logistic Regression, Linear Discriminant Analysis and Quadratic Discriminant Analysis. 

# Data Preprocessing
The ID columns are not really useful for predicting a model. So, I have omitted all ID columns (like Row, Anon Student ID etc.) from my datasets. Also, I have converted all the date-time columns, like First.Transaction.Time, Correct.Transaction.Time, Step.Start.Time etc. in numeric values. 
The biggest challenge in this project was to process the categorical variables. In general, it is difficult to use categorical features in different models.


I have worked with Algebra_I_2008-2009_train.txt dataset. This dataset contains 400,000 rows with 14 columns, so I separated these two datasets and worked on them individually. 
Feature Selection
Currently, the features which I have used for predicting the model are: 

Step.Start.Time: This is the starting time of the step. A problem may have multiple steps. I believe this is a useful feature because the p-value is close to 0 (<2.13e-15). Also, a student’s ability to answer a question can be predicted from the time when he/she starts a new step.

First.Transaction.Time: the time of the first transaction toward the step.
Correct.Transaction.Time: This is the time of the correct attempt toward the step, if there was one. P-value for this variable is also close to 0.

Step.End.Time: The ending time of the step. I think this is a useful variable because this timing might affect the first attempt.

Incorrects: Total number of incorrect attempts by the student on the step. This highly affects the student’s correct first attempt. (p-value: < 2e-16)

Hints: Total number of hints requested by the student for the step. The less a student is able to answer a problem, the higher this number will be. So, I think this is a very significant variable. (p-value: < 2e-16)
Corrects: Total correct attempts by the student for the step. 

dummyKC: the identified skills that are used in a problem, where available. A step can have multiple KCs assigned to it. Multiple KCs for a step are separated by ~~ (two tildes). Since opportunity describes practice by knowledge component, the corresponding opportunities are similarly separated by ~~ (double tildes)

dummyOpportunity: There are some other important features that need to be used in the model. These are knowledge component(KC) and opportunity. I tried to use these columns in the existing model, but the model was not supporting the columns. These categorical values can neither be converted as numeric or factors. So, my next step for this project is working on how to use KC and opportunity as variables for the model.

# Models/Prediction Algorithms
Here I have used Logistic Regression(LR) as the first model to predict the test data. The reason is, my dependant variables are categorical and my response variable here is binary. This is a well-known algorithm to find relationship between the categorical dependent variable and one or more independent variables by estimating probabilities.
I have also used Linear Discriminant Analysis (LDA) as the second model to test the data. The reason is, logistic regression does not make any assumption on the distribution of the data, while LDA does. So, it is expected that sometimes LDA will perform better.
The third model I have tried with is Quadratic Discriminant Analysis(QDA). QDA assumes a quadratic decision boundary, so it can accurately model a wider range of problems than the linear methods. 

# Training/Testing Set Up
It was not possible to load the whole dataset in RStudio. So I split the text file into two using the following linux command:
head -n 200000 algebra_2008_2009_train.txt
Then I had to process all the list variable before training.
When the categorical features were applied to the training model, it took a lot of time to generate output in R. I tried in few ways but it was not possible to make the time shorter. Even if I work with smaller sized dataset, still it does not give any faster output.

# Prediction Accuracy
I have run logistic regression on 100,000 training data, and predicted 100,000 test data. Here we can see that the result seems very good. But we need to work on more columns later. I tried with other columns as well (like Step.Duration, First.Transaction.Time) but from the p-values we can see that only these 6 variables are statistically significant.
Accuracy from LR = (2480+70311)/(2480+70311+10055+17154) = 0.72791
Accuracy from LDA = (8703+79942)/(10931+424+8703+79942) = 0.88645
Accuracy from QDA = (13448+76110)/(13448+4256+76110+6186) = 0.89558
 
So, this result comes only from using the numeric features. After using the categorical features we get the following output:

# Modeling with LDA and QDA for better accuracy
library(MASS)
glm.lda <- lda(Correct.First.Attempt~ Step.Start.Time + Step.End.Time +
                 Correct.Transaction.Time + Hints + Corrects + Incorrects,subset = train)
prediction.lda <- predict(glm.lda, x.100000)
table(Correct.First.Attempt.100000, prediction.lda$class)
fit.qda <- qda(Correct.First.Attempt~ Step.Start.Time + Step.End.Time +
                 Correct.Transaction.Time + Hints + Corrects + Incorrects,subset = train)
pred.qda <- predict(fit.qda, x.100000)
table(pred.qda$class, Correct.First.Attempt.100000)


Output
Deviance Residuals: 
    Min       1Q   Median       3Q      Max  
-7.0125   0.1927   0.2254   0.2621   8.4904  


Coefficients:
                                            		Estimate Std. Error            z value                   Pr(>|z|)    
(Intercept)                         		3.353e+02  1.604e+01   	20.906              < 2e-16 ***
Step.Start.Time                		-8.349e-05  1.052e-05   	-7.934 		<2.13e-15 ***
Step.End.Time            		-2.735e-07  1.312e-08  	-20.854             < 2e-16 ***
Correct.Transaction.Time  		4.066e-04  1.617e-05   	25.149  	< 2e-16 ***
Hints                    			-2.250e+00  3.252e-02  	-69.180  	< 2e-16 ***
Corrects                  			1.846e+00  8.017e-02   	23.023  	< 2e-16 ***
Incorrects               -2.959e+00  2.506e-02 -118.093  < 2e-16 ***
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
############################
Logistic Regression Truth Table:
Correct.First.Attempt.100000
pred.glm     	0     		1
       	0 	2480  		10055
       	1  	17154 		70311
> mean(pred.glm==Correct.First.Attempt.test)
[1] 0.72791
###############################
QDA Truth Table
Correct.First.Attempt.100000
pred.glm     	0     		1
       	0 	13448  		4256
       	1  	6186 		76110
> mean(pred.qda$class==Correct.First.Attempt.test)
[1] 0.89558
################################
LDA Truth Table
Correct.First.Attempt.100000
pred.glm     	0     		1
       	0 	8703  		10931
       	1  	424 		79942
> mean(prediction.lda$class==Correct.First.Attempt.test)
[1] 0.88645
Result using categorical features


dummyKC Find slope from two given points                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     ** 
dummyKC Full-Expression-Gla:Student-Modeling-Analysis                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        ** 
dummyKC Identify solution type of compound inequality using or                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               ***
dummyKC Plot point between minor tick marks - integer major/minor                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            ***


dummyKC simplify-fractions-sp                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                ***
dummyKC Write compound inequality in verbal problem                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          ***
dummyKC Write expression, any form                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           ***
dummyKC Write solution as inequality - double                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                ***
dummyOpportunity 10                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          ***
dummyOpportunity 13                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         ***


Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1


(Dispersion parameter for binomial family taken to be 1)


    Null deviance: 70447  on 72581  degrees of freedom
Residual deviance: 32003  on 71457  degrees of freedom
  (27417 observations deleted due to missingness)
AIC: 34253


Number of Fisher Scoring iterations: 18


Truth table with LR
Correct.First.Attempt.test
pred.glm     0     1
       0  2744 11437
       1 16890 68929
> mean(pred.glm==Correct.First.Attempt.test)
[1] 0.71673 (71.6% accurate)


Truth table with LDA
Correct.First.Attempt.test
        0     1
  0 13448  4256
  1  6186 76110
> mean(pred.lda$class==Correct.First.Attempt.test)
[1] 0.89558 (89.5% accurate)
Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
 0.0000  1.0000  1.0000  0.8037  1.0000  1.0000 
Here I have tried with other columns like KC.Subskills, Opportunity subskills, but those variables do not improve the accuracy to a significant amount. I also tried to use a new feature like (Opportunity+Knowledge Component) but that does not add any significance either. Also, I was unable to make the categorical feature work on QDA model. So, I skipped that part.


# Conclusion
From observing the results we can come into conclusion that logistic regression had the  

# Challenges
Huge number of instances
Datasets of the project are extremely large. The algebra_I_2008-2009 data was not being loaded directly in R. So, we separated the data in 2 files, train1.txt and train2.txt. Each of these files have 400,000 rows. Techniques such as sampling or instance selection should be performed to handle large size of instances. 
Missing values in test data sets
Nearly big subsets of features in the test datasets are completely missing. These features are critical and important in train datasets. Handling these missed features was a big challenge in this project. 
Highly categorical features
Features which are most important in modeling algorithms are highly categorical, which means I have text data and almost none of the columns are numeric. For example, Knowledge Component(KC) and Opportunity are very important features which I could not yet place as a variable. In other words, we have features that have so many distinct categorical values in them. Modeling based on such a huge number of distinct values is a big challenge.


