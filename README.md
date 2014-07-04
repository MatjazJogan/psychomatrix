psychomatrix
============
MATLAB implementation of the observer model in 

M Jogan and A. Stocker 

"A new two-alternative forced choice method for the unbiased 
characterization of perceptual bias and discriminability"

Journal of Vision, March 13, 2014, vol. 14 no.3

simulateobserver.m runs a sample experiment with a simulated observer. 

psychomatrix.m implements the observer model that allows to fit the decision probability values of the psychomatrix with a two-dimensional probability surface. This particular implementation assumes noise distributions are
Gaussians and have fixed widths.

optimaltrial.m implements the adaptive Bayesian estimation technique that optimally selects the reference values for the current trial based on the outcomes of previous trials by maximizing the expected information gain.
