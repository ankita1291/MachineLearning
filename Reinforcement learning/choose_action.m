function a = choose_action(qmatrix1,current_state1, epsilon)
d =rand;
if(d>epsilon )
   % index = find(ismember(qmatrix, current_state, 'rows'), 1);
    [value, ind] = max(qmatrix1(current_state1, :));
    a = ind;
else
    ind =  randi([1, 5], 1,1);
    a = ind;
end
