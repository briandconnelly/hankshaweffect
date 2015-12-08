#!/usr/bin/env Rscript

source('hankshaw.R')

data_fig2a <- read.csv('../data/lsweep.csv.bz2') %>%
    filter(Structured == TRUE) %>%
    filter(GenomeLength %in% c(0,8))

data_fig2a$Replicate <- as.factor(data_fig2a$Replicate)

fig2afacets <- function(variable, value)
{
    return(sprintf('%d Adaptive Loci', value))
}

fig2a <- ggplot(data_fig2a, aes(x=Time, y=CooperatorProportion,
                                color=as.factor(GenomeLength),
                                fill=as.factor(GenomeLength))) +
    draw_50line() +
    stat_summary(fun.ymax='mean', geom='ribbon', ymin=0, alpha=1, color=NA) +
    stat_summary(fun.y='mean', geom='line', color='black') +
    facet_grid(GenomeLength ~ ., labeller=fig2afacets) +
    scale_color_manual(values=c('8'=color_L08, '0'=color_L00), guide=FALSE) +
    scale_fill_manual(values=c('8'=color_L08, '0'=color_L00), guide=FALSE) +
    scale_y_continuous(limits=c(0,1)) +
    labs(x=label_time, y=label_producer_proportion) +
    theme_hankshaw(base_size=fig2_base_size)
fig2a <- rescale_plot(plot=fig2a, ratio=(1 + sqrt(5)))

g <- ggplotGrob(fig2a)
g <- gtable_add_grob(g, textGrob(expression(bold("A")),
                                 gp=gpar(col='black', fontsize=20),
                                 x=0, hjust=0, vjust=0.5), t=1, l=2)

png('../figures/Figure2a.png', width=6, height=3.708204, units='in',
    res=figure_dpi)
grid.draw(g)
dev.off()
trim_file("../figures/Figure2a.png")
