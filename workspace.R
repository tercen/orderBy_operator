library(tercen)
library(dplyr)

options("tercen.workflowId" = "69c66dc497df8e7d2548199984009d55")
options("tercen.stepId"     = "8e409a0f-23f8-484f-bcc6-d27e6dc75f1c")

getOption("tercen.workflowId")
getOption("tercen.stepId")

ctx <- tercenCtx()

df <- ctx %>% 
  select(.y, .ci, .ri)

FUNC <- "rev"
# FUNC <- ctx$op.value('function')
DECR <- FALSE
# DECR <- as.logical(ctx$op.value('decreasing'))

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
