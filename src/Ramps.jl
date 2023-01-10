module Ramps

export Ramp, MultiRamp, evaluate

struct Ramp
    x₀::Float64
    x₁::Float64
    t₀::Float64
    t₁::Float64

    # checks
    function Ramp(x₀, x₁, t₀, t₁)
        t₁ ≤ t₀ && error("t₁ must be > t₀")

        return new(x₀, x₁, t₀, t₁)
    end
end

struct MultiRamp
    ramps::Vector{Ramp}

    function MultiRamp(ramps::Vector{Ramp})
        # check suitability of ramps
        x₀ = ramps[1].x₀
        t₀ = ramps[1].t₀
        for (idx, ramp) in enumerate(ramps)
            # joining ramps must be equal e.g. ramps[1].x₁ == ramps[2].x₀
            x₀ ≠ ramp.x₀ && error("the start value of ramp $idx ($(ramp.x₀)) == end value of the previous ramp ($x₀)")

            # ramps must ascend e.g. ramps[1].t₁ ≤ ramps[2].t₀
            ramp.t₀ < t₀ && error("the t₀ of ramp $idx ($(ramp.t₀)) must be ≥ t₁ of previous ramp ($t₀)")

            x₀ = ramp.x₁
            t₀ = ramp.t₁
        end

        return new(ramps)
    end
end

## polynomial with desired properties
f(x) = x^3 * (6x^2 - 15x + 10)
fp(x) = x^2 * (30x^2 - 60x + 30)
fpp(x) = x * (120x^2 - 180x + 60)


## ramp function scaled to domain and range
function evaluate(x₀, x₁, t₀, t₁, t, n=0)
    # scale domain
    x = (t - t₀) / (t₁ - t₀)

    # choose derivative
    if n == 0
        return t < t₀ ? x₀ : t₀ ≤ t ≤ t₁ ? x₀ + (x₁ - x₀) * f(x) : t > t₁ ? x₁ : error("t = $t not a number?")
    elseif n == 1
        return t < t₀ ? 0.0 : t₀ ≤ t ≤ t₁ ? (x₁ - x₀) / (t₁ - t₀) * fp(x) : t > t₁ ? 0.0 : error("t = $t not a number?")
    elseif n == 2
        return t < t₀ ? 0.0 : t₀ ≤ t ≤ t₁ ? (x₁ - x₀) / (t₁ - t₀)^2 * fpp(x) : t > t₁ ? 0.0 : error("t = $t not a number?")
    else
        error("higher derivatives not implemented yet")
    end

end

evaluate(r::Ramp, t, n=0) = evaluate(r.x₀, r.x₁, r.t₀, r.t₁, t, n)

function evaluate(r::MultiRamp, t, n=0)
    x₀ = r.ramps[1].x₀
    t₀ = r.ramps[1].t₁

    for ramp in r.ramps
        t ≤ ramp.t₁ && return evaluate(ramp, t, n)
        x₀ = ramp.x₁
        t₀ = ramp.t₁
    end

    return evaluate(r.ramps[end], t, n)
end

end