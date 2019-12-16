# Homework Assignment 4  
  
1. Area under normal curve (-1.03, 1.85), in Z ~ N(0,1)  
  
This requires the Z-tables and the normal probability distribution  
z = -1.03 --> 0.8485 (on the positive side of the curve), requires reflection along y-axis  
z = 1.85 -> 0.9678  
  
Area = z(-1.03) <= Z <= z(1.85)  
z(1.85) - z(0) = 0.9678 - 0.5000 = 0.4678  
z(-1.03) - z(0) = 0.8485 - 0.5000 = 0.3485  
  
Area = 0.4678 + 0.3485 = 0.8163  
Assuming z-bar follows a normal distribution..  
P(-1.03 < Z < 1.85) = Area under the curve = 0.8163 = probability of Z   
  
2. Serum cholesterol follow normal distribution.  
mean = 175 mg per 100 ml  
SD = 30 mg per 100 ml  
  
Proportion of kids c- cholesterol within 2 SD x mean?  
  
X ~ N(u, sigma^2/n)  
  
First need to z-normalize the scores  
Z = x - u / SD  
Zupper = 235 - 175 / 30 = 2  
Zlower = 115 - 175 / 30 = -2  
  
P(-2 < Z < 2) = (0.9772 - 0.500) + (0.9772 - 0.500) = 0.9544  
  
3. 20% of a US city believe Nicaragua is in Africa. What is the probability that >= 200 of next 1000 people randomly sample (same city) believes that Nicaragua is located in Africa?  
  
This is a question of probability. The potential events are BELIEVE or NOT BELIEVE, within each individual. The individual events are independent, with the same probability (0.2) per trial. This follows a binomial discrete variable distribution, however the numbers are so large that we cannot use a calculator   easily.
  
n = 1000  
k = 200  
p = 0.2  
  
u = n x p = 200  
sigma = sqrt(n x p x (1-p)) = 12.6491  
  
This problem asks for probability AT LEAST 200 believe in Africa  
  
z = k - u / sigma = 200 - 200 / 12.6491 = 0  
  
P(X >= 200) = 50%  
  
4. Describe distribution of sample mean, unless it can't be determined. Give mean and SD of sample mean as well.  
  
a. Cholesterol measured in CCU, normally distributed  
n = 9  
u = 250  
sigma = 21  
  
X-bar ~ N(u, sigma^2/n) (as it is normal distributed)  
X-bar ~ N(250, 49)  
  
b. Cholesterol of random patients in CCU, unknown distribution  
n = 9 ... small population, cannot assume normal distribution  
u = 250  
sigma = 21  
  
Cannot determine sample distribution due to small size, CTL doesn't apply.  
ux = u = 250  
sigmax = sigma/sqrt(n) = 21/3 = 7  
  
c. Cholesterol for patients in CCU, unknown distribution  
n = 49 (large enough for normal distribution by CTL)  
u = 250  
sigma = 21  
  
X-bar ~ N(250, 9)  
  
d. Cholesterol for random sample of CCU, non-normal distribution  
n = 49  
u = 250  
sigma = 21  
  
We can apply CTL anyways, because it doesn't care about original distribution.  
  
X-bar ~ N(250, 9)  
  
5. Redo question number 4, and calculate probabilities that sample mean of cholesterol will be between 250 and 260 (when possible).  
  
a. Normal distribution, use Z scores  
  
Zlower = 250 - u / sigma = 0.0  
Zupper = 260 - u / sigma = 0.4762  
  
P(250 < X < 260) = 0.6808 - 0.5 = 0.1808  
  
b. Non-normal distribution, small size, cannot use either Z or T scores  
  
c. Normal distribution by CTL, and sigma known  
  
Zlower = 0.0  
Zupper = 0.4762   
P(250 < X < 260) = 0.1808  
  
d. Normal distribution by CTL, sigma known  
  
P(250 < X < 260) = 0.1808  
  
6. Researchers studies sugar in third trimester. Find 95% CI.  
n = 52  
x-bar = 70.12  
sigma = 10  
  
CI = X-bar ± zalpha x sigma/sqrt(n)  
= 70.12 ± z(95/2) x 10/sqrt(52)  
= 70.12 ± 0.6808 x 1.3868  
= 70.12 ± 0.9441  
  
95% CI = (69.1759, 71.0641)  
  
In this sample of pregnant women, using a normal distribution as the population mean glucose is known, we are 95% confident that the mean of sugars lies within our reported CI.   
  
7. Investigators looked at morning plasma citrate concentrations. Known to follow normal distribution. Find 95% CI.  
n = 10  
x-bar = 118.5  
sigma = 20.8  
  
95% CI = (114.022, 122.978)  
  
8. Maternity ward records for low SES. True SD known. Unknown distribution. Find 99% CI for true mean.  
n = 900 babies in low SES  
x-bar = 115  
sigma = 24  
  
99% CI = (114.4497, 115.5503)  
  
9. Pregnant women with sugars, but unknown sigma. Will need T distribution instead.  
n = 52  
x-bar = 70.12  
s = 10  
df = 51  
  
95% CI = (67.3354, 72.9046)  
  
10. Investigators looked at morning plasma citrate concentrations. Sample follows normal distribution.   
n = 10  
x-bar = 118.5  
s = 20.8  
df = 9  
  
95% CI = (103.6216, 133.3784)   
  
11. Maternity ward records for low SES. 99% CI?  
n = 900 babies in low SES  
x-bar = 115  
s = 24  
df = 899  
  
99% CI = (112.9352, 117.0648)  
