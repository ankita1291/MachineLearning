function exp3 = experiment3(training_data, training_label, beta,test_data, test_label)
accuracy_vect = [];
for m = 2:57
    %     [sorted_values, sorted_index] = sort(SVModel.beta);
    %     feature_index = sorted_index(m, :);
    m_random_index = randperm(57, m);
    training_data_mfeatures = training_data(:, m_random_index');
    training_label_mfeatures = training_label(:, :);
    test_data_mfeatures = test_data(:, m_random_index');
    test_label_mfeatures = test_label(:, :);
    
    csvwrite(strcat('training_m_',int2str(m),'.csv'), training_data_mfeatures);
    SVMModel = fitcsvm(training_data_mfeatures,training_label_mfeatures,'Standardize',true,'KernelFunction','linear','ClassNames',{'0','1'});
    [l1, score] = predict(SVMModel, test_data_mfeatures);
    l2 = cellfun(@str2double,l1);
    equality_vector = bsxfun(@eq, test_label_mfeatures, l2);
    fraction = sum(equality_vector == 1);
    accuracy_train = (fraction/length(test_label_mfeatures))*100;
    accuracy_train = (fraction/length(test_label_mfeatures))*100;
    disp(accuracy_train);
    accuracy_vect(end+1) = accuracy_train;
end
plotData(accuracy_vect);
