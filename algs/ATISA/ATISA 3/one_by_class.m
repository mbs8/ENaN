function M = one_by_class (thr_idx, class, q)
%    
%   function returns the representant´s index of each class. The
%   representant is the one which has the largest threshold
%   
%   thr_idx : instance´s index which has the largests thresholds
%   class : classes´s instances
%   q : amount of classes


M = zeros (q, 1);

for i = 1:q
    u = thr_idx(class(thr_idx) == i);
    M(i) = u(1);
end