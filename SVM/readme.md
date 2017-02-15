This is a SVM classifier in matlab that classifies spam mail from non spam mail.
Dataset used here is <a href = 'https://archive.ics.uci.edu/ml/datasets/Spambase'>Spambase</a>

Experiment 1 trains the network and reports the accuracy, precision, and recall. To do this we first divide the data into 2 parts:
1). To be used for train
2). To be used for Testing.
It then creates the  ROC curve for this SVM on the test data, using 200 or more evenly spaced thresholds. 

Experiment 2: 
Feature selection with linear SVM 
We train the SVM by varyinng the number of features. We start off with 2 features with the highest weight and then keep on increasing the number of features . This is to test the effect features have on the accuracy of the classifier.

Experiment 3:
Random feature selection
It is almost the same as Experiment 2, but here each feature is selected randomly from the complete training set.    
This is to see if using SVM weights for feature selection has any advantage over random. 


