MSCR 500 Quiz / Midterm  
Anish Shah  
10/25/19  

# Q1 - Read the NEJM article and answer the following questions.  
  
a) B  
b) A  
c) A  
d) B <- This question has an answer dependent on how smoking is considered. Does former exist in between never and current? That is debatable and thus could be either nominal or ordinal. As such, would disqualify this question with two reasonable answers.  
e) B  
f) FALSE  
  
# Q2 - Arizona Chapter of American Lung Association  
  
7% of population has lung disease, with 10% as non-smokers  
Of those without lung disease, 74.7% are non-smokers  
  
A = person has lung disease  
B = person is not smoker  
  
Tree diagram  
  
Has lung disease 			P(A) 		= 0.07  
	Nonsmoker 					P(B) 	= 0.10  
	Smoker 						P(B') 	= 0.90  
Does not have lung disease 	P(A') 		= 0.93  
	Nonsmoker 					P(B)  	= 0.747  
	Smoker 						P(B') 	= 0.253  
  
a) Probability of lung disease?  
  
P(A) = 0.07 <- this is because 7% of all patients have lung disease  
  
b) P(B | A)? What is the probability that B occurs given A?  
  
P(B | A) = 0.10  
  
c) P(B | A')?  
  
P(B | A') = 0.747  
  
d) Probability that person has lung disease AND is non-smoker?  
  
P(A n B) = P(B | A) x P(A)   
= 0.10 x 0.07  
= 0.007  
  
e) Probability that person has no lung disease AND is a non-smoker?  
  
P(A' n B) = P(B | A') x P(A')  
= 0.747 x 0.93  
= 0.6947  
  
f) Probability that person is a non-smoker?  
  
P(B) = P(A n B) + P(A' n B)  
= P(B | A) x P(A) + P(B | A') x P(A')  
= 0.10 x 0.07 + 0.747 x 0.93  
= 0.007 + 0.69471  
= 0.70  
  
# Q3 - Newspaper column advice on prengancy  
  
a) Probability of carrying time for pregnancy of 310 days?  
  
u = 266  
sigma = 16  
N(266, 16^2)  
  
Z = 310 - 266 / 16 = 2.75  
Z = 0.9970  
  
P( X >= 310) = area right of Z score on normalized curve  
= 1 - 0.9970   
= 0.003  
  
b) Is this pregnant lady "in a lot of trouble?"  
  
The SD is 16, and the mean is 266. Her carrying length is 310, which is within 3 SD of the mean (seen by the z-score of 2.75). Traditionally, most data is within 3 SD of the mean. Her score matches this. However, this is the very upper limit, with her chances of being in this population being 0.3%. She is "in trouble", unless there is strong evidence towards a longer gestation period (e.g. large birthweight, low amniotic fluid space), that helps to support this hypothesis.  
  
# Q4 - Nationwide radiation levels  
  
Known to be normally distributed  
u = 0.4 rem  
sigma = 0.05 rem  
N(0.4, 0.05^2)  
  
a) What is the 95%ile of background radiation?  
  
Z = 1.96 <- score needed for 95%ile  
X = Z x sigma + u  
X = 1.96 x 0.05 + 0.4  
X = .498  
  
Background radiation at 95%ile is 0.498 rem.  
  
b) Radiation measured at 100 locations around Brightglow plant. Find 95% CI for true average radiation level near Brightglow.  
  
xbar = 0.42 rem  
s = 0.05 rem <- Do not know sigma, so must use T-distribution.  
df = 99  
t = 1.984 <- for t of 0.025, represents 95%  
  
CI = xbar ± t(alpha/2) x s/sqrt(n)  
= 0.42 ± 1.984 x 0.05/sqrt(100)  
  
95% CI = (0.4101, 0.4299)  
  
c) Should alerts be issued?  
  
No, the confidence interval is lower than the 95%ile of background radiation than the upper limit of the 95% confidence interval for Brightglow town e.g. 0.498 > 0.4299, thus no alert is needed.   
  
(However, the question remains is if we want to base this off of the regional / sample 95% confidence interval, or if we want a higher confidence interval. That is more of a contextual question on how radiation safety protocols, etc. Personally, I might want background radiation levels that are even lower.)  
  
