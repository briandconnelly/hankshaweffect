#!/usr/bin/env Rscript

source('hankshaw.R')

d <- read.csv('../data/p0sweep.csv.bz2')
d$Replicate <- as.factor(d$Replicate)

# Plot cooperator presence as a function of initial cooperator proportion (after thinning)
data_interval <- 1
presence <- d %>%
    group_by(InitialCooperatorProp, Replicate) %>%
    arrange(Time) %>%
    summarise(Start=head(CooperatorProportion, n=1),
              Integral=data_interval * sum(CooperatorProportion)/(max(Time)-min(Time)))

pint <- ggplot(data=presence, aes(x=Start, y=Integral)) +
    geom_point(shape=1, alpha=0.33, color='black') +
    stat_smooth(method='loess') +
    scale_y_continuous(limits=c(0,1)) +
    scale_x_continuous(limits=c(0,1)) +
    labs(x=figlabels['producer_proportion_thin'],
         y=figlabels['producer_presence']) +
    theme_hankshaw(base_size = textbase_1wide)
pint <- rescale_golden(plot=pint)

save_figure(filename='../figures/p0sweep-integral.png', plot=pint,
            label=NA, trim=TRUE)

