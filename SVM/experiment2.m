function exp2 = experiment2(training_data, training_label, beta,test_data, test_label)
accuracy_vect = [];
%loop to select features from 2 to 57
for m = 2:57
    %sort the weight values from high to low
    [sorted_values, sorted_index] = sort(beta,'descend');
    %from the sorted vector, select the top m features with highest weights
    feature_index = sorted_index(1:m, :);
     if(m == 5)
        disp(feature_index);
    end
    training_data_mfeatures = training_data(:, feature_index);
    training_label_mfeatures = training_label(:, :);
    csvwrite(strcat('training_m_',int2str(m),'.csv'), training_data_mfeatures);
    %select the test data with only the m features  with high weights
    test_data_mfeatures = test_data(:, feature_index);
    test_label_mfeatures = test_label(:, :);
    %train the classifier on training data
    SVMModel = fitcsvm(training_data_mfeatures,training_label_mfeatures,'Standardize',true,'KernelFunction','linear','ClassNames',{'0','1'});
    %use the predict method to get the prediction on test data. No need to
    %standardize the test data if the 'standardize' attribute is set to true in
    %the fitcsvm method. Svm package does the standardization for you.
    [l1, score] = predict(SVMModel, test_data_mfeatures);
    l2 = cellfun(@str2double,l1);
    %calculate accuracy
    equality_vector = bsxfun(@eq, test_label_mfeatures, l2);
    fraction = sum(equality_vector == 1);
    accuracy_train = (fraction/length(test_label_mfeatures))*100;
    disp(accuracy_train);
    accuracy_vect(end+1) = accuracy_train;
end
figure();
plotData(accuracy_vect);
