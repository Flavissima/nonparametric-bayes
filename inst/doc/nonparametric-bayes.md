% Non-parametric approaches to optimal policy are more robust





































Abstract
=======================================================================


Introduction
=======================================================================


Most management recommendations from the ecological literature are based
on (or at least motivated by) parametric models. Though in principle
these models reflect mechanistic underpinnings of biological interactions
involved, in practice real mechanisms are often unknown and the true
dynamics too complex to be captured by simple models [@refs]. While
simple mechanistic models can nevertheless provide important insights
into possible dynamics -- for instance, demonstrating that a vaccine
does not have to be 100% effective to eliminate the transmission of a
virus  -- such approaches are not well-suited for use in
forecasting outcomes of potential management options.  Non-parametric 
approaches offer a more flexible alternative that can both more accurately
reflect the data available while also representing greater uncertainty
in areas (of state-space) where data is lacking.  Ecological research
and management strategy should pay closer attention to the opportunities 
and challenges nonparametric modeling can offer.  


### Quantitative vs Qualitative Decisions

In this paper, we consider those ecological management problems in which
a mathematical (or computational) model is used to quantitatively inform
decision-making by allowing a manager to compare to the expected consequences
of potential management actions (or policies).  We distinguish this from the
solely qualitative use of a model, in which models are used to represent and
compare hypotheses of different mechanisms that would lead to qualitatively 
different actions. 

We argue that while simple mechanistically motivated models
may be best for the latter case [@Cuddington2013; @Geritz2012], such models 
can be not only inaccurate but misleading in quantitative decision making.
Nonparametric models can more realistically represent uncertainties outside 
of observed data while also better capturing the dynamics in the region
observed.  Advances in the theory and computational implementations of 
nonparametric methods make them ripe for such applications.  We use the classic
problem of optimal harvest of a marine fishery to illustrate how the 
nonparametric approach of Gaussian processes can be applied. 

We imagine the manager seeks to maximize some known socio-economic value function, 
given their knowledge of the system. 
In particular, we will focus on the case in which the manager faces a series of decisions,
such as setting a harvest quota for a marine fishery each year based on observations
of the stock size the year before.  


### Uncertainties: the classical approach

The ecological dynamics of most systems of management interest are
typically both complex and unknown [@refs].  Despite this, quantitative
policy optimization in these systems has almost exclusively been based
on simple, mechanistically motivated parametric models.  There are
several reasons for this.  First, limited available data almost always
precludes any accurate estimate of more complicated models.  Second, the
computational demands of determining an optimal strategy in a sequential
decision-theory problem suffer from the "curse of dimensionality"
that makes it difficult to consider more complicated models, states,
or actions.  Unfortunately, these challenges also make it particularly
difficult to reflect the true uncertainty either in the parameters of
the given models (parametric uncertainty) or in the structure of the
models themselves (structural uncertainty).  Further unknowns such as
measurement uncertainty, parameter uncertainty, unobserved states,
knowledge of boundary conditions, etc. further compound the issue.
Though a hierarchical Bayesian approach provides a natural way to
address these from a statistical standpoint, formulating reasonable
parametric  descriptions of each form of uncertainty is a challenging
task in itself, let alone the computational difficulties of solving such
a system. @Cressie2009 provides a good account of the successes and
challenges of the approach.  Applying these approaches in the management
context of sequential decision making, in which forecasts must be obtained
over a range of possible actions and updated regularly as new information
arrives makes such an approach less feasible still.


An active literature and growing computational power over the past several decades have
only marginally improved this situation.  Parametric or structural uncertainty
can be introduced only by increasing the state space to reflect a distribution
of possible parameters [@refs] or the degree of belief in each of a set of possible models [@refs]
Frequently, the space of possible actions must then be reduced or the algorithms adjusted
by approximations to keep computations feasible.  



<span style="color:#007FFF;"> ***This part is overstated and unnecessary***
Though machine learning approaches have begun to appear in the
ecological and conservation literature (e.g. in species distribution models),
including the Gaussian process based approach used here [@Munch2005],
overall machine learning remains an unfamiliar and somewhat untrusted approach for many ecologists.
One potential barrier to their adoption is the absence of a framework
for applying machine learning approaches to resource management problems. </span>

