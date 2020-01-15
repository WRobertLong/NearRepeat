
x <- matrix(c(1,2,3,4,5,6,7,8,9,10), ncol = 2)
x <- matrix(c(10,9,8,7,6,5,4,3,2,1), ncol = 2)
x <- matrix(rnorm(10), ncol = 2)
dist(x, "manhattan")
dist(x, "euclidean")


x <- matrix(c(1,2,3,90,80,70), ncol = 2)

x <- matrix(c(1,1,2,2,3,3), byrow = TRUE, ncol = 2)

x <- matrix(c(3,3,2,2,4,4,5,5), byrow = TRUE, ncol = 2)

#
# R code to implement dist() function, ultimately to be re-written in C
#
