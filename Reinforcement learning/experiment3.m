epsilon = 0.5;
N0 = 5000;
M = 200;
reward_per_episode(N0, M) = 0;
qmatrix1(243, 5) = 0;
plotdata = [];
for i = 1:N0
%     if((epsilon~=0.1)&&(mod(i,50)==0))
%         epsilon = epsilon-0.01;
%     end
    canPos = randi([0, 1],10, 10);
    initial1 = randi([1,10]);
    initial2 = randi([1,10]);
    robby = [initial1, initial2];
    H = canPos(robby(1), robby(2));
    if(robby(1)+1==11)
        S = 2;
    else if(canPos(robby(1)+1) == 1)
            S = 1;
        else if(canPos(robby(1)+1) == 0)
                S= 0;
            end
        end
    end
    
    if(robby(1)-1==0)
        N = 2;
    else if(canPos(robby(1)-1) == 1)
            N = 1;
        else if(canPos(robby(1)-1) == 0)
                N= 0;
            end
        end
    end
    
    if(robby(2)+1==11)
        E = 2;
    else if(canPos(robby(2)+1) == 1)
            E = 1;
        else if(canPos(robby(2)+1) == 0)
                E= 0;
            end
        end
    end
    
    if(robby(2)-1 == 0)
        W = 2;
    else if(canPos(robby(2) -1) == 1)
            W = 1;
        else if(canPos(robby(2)-1) ==0)
                W =0;
            end
        end
    end
    
    initial_state = [H, N, S, E, W];
    initial_state1 = sum(10.^(length(initial_state)-1:-1:0).*initial_state);
    initial_state2 = base2dec(num2str(initial_state1), 3);
    
    current_state1 = initial_state2+1;
    current_state  = initial_state;
    
    for j = 1:M
        reward = 0;
        %take random action
        a =  choose_action(qmatrix1, current_state1, epsilon);
        if(a == 1)
            if(robby(1)- 1 == 0)
                reward = -5;
                %current_state(1, 1) = current_state(1,2);
            else
                robby(1) = robby(1) - 1;
                % row = row - 1;
            end
        elseif(a == 2)
            if(robby(1)+1 == 11)
                reward = -5;
            else
                robby(1) = robby(1)+1;
                %row = row +1;
            end
        elseif(a == 3)
            if(robby(2)+1 == 11)
                reward = -5;
            else
                robby(2) = robby(2)+1;
                %  col = col + 1;
            end
        elseif(a == 4)
            if(robby(2)-1 == 0)
                reward = -5;
            else
                robby(2) = robby(2)-1;
                %   col = col - 1;
            end
        else
            if(canPos(robby(1), robby(2)) == 0)
                reward = -1;
            else
                reward = 10;
                %                             current_state(1, 1) = 0;
                canPos(robby(1), robby(2)) = 0;
                % disp(canPos);
            end
        end
        reward_per_episode(i, j) = reward;
        %calculate final states and pass to update qmatrix
        % next_state1 = 0;
        
        next_state = calculateCurrentState( robby, canPos, a);
        next_state1 = sum(10.^(length(next_state)-1:-1:0).*next_state);
        next_state1 = base2dec(num2str(next_state1), 3);
        next_state1 = next_state1+1;
        qmatrix1 = updateQMatrix(qmatrix1,reward, current_state1, next_state1, a);
        current_state1 = next_state1;
        current_state  = next_state;
        
        
    end
    if(mod(i, 100) == 0)
        plotdata(end+1) = sum(reward_per_episode(i, :));
    end
end
% reward_per_episode(end) = reward_per_episode;

figure;
X = (1:50);
plot(X, plotdata);




reward_per_episode(5000, 200) = 0;
%testing loop
for i = 1:5000
    epsilon = 0.1;
    
    canPos = randi([0, 1],10, 10);
    initial1 = randi([1,10]);
    initial2 = randi([1,10]);
    robby = [initial1, initial2];
    H = canPos(robby(1), robby(2));
    if(robby(1)+1==11)
        S = 2;
    else if(canPos(robby(1)+1) == 1)
            S = 1;
        else if(canPos(robby(1)+1) == 0)
                S= 0;
            end
        end
    end
    
    if(robby(1)-1==0)
        N = 2;
    else if(canPos(robby(1)-1) == 1)
            N = 1;
        else if(canPos(robby(1)-1) == 0)
                N= 0;
            end
        end
    end
    
    if(robby(2)+1==11)
        E = 2;
    else if(canPos(robby(2)+1) == 1)
            E = 1;
        else if(canPos(robby(2)+1) == 0)
                E= 0;
            end
        end
    end
    
    if(robby(2)-1 == 0)
        W = 2;
    else if(canPos(robby(2) -1) == 1)
            W = 1;
        else if(canPos(robby(2)-1) ==0)
                W =0;
            end
        end
    end
    
    initial_state = [H, N, S, E, W];
    initial_state1 = sum(10.^(length(initial_state)-1:-1:0).*initial_state);
    initial_state2 = base2dec(num2str(initial_state1), 3);
    current_state1 = initial_state2+1;
    current_state  = initial_state;
    
    for j = 1:200
        reward = 0;
        %take random action
        a =  choose_action(qmatrix1, current_state1, epsilon);
        if(a == 1)
            if(robby(1)- 1 == 0)
                reward = -5;
                %current_state(1, 1) = current_state(1,2);
            else
                robby(1) = robby(1) - 1;
                % row = row - 1;
            end
        elseif(a == 2)
            if(robby(1)+1 == 11)
                reward = -5;
            else
                robby(1) = robby(1)+1;
                %row = row +1;
            end
        elseif(a == 3)
            if(robby(2)+1 == 11)
                reward = -5;
            else
                robby(2) = robby(2)+1;
                %  col = col + 1;
            end
        elseif(a == 4)
            if(robby(2)-1 == 0)
                reward = -5;
            else
                robby(2) = robby(2)-1;
                %   col = col - 1;
            end
        else
            if(canPos(robby(1), robby(2)) == 0)
                reward = -1;
            else
                reward = 10;
                %                             current_state(1, 1) = 0;
                canPos(robby(1), robby(2)) = 0;
                % disp(canPos);
            end
        end
        reward_per_episode(i, j) = reward;
        %  next_state1 = 0;
        %calculate final states and pass to update qmatrix
        next_state = calculateCurrentState( robby, canPos, a);
        next_state1 = sum(10.^(length(next_state)-1:-1:0).*next_state);
        next_state1 = base2dec(num2str(next_state1), 3);
        next_state1 = next_state1+1;
        %qmatrix1 = updateQMatrix(qmatrix1,reward, current_state1, next_state1, a);
        current_state1 = next_state1;
        current_state  = next_state;
        
    end
end
test_avg  = sum(sum(reward_per_episode, 2))/5000;
test_std = std(sum(reward_per_episode, 2));





