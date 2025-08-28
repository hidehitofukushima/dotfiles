random_dataset <- data.frame(x = rnorm(100), y = rnorm(100))
options(digits = 3)

# plot
plot(random_dataset$x, random_dataset$y)

# summary
summary(random_dataset)

# correlation
cor(random_dataset)

# regression
lm(y ~ x, data = random_dataset)

# linear model
lm(y ~ x, data = random_dataset)
k
ll <- lm(y ~ x, data = random_dataset)
plot(ll)
# linear model
summary(lm(y ~ x, data = random_dataset))

# linear model
anova(lm(y ~ x, data = random_dataset))

# linear model
confint(lm(y ~ x, data = random_dataset))

# linear model
predict(lm(y ~ x, data = random_dataset), data.frame(x = 0))

# linear model
residuals(lm(y ~ x, data = random_dataset))

# linear model
rstandard(lm(y ~ x, data = random_dataset))

# linear model
fitted(lm(y ~ x, data = random_dataset))

# linear model
rstudent(lm(y ~ x, data = random_dataset))

# linear model
hatvalues(lm(y ~ x, data = random_dataset))

# linear model																	
