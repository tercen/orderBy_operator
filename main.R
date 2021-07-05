library(tercen)
library(dplyr)

ctx <- tercenCtx()

df <- ctx %>% 
  select(.y, .ci, .ri)

FUNC <- ctx$op.value('function')
DECR <- as.logical(ctx$op.value('decreasing'))

if (FUNC == "rev") {
  ci <- as.double(unique(df$.ci))
  ri <- as.double(unique(df$.ri))
  
  cresult <- data.frame(
    .ci = ci,
    corder = ci
  ) %>% ctx$addNamespace()
  
  rresult <- data.frame(
    .ri = ri,
    rorder = rev(ri)
  ) %>% ctx$addNamespace()
} else {
  matrix <- df %>% 
    reshape2::acast(.ri ~ .ci, value.var = '.y', fun.aggregate = mean)
  
  rorder0 <- order(apply(X = matrix, MARGIN = 1, FUN = FUNC), decreasing = DECR)
  corder0 <- order(apply(X = matrix, MARGIN = 2, FUN = FUNC), decreasing = DECR)
  
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
}

list(cresult, rresult) %>% ctx$save()
