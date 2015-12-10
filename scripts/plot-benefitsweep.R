#!/usr/bin/env Rscript

source('hankshaw.R')

# How often data were logged
data_interval <- 1

d <- read.csv('../data/bsweep.csv.bz2')
d$Replicate <- as.factor(d$Replicate)

presence <- d %>%
    group_by(CooperationBenefit, Replicate) %>%
    summarise(Integral=data_interval * sum(CooperatorProportion)/(max(Time)-min(Time)))

pint <- ggplot(data=presence, aes(x=as.factor(CooperationBenefit), y=Integral)) +
    draw_replicates() +
    stat_summary(fun.data='figsummary', size=point_size) +
    scale_x_discrete(breaks=unique(data=presence$CooperationBenefit),
                     labels=label_benefits) +
    scale_y_continuous(limits=c(0, 1)) +
    labs(x=figlabels['benefit'], y=figlabels['producer_presence']) +
    theme_hankshaw(base_size=textbase_2wide) +
    theme(axis.text.x = element_text(size=rel(0.9)))
pint <- rescale_golden(plot=pint)

save_figure(filename='../figures/benefitsweep-integral.png', plot=pint,
            label='C', trim=TRUE)

