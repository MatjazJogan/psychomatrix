function [r1, r2, postYes, postNo] = optimaltrial(psy, p, pert)

% OPTIMALTRIAL implements the efficient procedure to selectively sample the
% psychomatrix in an experiment that uses the 2AFC method described
% in "A new two-alternative forced choice method for the unbiased
% characterization of perceptual bias and discriminability"
% M Jogan and A. Stocker
% Journal of Vision, March 13, 2014, vol. 14 no.3.
%
% OPTIMREFVAL returns R1 and R2, the optimal  values of the two reference
% stimuli r1 and r2 in each trial such that the expected information gain
% by the subject?s choice is maximal, and POSTY and POSTN which are the
% posterior parameter probabilities give the subject answers YES or NO.
%
% See SIMULATEOBSERVER for the contents of PSY and P. PERT (optional) randomly perturbs
% the optimal coordinate by picking [r1, r2] from random PERT coordinate pairs with 
% maximal expected entropy gain. Use PERT if you want to avoid excessive repetition of 
% stimuli triplets.
%
% Code is optimized for readability, not efficiency.
% 2011 Matjaz Jogan, University of Pennsylvania



draw = 1;

pYes = zeros(size(psy));
pNo  = pYes;



for i = 1:size(psy,3)                               % p({y,n}|lambda, r1, r2) * p(lambda)
    for j = 1:size(psy,4)
        for k = 1:size(psy,5)
            pYes(:,:,i,j,k) = psy(:,:,i,j,k) * p(i,j,k);
            pNo(:,:,i,j,k) = p(i,j,k) - pYes(:,:,i,j,k);
        end;
    end;
end;



mpYes = sumpd(sumpd(sumpd(pYes,1,3),1,3),1,3);      % p({Y,N}|r1, r2) after presenting 
mpNo  = sumpd(sumpd(sumpd(pNo,1,3),1,3),1,3);       % r1 and r2 at next trial


for i = 1:size(psy,3)                               % posterior p(lambda | r1, r2, {Y,N})
    for j = 1:size(psy,4)
        for k = 1:size(psy,5)
            pYes(:,:,i,j,k) = pYes(:,:,i,j,k)./mpYes;
            pNo(:,:,i,j,k) = pNo(:,:,i,j,k)./mpNo;
        end;
    end;
end;



eterm = -pYes.*log(pYes);                            % entropy
eterm(pYes<=0) = 0;
eYes = (sumpd(sumpd(sumpd(eterm,1,3),1,3),1,3));

eterm = -pNo.*log(pNo);
eterm(pNo<=0) = 0;
eNo = (sumpd(sumpd(sumpd(eterm,1,3),1,3),1,3));

entropy = eYes .* mpYes + eNo .* mpNo;

entropy(~entropy) = NaN;



if nargin > 2
    [dummy I] =  sort(entropy(:),'ascend');
    [r1a r2a] = ind2sub(size(entropy), I);
    rnd = round(1+pert*rand(1));
    r1 = r1a(rnd);
    r2 = r2a(rnd);
else
    [r1a r2a] = find(entropy == min(entropy(:)));
    r1 = r1a(1);
    r2 = r2a(1);
end;



postYes = squeeze(pYes(r1,r2,:,:,:));                % posterior probability for lambda
postNo  = squeeze(pNo(r1,r2,:,:,:));



if draw
    figure(1);
    imagesc(entropy),colormap gray, axis square off;
    hold on,
    plot(r2,r1,'r.'),hold off;
end;




function spd = sumpd( pd, int, dim )

nd = ndims(pd);
if nargin == 2
    nd = ndims(pd);
    spd = squeeze(sum(pd(:))*int^nd);
else
    spd = squeeze(sum(pd,dim)*int);
end


