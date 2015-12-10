#!/usr/bin/env Rscript

source('hankshaw.R')

# How often data were logged
data_interval <- 1

d <- read.csv('../data/csweep.csv.bz2') %>% filter(CooperationCost <= 0.5)
d$Replicate <- as.factor(d$Replicate)

presence <- d %>%
    group_by(CooperationCost, Replicate) %>%
    summarise(Integral=data_interval * sum(CooperatorProportion)/(max(Time)-min(Time)))

pint <- ggplot(data=presence, aes(x=CooperationCost, y=Integral)) +
    draw_replicates() +
    stat_summary(fun.data='figsummary', size=point_size) +
    scale_x_continuous(breaks=as.numeric(names(cost_labels)), labels=cost_labels) +
    scale_y_continuous(limits=c(0, 1)) +
    labs(x=figlabels['cost'], y=figlabels['producer_presence']) +
    theme_hankshaw(base_size=textbase_2wide)
pint <- rescale_golden(plot=pint)

save_figure(filename='../figures/costsweep-integral.png', plot=pint, label='D',
            trim=TRUE)
