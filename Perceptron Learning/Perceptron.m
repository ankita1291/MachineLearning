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






% %     for i = 1:60000
% %         x = scaled_image_pix(i,:);
% %         wt_input = bsxfun(@times,weight,x);
% %         wt_sum = sum(wt_input,2);
% %         [value,index] = max(wt_sum);
% %         pred_vals(i)= index-1;
% %         if (index-1 == actualValue(i))
% %             frac = frac+1;
% %         end
% %     end
%
%     disp((frac/60000)*100);
%     accuracy_vect(end+1) = (frac/60000)*100;
%     disp('.....Initial accuracy on test data....');
%     % compute initial accuracy for test data
%     frac =0;
%     for i =1:10000
%         r = p(i,:);
%         wt = bsxfun(@times,weight,r);
%         wt = sum(wt,2);
%         [value,ind] = max(wt);
%         if(ind-1 == actualValueForTest(i))
%             frac = frac+1;
%         end
%     end
%     accuracy_vect_test(end+1) = (frac/10000)*100;
%     %create  a loop to for 70 epochs
%     for t = 1:70
%         frac = 0;
%         fprintf('epoch---- %d\n',t);
%         %iterate through all training examples
%         for i = 1:60000
%             x = scaled_image_pix(i,:);
%             wt_input = bsxfun(@times,weight,x);
%             wt_sum = sum(wt_input,2);
%             activationVal(end+1) = 1./(1+exp(-wt_sum));
%             output = activaltionVal*
%            % pred_vals(i)= index-1;
%             %if predicted value = label then increase the count of fraction
% %             %of correct values
% %             if (index-1 == actualValue(i))
% %                 frac = frac+1;
%                 % else update all the weight vectors
%             else
%                 for j=0:9
%                     if (actualValue(i) == j && wt_sum(j+1)>0)
%                         weight(j+1,:) = eta(k).*(1-1)*x+weight(j+1,:);
%                     elseif(actualValue(i) == j && wt_sum(j+1)<=0)
%                         weight(j+1,:) = eta(k).*(1-0)*x+weight(j+1,:);
%                     elseif( wt_sum(j+1)>0)
%                         weight(j+1,:) = eta(k).*(0-1)*x+weight(j+1,:);
%                     else
%                         weight(j+1,:) = eta(k).*(0-0)*x+weight(j+1,:);
%                     end
%                 end
%             end
%         end
%         %compute accuracy after each epoch on both training and test data
%         disp('.......compute accuracy on training and test.......')
%         frac = 0;
%         for i = 1:60000
%             x = scaled_image_pix(i,:);
%             wt_input = bsxfun(@times,weight,x);
%             wt_sum = sum(wt_input,2);
%             [value,index] = max(wt_sum);
%             if (index-1 == actualValue(i))
%                 frac = frac+1;
%             end
%         end
%         accuracy_vect(end+1) = (frac/60000)*100;
%         frac = 0;
%         for i =1:10000
%             r = p(i,:);
%             wt = bsxfun(@times,weight,r);
%             wt = sum(wt,2);
%             [value,ind] = max(wt);
%             if(ind-1 == actualValueForTest(i))
%                 frac = frac+1;
%             end
%         end
%         accuracy_vect_test(end+1) = (frac/10000)*100;
%         fprintf('accuracy on test data after epoch %d %d\n',t ,accuracy_vect_test(end));
%
%     %run the final weights on test data, after completion of 70nepochs to
%     %obtain the confusion matrix
%     frac = 0;
%     for i =1:10000
%         r = p(i,:);
%         wt = bsxfun(@times,weight,r);
%         wt = sum(wt,2);
%         [value,ind] = max(wt);
%         last_ep(end+1) = ind-1;
%         if(ind-1 == actualValueForTest(i))
%             frac = frac+1;
%         end
%     end
%     % plot the data for each learning rate
%     plotData(accuracy_vect, accuracy_vect_test);
%     % get the confusion matrix
%     cm = confusionmat(actualValueForTest, last_ep');
%     disp(cm);
