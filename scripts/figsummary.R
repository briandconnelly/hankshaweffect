# Summary statistics used in figures
# - This is a wrapper for ggplot::mean_cl_boot, which itself uses
#   Hmisc::smean.cl.boot, that clips values in the range [0,1] so that ribbons
#   on plots whose axes are limited to that range aren't broken
# - 95% confidence intervals are estimated by bootstrapping with 1000 resamples

figsummary <- function(x, ...)
{
    v <- mean_cl_boot(x, B=1000, ...)
    v$ymin[v$ymin < 0] <- 0
    v$ymax[v$ymax > 1] <- 1
    v
}
