#!/usr/bin/env Rscript

source('hankshaw.R')

d <- read.csv('../data/migration-topology.csv.bz2')
d$Topology <- factor(d$Topology,
                     levels=c("lattice", "r16", "r128", "complete", "single"),
                     labels=c("Lattice", "16\nRegular", "128\nRegular",
                              "Complete", "Well-Mixed\nPopulation"))

data_interval <- 1
mintegral <- d %>%
    group_by(Topology, Replicate) %>%
    summarise(Integral=data_interval * sum(CooperatorProportion)/(max(Time)-min(Time)))

p <- ggplot(data=mintegral, aes(x=Topology, y=Integral)) +                     
    draw_replicates() +
    stat_summary(fun.data='figsummary', size=0.8) +                           
    scale_y_continuous(limits=c(0, 1)) +                                        
    scale_color_hue(name="", guide=FALSE) +                                     
    labs(x=figlabels['topology'], y=figlabels['producer_presence']) +
    theme_hankshaw(base_size=textbase_1wide)                                       
p <- rescale_golden(plot = p)  

save_figure(filename='../figures/migration-topology.png', plot=p, trim=TRUE)

