# Q1

Researched have simulations for smallpox. Graphs demonstrate the patterns of containment strategies.
A = surveillance and containment
B = Mass vaccination

## a. Mean number of cases for strategy A?

xbar = ∑xi / n
= 404/16 
= 25.25

## b. SD of strategy A?

Will use n instead of n-1 because we are considering this the entire population, and don't need to generalize (or bias the mean towards the sample mean).

s = sqrt( ∑(xi - xbar)^2 / n )

∑(xi^2-xbar)^2 = 4833, thus

s = sqrt(4833 / n)
s = 17.38

## c. Median for each strategy?
A = 21.5
B = 7

## d. Summarize the data and compare smallpox by strategy

The mean number of cases in strategy A is ~25, with a SD of ~17. The mean number of cases of strategy B is ~9, with a SD of ~7. The max number of cases is higher in A than B (56 versus 22), and there are overall much more cases in A than B (404 vs 147). Pick strategy B.

# Q2

Vaccination is recommended for teenagers, with second does 6-12 months after first dose. 5% get side effects after 1st dose, and 10% of that same group get side effects after 2nd dose. 80% who receive both doses experience no side effects after either.

This is a conditional probability question. 

_Tree diagram_

1st dose +SE 			P(1D) 		= 0.05
	2nd dose +SE 			P(2D) 	= 0.10
	2nd dose -SE 			P(2D') 	= 0.90
1st dose -SE 			P(1D') 		= 0.95
	2nd dose +SE 			P(2D) 	= 0.16
	2nd dose -SE 			P(2D') 	= 0.84

0.80 ...
0.80 = P(both doses = no SE) 
0.80 = P(1D' n 2D') 
0.80 = P(2D' | 1D') x P(1D')
0.80 = P(2D' | 1D') x 0.95 
0.84 = P(2D' | 1D')

Total probability should add to 1
1 = P(2D | 1D) + P(2D' | 1D) + P(2D | 1D') + P(2D' | 1D')
1 = 0.05 x 0.10 + 0.05 x 0.90 + 0.95 x 0.16 + 0.95 + 0.84
1 = 1

## a. Probability of 2nd dose causing SE after 1st dose with no SE?

This requires general multiplication rule and conditional probability

P(1D') = 0.95
P(2D | 1D') = 0.16

P(1D' n 2D) 
= P(2D | 1D') x P(1D')
= 0.16 x 0.95 
= 0.152

## b. Probability of 2nd dose causing side effects, regardless of dose 1?

This requires total probability theorem

P(2D)
= P(1D n 2D) + P(1D' n 2D)
= P(2D | 1D) x P(1D) + P(2D | 1D') x P(1D')
= 0.10 x 0.05 + 0.16 X 0.95
= 0.157

## c. Probability that side effects overall?

This requires the general addition rule

P(1D u 2D) = probability of either dose causing SE
= P(1D) + P(2D) - P(1D n 2D)
= P(1D) + P(2D) - P(2D | 1D) x P(1D)
= 0.05 + 0.157 - 0.10 x 0.05 
= 0.202 ~= 0.20 <- this makes sense, since 80% have no side effects, thus 20% have some side effects

# Q3

Rahza gets the flu, and makes contact with a susceptible person. Probability new person gets the flu is 0.01. Rahza contacts 17 independent people. 

This is a discrete binomial probability question..

n = 17
p = 0.01

## a. Probability that AT MOST 1 person gets sick?

n = 17
p = 0.01
k <= 1

P(X <= 1) = P(X = 1) + P(x = 0)
P(X = k) = nCk x p^k x (1-p)^(n-k)

P(X = 1) = 17C1 x 0.01^1 x 0.99^16
= 17 x 0.01 x 0.8515
= 0.1447

P(X = 0) = 17C0 x 0.01^0 x 0.99^17
= 1 x 1 x 0.8429
= 0.8429

P(X <= 1) = 0.8429 + 0.1447 = 0.9876

## b. Probability that AT LEAST 1 person becomes sick?

n = 17
p = 0.01
k >= 1

P(X >= 1) = P(X = 17) + (X = 16) ... P(X = 1)

This is computationally heavy. Likely there is an alternative using complements.

P(X >= 1) = 1 - P(X >= 1')
P(X >= 1') = P(X = 0) ...

P(X >= 1) = 1 - P(X = 0)
= 1 - 0.8429
= 0.1571


# Q4

Length of time between exposure to virus and appearance of symptoms is 72 hours, with SD of 12 hours. Follows normal distribution.

µ = 72
sigma = 12
N(72, 12^2)

## i. What is the probability that symptoms won't appear for 96 hours after exposure?

Z = 96 - µ / sigma = 2.0
Z = 0.9772

P(X >= 96) = area to the left of the Z-score on a normalized curve
= 1 - 0.9772 = .0228

##. How many hours before 99% chance that symptoms will appear?

Z = 2.33 <- score needed for 99%ile

X = Z x sigma + u
X = 2.33 x 12 + 72 = 99.96 hours


