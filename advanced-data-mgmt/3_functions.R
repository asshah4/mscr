#!/usr/bin/env Rscript

# Add two numbers using "mouth" of the + function
'+'(1,1) # Should equal 2

# Write a function called add5 that adds five to a single number.
add5 <- 
	function(x) {
		x + 5
	}

# Write a function that takes two arguments a vector and a single number and returns the element of the vector corresponding to that number. Call it pick_n.
pick_n <- 
	function(x, y) {
		x[y]
	}

# Write a function that computes the two values that solve  a quadratic equation of the form, ax2+bx+c=0. The values as you may recall are called roots are given by the following formula that you’ve probably not seen since high school:
# You can compute the square root with sqrt(). R only returns the last object… how can you return “two” things at once? (Hint: use one of the data types you already know.)
quad <-
	function(a, b, c) {
		x <- (-b + sqrt(b^2 - 4*a*c)) / (2*a)
		y <- (-b - sqrt(b^2 - 4*a*c)) / (2*a)
		c(x,y)
	}

# Try to write a function that returns a function. Here is a suggestion. Write a function that takes a single number as an argument and returns a function that adds that number to its argument. Remember you can save the output of a function like anything else. So, your function, if it were called add_factory, would work like this:
singlefn <- function(x) {x}
doublefn <- 
	function(y) {
		2*singlefn(y)
	}

