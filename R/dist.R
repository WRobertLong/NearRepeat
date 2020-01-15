#
# Robert Long  15 Jan 2020
# R code to implement dist() function, to be re-written in C
#
# Function receives a matrix consisting of 2 columns where
# Each row is a point in 2D space
# Function returns a lower triangular matrix of distances
# between all points
#
# data matrix = x
# store result in a vector of length n * (n - 1) / 2 for conversion
# to lower triangular later = dd
# current row of data matrix = m
#
# 
# Algorithm:
# 
# loop over columns of the LT matrix we will create (index i)
#   then loop over rows of rows of x (index m)
# compute distance from m to m + i and store in dd

x <- matrix(c(1,1,2,2,3,3,4,4,5,5), byrow = TRUE, ncol = 2)

n <- nrow(x)

dd <- numeric(n * (n - 1) / 2)

j <- 1

for ( i in 1:(n-1) ) {
  for ( m in i:(n-1) ) {
    # loop over rows
    #i <- 1
    # calc distance to 
    
    dd[j] <- sqrt((x[m + 1, 1] - x[i, 1])^2 + (x[m + 1, 2] - x[i, 2])^2)
    j <- j + 1
  }
}

# test
vdist <- as.vector(dist(x, "euclidean"))
all.equal(vdist, dd )
