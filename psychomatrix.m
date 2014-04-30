function p = psychomatrix(range, tVal, bias, rSigma, tSigma)

% PSYCHOMATRIX psychomatrix for the 2AFC method described in
% "A new two-alternative forced choice method for the unbiased 
% characterization of perceptual bias and discriminability"
% M Jogan and A. Stocker 
% Journal of Vision, March 13, 2014, vol. 14 no.3
% 
% P = PSYCHOMATRIX(RANGE, TVAL, BIAS, RSIGMA, TSIGMA) returns  
% psychomatrices with probabilities p(|<r1>-<t>|>|<r2>-<t>|) 
% for each r1 and r2 in RANGE and for parameters TVAL (value of test),
% BIAS (difference between perceived value and true value of test), 
% RSIGMA and TSIGMA (noise parameters for reference and test).
%
% TVAL, BIAS and TSIGMA have to be vectors of same length.
%
% Examples:
% p = psychomatrix(-15:15, [0.0 0.0], [0.0 5.0], [2.0], [2.0 4.0]);
% subplot(1,2,1),imagesc(p(:,:,1)),subplot(1,2,2),imagesc(p(:,:,2))
% p = psychomatrix(-15:15, [0.5 0.0], [0.0 0.5], [2.0 1.0], [2.0 4.0]);
% subplot(1,2,1),imagesc(p(:,:,1)),subplot(1,2,2),imagesc(p(:,:,2))
%
% 2011 Matjaz Jogan, University of Pennsylvania

[rHi rLo] = meshgrid(range);
nCond = numel(tSigma);
rHi   = repmat(rHi, [1 1 nCond]);
rLo   = repmat(rLo, [1 1 nCond]);

si    = [numel(range) numel(range)];
test  = shiftdim(repmat(tVal', [1 si]), 1);
u  = rLo - rHi; 
v = (rHi + rLo) - (2 .* test);

uSigma = sqrt(rSigma.^2 + rSigma.^2);
vSigma = sqrt(rSigma.^2 + rSigma.^2 + 4 * tSigma.^2);
uSigma = shiftdim(repmat(uSigma', [1 si]), 1);
vSigma = shiftdim(repmat(vSigma', [1 si]), 1);

uMean = zeros([si nCond]);
vMean = shiftdim(repmat(2 * bias', [1 si]), 1);

uCdf = normcdf(u, uMean, uSigma);
vCdf = normcdf(v, vMean, vSigma);

p = uCdf .* vCdf + (1-uCdf) .* (1-vCdf);

end
