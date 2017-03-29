function [qmatrix] = updateQMatrix(qmatrix, reward, current_state, action, a)
eta = 0.2;
gamma = 0.9;
q = qmatrix(:, 1:5);
index = find(ismember(q, current_state, 'rows'), 1);
max_reward = 0;
for i =1: length(current_state)
    ones = find(current_state == 1);
    if(size(ones) >0)
        if(ones(1) == 1)
            max_reward = 10;
        else
            max_reward = 0;
        end
    end
end
qmatrix(index, end) =  qmatrix(index, end) + eta*(reward + gamma*(max_reward) - qmatrix(index, end));
