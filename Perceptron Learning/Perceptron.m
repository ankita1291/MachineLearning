%load the mnist_train and mnist_test csv files
data = load('/mnist_train.csv');
%test = load('mnist_test.csv');
%get the vector containing the actual label for the training examples in
%both training and test csv files
actualValue = data(:,1);
%actualValueForTest = test(:,1);
noOfEx = length(actualValue);
%get the matrix containing the image pixel values of the training example
image_pix = [ones(noOfEx,1),data(:,2:end)];
%create a vector for different learning rates
eta = [0.01;0.01;0.1];
%scale the image pixels
scaled_image_pix = image_pix./255;
hidden_layer = [];
%initialize values
accuracy_vect = [];
accuracy_vect_test = [];
last_ep = [];
wt_sum= [];
wt_input =[];
wt_past_hidden_output =zeros(21, 10);
wt_past_input_hidden =zeros(785, 20);
%create a weight vector for each of the 10 possible output class
weight = rand(20,785).*1 - 0.5;
% error_output_unit=zeros(noOfEx, 10);
% error_hidden_unit=zeros(noOfEx, 20);
a = -0.05;
b = 0.05;
wt_hidden_output =  (b-a).*rand(10, 21) + a; 
wt_input_hidden = (b-a).*rand(20, 785) + a;
momentum = 0.9;
for epoch = 1:50
    fraction = 0;
    for i= 1:60000
        trainset = scaled_image_pix(i,:);
        hidden_layer = sum(bsxfun(trainset, wt_input_hidden), 2);%row vector of activations
        activation_hidden = 1.0 ./(1.0+exp(-hidden_layer));%row vector of activations
        activation_hidden =[1;activation_hidden];
        hidden_nodes_to_output =  sum(bsxfun(activation_hidden', wt_hidden_output), 2);
        activations_output = 1./(1+exp(-hidden_nodes_to_output));
        [value_predicted, index_of_predicted] = max(activations_output);
      
        if(actualValue(i) == index_of_predicted-1)
            fraction = fraction+1;
        end
        error_output_unit = activations_output .* (1 - activations_output).*(0.1 - activations_output);
        error_output_unit(index_of_predicted) = activations_output(index_of_predicted).*(1-activations_output(index_of_predicted)).*(0.9 - activations_output(index_of_predicted));
        s = sum(bsxfun(@times, wt_hidden_output(:, 2:end), error_output_unit),2);
        error_hidden_unit = activation_hidden(2:end,:) .*(1 - activation_hidden( 2:end,:)).*s; 
           
        wt_hidden_output =+  eta(1).*bsxfun(@times,error_output_unit, activation_hidden') + momentum.*wt_past_hidden_output;
        wt_past_hidden_output = wt_hidden_output;
        wt_input_hidden =+ eta(1).*bsxfun(@times,error_hidden_unit, trainset')+ momentum.*wt_past_input_hidden;
        wt_past_input_hidden = wt_input_hidden;
    end
    accuracy_train = (fraction/60000)*100;
    disp(accuracy_train);
   disp(hidden_layer(1));
end


