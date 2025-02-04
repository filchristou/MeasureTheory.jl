# Bernoulli distribution

export Bernoulli
import Base

@parameterized Bernoulli()

@kwstruct Bernoulli()

@kwstruct Bernoulli(p)

@kwstruct Bernoulli(logitp)

Bernoulli(p) = Bernoulli((p = p,))

basemeasure(::Bernoulli) = CountingMeasure()

testvalue(::Bernoulli) = true

insupport(::Bernoulli, x) = x == true || x == false

@inline function logdensity_def(d::Bernoulli{(:p,)}, y)
    p = d.p
    y == true ? log(p) : log1p(-p)
end

function density_def(::Bernoulli{()}, y)
    return 0.5
end

@inline function logdensity_def(d::Bernoulli{()}, y)
    return -logtwo
end

function density_def(d::Bernoulli{(:p,)}, y)
    p = d.p
    return 2 * p * y - p - y + 1
end

@inline function logdensity_def(d::Bernoulli{(:logitp,)}, y)
    x = d.logitp
    return y * x - log1pexp(x)
end

function density_def(d::Bernoulli{(:logitp,)}, y)
    exp_x = exp(d.logitp)
    return exp_x^y / (1 + exp_x)
end

gentype(::Bernoulli) = Bool

Base.rand(rng::AbstractRNG, T::Type, d::Bernoulli{()}) = rand(rng, T) < one(T) / 2

Base.rand(rng::AbstractRNG, T::Type, d::Bernoulli{(:p,)}) = rand(rng, T) < d.p

function Base.rand(rng::AbstractRNG, T::Type, d::Bernoulli{(:logitp,)})
    rand(rng, T) < logistic(d.logitp)
end

asparams(::Type{<:Bernoulli}, ::StaticSymbol{:p}) = as𝕀
asparams(::Type{<:Bernoulli}, ::StaticSymbol{:logitp}) = asℝ

proxy(d::Bernoulli{(:p,)}) = Dists.Bernoulli(d.p)
proxy(d::Bernoulli{(:logitp,)}) = Dists.Bernoulli(logistic(d.logitp))
