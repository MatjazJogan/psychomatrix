function [r1, r2, postYes, postNo] = optimRefVal(estimator, pert)

% OPTIMALREFVAL implements the efficient procedure to selectively sample the
% psychomatrix in an experiment that uses the 2AFC method described
% in "A new two-alternative forced choice method for the unbiased
% characterization of perceptual bias and discriminability"
% M Jogan and A. Stocker
% Journal of Vision, March 13, 2014, vol. 14 no.3.
%
% OPTIMREFVAL returns R1 and R2, the optimal  values of the two reference
% stimuli r1 and r2 in each trial such that the expected information gain
% by the subject’s choice is maximal, and POSTYES and POSTNO which are the
% posterior parameter probabilities give the subject answers YES or NO.
%
% See SIMOBSERVER for the contents of ESTIMATOR. PERT (optional) randomly perturbs
% the optimal coordinate by picking [r1, r2] from random PERT coordinates with 
% maximal expected entropy gain. Use PERT to avoid excessive repetition of stimuli triplets.
%
% 2011 Matjaz Jogan, University of Pennsylvania

draw = 1;

pY = zeros(size(estimator.P));
pN = pY;
pYes = zeros(estimator.lrange, estimator.lrange);
pNo = pYes;

% p({Y,N}|lambda, r1, r2) * jointp(lambda)
%
for i = 1:estimator.ls
    for j = 1:estimator.ls
        for k = 1:estimator.lb
            pY(:,:,i,j,k) = estimator.P(:,:,i,j,k) * estimator.jointp(i,j,k);
            pN(:,:,i,j,k) = estimator.jointp(i,j,k) - pY(:,:,i,j,k);
        end;
    end;
end;

% p({Y,N}|r1, r2) after presenting r1 and r2 at next trial
%
pYes = sumPd(sumPd(sumPd(pY,1,3),1,3),1,3);
pNo = sumPd(sumPd(sumPd(pN,1,3),1,3),1,3);

% posterior p(lambda | r1, r2, {Y,N})
%
for i = 1:estimator.ls;
    for j = 1:estimator.ls
        for k = 1:estimator.lb
            pY(:,:,i,j,k) = pY(:,:,i,j,k)./pYes;
            pN(:,:,i,j,k) = pN(:,:,i,j,k)./pNo;
        end;
    end;
end;

% entropy
%
eterm = -pY.*log(pY);
eterm(pY<=0) = 0;
eY = (sumPd(sumPd(sumPd(eterm,1,3),1,3),1,3));

eterm = -pN.*log(pN);
eterm(pN<=0) = 0;
eN = (sumPd(sumPd(sumPd(eterm,1,3),1,3),1,3));

entropy = eY .* pYes + eN .* pNo;

entropy(~entropy) = NaN;

if nargin > 1
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

postYes = squeeze(pY(r1,r2,:,:,:));
postNo = squeeze(pN(r1,r2,:,:,:));

if draw
    figure(1);
    imagesc(entropy),colormap gray, axis square off;
    hold on,
    plot(r2,r1,'r.'),hold off;
end;

function sPd = sumPd( pD, int, dim )

nd = ndims(pD);
if nargin == 2
    nd = ndims(pD);
    sPd = squeeze(sum(pD(:))*int^nd);
else
    sPd = squeeze(sum(pD,dim)*int);
end


