psychomatrix
============
MATLAB implementation of the observer model in 

M Jogan and A. Stocker 
"**A new two-alternative forced choice method for the unbiased 
characterization of perceptual bias and discriminability**"
Journal of Vision, March 13, 2014, vol. 14 no.3

`simulateobserver.m` runs a sample experiment with a simulated observer. 

`psychomatrix.m` implements the observer model that allows to fit the decision probability values of the psychomatrix with a two-dimensional probability surface. This particular implementation assumes noise distributions are
Gaussians and have fixed widths.

`optimaltrial.m` implements the adaptive Bayesian estimation technique that optimally selects the reference values for the current trial based on the outcomes of previous trials by maximizing the expected information gain.

```matlab
sim = simulateobserver(rSigma, tSigma, tVal, bias, range, nTrials)
```
simulates `nTrials` of an 2AFC experiment where two reference stimuli are compared to a test (standard) stimulus. In each trial, the observer chooses the reference stimulus that is perceptually closer to the test. Perception ot the two reference stimuli is characterized by two normal distributions of width `rSigma` centered on the two reference values. Perception of test is characterized by a normal distribution of width `tTest` centered on `tVal`. `bias` is the magnitude of the perceptual bias in subject's perception of the test stimulus. `range` is the support for reference values. 
Example:
```matlab
sim = simulateobserver(1, 1.5, 0, 0, linspace(-10,10,31), 200)
p = sim.psychomatrix;
imagesc(p)
```
