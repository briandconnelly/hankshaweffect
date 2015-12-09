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
    labs(x=figlabels['time'], y=figlabels['producer_proportion']) +
    theme_hankshaw(base_size=textbase_2wide)
fig2a <- rescale_plot(plot=fig2a, ratio=(1 + sqrt(5)))

save_figure(filename='../figures/Figure2a.png', plot=fig2a, label='A',
            trim=TRUE)

