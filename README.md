# Ramps.jl

## Overview
Exports the `Ramp` type which, when evaluated, smoothly ramp up from one level to another over a specified time, with zero first and second derivatives at endpoints, `MultiRamp` type which chains together multiple ramps, and `evaluate` to evaluate the ramp, or its derivative, at any given time.

## Maths
Solve system of equations to determine coefficients for a quintic polynomial (chosen so that the second derivative is a cubic) so that the quintic polynomial $x(t)$ gives $x(0) = 0$, $x(1) = 1$, $x'(0) = 0$, $x'(1) = 0$, $x''(0) = 0$, and $x''(1) = 0$. Resulting polynomial is then scaled for any range $(x_0, x_1)$ and any domain $(t_0,t_1)$. If $t < t_0$ then $x(t) = x_0$ and if $t > t_1$ then $x(t) = x_1$

## Installation
```julia
  pkg> add Ramps
```

## Example usage
```julia
using Ramps

# create a ramp from 0 to 10 from 0 to 2
r = Ramp(0,10,0,2)

# evaluate ramp at start, middle, and end
evaluate(r, 0) == 0
evaluate(r, 1) == 5
evaluate(r, 2) == 10

# evaluate first and second derivative at start and end (third arguement is the derivative, default = 0)
evaluate(r, 0, 1) == 0
evaluate(r, 2, 2) == 0

# evaluate out of domain of ramp
evaluate(r, -100) == 0
evaluate(r, 100, 2) == 0

# create multiple ramps - must ensure ramps begin one after the other and start value is same as previous end value
r1 = Ramp(0, 10, 2, 4)
r2 = Ramp(10, 2, 5, 6)
mr = MultiRamp([r1,r2]) # will check ramps

# evaluate
evaluate(mr, 0) == 0
evaluate(mr, 2.3) ≈ 0.2661187...
evaluate(mr, 4.5) == 10
evaluate(mr, 4.5, 2) == 0
evaluate(mr, 5.7) ≈ 3.30464...
evaluate(mr, 6) == 2
evaluate(mr, 100) == 2
evaluate(mr, 100, 2) == 0

```

