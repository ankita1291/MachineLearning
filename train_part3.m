function confusionMatrix = train_part3(first_part_data, label_first_part, full_data,full_data_label)
actualValue = label_first_part;
%load the test data file
test = load('/mnist_test.csv');
actualValueForTest = test(:,1);
% calculate the number of rows in both training and test data
noOfEx = length(actualValue);
noOfEx2 = length(actualValueForTest);
noOfEx3 = length(full_data_label);
scaled_pix_full_data = [ones(noOfEx3, 1), full_data(:, 2:end)]./255;
%get the matrix containing the image pixel values of the training example
image_pix = [ones(noOfEx,1),first_part_data(:,2:end)];
%create a vector for different learning rates
eta = [0.1;0.01;0.01];
%scale the image pixels
scaled_image_pix = image_pix./255;
scaled_image_pix_test = [ones(noOfEx2,1),test(:,2:end)]./255;
hidden_layer = [];
%initialize values
accuracy_vect_training = [];
accuracy_vect_test = [];
no_hidden_units = 100;
wt_past_hidden_output =zeros(no_hidden_units+1, 10);
wt_past_input_hidden =zeros(785, no_hidden_units);
error_output_unit=zeros(1, 10);
error_hidden_unit=zeros(1, no_hidden_units);
a = -0.05;
b = 0.05;
wt_hidden_output =  (b-a).*randn(no_hidden_units+1,10) + a;
wt_input_hidden = (b-a).*randn(785, no_hidden_units)+ a;
momentum = 0.9;
% for epoch 0
 %compute accuracy on training data
    fraction = 0;
    wtd_sum_hidden = scaled_pix_full_data * wt_input_hidden;
      %calculate the sigmoid 
    hidden_activations1 = [ones(noOfEx3, 1), sigmf(wtd_sum_hidden, [1, 0])];
    wtd_sum_output = hidden_activations1 * wt_hidden_output;
    output_activations1 = sigmf(wtd_sum_output, [1, 0]);
    [value, index] = max(output_activations1, [], 2);
    index = index - 1;
    %calculate the no of matching predictions
    equality_vector = bsxfun(@eq, full_data_label, index);
    fraction = sum(equality_vector == 1);
    accuracy_train = (fraction/noOfEx3)*100;
    disp(accuracy_train);
    accuracy_vect_training(end+1) = accuracy_train;
    
    fraction = 0;
    %compute accuracy on test data
    wtd_sum_hidden2 = scaled_image_pix_test * wt_input_hidden;
    hidden_activations2 = [ones(10000, 1), sigmf(wtd_sum_hidden2, [1, 0])];
    wtd_sum_output2 = hidden_activations2 * wt_hidden_output;
    output_activations2 = sigmf(wtd_sum_output2, [ 1, 0]);
    [value, index] = max(output_activations2, [], 2);
    index = index-1;
    equality_vector = bsxfun(@eq, actualValueForTest, index);
    fraction = sum(equality_vector == 1);
    accuracy_test = (fraction/noOfEx2)*100;
    disp(accuracy_test);
    accuracy_vect_test(end+1) = accuracy_test;
    
    
for epoch = 1:50
    fraction = 0;
    for i= 1:noOfEx
        trainset = scaled_image_pix(i,:);
        hidden_layer = trainset*wt_input_hidden;
        %activation_hidden = 1.0 ./(1.0 + exp(abs(hidden_layer)));%row vector of activations
        activation_hidden = [1, sigmf(hidden_layer, [1, 0])];%row vector of activations for hidden units
        % activation_hidden =[1,activation_hidden];
        hidden_nodes_to_output =  activation_hidden*wt_hidden_output;
        activations_output = sigmf(hidden_nodes_to_output, [1, 0]);%row vector of activations for output units
        %activations_output = 1.0 ./(1.0 + exp(-hidden_nodes_to_output));
        [value_predicted, index_of_predicted] = max(activations_output);
       %calculate errot in the output units
        error_output_unit = activations_output .* (1 - activations_output).*(0.1 - activations_output);
        error_output_unit(actualValue(i)+1) = activations_output(actualValue(i)+1).*(1-activations_output(actualValue(i)+1)).*(0.9 - activations_output(actualValue(i)+1));
        %calculate error in the hidden units
        s = sum(bsxfun(@times, wt_hidden_output(2:end,:), error_output_unit),2);
        error_hidden_unit = activation_hidden(:,2:end) .*(1 - activation_hidden(:,2:end)).*s';
        
        intermediate =  eta(1).*bsxfun(@times,error_output_unit, activation_hidden') + momentum.*wt_past_hidden_output;
        wt_hidden_output= wt_hidden_output + intermediate;
        wt_past_hidden_output = intermediate;
        
        intermediate1=  eta(1).*bsxfun(@times,error_hidden_unit, trainset')+ momentum.*wt_past_input_hidden;
        wt_input_hidden = wt_input_hidden + intermediate1;
        wt_past_input_hidden = intermediate1;
    end
    
    %compute accuracy on training data
    fraction = 0;
    wtd_sum_hidden = scaled_pix_full_data * wt_input_hidden;
    hidden_activations1 = [ones(noOfEx3, 1), sigmf(wtd_sum_hidden, [1, 0])];
    wtd_sum_output = hidden_activations1 * wt_hidden_output;
    output_activations1 = sigmf(wtd_sum_output, [1, 0]);
    [value, index] = max(output_activations1, [], 2);
    index = index - 1;
    equality_vector = bsxfun(@eq, full_data_label, index);
    fraction = sum(equality_vector == 1);
    accuracy_train = (fraction/noOfEx3)*100;
    disp(accuracy_train);
    accuracy_vect_training(end+1) = accuracy_train;
    
    fraction = 0;
    %compute accuracy on test data
    wtd_sum_hidden2 = scaled_image_pix_test * wt_input_hidden;
    hidden_activations2 = [ones(10000, 1), sigmf(wtd_sum_hidden2, [1, 0])];
    wtd_sum_output2 = hidden_activations2 * wt_hidden_output;
    output_activations2 = sigmf(wtd_sum_output2, [ 1, 0]);
    [value, index] = max(output_activations2, [], 2);
    index = index-1;
    equality_vector = bsxfun(@eq, actualValueForTest, index);
    fraction = sum(equality_vector == 1);
    accuracy_test = (fraction/noOfEx2)*100;
    disp(accuracy_test);
    accuracy_vect_test(end+1) = accuracy_test;
end

%plot the data for each learning rate
plotData(accuracy_vect_training, accuracy_vect_test);
%calculations for confusion matrix
wtd_sum_hidden2 = scaled_image_pix_test * wt_input_hidden;
hidden_activations2 = [ones(noOfEx2, 1), sigmf(wtd_sum_hidden2, [ 1, 0])];
wtd_sum_output2 = hidden_activations2 * wt_hidden_output;
output_activations2 = sigmf(wtd_sum_output2, [ 1, 0]);
[value, index] = max(output_activations2, [], 2);
predicted_value = index - 1;
%get the confusion matrix
cm = confusionmat(actualValueForTest, predicted_value);
disp(cm);
confusionMatrix = cm;

