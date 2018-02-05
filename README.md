# Analysis of imputation bias for feature selection with missing data
We study risk/benefit tradeoff of missing value imputation in the context of feature selection. We caution against using imputation methods that may yield false positives: features not associated to the target becoming dependent as a result of imputation. We also investigate situations in which imputing missing values may be beneficial to reduce false negatives.  We use causal graphs to  characterize when structural bias arises and introduce a de-biased version of the t-test. 

For the sake of simplicity, we only have 3 variables: Two continuous *features* and one target variable (**T**). One of the features (**H**) is fully observed (no missing data) and is used to *help* another variable that has missing data, which we call *source* (**S**). We are interested in studying how we can determine whether the *S* variable and the target *T* are significantly dependent. We will use a variant of the T-statistic to measure that dependence.

![Causal relations](causal_relations.png "Diagram of different causal relations between three variables. Left hand number will be used to identify the corresponding causal model source")
Diagram of different causal relations between three variables. Left hand number will be used to identify the corresponding causal model source


## Repository content
- **causal_relation**: Contains main functions that allow to reproduce different causal relationships between three variables (source variable *S*, helper variable *H* and target variable *T*), allowing the generation and imputation of missing data in *S* with *H*.
- **graph**: Contains functions that graphically represent the results obtained in different causal relationships.
- **libs**: Contains base library functions used in this work.
- **statistics**: Contains different statistic functions used in this work, ranging from original T-test to different modifications of this statistic test.
- **utils**: Contains general purpose functions.

## Experimental reproduction
1. Add all the project folders to Matlab path.
2. Execute the desired function of *causal_relation* folder.