# include <stdio.h>
# include <stdlib.h>
# include <math.h>

void print_data(size_t m, size_t n, int array[][m]) { 
    int i, j; 
    for (i = 0; i < n; i++) 
      for (j = 0; j < m; j++) 
		  printf("%d ", array[i][j]); 
}

int main() { 

    int n = 20, c = 2, i, j, m, dd_len ;
    float *dd ;
	int data[n][c] ;
	
	for ( i = 0; i < n ; i++) {
	  data[i][0] = i + 1 ; 
	  data[i][1] = i + 1 ; 
	}
	
	print_data(n, c, data) ;
		
	dd_len = n * (n - 1) / 2 ;
	dd = malloc( dd_len * sizeof(float)) ;
		
	j = 0 ;
	
	for ( i = 0; i < (n - 1); i++ ) {
		// loop across columns of what will be the lower triangular matrix
    
		for ( m = i; m < (n - 1); m++ ){
			// loop over rows of the data
			// note the initial value of the inner loop counter
			dd[j] = sqrt(pow((data[m+1][0] - data[i][0]), 2) +  pow((data[m+1][1] - data[i][1]), 2)) ;
			j++ ;
		}  
	}
	
	//print the distance matrix as a vector
	for ( i = 0; i < j ; i++)
		printf("%f ", dd[i]); 
	
	free(dd) ;
	
   return 0; 
} 
