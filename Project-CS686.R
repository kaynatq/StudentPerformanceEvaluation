x <- read.csv("Documents/algebra_2008_2009/algebra_2008_2009_train.txt", header=T, sep = "\t", na.strings = c(" "))
View(x)
attach(x)
# head -n 200000 algebra_2008_2009_train.txt

KC.SubSkills.3 <- lapply(strsplit(as.character(KC.SubSkills.), "\\~"), "[", 1)
Opportunity.SubSkills.3 <- lapply(strsplit(as.character(Opportunity.SubSkills.), "\\~"), "[", 1)
x["dummyKC"] <- unlist(KC.SubSkills.3)
x1["dummyOpportunity"] <- unlist(Opportunity.SubSkills.3)
x1 <- data.frame(x1)
attach(x1)
x1$First.Transaction.Time <- as.POSIXct(x1$First.Transaction.Time, na.rm=TRUE)
x1$First.Transaction.Time <- as.numeric(x1$First.Transaction.Time)
#x$Step.Start.Time <- as.POSIXct(x$Step.Start.Time, na.rm=TRUE)
x1$Step.Start.Time <- as.numeric(x1$Step.Start.Time)
#x$Opportunity.SubSkills. <- lapply(strsplit(as.character(Opportunity.SubSkills.), "\\~"), "[",1)

View(x1)
#x$Correct.Transaction.Time <- as.POSIXct(x$Correct.Transaction.Time, ns.rm = TRUE)
x1$Correct.Transaction.Time <- as.numeric(x1$Correct.Transaction.Time)
x1$Step.End.Time <- as.POSIXlt(x1$Step.End.Time, na.rm = TRUE)
x1$Step.End.Time <- as.numeric(x1$Step.End.Time, na.rm = TRUE)

train <- (Row > 100000)
# use "test.x"
x.test <- x1[!train,]
Correct.First.Attempt.test <- Correct.First.Attempt[!train]
glm.correct <- glm(Correct.First.Attempt~ First.Transaction.Time + Step.Start.Time + Step.End.Time +
                     Correct.Transaction.Time + Incorrects + dummyKC+ dummyOpportunity, data = x1,
                   family = binomial, subset = train)

summary(glm.correct)
prediction <- predict(glm.correct, data = x.test, type = "response")
length(dummyOpportunity)
pred.glm <- rep(0, length(prediction))
pred.glm[prediction > 0.5] <- 1
Correct.First.Attempt.test <- Correct.First.Attempt[72581]
table(pred.glm, Correct.First.Attempt.test)
length(pred.glm)
#pdf(file = "barplot.pdf")
counts <- table(KC.Rules., Correct.First.Attempt)
plot(KC.Rules., Correct.First.Attempt, main="Correct First Attempt VS KC.Rules", 
        xlab="KC.Rules", ylab = "Correct First Attempt")
mean(pred.glm==Correct.First.Attempt.test)
#dev.off()
library(MASS)
glm.lda <- lda(Correct.First.Attempt~ Step.Start.Time + Step.End.Time +
                 Correct.Transaction.Time + Hints + Corrects + Incorrects,subset = train)
prediction.lda <- predict(glm.lda, x.100000)

table(Correct.First.Attempt.100000, prediction.lda$class)
mean(prediction.lda$class==Correct.First.Attempt.100000)
fit.qda <- qda(Correct.First.Attempt~ Step.Start.Time + Step.End.Time +
                 Correct.Transaction.Time + Hints + Corrects + Incorrects,subset = train)
pred.qda <- predict(fit.qda, x.100000)
table(pred.qda$class, Correct.First.Attempt.100000)
mean(pred.qda$class==Correct.First.Attempt.100000)
summary(Correct.First.Attempt.100000)
hist(Correct.First.Attempt.100000)
