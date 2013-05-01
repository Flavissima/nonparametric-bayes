## Introductory examples in approximate dynamic programming










### Alogorithm 1 

Based on Powell 2006, page 97.  



```r
f <- function(x, h, p){
    A <- p[1] 
    B <- p[2] 
    s <- pmax(x-h, 0)
    A * s/(1 + B * s)
}
pars <- c(1.5, 0.05)
K <- (pars[1] - 1)/pars[2]
```


We begin with a simulation method $X_{t+1} = f(X_t, Z_t)$.  For illustration, let us consider $f(X_t, Z_t) = Z_t \frac{a X_t}{b + X_t}$ with a = 1.5 and b = 0.05.  We define a statespace $S$



```r
S <- seq(0, 1, length=10) 
```


as a uniform grid of 10 points from 0 to 1.  We also need a value function on the state space, $C_t(S_t)$. For simplicity, we set the price of harvest at unity and the cost of harvesting at zero, so that $C_t(S_t, x_t) = \min(x_t, S_t)$.  
($C_t$ is sometimes denoted $\mathbb{\Pi}$).  We also need an action space $\chi_t$ of possible harvest values.  Again for simplicity we assume that harvest can be set to any possible state size, $\chi_t \equiv S_t$,


```r
chi <- S
```





```r
T <- 10
N <- 10
```


The approximate dynamic programming algorithm will perform a finite number $N$ = 10 iterations over a window of time $T$ =10 in our example.  The algorithm can be described as follows: 


- **Step 0**
  - Initialize some $\tilde V_t^0(S_t)$ for all states $S_t$ 
  where the superscripts denote iterations in the forward approximation.  As we know absolutely nothing yet to base our initial guess on, we just arbitrarily set this to zero.  


```r
V <- numeric(length(S))
```

  
  - Choose some initial state $S_0^1$
  We start at some initial state for $n = 1$ (superscript) and $t = 0$ (subscript). The choice of initial condition may come from the problem itself, otherwise we choose something arbitrarily.  


```r
S_0 <- 0.5
```


  - Set $n = 1$

- **Step 1**: Choose a sample path, $\omega^n$


```r
sigma <- 0.2
Z <- rlnorm(T, 0, sigma)
```


- ** Step 2**: For $t = 0, 1, 2, \ldots, T$, do:

  - Solve:

$$V_t(S_t) = \max_{x_t \in \chi_t} \left(C(S_t, x_t) + \gamma \sum_{s^{\prime} \in mathcal{S}} \mathbb{P}(s^{\prime} | S_t^n, x_t) V_{t+1}^{n-1} s^{\prime} \right)$$

Let's start with $t=0$, $n=1$ and fix an $x_0$ from the set of $\chi$ (allowing the action space to be the same in each period, we can omit the subscript on $\chi$) to get started.  We first compute $C(S_0, x_0)$. $S_0 = S_0^1$ which we fixed in step 0b arbitrarily at 0.5.  Taking $x_0$ as the smallest harvest, $\min(\chi)$ = 0 and evaluating $C(S_0,X_0) = \min(S_0, X_0)$ gives us 0, rather trivially.  

The next terms depend on the value $\tilde V^0_1(s^{\prime})$ for all $s^{\prime} \in S$, which we have no idea about.  Fortunately we have assumed a value for each of these in step 0a.  

We must also come up with some values for the probability $\mathbb{P}(s^{\prime} | S_1^0, x_1)$ for each state, given our current state $S_1^0$ and considered action $x_1$.  This is more straight forward, since it is determined by our one-step transition function (without simulation - recall that the single step transition is given exactly).   


```r
require(pdgControl)
F <- determine_SDP_matrix(f, pars, S, chi, sigma)
```



To do so, we evaluate the argument for each value in our action space, $x_t \in \chi_t$,

```r
s <- S_0
C <- function(S, X) pmin(S, X)

sapply(0:T, function(t){
  max(
    arg <- sapply(chi, function(x){
      C(s, x) + 
      f_matrix[
    c(x.n_t = which.max(arg), v.n_t = max(arg)) 
    
```
