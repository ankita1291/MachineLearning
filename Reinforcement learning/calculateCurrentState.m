function [next_state] =  calculateCurrentState( robby, canPos, a)
H = canPos(robby(1), robby(2));
N =0; S= 0; E= 0 ;W =0;
%if(a == 1)
if(robby(1)- 1==0)
    N = 2;
elseif(canPos(robby(1)- 1, robby(2)) == 1)
    N = 1;
elseif(canPos(robby(1)-1,robby(2)) == 0)
    N= 0;
end
%else if (a == 2)
if(robby(1)+1==11)
    S = 2;
elseif(canPos(robby(1)+1, robby(2)) == 1)
    S = 1;
elseif(canPos(robby(1)+1, robby(2)) == 0)
    S= 0;
end

%   else if(a == 3)
if(robby(2)+1==11)
    E = 2;
elseif(canPos(robby(1), robby(2)+1) == 1)
    E = 1;
elseif(canPos(robby(1), robby(2)+1) == 0)
    E= 0;
end

%     else if(a == 4)
if(robby(2)-1 == 0)
    W = 2;
elseif(canPos(robby(1), robby(2) -1) == 1)
    W = 1;
elseif(canPos(robby(1), robby(2)-1) ==0)
    W =0; 
end
next_state = [H, N, S, E, W];


%
% if(row-1 < 1)
%     current_state(1, 2) = 2;
% else
%     current_state(1, 2) = canPos(row-1, col);
% end
% if(row+1>10)
%     current_state(1, 3) = 2;
% else
%     current_state(1, 3) = canPos(row+1, col);
% end
% if(col+1>10)
%     current_state(1, 4) = 2;
% else
%     current_state(1, 4) = canPos(row, col+1);
% end
% if(col-1<1)
%     current_state(1, 5) = 2;
% else
%     current_state(1, 5) = canPos(row, col-1);
% end