<span style="color:#007FFF;">***transition sentences!?***</span> 

Traditional approaches to optimal control (Pontryagin's principle, stochastic
dynamic programming) rely on knowledge of the state equation, usually described
by a simple parametric model. Here we illustrate how a stochastic dynamic
programming algorithm can alternatively be driven by the predictions from
a Gaussian process -- a machine learning approximation to the state dynamics.  

<span style="color:#007FFF;">***Okay, perhaps that's novel, but it's pretty trivial.  Isn't it
obvious to everyone that it's trivial?***</span>


<span style="color:#007FFF;">***paraphrase advantages of machine learning***</span>

Management goals / decision-theoretic approaches need accurate prediction
over relevant (short?) timescales more than reasonable long-term
mechanisms.  Machine-learning approaches may offer the benefit of the
hierarchical Bayesian approach without the practical and computational
limitations of their parametric kin.  Non-parametric models are flexible
enough to take maximum advantage of the data available, while being
appropriately ambiguous about the dynamics of a system in regions of
parameter space that have been poorly or never sampled.




Approach and Methods
=====================================================================

### The optimal control problem in fisheries management

In our example, we focus on the problem in which a manager must set 
the harvest level for a marine fishery each year to maximize the net
present value of the resource, given an estimated stock size from the year
before. Rich data and global concerns have made marine fisheries the crucible for much
of the founding work [@Gordon1954; @Reed1979; @May1979; @Ludwig1982]
in managing ecosystems under uncertainty.  Global trends [@Worm2006]
and controversy [@Hilborn2007; @Worm2009] have made understanding these
challenges all the more pressing. 

To permit comparisons against a theoretical optimum we will consider
data on the stock dynamics simulated from a simple parametric model
in which recruitment of the fish stock $X_{t+1}$ in the following year
is a stochastic process governed by a function $f$ of the current 
stock $X_t$, selected harvest policy $h_t$, and noise process $Z$,

$$X_{t+1} = Z_t f(X_t, h_t) $$


Given parameters for the function $f$ and probability distribution $Z$, 
along with a given economic model determining the  price/profit $\Pi(X_t, h_t)$
realized in a given year given a choice of harvest $h_t$ and observed stock $X_t$.
This problem can be solved exactly for discretized values of stock $X$ and policy $h$
using stochastic dynamic programming (SDP) [@Mangel1985]. Problems of this sort underpin much marine fisheries management today.  

A crux of this approach is correctly specifying the functional form of $f$,
along with its parameters.  The standard approach [@refs] uses one of a 
handful of common parametric models representing the stock-recruitment
relationship, usually after estimating the model parameters from any 
available existing data. Though modifications of this approach mentioned in the 
introduction can permit additional sources of uncertainty such as measurement 
error in the stock assessment, implementation errors in the harvest policy, [@Clark1986; @Roughgarden1996; @Sethi2005]
uncertainty in parameters [@Mangel1985; @Schapaugh2013] or model structure [@Williams2001; @Athanassoglou2012],
we focus on the simplest example to illustrate the comparison, where only a 
single form of uncertainty (the growth shocks $Z_t$) is present in the underlying
model, making additional modes unnecessary. 
<span style="color:#007FFF;">***Add comment / apology on single species dynamics?*** </span> 


We compare this approach to our alternative that uses a Gaussian Process (GP)
in place of the a given stock recruitment curve.  We briefly revisit
a description of the Gaussian Process approach that has appeared in 
recent literature before describing how we take the important step of 
adapting the GP to the decision theory problem that can still be solved
using SDP. 

### The Non-parametric Bayesian alternative for stock-recruitment curves

The use of Gaussian process (GP) regression (or "kreging" in the geospatial
literature) to formulate a predictive model is relatively new in the
context of modeling dynamical systems [@Kocijan2005] and introduced
in the ecological modeling and fisheries management by @Munch2005.
An accessible and thorough introduction to the formulation and use of
GPs can be found in @Rasmussen2006.

