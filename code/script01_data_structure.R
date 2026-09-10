## scalar
a <- 1.2
b <- "a"

## vector 
va <- c(1.2, 3, 4.6) 
mean(va) 

vb <- c("1","2", "3") 
mean(vb) ## error 

## matrix
vc <- c(1.3, 4.2, 5.6)
vd <- c(10, 3, 2)

 ma <- cbind(vc, vd)
 mb <- rbind(vc, vd)

 
 
## tricky data type: factor 
  vz <- c("a" , "b" , "c")
  vf <- factor(vz) 

  ## dataframe
 df0 <- data.frame(letter=vz, numeric =va)
 
 
 df0