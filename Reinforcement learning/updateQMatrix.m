function [qmatrix] = updateQMatrix(qmatrix1, reward, current_state1, next_state1, a)
%eta = linspace(0, 1, 4);
eta = 0.2;
gamma = 0.2;

max_reward = max(qmatrix1(next_state1,:));
%calculate the next state
disp(current_state1);
qmatrix1( current_state1,a ) = qmatrix1(current_state1, a) + eta*(reward + gamma*(max_reward) - qmatrix1(current_state1, a));
%action(index, a) =  action(index, a) + eta*(reward + gamma*(max_reward) - action(index, a));
qmatrix = qmatrix1;