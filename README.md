# Analysis of imputation bias for feature selection with missing data
We study risk/benefit tradeoff of missing value imputation in the context of feature selection. We caution against using imputation methods that may yield false positives: features not associated to the target becoming dependent as a result of imputation. We also investigate situations in which imputing missing values may be beneficial to reduce false negatives.  We use causal graphs to  characterize when structural bias arises and introduce a de-biased version of the t-test. 

![Causal relations](causal_relations.png "Diagram of different causal relations between three variables. Left hand number will be used to identify the corresponding causal model source")
Diagram of different causal relations between three variables. Left hand number will be used to identify the corresponding causal model source
