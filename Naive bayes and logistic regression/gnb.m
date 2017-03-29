function  c = gnb(test_data, mean_spam, std_spam, mean_nonspam, std_nonspam, prior_p_spam, prior_p_nonspam)
test_data = test_data(:, 1:57);
class = [];
% if standard deviation is 0 change it to 0.0001
std_spam(std_spam==0)=0.0001;
std_nonspam(std_nonspam==0)=0.0001;
const1 = 1./sqrt(2*pi*std_spam);
standardize1 = bsxfun(@rdivide, bsxfun(@minus,test_data, mean_spam).^2, 2*std_spam.^2);
standardize2 = bsxfun(@rdivide, bsxfun(@minus,test_data, mean_nonspam).^2, 2*std_nonspam.^2);
const2 = 1./sqrt(2*pi*std_nonspam);

gaussian_probability_spam = sum(log(bsxfun(@times,exp(-standardize1), const1)), 2)+ log(prior_p_spam);
gaussian_probability_nonspam = sum(log(bsxfun(@times, exp(-standardize2), const2)), 2)+ log(prior_p_nonspam);
for i= 1: length(gaussian_probability_spam)
    if(gaussian_probability_spam(i)> gaussian_probability_nonspam(i))
        class(end+1) =  1;
    else
        class(end+1) = 0;
    end
end

c= class;
