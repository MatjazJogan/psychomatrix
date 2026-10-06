psychomatrix
============
MATLAB implementation of the observer model in 

M Jogan and A. Stocker 
"**A new two-alternative forced choice method for the unbiased 
characterization of perceptual bias and discriminability**"
Journal of Vision, March 13, 2014, vol. 14 no.3

**▶ [Interactive demo](https://matjazjogan.github.io/psychomatrix/)**: standard 2AFC and the psychomatrix method compared on orientation and Ebbinghaus stimuli, with a simulated observer or with you as the observer.

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

Interactive demo
----------------
[`docs/index.html`](docs/index.html) is a self-contained browser demo (no build step; open it locally or serve `docs/` with GitHub Pages).

A target is compared with references along a primary dimension (orientation or size) while differing from them along a secondary one. The secondary dimension induces a perceptual bias in the primary, and this bias is what the experiment measures.

* **Orientation.** Gabor patches. The secondary dimension is the visibility of the target (contrast or additive noise), optionally with a tilted surround grating (tilt illusion). All orientations lie between vertical and the 45° oblique, so target and references are biased towards the same cardinal axis.
* **Size.** Discs of equal low contrast. The secondary dimension is the Ebbinghaus context around the target: small, absent or large inducers.

Each condition is measured by standard 2AFC (target against one reference; method of constant stimuli; cumulative Gaussian fit) and by the psychomatrix method (target with two references, "which reference matches the target?"; trials placed by expected information gain as in `optimaltrial.m`; model from `psychomatrix.m`).

In standard 2AFC, any asymmetry between target and reference beyond the primary dimension invites a decision bias that grows with the observer's uncertainty and cannot be distinguished from the perceptual bias; the PSE estimates their difference. The two references of the psychomatrix differ only in the primary dimension, and the target is never a response option, so the decision bias has nothing to act on and the method recovers the perceptual bias together with separate target and reference noise. The simulated observer makes this explicit, with decision bias c = z<sub>0</sub>√(σ<sub>t</sub>²+σ<sub>r</sub>²) + κ(σ<sub>t</sub> − σ<sub>r</sub>), and a sweep along the secondary dimension shows the two estimates diverging. A second mode runs both procedures on the viewer.
