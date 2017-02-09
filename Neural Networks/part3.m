%load the mnist_train and mnist_test csv files
data = load('/mnist_train.csv');
%randomize the rows of the data
rand_idx = randperm(length(data));
rand_idx = rand_idx';
%divide the training in two parts
first_part_data = data(rand_idx(1:30000), :);
second_part_data = data(rand_idx(30001:45000), :);
full_data = data(rand_idx, :);
label_first_part = first_part_data(:, 1);
label_second_part = second_part_data(:, 1);
label_full_data = full_data(:, 1);
%call the method to start traing the network
confusionMatrix = train_part3(first_part_data, label_first_part, full_data,label_full_data);

