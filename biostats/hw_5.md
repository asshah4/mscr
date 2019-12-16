---
title: MSCR 500 Homework Assignment 5
author: Anish Shah
date: 11/05/19
---

  
# Q1.  
  
Random sample of 10 diabetic women.  
x-bar = 84 mmHg  
s = 9.1 mmHg  
Test if true DBP for female is > µ (µ = true mean DBP 74.4 mmHg)  
alpha = 0.05  
N(0,1)  
  
__Hypothesis__:   
  
H0 -> µ = xbar  
H1 -> µ < xbar (left tailed hypothesis)  
  
__Parameters__:  
  
population mean, sample mean  
  
__alpha__ = 0.05  
  
__Name of hypothesis test:__  
  
one-sample, left-tailed t-test  
  
__Justification__:  
  
The population follows a normal distribution but population SD is unknown (thus t is correct), and this is talking about a single sample population, with knowledge of the population mean given, but not the population SD. Also, n = 10, which is n < 15, but can use normal distribution since that   is given.
  
__Test Statistic Computation:__  
  
T = (xbar - µ) / (s / sqrt(n))  
= 84 - 74.4 / (9.1 / sqrt(10))  
= 3.336  
  
Distribution of test statistic under H0:  
  
T ~ t(9)  
  
__P-value computation:__  
  
t = 3.336, which with df = 9, gets us to a t(0.005) = 3.250. This suggests that P < 0.005 when T >= 3.3  
  
Decision to _REJECT_ H0 at alpha = 0.05  
  
_Conclusion:_  
  
alpha = 0.05, and P < 0.005. Since alpha > P, we can reject the H0. This means that the sample mean of DBP for diabetics is likely greater than 74.4.   
  
# Q2.  
  
xbar = 747.3 mg of calcium intake  
s = 262.2 mg  
alpha = 0.05  
µ = 800 mg  
n = 40  
  
__Hypothesis:__  
  
H0 --> µ = xbar   
H1 --> µ > xbar (right-tailed)  
  
__Parameters:__  
  
__alpha__ = 0.05  
  
__Name of hypothesis test:__  
  
one-sided, right-tailed t-test  
  
__Justification:__  
  
We have a n=40 population, allowing us to use normal distribution pattern, but population SD is unknown, thus must use t-distribution. Only single sample for comparison to population mean.  
  
__Test Statistic Computation:__  
  
T = (xbar - u) / (s / sqrt(n))  
= (747.3 - 800) / (262.2 / sqrt(40))  
= -1.2712  
  
__Distribution of test statistic under H0:__  
  
T ~ t(39)  
  
__P-value computation:__  
  
t = -1.2712 with df = 39.  
t(0.10) = -1.304  
p(t = -1.271) <= 0.10  
  
Decision to _FAIL TO REJECT_  H0 at alpha = 0.05  
  
__Conclusion:__  
  
We fail to reject the null, H0, at an alpha of 0.05. The mean calcium of the poor is not significantly less than the population mean of 800 mg calcium.   
  
# Q3.  
  
Random sample of 10 diabetic women.  
x-bar = 84 mmHg  
sigma = 9.1 mmHg  
Test if true DBP for female is > µ (µ = true mean DBP 74.4 mmHg)  
alpha = 0.05  
N(0,1)  
  
__Hypothesis__:   
  
H0 -> µ = xbar  
H1 -> µ < xbar (left tailed hypothesis)  
  
__Parameters__:  
  
population mean, sample mean  
  
__alpha__ = 0.05  
  
__Name of hypothesis test:__  
  
one-sample, left-tailed z-test  
  
__Justification__:  
  
The population follows a normal distribution and population SD is known (thus z is correct), and this is talking about a single sample population, with knowledge of the population mean given. We also know its a normal distribution, can use z-distribution.  
  
__Test Statistic Computation:__  
  
Z = (xbar - µ) / (sigma / sqrt(n))  
= 84 - 74.4 / (9.1 / sqrt(10))  
= 3.336 --> area under curve = 0.9996  
  
Distribution of test statistic under H0:  
  
X ~ N(u, (sigma/sqrt(n))^2)  
X ~ N(74.4, 8.281)  
  
__P-value computation:__  
  
P(Z >= 3.336) for left sided test = 1 - 0.9996 = 0.0004  
  
Decision to _REJECT_ H0 at alpha = 0.05  
  
_Conclusion:_  
  
alpha = 0.05, and P = 0.0004. Since p < alpha, we can reject the H0. This means that the sample mean of DBP for diabetics is likely greater than 74.4.   
  
# Q4.  
  
xbar = 747.3 mg of calcium intake  
sigma = 262.2 mg  
alpha = 0.05  
µ = 800 mg  
n = 40  
  
__Hypothesis:__  
  
H0 --> µ = xbar   
H1 --> µ > xbar (right-tailed)  
  
__Parameters:__  
  
__alpha__ = 0.05  
  
__Name of hypothesis test:__  
  
one-sided, right-tailed z-test  
  
__Justification:__  
  
We have a n=40 population, allowing us to use normal distribution pattern, and population SD is known, thus can use z-test.  
  
__Test Statistic Computation:__  
  
Z = (xbar - u) / (s / sqrt(n))  
= (747.3 - 800) / (262.2 / sqrt(40))  
= -1.2712  
  
__Distribution of test statistic under H0:__  
  
X ~ N(800, 1718.721)  
  
__P-value computation:__  
  
P(Z = -1.2712) = 0.1020  
  
Decision to _FAIL TO REJECT_ H0 at alpha = 0.05  
  
__Conclusion:__  
  
The P value associated with the Z score is 0.1020. alpha is < p, thus we cannot reject the null hypothesis, H0. We cannot exclude that the sample mean of calcium in the poor is less than the population mean of calcium.  
  
