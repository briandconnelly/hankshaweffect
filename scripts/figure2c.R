#!/usr/bin/env Rscript

source('hankshaw.R')

# How often data were logged
data_interval <- 1

data_fig2c <- read.csv('../data/bsweep.csv.bz2')
data_fig2c$Replicate <- as.factor(data_fig2c$Replicate)

data_fig2c_integral <- data_fig2c %>%
    group_by(CooperationBenefit, Replicate) %>%
    summarise(Integral=data_interval * sum(CooperatorProportion)/(max(Time)-min(Time)))

fig2c <- ggplot(data_fig2c_integral, aes(x=as.factor(CooperationBenefit), y=Integral)) +
    draw_replicates() +
    stat_summary(fun.data='figsummary', size=point_size) +
    scale_x_discrete(breaks=unique(data_fig2c_integral$CooperationBenefit),
                     labels=label_benefits) +
    scale_y_continuous(limits=c(0, 1)) +
    labs(x=figlabels['benefit'], y=figlabels['producer_presence']) +
    theme_hankshaw(base_size=textbase_2wide) +
    theme(axis.text.x = element_text(size=rel(0.9)))
fig2c <- rescale_golden(plot=fig2c)

save_figure(filename='../figures/Figure2c.png', plot=fig2c, label='C',
            trim=TRUE)

