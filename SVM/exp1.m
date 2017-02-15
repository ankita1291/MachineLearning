close all;      
%load the data
data = load ('/spambase.data');
%get the first 57 cols which contain the features
feature_vect = data(:, 1:57);
%label = data(:, 58);
%divide the training data into two parts
h = floor(size(feature_vect, 1)/2);
%compute random permutation of the data rows
rand_idx = randperm(length(data));
rand_idx = rand_idx';
%use the random permutation to divide the data into two parts: namely
%training data and test data
training_data = data(rand_idx(1:h) , :);
training_label  = training_data(:, 58);
training_data = training_data(:, 1:57);

test_data = data(rand_idx(h + 1: 4601), :);
test_label = test_data(: , 58);
test_data = test_data(:, 1:57);

%use the fitcsvm method to train the classifier on training data
SVMModel = fitcsvm(training_data,training_label,'Standardize',true,'KernelFunction','linear','ClassNames',{'0','1'});
%use the predict method to get the prediction on test data. No need to
%standardize the test data if the 'standardize' attribute is set to true in
%the fitcsvm method. Svm package does the standardization for you.
[l1, score] = predict(SVMModel, test_data);
%calculate accuracy on test data
l2 = cellfun(@str2double,l1);
cp = classperf(l2, test_label);
recall = cp.Sensitivity;
precision = cp.PositivePredictiveValue;
disp('Reacll is: ')
disp(recall);
disp('Precision is:');
disp(precision)
equality_vector = bsxfun(@eq, test_label, l2);
fraction = sum(equality_vector == 1);
accuracy_train = (fraction/length(test_label))*100;
disp('Accuracy is:');
disp(accuracy_train);
%calculate all the positive classifications 
total_positives = sum(test_label == 1);
recall = count/total_positives;
disp(recall);
total_negatives = length(test_label) - total_positives;

%ROC curve
tp = 0; fp = 0;
tpr =[]; fpr =[];
%calculate the thresholds
min_val = min(score(:,2));
max_val = max(score(:,2));
threshold = linspace(min_val, max_val, 200);
%calculate true positives and true negatives
for i = 1:200
    for j = 1: length(test_data)
        %if the score value>threshold and also the actual label is 1 => the
        %training example is true positive
        if(score(j,2) > threshold(i) && test_label(j)==1)
            tp = tp+1;
         %if the score value>threshold but the actual label is 0 => the
        %training example is false positive
        else if(score(j,2)>threshold(i) && test_label(j) == 0)
                fp = fp+1;
            end
        end
    end
    %calculate true positive rate
     tpr(end+1) = tp/(total_positives);
     %calculate false positive rate
     fpr(end+1) = fp/total_negatives;
     tp = 0;
     fp = 0;
end
plot(fpr,tpr);
            

experiment2(training_data,training_label,SVMModel.Beta, test_data, test_label);
experiment3(training_data,training_label,SVMModel.Beta, test_data, test_label);