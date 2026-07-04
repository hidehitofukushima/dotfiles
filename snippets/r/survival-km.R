library(survival)
library(survminer)

fit <- survfit(Surv(time, status) ~ group, data = df)

p <- ggsurvplot(
  fit,
  data = df,
  risk.table = TRUE,
  pval = TRUE
)

p