The essence of the GP approach can be captured in the
following thought experiment: An exhaustive parametric approach to the
challenge of structural uncertainty might proceed by writing down all
possible functional forms for the underlying dynamical system with all
possible parameter values for each form, and then consider searching
over this huge space to select the most likely model and parameters;
or using a Bayesian approach, assign priors to each of these possible
models and infer the posterior distribution of possible models. The
GP approach can be thought of as a computationally
efficient approximation to this approach. GPs represent
a large class of models that can be though of as capturing or reasonably
approximating the set of models in this collection.  By modeling at the
level of the process, rather than the level of parametric equation,
we can more concisely capture the possible behavior of these curves.
In place of a parametric model of the dynamical system, the GP 
approach postulates a prior distribution of (n-dimensional)
curves that can be though of as approximations to a range of possible
(parametric) models that might describe the data. The GP allows us
to consider a set of possible curves simultaneously.  
<span style="color:#007FFF;"> ***Figure 1 include curves drawn from the posterior density?*** </span>


<span style="color:#007FFF;">***Do we need more specifics on Gaussian process as an approximation
to parametric models? Discussion of Gaussian process vs other machine
learning / forecasting approaches that have less clear statistical
foundations?  If so, does this all belong in the discussion?***</span>


### Background on Gaussian Process inference

Once the posterior Gaussian process (GP) has been estimated [e.g. see
@Munch2005], it is necessary to adapt it in place of the parametric
equation for the stochastic dynamic programming (SDP) solution [see
@Mangel1988 for a detailed description of parametric SDP methods] to the
optimal policy. The essence of the idea is straight forward -- we will use
the estimated GP in place of the parametric growth function to determine
the stochastic transition matrix on which the SDP calculations are based.
The SDP is solved in a discretized state space -- both the continuously 
valued population densities $X$ and harvest quotas $h$ are first mapped to
a bounded, discrete grid.  (For simplicity we will consider a uniform grid,
though for either parametric or GP-based SDP it is often advantageous to 
use a non-uniform discretization such as a basis function representation,
e.g. see [@Deisenroth2009]). 

The SDP approach then computes a transition matrix, $\mathbf{F}$.  We 
demonstrate that calculation is just as straight forward based on the GP
as it is in the classical context using the parametric model.  The 
${i,j}$ of the transition matrix $F$ entry gives the probability of transitioning into 
state $x_i$ given that the system is in state $x_j$ in the previous 
time-step.  To generate the transition
matrix based on the posterior GP, we need only the expected values
at each grid point and the corresponding variances (the diagonal of
the covariance matrix), as shown in Figure 1.  Given the mean of the 
GP posterior at each grid-point as the vector $E$ and variance at that
point as vector $V$, the probability of transitioning from state $x_i$ to state $x_j$ is

$$\mathcal{N}\left(x_j | \mu = E_i, \sigma = \sqrt{V_i}\right)$$

where $\mathcal{N}$ is the Normal density at $x_j$ with mean $\mu$ and
variance $\sigma^2$.  Strictly speaking, the transition probability should
be calculated by integrating the normal density over the bin of width
$\Delta$ centered at $x_j$.  For a sufficiently fine grid that $f(x_j)
\approx f(x_j + \Delta)$, it is sufficient to calculate the density at
$x_j$ and then row-normalize the transition matrix. The process
can then be repeated for each possible discrete value of our control 
variable, (harvest $h$).  


**Pseudocode for the determining the transition matrix from the GP**

```r
for(h in h_grid)
  F_h = for(x_j in grid)
          for(i in 1:N) 
            dnorm(x_j, mu[i]-h, V[i])
```


Using the discrete transition matrix we may write down the Bellman
recursion defining the stochastic dynamic programming iteration:

\begin{equation}
V_t(x_t) = \max_h \mathbf{E} \left( h_t + \delta V_{t+1}( Z_{t+1} f(x_t - h_t)) \right)
\end{equation}

where $V(x_t)$ is the value of being at state $x$ at time $t$, $h$
is control (harvest level) chosen. Numerically, the maximization is
accomplished as follows. Consider the set of possible control values to
be the discrete values corresponding the grid of
stock sizes.  Then for each $h_t$ there is a corresponding transition
matrix $\mathbf{F}_h$ determined as described above but with mean 
$\mu = x_j - h_t$. Let $\vec{V_t}$ be the vector whose $i$th element corresponds
to the value of having stock $x_i$ at time $t$.  Then let $\Pi_h$ be
the vector whose $i$th element indicates the profit from harvesting
at intensity $h_t$ given a population $x_i$ (e.g. $\max(x_i, h_t)$
since one cannot harvest more fish then the current population size).
Then the Bellman recursion can be given in matrix form as

