# Student Performance Evaluation

This problem aims at predicting students learning based on logs of tutoring systems. Here we have to find if a student can give correct answer to a problem on the first attempt. So, our target/response variable here is Correct.First.Attempt, according to our dataset. As it has a binary output, 0 or 1, we can define it as a classification problem.
Very large datasets and highly categorical features are the two main aspects of this project. Missing values are also a challenging problem when we are dealing with a very large training datasets. Moreover, most classifiers are not performing efficiently on large datasets. So far in this project I have tried to fit a model using Logistic Regression, Linear Discriminant Analysis and Quadratic Discriminant Analysis. 

# DATA PREPROCESSING
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

dummyKC: the identified skills that are used in a problem, where available. A step can have multiple KCs assigned to it. Multiple KCs for a step are separated by ~~ (two tildes). Since opportunity describes practice by knowledge component, the corresponding opportunities are similarly separated by ~~ (double tilda)

dummyOpportunity: There are some other important features that need to be used in the model. These are knowledge component(KC) and opportunity. I tried to use these columns in the existing model, but the model was not supporting the columns. These categorical values can neither be converted as numeric or factors. So, my next step for this project is working on how to use KC and opportunity as variables for the model.

# MODELS/PREDICTION ALGORITHMS
Here I have used Logistic Regression(LR) as the first model to predict the test data. The reason is, my dependant variables are categorical and my response variable here is binary. This is a well-known algorithm to find relationship between the categorical dependent variable and one or more independent variables by estimating probabilities.
I have also used Linear Discriminant Analysis (LDA) as the second model to test the data. The reason is, logistic regression does not make any assumption on the distribution of the data, while LDA does. So, it is expected that sometimes LDA will perform better.
The third model I have tried with is Quadratic Discriminant Analysis(QDA). QDA assumes a quadratic decision boundary, so it can accurately model a wider range of problems than the linear methods. 


