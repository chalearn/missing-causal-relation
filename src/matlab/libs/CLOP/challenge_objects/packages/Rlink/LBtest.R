LBtest <- function(lb=NULL, xtest=NULL, ytest=NULL, nunits=NULL, graphic=1) {
# Function to train LogitBoost
# IG Sept 2006, after Roman Lutz's code.
# lb      --    A list of the trees
# xtest   --    Test data matrix
# nunits  --    Limit on the number of weak learners

  library(rpart)
  memory.limit(size=4000)
  
  # Find the file name
  namelist=dimnames(lb)[[1]]
  for (i in 1:length(namelist)) {
    if (namelist[i]=='filename') fn = lb[[i]]
    if (namelist[i]=='shrink') shrink = lb[[i]]
    if (namelist[i]=='zmax') zmax = lb[[i]]
    if (namelist[i]=='fracpos') fracpos = lb[[i]]
    if (namelist[i]=='train') train = lb[[i]]
    if (namelist[i]=='depth') depth = lb[[i]]
    if (namelist[i]=='nboost') nboost = lb[[i]]
  }   

  # Reload the logitboost object (called fitlist)
  # fn=lb$filename; shrink=lb$shrink, etc
  load(file=fn)
  
  # Number of weak learners
  if(is.null(nunits)) {
    if(train==1) nunits=nboost 
    else nunits=length(fitlist) 
  } 
  
  # Check whether training was actually performed 
  if(train==0) {
    ntrain <- dim(x)[1]
    print(paste("Training set size:", ntrain))
    probtrain <- rep(1/2, ntrain)
    FFtrain <- rep(0, ntrain)
    cntrl <- rpart.control(maxdepth=depth, minbucket=1, minsplit=2,
                           maxcompete=0, maxsurrogate=0, cp=0, xval=0)
    trainerror <- rep(NA,nboost)
    trainmisclass <- rep(NA,nboost)
    probtrain <- rep(1/2, ntrain)
    FFtrain <- rep(0, ntrain)
  }
  ntest <- dim(xtest)[1]
  p <- dim(xtest)[2]
  print(paste("Test set size:", ntest))
  print(paste("Number of features:", p))
  probtest <- rep(1/2, ntest)
  FFtest <- rep(0, ntest)
  
  # Convert y to 0/1
  if(train==0) y=(y+1)/2 
  if(!is.null(ytest)) { 
    ytest=(ytest+1)/2      
    testerror <- rep(NA,nunits)
    testmisclass <- rep(NA,nunits)
  }
    
  for (m in 1:nunits) {
  
      if(train==0) {
        # Train a weak learner
        w <- pmax(probtrain*(1-probtrain),1e-15)
        z <- pmax(pmin((y - probtrain)/w,zmax),-zmax)
        fit <- rpart(z~x, method="anova", weights=w, control=cntrl)
        ff_train <- as.numeric(predict(fit, newdata=list(x=x)))       
        FFtrain <- FFtrain + 1/2* ff_train * shrink
        probtrain <- 1/(1+exp(-2*FFtrain))
      }
      else {
        # Just read it from the list
        fit=fitlist[[m]]
      }
      
      ff_test <- as.numeric(predict(fit, newdata=list(x=xtest)))
      
      FFtest <- FFtest + 1/2* ff_test * shrink
      probtest <- 1/(1+exp(-2*FFtest))
      discrim = probtest - fracpos
      
      if(graphic==1) {
        if(train==0) {
          trainerror[m] <- sum(log(1+exp(-2*(2*y-1)*FF)))
          # balanced error rate
          binaertrain <- as.numeric(probtrain > fracpos)
          traine0 <- mean(binaertrain[y==0])
          traine1 <- 1-mean(binaertrain[y==1])
          trainmisclass[m] <- (traine0+traine1)/2
        }
        else {
          if(!is.null(ytest)) {
          testerror[m] <- sum(log(1+exp(-2*(2*ytest-1)*FFtest)))
          # balanced error rate
          binaertest <- as.numeric(discrim>0)
          teste0 <- mean(binaertest[ytest==0])
          teste1 <- 1-mean(binaertest[ytest==1])
          testmisclass[m] <- (teste0+teste1)/2
          }
        }
      }
      
  }
  
  if (graphic==1) {
      if(train==0) {
        windows()
        par(mfrow=c(2,1))
        plot(trainerror, type="l")
        plot(trainmisclass, type="l", lty=3)      
      }
      if(!is.null(ytest)) {
        windows()
        par(mfrow=c(2,1))
        plot(testerror, type="l")
        plot(testmisclass, type="l", lty=3)
      }
  }

  discrim # discriminant value
}