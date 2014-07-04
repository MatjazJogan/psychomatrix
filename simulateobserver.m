function Sim = simulateobserver(rSigma, tSigma, tVal, bias, range, nTrials)

% SIMULATEOBSERVER simulation of an experiment using the 2AFC method described
% in "A new two-alternative forced choice method for the unbiased
% characterization of perceptual bias and discriminability"
% M Jogan and A. Stocker
% Journal of Vision, March 13, 2014, vol. 14 no.3
%
% EST = SIMULATEOBSERVER(RSIGMA, TSIGMA, TVAL, BIAS, RANGE, NTRIALS) simulates
% NTRIALS of the 2AFC experiment assuming an observer that, at each trial, 
% chooses which of the two reference stimuli is closer to a test stimulus. 
% RSIGMA specifies the width of the gaussian noise distribution for the two 
% reference stimuli. 
% TSIGMA regulates the width of the gaussian noise distribution for the test 
% stimulus. 
% TVAL is the value of the test stimulus (constant throughout the experiment). 
% BIAS is the magnitude of the perceptual bias in subject's perception of the 
% test stimulus. 
% RANGE is the discrete experimental range for reference stimuli placement. 
%
% The values of the two reference stimuli in each trial are selected by
% calling OPTIMALTRIAL which returns r1 and r2 such that the expected information 
% gain by the subject?s choice is maximal. 
% Code is optimized for readability and not for speed.
%
% Dependencies:
% optimaltrial.m
% psychomatrix.m
%
% Examples:
% sim = simulateobserver(1, 1.5, 0, 0, linspace(-10,10,31), 200)
% p = sim.psychomatrix;
% imagesc(p),
%
% 2011 Matjaz Jogan, University of Pennsylvania


Obs.test.bias  = bias;                      % set observer's parameters
Obs.test.sigma = tSigma;
Obs.ref.sigma  = rSigma;

lRange  = length(range);                    % set experimental range

bias    = linspace(-5, +5, 10);             % set parameter probability matrix range
sigma   = linspace(.01, 2, 10);
lBias   = length(bias);
lSigma  = length(sigma);



psy = zeros(lRange, lRange, lSigma, lSigma, lBias);    % generate psychomatrices 
for isr = 1:lSigma                                     % p(|<r1>-<t>|>|<r2>-<t>|) 
    for ist = 1:lSigma                                 % for the sampled parameter range
        for ib = 1:lBias
            psy(:,:,isr, ist, ib) = psychomatrix(range, tVal,...
                bias(ib), sigma(isr), sigma(ist));
        end
    end
end
psy(psy<=0) = eps;
psy(psy>=1) = 1-eps;



p = ones(lSigma, lSigma, lBias);            % initialize uniform joint prior 
p = (p / numel(p));                         % over observer parameters

pm = zeros(lRange, lRange);                 % (|<r1>-<t>|>|<r2>-<t>|) count matrix
hm = pm;                                    % trial count matrix



for iTrial = 1:nTrials
    
    [ref1, ref2, pYes, pNo] = optimaltrial(psy, p, 4);
    fprintf('trial %d r1: %d  r2: %d\n', iTrial, ref1, ref2)
    
    response = [1,2];
    
    Obs.ref.estimated1 = range(ref1) + Obs.ref.sigma * randn(1);
    Obs.ref.estimated2 = range(ref2) + Obs.ref.sigma * randn(1);
    
    Obs.test.estimated = tVal + Obs.test.bias + Obs.test.sigma * randn(1);
    closer = dist(Obs.test.estimated, Obs.ref.estimated1) > dist(Obs.test.estimated, Obs.ref.estimated2);
    
    Obs.response = response(closer + 1);
    
    switch Obs.response                    
        case 1                              % reference 1 observed closer to test
            hm(ref1, ref2) = hm(ref1, ref2) + 1;
            p = pNo;
        case 2                              % reference 2 observed closer to test
            hm(ref1, ref2) = hm(ref1, ref2) + 1;
            pm(ref1, ref2) = pm(ref1, ref2) + 1;
            p = pYes;
    end
end



Sim.range = range;
Sim.pm = pm;
Sim.hm = hm;
Sim.psychomatrix = pm./hm;