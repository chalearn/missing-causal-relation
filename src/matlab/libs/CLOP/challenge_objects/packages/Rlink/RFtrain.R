RFtrain <- function(..., x=NULL, y=NULL, type="classification") {
# Wrapper for randomForest, which allows saves
# forest objects in Matlab format.
# Note: in the randomForest function, the type classification
# is recognized by the fact that y is a factor.
# Isabelle Guyon -- isabelle@clopinet.com -- August 2006
    
    X <- as.data.frame(x);
    
    if (type=="classification") {
        Y <- as.factor(y)
        forest=randomForest(x=X, y=Y, ...)
        # forest=randomForest(y=Y, classwt=1/table(Y), ...)
        # I think it works only for binary outcomes
    } 
    else {
        forest=randomForest(x=X, y=y, ...) 
    }
    
    # Save the forest object for future reference
    fn=date()
    fn=paste(unlist(strsplit(fn, " ")), collapse='_')
    fn=paste(unlist(strsplit(fn, ":")), collapse='_')
    fn=paste(c(fn, 'forest.Rdata'), collapse='_')
    save(forest, file=fn, compress=TRUE)
    forest$errimp=importance(forest)    # feature weights
    forest$filename=fn   
    # Return only a few things to save time/memory
    frst <- list(filename=fn, classes=forest$classes, ntree=forest$ntree, mtry=forest$mtry, errimp=forest$errimp)
    frst
}    
