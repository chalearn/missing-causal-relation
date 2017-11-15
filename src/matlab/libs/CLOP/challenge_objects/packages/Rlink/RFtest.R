RFtest <- function(forest=NULL, xtest=NULL) {
# Wrapper for randomForest.predict, which allows using
# forest objects saved in Matlab format.
# Isabelle Guyon -- isabelle@clopinet.com -- August 2006

    # print(forest)
    
    # Find the file name
    namelist=dimnames(forest)[[1]]
    for (i in 1:length(namelist)) {
        if (namelist[i]=='filename') fn = forest[[i]]
    }   
    
    # Reload the forest object
    # fn=forest$filename
    load(file=fn)
    
    Xtest <- as.data.frame(xtest);
    
    # Make predictions
    preds <- predict(forest, newdata = Xtest, type = "prob")
}
