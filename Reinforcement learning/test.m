total_combs = npermutek([0 1 2],5);
disp(total_combs(74));
epsilon = 1;
N = 5000;
M = 200;
reward_per_episode(N, M) = 0;
qmatrix1(243, 5) = 0;
%generate all possible state
zer_col = zeros(size(total_combs, 1), 1);
qmatrix = total_combs;
  action(243, 5)=0;
  plotdata = [];
%qmatrix(:, 6) = 0;
for i = 1:N
    if(mod(N, 50) == 0)
        epsilon = 99/100*epsilon;
    end
    canPos = randi([0, 1],10, 10);
    reward = 0;
    initial_no = randi([1,100]);
    initial_state = [0 1 2 0 0];
    initital_state1  = dec2base(intial_state, 3);
    
   % col = mod(initial_no, 10);
    %row = ceil(initial_no/10);
%     if(col == 0)
%         col = 10;
%     end
%     initial_state(1, 1) = canPos(row, col);
%     if(row == 1)
%         initial_state(1, 2) = 2;
%     else
%         initial_state(1, 2) = canPos(row-1, col);
%     end
%     if(row == 10)
%         initial_state(1, 3) = 2;
%     else
%         initial_state(1, 3) = canPos(row+1, col);
%     end
%     if(col == 10)
%         initial_state(1, 4) = 2;
%     else
%         initial_state(1, 4) = canPos(row, col+1);
%     end
%     if(col == 1)
%         initial_state(1, 5) = 2;
%     else
%         initial_state(1, 5) = canPos(row, col-1);
%     end
    current_state = initial_state1;
    for j = 1:M
        reward = 0;
        %take random action
       a =  choose_action(qmatrix1, action, current_state, epsilon);
     %   a = randi(1, 5);
        if(a == 1)
            if(current_state(1, 2) == 2)
                reward = -5;
                %current_state(1, 1) = current_state(1,2);
            else
                current_state(1, 1) = current_state(1,2);
                row = row - 1;
            end
        else if(a == 2)
                if(current_state(1, 2) == 2)
                    reward = -5;
                else
                    current_state(1, 1) = current_state(1,3);
                    row = row +1;
                end
            else if(a == 3)
                    if(current_state(1, 3) == 2)
                        reward = -5;
                    else
                        current_state(1, 1) = current_state(1,4);
                        col = col + 1;
                    end
                else if(a == 4)
                        if(current_state(1, 4) == 2)
                            reward = -5;
                        else
                            current_state(1, 1) = current_state(1,5);
                            col = col - 1;
                        end
                    else
                        if(current_state(1, 1) == 0)
                            reward = -1;
                        else
                            reward = 10;
                            current_state(1, 1) = 0;
                            canPos(row, col) = 0;
                              disp(canPos);
                        end
                    end
                end
            end
        end
        reward_per_episode(i, j) = reward;
        current_state = calculateCurrentState(current_state, row, col, canPos);
        action = updateQMatrix(qmatrix,reward, current_state, action, a); 
    end
   % reward_per_episode(end) = reward_per_episode;
    if(mod(i, 100) == 0)
        plotdata(end+1) = sum(reward_per_episode(i));
    end
end
figure;
X = (1:50);
plot(X, plotdata);
test_avg  = sum(reward_per_episode, 2);
test_std = std(reward_per_episode, 0, 2);





