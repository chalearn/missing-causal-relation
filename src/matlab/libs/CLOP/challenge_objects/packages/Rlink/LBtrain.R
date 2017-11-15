LBtrain <- function(x, y, shrink=0.3, nboost=100, depth=2, zmax=10, train=1, graphic=1) {
# Function to train LogitBoost
# IG Sept 2006, after Roman Lutz's code.
# x       --    Training data matrix
# y       --    +-1 labels
# shrink  --    Shrinkage parameter
# nboot   --    Number of boosting iterations
# depth   --    Maximum tree depth
# zmax    --    Maximum z value (adjusted target values)
# train   --    Option that saves memory: no training is actually performed if train=0.
#               The training data is only saved.
# graphic --    Plot the learning curve (only if train=1) 

  # Create a file name to save the trained object
  fn=date()
  fn=paste(unlist(strsplit(fn, " ")), collapse='_')
  fn=paste(unlist(strsplit(fn, ":")), collapse='_')
  fn=paste(c(fn, 'logitboost.Rdata'), collapse='_') 
  
  # Compute the fraction of positive examples
  ntrain <- dim(x)[1]
  p <- dim(x)[2]
  print(paste("Training set size:", ntrain))
  print(paste("Number of features:", p))
  numplus1 <- sum(y==1)
  fracpos <- numplus1/ntrain 
  
  if(train==0) {
    # Don't train, just save the data
    save(x, y, file=fn, compress=TRUE)
    print("Data saved")
  }
  else {
    # Actually train
    library(rpart)
    memory.limit(size=4000)
    
    # Convert y to 0/1
    y=(y+1)/2
    
    # Initializations
    cntrl <- rpart.control(maxdepth=depth, minbucket=1, minsplit=2,
                           maxcompete=0, maxsurrogate=0, cp=0, xval=0)
    trainerror <- rep(NA,nboost)
    trainmisclass <- rep(NA,nboost)
    probtrain <- rep(1/2, ntrain)
    FF <- rep(0, ntrain)
    
    fitlist <- vector("list", nboost)
    
    for (m in 1:nboost) {
    
        w <- pmax(probtrain*(1-probtrain),1e-15)
        z <- pmax(pmin((y - probtrain)/w,zmax),-zmax)
        #print(table(z))
        
        #Learner fitten (tree)
        fit <- rpart(z~x, method="anova", weights=w, control=cntrl)
        
        fitlist[[m]]=fit
        
        #print(fit)
        #print(fit$cptable[1,1]-fit$cptable[2,1])
        #print(max(abs(z)))
        #print(attr(fit$splits,"dimnames")[[1]])
        #print(min(fit$frame$n))
        ff <- as.numeric(predict(fit, newdata=list(x=x)))
        
        FF <- FF + 1/2* ff * shrink
        probtrain <- 1/(1+exp(-2*FF))
    
        #neg loglik
        #print(c(sum(log(1+exp(-2*ytrain*FF[1:ntrain]))),
        #      sum(z^2*w)-sum((z-ff[1:ntrain])^2*w)))
        
        trainerror[m] <- sum(log(1+exp(-2*(2*y-1)*FF)))
        #trainmisclass[m] <- mean((sign(FF)+1)/2 !=y)    
    
        # balanced error rate
        binaertrain <- as.numeric(probtrain > fracpos)
        traine0 <- mean(binaertrain[y==0])
        traine1 <- 1-mean(binaertrain[y==1])
        trainmisclass[m] <- (traine0+traine1)/2
        
    }
    
    if (graphic==1) {
        windows()
        par(mfrow=c(2,1))
        plot(trainerror, type="l")
        plot(trainmisclass, type="l", lty=3)
    }
  
    # Save the ligitboost object for future reference
    save(fitlist, file=fn, compress=TRUE)
  }
  
  list(filename=fn, train=train, shrink=shrink, fracpos=fracpos, zmax=zmax, depth=depth, nboost=nboost)

}