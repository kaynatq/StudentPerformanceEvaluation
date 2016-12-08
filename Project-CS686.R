# head -n 200000 algebra_2008_2009_train.txt

# Modeling only with numeric variables
library(MASS)
x <- read.csv("Documents/Student_Performance_Evaluation/algebra_2008_2009/algebra_2008_2009_train.txt", header=T, sep = "\t", na.strings = c(" "))
View(x)
attach(x)

x$First.Transaction.Time <- as.POSIXct(x$First.Transaction.Time, na.rm=TRUE)
x$First.Transaction.Time <- as.numeric(x$First.Transaction.Time)
x$Step.Start.Time <- as.numeric(x$Step.Start.Time)
x$Step.Start.Time <- as.numeric(x$Step.Start.Time)
x$Correct.Transaction.Time <- as.numeric(x$Correct.Transaction.Time)
x$Step.End.Time <- as.POSIXlt(x$Step.End.Time, na.rm = TRUE)
x$Step.End.Time <- as.numeric(x$Step.End.Time, na.rm = TRUE)

train <- (Row > 100000)
x.test <- x[!train,]
Correct.First.Attempt.test <- Correct.First.Attempt[!train]

# logistic regression
glm.correct <- glm(Correct.First.Attempt~ First.Transaction.Time + Step.Start.Time + Step.End.Time +
                     Correct.Transaction.Time + Incorrects, data = x,
                   family = binomial, subset = train)

summary(glm.correct)
prediction <- predict(glm.correct, data = x.test, type = "response")
pred.glm <- rep(0, length(Correct.First.Attempt.test))
pred.glm[prediction > 0.5] <- 1
table(pred.glm, Correct.First.Attempt.test)

counts <- table(KC.Rules., Correct.First.Attempt)
plot(KC.Rules., Correct.First.Attempt, main="Correct First Attempt VS KC.Rules", 
        xlab="KC.Rules", ylab = "Correct First Attempt")

counts <- table(Hints, Correct.First.Attempt)
plot(Hints, Correct.First.Attempt, main="Correct First Attempt VS Hints", 
     xlab="Hints", ylab = "Correct First Attempt")
mean(pred.glm==Correct.First.Attempt.test)


# linear discriminant analysis
glm.lda <- lda(Correct.First.Attempt~ Step.Start.Time + Step.End.Time +
                 Correct.Transaction.Time + Hints + Corrects + Incorrects,subset = train)
prediction.lda <- predict(glm.lda, x.test)

table(Correct.First.Attempt.test, prediction.lda$class)
mean(prediction.lda$class==Correct.First.Attempt.test)

# quadratic discriminant analysis
fit.qda <- qda(Correct.First.Attempt~ Step.Start.Time + Step.End.Time +
                 Correct.Transaction.Time + Hints + Corrects + Incorrects,subset = train)
pred.qda <- predict(fit.qda, x.test)
table(pred.qda$class, Correct.First.Attempt.test)
mean(pred.qda$class==Correct.First.Attempt.test)
summary(Correct.First.Attempt.test)
hist(Correct.First.Attempt.test)

# working with categorical features
KC.SubSkills.3 <- lapply(strsplit(as.character(KC.SubSkills.), "\\~"), "[", 1)
Opportunity.SubSkills.3 <- lapply(strsplit(as.character(Opportunity.SubSkills.), "\\~"), "[", 1)
x["dummyKC"] <- unlist(KC.SubSkills.3)
x["dummyOpportunity"] <- unlist(Opportunity.SubSkills.3)
x1 <- data.frame(x)
attach(x1)
x1$First.Transaction.Time <- as.numeric(x1$First.Transaction.Time)
x1$Step.Start.Time <- as.numeric(x1$Step.Start.Time)
View(x1)
x1$Correct.Transaction.Time <- as.numeric(x1$Correct.Transaction.Time)
x1$Step.End.Time <- as.numeric(x1$Step.End.Time, na.rm = TRUE)

train <- (Row > 100000)
x1.test <- x1[!train,]
Correct.First.Attempt.test <- Correct.First.Attempt[!train]

# This computation takes around 30 mins to generate output
glm.correct <- glm(Correct.First.Attempt~ First.Transaction.Time + Step.Start.Time + Step.End.Time +
                     Correct.Transaction.Time + Incorrects + dummyKC + 
                     dummyOpportunity, data = x1,
                   family = binomial, subset = train)

summary(glm.correct)
prediction <- predict(glm.correct, data = x1.test, type = "response")
pred.glm <- rep(0, length(Correct.First.Attempt.test))
pred.glm[prediction > 0.5] <- 1
table(pred.glm, Correct.First.Attempt.test)

mean(pred.glm==Correct.First.Attempt.test)

# this one also takes 15-20 mins to run
glm.lda <- lda(Correct.First.Attempt~ Step.Start.Time + Step.End.Time +
                 Correct.Transaction.Time + Hints + Corrects + Incorrects +
               dummyKC + dummyOpportunity, data = x1, subset = train)
prediction.lda <- predict(glm.lda, x1.test)

table(Correct.First.Attempt.test, prediction.lda$class)
mean(prediction.lda$class==Correct.First.Attempt.test)