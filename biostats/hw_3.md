__Problem 1__

Given:
X = {0:20} ... discrete random variable, non-uniform distribution.
Pr(X <= 17) = 0.2
Pr(X <= 18) = 0.3
Pr(X <= 19) = 0.35

The complements of this data:
Pr(X > 17) = 1 - Pr(X <= 17) = 0.8
Pr(X > 18) = 1 - Pr(X <= 18) = 0.7
Pr(X > 19) = 1 - Pr(X <= 19) = 0.65

A. 

Pr(X > 19) = 0.65 (as X can only be the number 20)

B.

Pr(X >= 19) = Pr(X > 18) = 0.7
This make sense because X can only be 19 or 20
We already know thee probability of being <= 18 is 0.3
Thus what is left must add up to 1.0

C. 

Pr(X < 19) ... probability of X being between 0 to 18, inclusive of 18
= Pr(X <= 18) = 0.3

D. 

Pr(18 <= X <= 19) ... this means X can be either 18 or 19

Possible probability windows for X:
Pr(X <= 17) = 0.2
Pr(X > 19) = 0.65

The only remaining sample space left is 18 and 19
The sum of the probabilities has to be = 1

Pr(18 <= X <= 19) 
= 1 - Pr(X <= 17) - Pr(X > 19)
= 1 - 0.2 - 0.65
= 0.15

__Problem 2__

9.8% of 18-24 year olds = left handed... this is binomial random variable

P(X <= 2) is the question (since it is "<= 2 individuals")

Population = 18-24 year odls
	n = 10
	p = 0.098
	k = {0 - 2} # This satisfies the "at most two individuals" comment
	nCk = n! / k!(n-k)!
	P(X = k) = nCk x p^k x (1-p)^(n-k)

X ~ B(10, 0.098)

	P(X = 2) = [10C2] x 0.098^2 x (0.902)^(8)
	nCk = 10! / 2!(8)! = 10 * 9 / 2 = 45
	P(X = 2) = 45 x 0.009604 x 0.43818 = 0.1894

	P(X = 1) = [10C1] x 0.098^1 x (0.902)^(9)
	nCk = 10! / 1!(9)!
	P(X = 1) = 10 x 0.098 x 0.3952 = 0.3873

	P(X = 0) = [10C0] x 0.098^0 x (0.902)^(10)
	nCk = 10! / 0!(10)!
	P(X = 0) = 1 x 1 x = 0.3565

Cumulative probability, thus needs additions
P(X <= 2) = 0.9332

__Problem 3__

A. Probability of getting flu is 0.01 with vaccine. Number of trials is 100. Yes, this could be a binomial variable (either get the flu, or not).

B. Population of 10. Selecting 5 kids total, but no replacement. They answer a question correctly or not is a binary, however each student has a different probability of answering the question correctly (e.g. could have studied, could have cheated, etc). Thus, the success of each trial is not the same. 

__Problem 4__

Probability of test of being positive for HIV is 0.005
Population is 140 people
Test can be positive or not, with same chance each trial

A. 

X ~ B(140, 0.005)... justified above why this is a binomial random variable

B. 

Pr(X > 0) = 1 - Pr(X <= 0) 

Since there can't be negative people... Pr(X <= 0) = Pr(X = 0)

n = 140
p = 0.005
k = 0
nCk = 140! / 0!(140-0)! = 140!/140! = 1

P(X = 0) = nCk x p^k x (1-p)^(n-k)
	= 140C0 x 0.005^0 x (0.995)^(140)
	= 1 x 1 x 0.4957
	= 0.4957

Pr(X > 0) = 1 - 0.4957 = 0.5043
