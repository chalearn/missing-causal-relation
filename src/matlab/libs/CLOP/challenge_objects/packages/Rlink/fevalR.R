# Executes a given function called from Matlab
# Isabelle Guyon -- isabelle@clopinet.com -- August 2006

# find the directory to the input data from the arguments
theArgs <- commandArgs()
print(theArgs)
#datapath=substring(theArgs[4], 7, 1000000)
datapath=theArgs[4]
# datapath="Z:/user On My Mac/Isabelle/Projects/ChallengeBook/Clop/challenge_objects/packages/Rlink/"
print(datapath)

# store the current directory
initial.dir<-getwd()

# change to the new directory
setwd(datapath)

# load the necessary libraries
OK=require(randomForest)
if(!OK)   {
    install.packages(repos="http://cran.r-project.org", "randomForest")
}
OK=require(randomForest)
if(!OK)   {
    print("ERROR: randomForest cannot be loaded");
}

OK=require(R.matlab)
if(!OK)   {
    install.packages(repos="http://cran.r-project.org", "R.matlab")
    install.packages(repos="http://cran.r-project.org", "R.oo")
}
OK=require(R.matlab)
if(!OK)   {
    print("ERROR: R.matlab cannot be loaded");
}

# read the function name
func = scan("__function_called.txt", what='character');
print(func)

# load the function if necessary
if (!exists(func)) source(paste(func, ".R", sep=''));

# read number of arguments
argnum <- scan("__arg_num.txt");
print(argnum)

# read the argument names
argnames <- scan("__arg_names.txt", what='character');
print(argnames)

# read the arguments
argvals=array()
for (i in 1:argnum) {
    print(i)
    filename=sprintf("__arg%s.mat", i);
    print(filename)
    argvals[i] <- readMat(filename);
}
 
# create a call as a string
my_call=paste(func, "(");
for (i in 1:argnum) {
    if (i>1) my_call = paste(my_call, ",");
    my_call = paste(my_call, argnames[i], "= argvals[[", i, "]]");
    
}
my_call=paste(my_call, ")");
my_call

# execute the call
resu=eval(parse(text=my_call));
if (!is.list(resu)) resu=list(resu=resu) #  This may not always work, fix later

# create a string with all the results
my_write='writeMat("__resu.mat", ';
resunum=length(resu);
namelist=names(resu);
first_arg=0;
for (i in 1:resunum) {
    if (namelist[i]!="call" && !is.null(resu[[i]])) {
        if (first_arg>0) my_write = paste(my_write, ",");
        attrname=namelist[i];
        # replace dots by _
        attrname=paste(unlist(strsplit(attrname, "\\.")), collapse='_')
        my_write = paste(my_write, attrname, "= resu[[", i, "]]");
        first_arg=1;
    }
}  
my_write=paste(my_write, ")");

# write the results to a file
eval(parse(text=my_write));      






