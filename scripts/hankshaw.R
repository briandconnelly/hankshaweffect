library(dplyr)
library(magrittr)
library(ggplot2)
library(ggplot2bdc)
library(gtable)
library(scales)

source('formatting.R')
source('figsummary.R')

trim_file <- function(f) system(sprintf("convert -trim '%s' '%s'", f, f))
trim_pdf <- function(f) system(sprintf("pdfcrop '%s' '%s'", f, f))

save_figure_png <- function(filename, plot, label=NA, trim=TRUE)
{
    g <- ggplotGrob(plot)
    if (!is.na(label))
    {
        g <- gtable_add_grob(g, textGrob(expression(bold(label)),
                                         gp=gpar(col='black', fontsize=20),
                                         x=0, hjust=0, vjust=0.5), t=1, l=2)
    }
    png(filename=filename, width=6, height=6, units='in', res=figure_dpi)
    grid.draw(g)
    dev.off()
    if (trim) trim_file(f=filename)
}