$$V_{t} = \max_h \left( \Pi_{h_{t}} + \delta \mathbf{F}_h V_{t+1} \right)$$

where the sum is element by element and the expectation is computed by the matrix multiplication $\mathbf{F} V_{t+1}$.  

### Pseudocode for the Bellman iteration

```r
 V1 <- sapply(1:length(h_grid), function(h){
      delta * F[[h]] %*% V +  profit(x_grid, h_grid[h]) 
    })
    # find havest, h that gives the maximum value
    out <- sapply(1:gridsize, function(j){
      value <- max(V1[j,], na.rm = T) # each col is a diff h, max over these
      index <- which.max(V1[j,])  # store index so we can recover h's 
      c(value, index) # returns both profit value & index of optimal h.  
    })
    # Sets V[t+1] = max_h V[t] at each possible state value, x
    V <- out[1,]                        # The new value-to-go
    D[,OptTime-time+1] <- out[2,]       # The index positions
```

This completes the algorithm adapting the GP to the sequential decision-making 
problem through SDP, which we believe has not yet been demonstrated in the
literature.  We provide an R package implementation of this, along with
the Gaussian process inference, in the supplemental materials.  




## Example in a bistable system

Concerns over the potential for tipping points in ecological dynamics
[@Scheffer2001] highlight the dangers of uncertainty in ecological
management and pose a substantial challenge to existing decision-theoretic
approaches [@Brozovic2011].  Because intervention is often too late 
after a tipping point has been crossed (but see @Hughes2013), management
is most often concerned with avoiding potentially catostrophic tipping
points before any data is available at or following a transition that
would more clearly reveal these regime shift dynamics [e.g. @Bestelmeyer2012].

<!-- Explain the connection to alternative stable states -->

To illustrate the value of the non-parametric Bayesian approach to management,
we focus on example of a system containing such a tipping point whose dynamics
can still be described by a simple, one-dimensional parametric model.  
We will focus on a simple parametric model for a single species [derived
from fist principles by @Allen2005a] as our underlying "reality".

\begin{align}
X_{t+1} &= Z_t f(S_t) \\
S_t &= X_t - h_t \\
f(S_t) &= e^{r \left(1 - \frac{S_t}{K}\right)\left(S_t - C\right)}
\end{align}

Where $Z_t$ is multiplicative noise function with mean 1, representing
stochastic growth. We will consider log-normal noise with shape parameter
$\sigma_g$.  We start with an example in which the parameters are $r =$
2, $K =$ 10, $C =$ 5, and  $\sigma_g =$ 0.05.


As a low-dimensional system completely described by three parameters, this
scenario should if anything be favorable to a parametric-based approach.
This model contains an Allee effect, or tipping point, below which the
population is not self-sustaining and shrinks to zero [@Courchamp2008].


Both parametric and nonparametric approaches will require training
data on which to base their model of the process.  We generate the
training data under the model described in Eq 1 for 35 time
steps, under a known but not necessarily optimal sequence of harvest
intensities, $h_t$.  For simplicity we imagine a fishery that started
from zero harvest pressure and has been gradually increasing the harvest.




<!-- things that we could hit upon in discussion:
Using data simulated from a specified model rather than empirical data
permits the comparison against the true underlying dynamics, setting 
a bar for the optimal performance possible.  

