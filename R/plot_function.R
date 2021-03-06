#' @import ggplot2
NULL

#' Plots a Heat Map of Near Repeat results based on p-values
#'
#' @param knox_object     a knox object, i.e. the result of a 'NearRepeat()' funtion call
#' @param pvalue_range    the range of p-values that will be colored as "significant",
#'                        default = c(0, .05)
#' @param text            labels of cells, default is "knox_ratio". Possible values are
#'                        "observed", "knox_ratio", "knox_ratio_median", "pvalues", or NA
#' @param minimum_perc    The minimum percentage of increased Knox value that will be highlighted.
#'                        Default is 20% (or a Knox ratio of >= 1.2), as per the recommendations
#'                        of Ratcliffe (2009). If parameter text equals "pvalues" or NA,
#'                        the p-values alone determine highlighting, irrespective of the Knox (median)
#'                        ratios.
#' @return                a heat map based on p-values (generated by ggplot2)
#' @examples
#'
#' # Generate example data. Suppose x and y refer to meters distance.
#' set.seed(10)
#' (mydata <- data.frame(x = sample(x = 20, size = 20, replace = TRUE) * 20,
#'                      y = sample(x = 20, size = 20, replace = TRUE) * 20,
#'                      date = as.Date(sort(sample(20, size = 20, replace = TRUE)), origin = "2018-01-01")
#'                      ))
#'
#' # The plot() function can be used to plot a Heat Map of Near Repeat results based on p-values
#' set.seed(4622)
#' myoutput <- NearRepeat(x = mydata$x, y = mydata$y, time = mydata$date,
#'                        sds = c(0,100,200,300,400), td = c(0,1,2,3,4,5))
#' plot(myoutput)
#'
#' # The default range of p-values that will be highlighted (0-.05) can be adjusted using
#' # the 'pvalue_range' parameter. By default the Knox ratios are printed in the cells,
#' # but this can be adjusted using the 'text' parameter. The default is "knox_ratio".
#' # Possible values are "observed", "knox_ratio", "knox_ratio_median", "pvalues", or NA.
#' # For more information, see vignette("NearRepeat")
#'
#' plot(myoutput, pvalue_range = c(0, .1), text = "observed")
#' plot(myoutput, pvalue_range = c(0, .1), text = "pvalues")
#'
#' @export
plot.knox <- function(knox_object, pvalue_range = c(0, .05), text = "knox_ratio", minimum_perc = 20){

  ggplot.df <- data.frame(knox_object$pvalues)

  ggplot.df$observed <- as.vector(knox_object$observed)
  ggplot.df$knox_ratio <- as.vector(knox_object$knox_ratio)
  ggplot.df$knox_ratio_median <- as.vector(knox_object$knox_ratio_median)
  ggplot.df$pvalues <- ggplot.df$Freq

  if(!is.na(text)){
    if (text == "knox_ratio" | text == "knox_ratio_median"){
      ggplot.df$pvalues[ggplot.df[, text] < (100 + minimum_perc)/100] <- NA
    }
  }

  ggplot.df$Var1 <- factor(ggplot.df$Var1, levels = rev(levels(ggplot.df$Var1)))

  myplot <- ggplot(data = ggplot.df, aes(x=Var2, y=Var1, fill=pvalues)) +
                   geom_tile(colour = "black") +
                   scale_fill_gradient2(low = "darkred", high = "khaki1", mid = "orangered",
                                        limit = pvalue_range, na.value = "white",
                                        name = "p-value") +
                   theme_minimal() +
                   theme(axis.text.x = element_text(angle = 45, hjust = .2, vjust = .9)) +
                   coord_fixed() +
                   xlab("Temporal distance") +
                   ylab("Spatial distance") +
                   scale_x_discrete(position = "top")

  if(!is.na(text)) myplot <- myplot + geom_text(aes(label = round(get(text), 2)))

  return(myplot)
}

