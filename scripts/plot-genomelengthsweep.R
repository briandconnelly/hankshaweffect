#!/usr/bin/env Rscript

source('hankshaw')

# How often data were logged
data_interval <- 1

d <- read.csv('../data/lsweep.csv.bz2') %>%
    filter(Structured == TRUE)

# Plot cooperator proportion over time for L=0 and L=8 -----------------------

# TODO

#save_figure(filename='../figures/genomelengthsweep-sample', plot=pX,
#            label='A', trim=TRUE)


# Plot cooperator presence for different genome lengths ----------------------
presence <- d %>%
    group_by(GenomeLength, Replicate) %>%
    summarise(Integral=data_interval * sum(CooperatorProportion)/(max(Time)-min(Time)))

presence$GenomeLength <- as.factor(presence$GenomeLength)

pint <- ggplot(data=presence, aes(x=GenomeLength, y=Integral,
                                   color=GenomeLength)) +
    draw_replicates() +
    stat_summary(fun.data='figsummary', size=point_size, color='black') +
    stat_summary(fun.y='mean', geom='point', size=3.3) +
    scale_color_manual(values=c('0'=color_L00, '1'='black', '2'='black',
                                '3'='black', '4'='black', '5'='black',
                                '6'='black', '7'='black', '8'=color_L08,
                                '9'='black', '10'='black'), guide=FALSE) +
    scale_x_discrete(breaks=unique(presence$GenomeLength),
                     labels=label_genomelengths) +
    scale_y_continuous(limits=c(0, 1)) +
    labs(x=figlabels['genome_length'], y=figlabels['producer_presence']) +
    theme_hankshaw(base_size=textbase_2wide)
pint <- rescale_golden(plot=pint)

save_figure(filename='../figures/genomelengthsweep-integral.png', plot=pint,
            label='B', trim=TRUE)