(Motivation, alternatives, stationarity, examples without a stable node
(limit-cycle models), examples based on observations near a stable node
alone, and why that isn't impossible).
-->

<span style="color:#007FFF;">***Should we include any emprical examples?***</span>

### Estimating parametric models 

We estimate two parametric models from the data using a maximum likelihood
approach.  The first model is structurally identical to the true model
(Eq 1), differing only in that it's parameters are estimated from the
observed data rather than given.  The alternative model is the Ricker
model, which is structurally similar and commonly used in for such data.  

The maximum likelihood estimates (MLE) will assume that the process noise $Z_t$
is log-normal, as in the simulation itself.  In reality the noise structure might 
differ from this assumption, making this a best-case scenario for the MLE approach.  
The GP must also make an assumption about the noise structure -- in this case we 
assume additive noise, though multiplicative noise would be more accurate.  This
will illustrate the flexibility of the GP in fitting different noise structures
even without knowledge of the correct assumptions.  

The GP estimate is Bayesian approach which requires specification of
prior distributions for the hyper-parameters [see Appendix for details,
or @Rassmussen1996, @Munch2005 for background], as given in Table 1.
Then given the data, both the GP and the MLE parametric models can
be estimated as described above, as we implement in R in the code
provided in supplementary materials.  


Results
====================================================


Figure 1 shows the  inferred Gaussian Process compared to the true and the
MLE parametric models, predicting the relationship between observed stock
size (x-axis) to the stock size following recruitment the following year.
The gray shading shows the uncertainty estimated by the GP.  Unlike the
MLE estimates, the GP uncertainty changes depending on where the data is
available, allowing for a much greater level of uncertainty at low stock
sizes.  While it would be natural (and straight forward) to condition
the GP on passing through the origin (0,0) (see appendix), the estimate
shown here is based only on the observed data. The observed data from
which each model is estimated is also shown.  The observations come
from only a limited region of state space corresponding to unharvested
or weakly harvested system.  No observations occur at the theoretical
optimum (7.5 units, see Figure 2) or near the tipping point (5 units).

<!-- Would it be useful to show the uncertainty in the other models? -->

<!-- with (light grey) and without (darker grey) measurement error -->

![Graph of the inferred Gaussian process compared to the true process and maximum-likelihood estimated process.  Graph shows the expected value for the function $f$ under each model.  Two standard deviations from the estimated Gaussian process covariance (grey shading)  is also shown.  The training data is also shown as black points. ](figure/gp_plot.png) 



The resulting optimal management strategy based on each of the inferred
models is shown in Figure 2, against the optimal strategy given the
true underlying dynamics.  Policies are shown in terms of target
escapement, $S_t$.  Under models such as this a constant escapement
policy is expected to be optimal [@Reed1979], whereby population levels
below a certain size $S$ are unharvested, while above that size the harvest
strategy aims to return the population to $S$, resulting in the hockey-stick
shaped policies shown.  Only the GP policy deviates slightly from this.  The MLE parametric model
corresponding to parametric uncertainty alone (gold line labeled "Parametric", 
that is, using the same structural form as the underlying simulation) nevertheless overestimates 
the carrying capacity of the stock and therefore underestimates the harvest
rates, always waiting for the stock to rise further than is actually possible.
The Ricker model (green line, showing "Structural" inaccuracies) does not 
foresee the tipping point dynamics reflected in the concavity of the other three
models (Figure 1), and selects a much more aggressive harvesting strategy.  


![The steady-state optimal policy (infinite boundary) calculated under each model.  ](figure/policies_plot.png) 


The consequences of managing 100 replicate realizations of the 
simulated fishery under each of the policies estimated is shown in Figure 3.  As expected
from the policy curves, the structurally correct model ("Parametric" uncertainty, gold) 
underharvests, leaving the stock to vary around it's unfished optimum.  The GP overharvests
the population slightly relative to the optimal value.  The structurally
incorrect Ricker model ("Structural", green line) overharvests the population passed
the tipping point consistently, resulting in the immediate crash of the stock and 
thus derives minimal profits.  


***(may need to show harvest dynamics since
that is not clear from the figure! Also isn't general, sometimes does
optimally, sometimes over-fishes.  Perhaps need to show more examples.)
May need to show profits too?***

![Gaussian process inference outperforms parametric estimates. Shown are 100 replicate simulations of the stock dynamics (eq 1) under the policies derived from each of the estimated models, as well as the policy based on the exact underlying model.](figure/sim_plot.png) 



The results shown in Figures 1-3 are not unique to the simulated data or models chosen
here, but arises across a range of parameter values and simulations as shown in the 
supplemental figures.  The results across this range can most easily be compared 
by the relative differences in net present value realized by each of the approaches,
as shown in Figure 4.  The Gaussian Process most consistently realizes a value 
close to the optimal solution, and importantly avoids ever driving the system across
the tipping point, which results in the near-zero value cases in the parametric models.  

![Histograms of the realized net present value of the fishery over a range of simulated data and resulting parameter estimates. For each data set, the three models are estimated as described above. Values plotted are the averages of a given policy over 100 replicate simulations. Details and code provided in the supplement.](figure/figure4.png)

Discussion 
==================================================================


Non-parametric Bayesian methods have received far too little attention
in ecological modeling efforts that are aimed at improved conservation
planning and decision making support.  Such approaches may be particularly
useful when the available data is restricted to a limited area of
state-space, which can lead parametric models to underestimate the
uncertainty in dynamics at population levels (states) which have not
been observed.  One reason for the relative absence of nonparametric
approaches in the natural resource management context may be the lack
of existing approaches for adapting the non-parametric Bayesian models
previously proposed [@Munch2005] to a decision-theoretic framework.
Adapting a non-parametric approach requires modification of existing
methods for decision theory.  We have illustrated how this might be
done for a classic stochastic dynamic programming problem, opening the
door for substantial further research into how these applications might
be improved.


While non-parametric Bayesian approaches will not always be preferable 
to simple mechanistic models, we highlight three aspects of the problem
consider here that make these methods particularly valuable.  These aspects
are common to many conservation decision making problems, which thus merit
greater use of non-parametric machine learning approaches that can best 
take advantage of them.  

### 1. Large uncertainty where the data is poor 

The parametric models perform worst when they propose a management strategy
outside the range of the observed data. The non-parametric Bayesian approach, 
in contrast, allows a predictive model that expresses a great deal of uncertainty
about the probable dynamics outside the observed range, while retaining very
good predictive accuracy in the range observed.  The management policy 
dictated by the GP balance this uncertainty against
the immediate value of the harvest, and act to stabilize the population 
dynamics in a region of state space in which the predictions can be 
reliably reflected by the data.  


### 2. Predictive accuracy where data is good

While expressing larger uncertainty outside the observed data, the GP
can also provide a better fit with smaller uncertainty inside the range
of the observed data. This arises from the greater flexibility of the 
Gaussian process, which describes a large family of possible curves.  
While in a parametric context this over-fitting would be more worrisome --
a high-degree polynomial could fit the data even better -- those 
concerns are driven by the resulting parametric fit outside the data,
which may involve wild oscillations unsupported by the data.  As we 
have seen in #1, the GP is less vulnerable to such unjustified predictions
outside the data, and is meanwhile free to benefit from the greater 
fit where the data is available.  

<!--
<span style="color:#007FFF;"> ***wow, run-on tangent here?*** </span>
Predictive accuracy is not the goal of all modeling, as ecologists
have been observing for as long as they made models (perhaps none
more memorably than @Levins1969).  Mechanistic modeling is at its
most powerful not when it is used to directly forecast future states
but when it provides an understanding of how to approach a problem.
SIR-type models from the epidemiological literature are a good example.
While the simplest SIR models have little predictive power over the
outbreak intensity or timing at a particular location, they provide a
powerful understanding of the spread of an infection in terms of a single,
biologically meaningful parameter: $R_0$, the basic reproductive number.
From the model, it becomes clear that management need not vaccinate every
member of the population to stop the spread, but rather it suffices to
vaccinate a sufficient fraction of the population to reduce $R_0$ below 1.
-->


### 3. Time scale for new data 

In the sequential decision making problem we considered, we are
presented with new data after each action.  The relevant timescale
for the prediction is thus not the long-term dynamics, which would be
wildly divergent, but the dynamics over this much shorter interval.
While ecologists may be hesitant to base continual management on a model
with obviously inaccurate long-term behavior, engineers tend to consider
the problem in frequency space and gravitate to the opposite position --
a good control model should prioritize high-frequency accuracy over low
frequency accuracy.  The differences in intuition may arise from the
timescales at which each profession can typically adjust their control
variables -- much faster for a control system of a chemical plant than
state policy for a natural resource.  Still, the lesson is clear: when
facing repeated management decisions over a short timescale, such as
setting annual harvests of a fishery, it may be more valuable to use a
machine learning algorithm that makes accurate year-ahead predictions
that capture some of the high-frequency fluctuations that appear only
as noise in a mechanistic model of the long-term population dynamics.



## Future directions

<span style="color:#007FFF;"> Jargony and vague </span>
While we have highlighted certain generic of this problem that allow the
nonparametric approach to excel -- short timescales between successive
observations and actions, the accuracy in the appropriate region of state
space, the ability to express uncertainty outside the observed data --
there are equally several aspects for which the nonparametric Bayesian approach is
nevertheless at a relative disadvantage. In this simulated example, the underlying
dynamics are truly governed by a simple parametric model, allowing
the parametric approaches to be more accurate.  Similarly, because the
dynamics are  one-dimensional dynamics and lead to  stable nodes (rather
than other attractors such as limit-cycles resulting in oscillations),
the training data provides relatively limited information about the
dynamics.  For these reasons, we anticipate that in higher-dimensional
examples characteristic of ecosystem management problems that the machine
learning approach will prove even more valuable.

<span style="color:#007FFF;"> Data complexity. Perhaps too far out of scope... </span>
The nonparametric Bayesian approach is also better suited to complex and
disparate data.  Incorporating various sources of information into
mechanistic models can be an immensely difficult due to the increased
complexity involved.  Only thanks to tandem advances in increasing
computational power and hierarchical statistical methodology have we
been able to tackle such intuitively important complexity (and the
potentially new available data that accompanies it) such as spatial
distribution, heterogeneities of space, time, and individuals, to shift
to ecosystem-based approaches from single-species based approaches.
Without the need to formulate mechanisms, many modern machine learning
algorithms can leverage potential information from all available sources
of data directly.  The algorithms can recognize unanticipated or subtle
patterns in large data sets that enable more accurate predictions than
mechanistic models that are formulated at a more macroscopic level.



Acknowledgments
================

This work was partially supported by the Center for Stock Assessment Research, a partnership between the University of California Santa Cruz and the Fisheries Ecology Division, Southwest Fisheries Science Center, Santa Cruz, CA and by NSF grant EF-0924195 to MM.


<span style="color:#007FFF;"> 
***Possible additional discussion material?***

* Discuss constant escapement in model, in policies.
* Limitations of this comparison: Are the maximum-likelihood solutions
a straw man?
* Discussion of alternative related approaches: POMDP/MOMDP

* Online learning 
* Multiple step-ahead predictions 
* Explicitly accomidating additional uncertainties 
* Improving inference of optimal policy from the GP
</span> 

--------------------------------------------------------------------

Appendix / Supplementary Materials
==================================

### The Gaussian process

The Gaussian process is defined by a covariance kernel.  By requiring our kernel to follow a generic functional form, we can compactly describe the Gaussian process using only a handful of parameters (Table 1) 


parameter       interpretation
---------       -------------- 
$\sigma^2$      The process noise (from the kernel)
$\tau^2$        Variance around the mean
$\beta_0$       The mean is given by a linear model of slope $\beta$ 
$d$             The length-scale of the covariance function
$n$             The observation error

: Table of parameters for the Gaussian process

Rather than estimate values of these parameters directly, we take a hierarchical approach of placing prior distributions on each.  Following @Gramarcy2005 we use a Gaussian prior on $\beta_0$, an inverse gamma prior on $\sigma^2$ and $\tau^2$, a gamma prior on the observation noise $n$, and exponential prior on the length-scale $d$. 

###  Formulating a dynamic programming solution

The fishery management problem over an infinite time horizon can be stated as:

\begin{align}
& \max_{ \{h_t\} \geq 0 } \mathbf{E} \lbrace \sum_0^\infty \delta^t \Pi(h_t) \rbrace \\
& \mathrm{s.t.}  \\
 & X_t = Z_t f\left(S_{t-1}\right) \\
 & S_t = X_t - h_t \\
 & X_t  \geq 0 
\end{align}

Where $\mathbf{E}$ is the expectation operator, $\delta$ the discount
rate, $\Pi(h_t)$ the profit expected from a harvest of $h_t$, and other
terms as in Eq. (1).  For simplicity, we have assumed that profits depend
only on the chosen harvest; simplifying further we will usually consider
profits to be proportional to harvest, $\Pi(h_t) = h_t$.

Once the posterior Gaussian process (GP) has been estimated [e.g. see
@Munch2005], it is necessary to adapt it in place of the parametric
equation for the stochastic dynamic programming (SDP) solution [see
@Mangel1988 for a detailed description of parametric SDP methods] to the
optimal policy. The essense of the idea is straight forward -- we will use
the estimated GP in place of the parametric growth function to determine
the stochastic transition matrix on which the SDP calculations are based.

The posterior Gaussian process is completely defined by the expected value
and covariance matrix at a defined set of training points.  For simplicity
we will consider a these points to fall on a discrete, uniform grid $x$
of 101 points from 0 to 15
(1.5 times the positive equilibrium $K$).  Again to keep things simple
we will use this same grid discretization for the parametric approach.
Other options for choosing the grid points, including collocation methods
and functional basis expansion (or even using Gaussian processes in place
of the discrete optimization; an entirely different context in which GP
can be used in SDP, see [@Deisenroth2009]) could also be considered.

## Pseudocode for the determining the transtion matrix from the GP

```r
for(h in h_grid)
  F_h = for(x_j in grid)
          for(i in 1:N) 
            dnorm(x_j, mu[i]-h, V[i])
```


A transition matrix for each of the parametric models $f$ is calculated
using the log-normal density with mean $f(x_i)$ and log-variance as
estimated by maximum likelihood.  From the discrete transition matrix we
may write down the Bellman recursion defining the the stochastic dynamic
programming iteration:

\begin{equation}
V_t(x_t) = \max_h \mathbf{E} \left( h_t + \delta V_{t+1}( Z_{t+1} f(x_t - h_t)) \right)
\end{equation}

where $V(x_t)$ is the value of being at state $x$ at time $t$, $h$
is control (harvest level) chosen. Numerically, the maximization is
accomplished as follows. Consider the set of possible control values to
be the discrete 101 values corresponding the the grid of
stock sizes.  Then for each $h_t$ there is a corresponding transition
matrix $\mathbf{F}_h$ determined as described above but with mean 
$\mu = x_j - h_t$. Let $\vec{V_t}$ be the vector whose $i$th element corresponds
to the value of having stock $x_i$ at time $t$.  Then let $\Pi_h$ be
the vector whose $i$th element indicates the profit from harvesting
at intensity $h_t$ given a population $x_i$ (e.g. $\max(x_i, h_t)$
since one cannot harvest more fish then the current population size).
Then the Bellman recursion can be given in matrix form as

$$V_{t} = \max_h \left( \Pi_{h_{t}} + \delta \mathbf{F}_h V_{t+1} \right)$$

where the sum is element by element and the expectation is computed by the matrix multiplication $\mathbf{F} V_{t+1}$.  

### Pseudocode for the Bellman iteration

```r
 V1 <- sapply(1:length(h_grid), function(h){
      delta * F[[h]] %*% V +  profit(x_grid, h_grid[h]) 
    })
    # find havest, h that gives the maximum value
    out <- sapply(1:gridsize, function(j){
      value <- max(V1[j,], na.rm = T) # each col is a diff h, max over these
      index <- which.max(V1[j,])  # store index so we can recover h's 
      c(value, index) # returns both profit value & index of optimal h.  
    })
    # Sets V[t+1] = max_h V[t] at each possible state value, x
    V <- out[1,]                        # The new value-to-go
    D[,OptTime-time+1] <- out[2,]       # The index positions
```

_Currently this shows the literal R code, should be adapted_ 


MCMC posterior distributions and convergence analysis
----------------------------------------------------------------------------


***Can we get this figure into the main text with appropriate discussion without getting too technical?***

![Histogram of posterior distributions for the estimated Gaussian Process shown in Figure 1.  Prior distributions overlaid.](figure/posteriors.png) 

 
 @Gramacy2005
 
## Tables of nuisance parameters, sensitivity analysis

### List of hyper-parameters, prior distributions and their parameters

## Reproducible code, "Research Compendium"


