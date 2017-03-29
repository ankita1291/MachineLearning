close all;      
%load the data
data = load ('/spambase.data');
labels = data(:,size(data,2));
features_matrix = data(:, 1:57);
[sorted_value, sorted_index] = sort(labels,'descend');
spam_data = sum(sorted_value == 1);
nonspam_data = length(sorted_value) - spam_data;
%compose the training data and test data by splitting in to two
training_index = sorted_index([1:floor(spam_data/2) ,spam_data:floor(nonspam_data/2)+spam_data],:);
test_index = sorted_index([floor(spam_data/2)+1: spam_data-1, floor(nonspam_data/2)+1:nonspam_data], :);
training_data = data(training_index,:);
training_label = labels(training_index, :);
test_data = data(test_index, :);
test_label = labels(test_index, :);
%compute prior probabilities on training data
prior_p_spam = sum(labels(training_index,:)== 1)/size(training_data,1);
prior_p_nonspam = sum(labels(training_index,:)== 0)/size(training_data,1);

disp(prior_p_spam);
disp(prior_p_nonspam);
%compute mean and standard deviation
mean_vector_spam = mean(training_data(1:floor(spam_data/2), 1:57), 1);
std_vector_spam = std(training_data(1:floor(spam_data/2), 1:57),1);
mean_vector_nonspam = mean(training_data(spam_data:end,1:57), 1);
std_vector_nonspam = std(training_data(spam_data:end,1:57), 1);

%call the gaussian naive bayes function
c = gnb(test_data,mean_vector_spam,std_vector_spam,mean_vector_nonspam,std_vector_nonspam, prior_p_spam, prior_p_nonspam);
equality_vector = bsxfun(@eq, test_label, c');
fraction = sum(equality_vector == 1);
accuracy_test = (fraction/length(test_label))*100;
disp(accuracy_test);
%calculate all the positive classifications 
total_positives_pred = sum(c == 1);
count  = 0;
for i = 1:length(c)
    if(c(i) == test_label(i) && c(i) == 1)
        count = count + 1;
    end
end

precison = count/total_positives_pred;
disp(precison);
total_positives  = sum(test_label == 1);
recall = count/total_positives;
disp(recall);
%calculate confusion marix
conf_matrix = confusionmat(test_label, c);
disp(conf_matrix);
d = logistic_regression(training_data, test_data );

fraction = 0;
equality_vector = bsxfun(@eq, test_label, d);
fraction = sum(equality_vector == 1);
accuracy_test = (fraction/length(test_label))*100;
disp(accuracy_test);

%calculate all the positive classifications 
total_positives_pred2 = sum(d == 1);
count  = 0;
for i = 1:length(d)
    if(d(i) == test_label(i) && d(i) == 1)
        count = count + 1;
    end
end
precison2 = count/total_positives_pred2;
disp(precison2);
total_positives2  = sum(test_label == 1);
recall2 = count/total_positives;
disp(recall2);
conf_matrix2 = confusionmat(test_label, +d);
disp(conf_matrix2);
