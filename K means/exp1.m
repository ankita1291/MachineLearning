data = load('/optdigits.train');
test_data = load('/optdigits.test');
K = 30;
cluster_class_matrix(K,2)=0;
[rows, cols] = size(data);
a = 0;
b = 16;
run_history = [];
actual_val = data(:, cols);
value1 = [10,1];
flag= 1;
best_run=[];
mss =[];
best_centroids=[];
total_valid_clusters= 0;
K_comb = linspace(1, 10, 10);
%calculate euclidean distance from each point to each centroid
distance_formula = @(xx, yy) (xx - yy).^2;
temp = zeros(rows, 1);
amse = [];
amss = [];
feature_data = data(:,1: cols-1);
%main loop
for j =1:2
    mse=[];
    flag1 = 1;
    run_index_history=[];
    converged_index = [];
    converged_centroids= [];
    loop = 0;
    centroids = (b-a)*rand(K,cols-1)+a;
    %loop for kmeans algorithm
    while 1
        loop = loop+1;
        %calculate distance between training points and centroids
        f1 = norm(centroids(1,:) -feature_data(1,:) );
        f2 =norm(centroids(2,:) -feature_data(1,:));
        sum4=sum(bsxfun(distance_formula, centroids, permute(feature_data,[3 2 1])), 2);
        %f = norm(centroids(1,:)-feature_data(1,:));
        distance_centroid_point1= reshape(permute(sum4, [2,3,1]), [], K);
        distance_centroid_point = (distance_centroid_point1).^(1/2);
        %get the cluster number for each point that is the closest to that
        %point. index is a 3283*1 vector where each entry corresponds to
        %the cluster number for that point.
        [value, index] = min(distance_centroid_point,[], 2);
        
        if(flag1==1)
            run_index_history = index;
            flag1 = 0;
            %termination condition for kmeans algorithm, if the new
            %clusters are the same as the previous iteration then the
            %system has converged
        else if( isequal(run_index_history, index)==1 || loop == 50)
                disp(loop);
                converged_index = index;
                converged_centroids = centroids;
                break;
            end
        end
        %recalculate the centroids, the new centroids are the mean of the
        %training points each cluster contains.
        for i = 1: K
            f = find(index == i);
            if f
                c = data(f,1:64);
                [r, col ] = size(c);
                centroids(i, :) = mean(c, 1);
            else
                centroids(i, :) =  centroids(i, :);
            end
        end
        run_index_history = index;
    end
    %calculate average mean square error and mean square seperation. Based
    %on the average mean square , assign values to  best_run and best_centroids which will be used to 
    %classify test data points . 
    for i = 1: K
        f = find(converged_index == i);
        if size(f)>0
            total_valid_clusters = total_valid_clusters+1;
            c = data(f,:);
            [r, col] = size(c);
            nl = bsxfun(distance_formula, converged_centroids(i, :), c(:, 1:col-1));
            mse1 = sum((sum(nl,2)))/r;
            mse(end+1) = mse1;
        end
    end
    amse(j) = mean(mse);
    if (flag == 0)
      %  If average mean square
    %for the current run is less than the previous average mean square,
    %then reassign best_run and best_centroids to reflect the new updated
    %values.
        if (amse(j)<=amse(j-1))
            best_run = converged_index;
            best_centroids = converged_centroids;
        end
    else
        best_run = converged_index;
        best_centroids = converged_centroids;
        flag = 0;
    end
    %calculate mean square seperation
    comb = nchoosek(K_comb, 2);
    sum1 = 0;
    for y = 1:length(comb)
        n = bsxfun(distance_formula, converged_centroids(comb(y,1), :), converged_centroids(comb(y,2), :));
        sum1 = sum1 + (sum(n,2));
    end
    mss(j) = sum1/length(comb);
end

[val , index_min] = min(amse);
disp(index_min);
%Create a cluster_class_matrix that maps the representative class for
%each cluster. representative class for each cluster is the one that occurs
%maximum number of times in the points that belong to that cluster. 
for i=1:K
    c=[];
    f = find(best_run == i);
    if size(f)>0
        c = data(f,:);
    [r11, c11] = size(c);
    labels = c(:, c11);
    max_occurence = mode(labels);
    cluster_class_matrix(i,:) = [i, max_occurence];
     else
         cluster_class_matrix(i,:) = [i, -1];
    end
    
end
%classify test data points
[row1, col1] = size(test_data);
test_label = test_data(:, col1);
inter_test = sqrt(sum(bsxfun(distance_formula, best_centroids, permute(test_data(:, 1: col1-1),[3 2 1])), 2));
distance_centroid_point_t= reshape(permute(inter_test, [2,3,1]), [], K);
[value, index_t] = min(distance_centroid_point_t,[], 2);

test_class = cluster_class_matrix(index_t, 2);
equality_vector = bsxfun(@eq, test_class, test_label);
fraction = sum(equality_vector == 1);
accuracy = fraction/row1*100;
disp(accuracy);
figure();
cm = confusionmat(test_class, test_label);
disp(cm);
%visualize points
for i = 1:K
    cl = best_centroids(i, :);
    pixel_matrix = reshape(cl, 8, 8);
    subplot(K/2,K/2,i);
    imshow(imresize(mat2gray(pixel_matrix),2));
end







