psychomatrix
============
MATLAB implementation of the observer model in 

M Jogan and A. Stocker 
"**A new two-alternative forced choice method for the unbiased 
characterization of perceptual bias and discriminability**"
Journal of Vision, March 13, 2014, vol. 14 no.3

**▶ [Try the interactive demo](https://matjazjogan.github.io/psychomatrix/)**: standard 2AFC vs. the psychomatrix method on tilt-illusion and Ebbinghaus stimuli, with a simulated observer or with yourself as the subject.

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
`docs/index.html` is a self-contained browser demo (no build step, open it locally or serve `docs/` with GitHub Pages). Visibility is reduced along a secondary dimension (low contrast or pixel noise). Two stimuli are available:

* **Orientation** (Gabor patches): either no context, where target and references differ only in orientation and visibility and the fading target is drawn toward (or pushed from) vertical, or a tilted surround grating (tilt illusion). All patches stay between vertical and the 45° oblique so they are biased relative to the same cardinal.
* **Size** (Ebbinghaus illusion): the target and reference discs share one fixed low contrast, and the inducers around the target (small, none, large) are the secondary dimension. Without inducers the setup is symmetric and neither bias is expected.

Each stimulus is measured with **standard 2AFC** (target vs. one reference, method of constant stimuli, cumulative-Gaussian fit) and with **the psychomatrix method** (target plus two references, "which reference matches the target?", trials placed by expected information gain as in `optimaltrial.m`, model from `psychomatrix.m`).

The simulated observer's perceptual bias changes with target visibility, so both methods should track it. In standard 2AFC it also applies a decision bias c = z<sub>0</sub>·√(σ<sub>t</sub>²+σ<sub>r</sub>²) + κ(σ<sub>t</sub> − σ<sub>r</sub>): z<sub>0</sub> is a criterion shift from any asymmetry between target and reference (e.g. a salient surround or inducers), fixed in units of uncertainty so its effect grows with noise, and zero only when they differ in the judged dimension alone; the second term grows with extra uncertainty about the target. The standard PSE therefore lands on b − c, while the psychomatrix, whose two references are equally clear and never include the target as an option, recovers b, σ<sub>t</sub> and σ<sub>r</sub>. A sweep over degradation levels shows the gap growing with noise. The *Try it yourself* tab runs both procedures on you.
