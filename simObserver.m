function est = simObserver(rsigma, tsigma, tval, bias, ntrials)

% SIMOBSERVER simulation of an experiment using the 2AFC method described 
% in "A new two-alternative forced choice method for the unbiased 
% characterization of perceptual bias and discriminability"
% M Jogan and A. Stocker 
% Journal of Vision, March 13, 2014, vol. 14 no.3
% 
% EST = SIMOBSERVER(RSIGMA, TSIGMA, TVAL, BIAS, RANGE, NTRIALs) simulates 
% NTRIALS of the 2AFC method assuming an observer that, at each trial, chooses which  
% of the two reference stimuli is closer to a test stimulus. RSIGMA regulates the 
% gaussian noise distribution for the reference stimuli. TSIGMA regulates the 
% gaussian noise distribution for the test stimulus. TVAL is the value of the test stimulus 
% (constant thorough the experiment). BIAS is the bias in perception of the
% test stimulus. RANGE is the discrete experimental range for stimulus
% placement. Code is optimized for readability and not for speed. 
%
% Examples:
% est = simObserver(1, 1.5, 0, 0, linspace(-10,10,31), 200)
% p = est.psychomatrix; 
% imagesc(p),
%
% 2011 Matjaz Jogan, University of Pennsylvania


% set observer's parameters
obs.test.mean  = tval;
obs.test.bias  = bias;
obs.test.sigma = tsigma;
obs.ref.sigma  = rsigma;

% set experimental range
est.range = range;
est.lrange = length(est.range);

% set parameter probability matrix range
est.bias    = linspace(-5, +5, 10);
est.sigma   = linspace(.01, 2, 10);
est.lb      = length(est.bias);
est.ls      = length(est.sigma);

% generate psychomatrices p(|<r1>-<t>|>|<r2>-<t>|) for the sampled parameter range
est.P = zeros(est.lrange, est.lrange, est.ls, est.ls, est.lb);
for isr = 1:est.ls
    for ist = 1:est.ls
        for ib = 1:est.lb
            est.P(:,:,isr, ist, ib) = psychomatrix(est.range, obs.test.mean,...
                est.bias(ib), est.sigma(isr), est.sigma(ist));
        end;
    end;
end
est.P(est.P<=0)=eps;
est.P(est.P>=1)=1-eps;

% initialize uniform joint prior over observer parameters
est.jointp = ones(est.ls, est.ls, est.lb);
est.jointp = (est.jointp / (est.ls^2*est.lb));

% (|<r1>-<t>|>|<r2>-<t>|) count matrix
est.pm = zeros(est.lrange, est.lrange);
% trial count matrix
est.hm = est.pm;

for itrial = 1:ntrials;    
    [est.rlo, est.rhi, pyes, pno] = optimRefVal(est, 4);
    fprintf('trial %d r1: %d  r2: %d\n', itrial, est.rlo, est.rhi)
    
    response= [1,2];
    
    obs.ref.estimated.lo = est.range(est.rlo) + obs.ref.sigma * randn(1);
    obs.ref.estimated.hi = est.range(est.rhi) + obs.ref.sigma * randn(1);
    
    obs.test.estimated = (obs.test.mean + obs.test.bias) + obs.test.sigma * randn(1);    
    closer = (dist(obs.test.estimated, obs.ref.estimated.lo) > dist(obs.test.estimated, obs.ref.estimated.hi));
        
    obs.response = response(closer + 1);
    
    switch (obs.response) % adjust for the actual user's task (which is closer/more distant)
        case 1 % reference 1 closer to test
            est.hm(est.rlo, est.rhi) = est.hm(est.rlo, est.rhi) + 1;
            est.jointp = pno;
        case 2 % reference 2 closer to test
            est.hm(est.rlo, est.rhi) = est.hm(est.rlo, est.rhi) + 1;
            est.pm(est.rlo, est.rhi) = est.pm(est.rlo, est.rhi) + 1;
            est.jointp = pyes;
    end;    
end;

est.psychomatrix = est.pm./est.hm;
