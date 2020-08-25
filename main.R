library(tercen)
library(dplyr)

ctx <- tercenCtx()

df <- ctx %>% 
  select(.y, .ci, .ri) %>% 
  reshape2::acast(.ri ~ .ci, value.var = '.y', fun.aggregate = mean)

# FUNC <- "mean"
FUNC <- ctx$op.value('function')
# DECR <- FALSE
DECR <- as.logical(ctx$op.value('decreasing'))

rorder0 <- order(apply(X = df, MARGIN = 1, FUN = FUNC), decreasing = DECR)
corder0 <- order(apply(X = df, MARGIN = 2, FUN = FUNC), decreasing = DECR)

ci <- seq(from = 0, to = length(corder0) - 1)
ri <- seq(from = 0, to = length(rorder0) - 1)

corder <- as.double(ci)
rorder <- as.double(ri)

ci <- ci[corder0]
ri <- ri[rorder0]

cresult <- data.frame(
  .ci = ci,
  corder = corder
) %>% ctx$addNamespace()

rresult <- data.frame(
  .ri = ri,
  rorder = rorder
) %>% ctx$addNamespace()

list(cresult, rresult) %>% ctx$save()
