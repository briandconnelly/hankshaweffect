#!/usr/bin/env Rscript

source('hankshaw.R')

d <- read.csv('../data/thinnothin.csv.bz2')
d$Replicate <- as.factor(d$Replicate)


# Plot average cooperator proportion over time ---------------------------------

d8 <- d %>% filter(GenomeLength == 8)
pX <- ggplot(data=d8, aes(x=Time, y=CooperatorProportion, color=InitialThinning,
                         fill=InitialThinning, linetype=InitialThinning)) +
    draw_50line() +
    stat_summary(fun.data='figsummary', geom='ribbon', color=NA, alpha=0.2) + 
    stat_summary(fun.y='mean', geom='line') +
    scale_y_continuous(limits=c(0,1)) +
    scale_linetype_manual(values=c('FALSE'='solid', 'TRUE'='dashed'),
                          labels=c('FALSE'=figlabels[['without_stress']],
                                   'TRUE'=figlabels[['with_stress']]),
                          name='') +
    scale_color_manual(values=c('FALSE'='grey70', 'TRUE'='grey20'),
                       labels=c('FALSE'=figlabels[['without_stress']],
                                'TRUE'=figlabels[['with_stress']]),
                       name='') +
    scale_fill_manual(values=c('FALSE'='grey70', 'TRUE'='grey20'),
                      labels=c('FALSE'=figlabels[['without_stress']],
                               'TRUE'=figlabels[['with_stress']]),
                      name='', guide=FALSE) +
    labs(x=figlabels['time'], y=figlabels['producer_proportion']) +
    theme_hankshaw(base_size = textbase_2wide) +
    theme(legend.position=c(.5, 1.035), legend.justification=c(0.5, 0.5)) +
    theme(legend.text = element_text(size=rel(0.66), colour="grey40"))
pX <- rescale_golden(plot=pX)

save_figure(filename = "../figures/thinnothin.png", plot = pX, label='A',
            trim=TRUE)


# Plot cooperator presence ------------------------------------------------

data_interval <- 1

presence <- d %>%
    group_by(GenomeLength, InitialThinning, Replicate) %>%
    summarise(Integral=data_interval*sum(CooperatorProportion)/(max(Time)-min(Time)))

pint <- ggplot(data=presence, aes(x=GenomeLength, y=Integral,
                                  shape=InitialThinning,
                                  color=InitialThinning)) +
    draw_replicates() +
    stat_summary(fun.data='figsummary', size=point_size) +
    scale_y_continuous(limits=c(0,1)) +
    scale_x_continuous(breaks=unique(presence$GenomeLength),
                       labels=label_genomelengths) +
    scale_color_manual(values=c('FALSE'='grey70', 'TRUE'='black'),
                       labels=c('FALSE'=figlabels[['without_stress']],
                                'TRUE'=figlabels[['with_stress']]),
                       name='') +
    scale_shape_manual(values=c('FALSE'=15, 'TRUE'=16),
                       labels=c('FALSE'=figlabels[['without_stress']],
                                'TRUE'=figlabels[['with_stress']]),
                       name='') +
    labs(x=figlabels['genome_length'], y=figlabels['producer_presence']) +
    theme_hankshaw(base_size=textbase_2wide) +
    theme(legend.position=c(.5, 1.035), legend.justification=c(0.5, 0.5)) +
    theme(legend.text = element_text(size=rel(0.66), colour="grey40"))
pint <- rescale_golden(plot=pint)

save_figure(filename = "../figures/thinnothin-integral.png", plot = pint,
            label='B', trim=TRUE)
