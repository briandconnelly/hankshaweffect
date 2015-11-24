#!/usr/bin/env Rscript

library(magrittr)
library(dplyr)
library(ggplot2)
library(ggplot2bdc)
library(scales)

source('figsummary.R')
source('formatting.R')

d <- read.csv('../data/fitnessgamma.csv.bz2')
d$Replicate <- as.factor(d$Replicate)


# Fitness Curves ----------------------------------------------------------

base_fitness <- 1.0
benefit_nonzero <- 0.3
production_cost <- 0.1

fdata <- expand.grid(NumOnes=seq(0, 8), Coop=c(FALSE), Shape=unique(d$Shape))
fdata$Fitness <- base_fitness - (fdata$Coop * production_cost) + (benefit_nonzero * (fdata$NumOnes ^ fdata$Shape))

pshape <- ggplot(data=fdata, aes(x=NumOnes, y=Fitness, color=as.factor(Shape))) +
    geom_line() +
    scale_color_hue(name=label_gamma) +
    #scale_y_log10() +
    labs(x=label_numones, y=label_fitness) +
    theme_hankshaw(base_size = 17) +
    theme(legend.position=c(.5, 1.035), legend.justification=c(0.5, 0.5)) 
pshape <- rescale_golden(plot = pshape)
ggsave_golden(filename='../figures/fitnessgamma-gamma.png', plot=pshape)
#trim_file(f='../figures/fitnessgamma-gamma.png')

ggsave_golden(filename='../figures/fitnessgamma-gamma-log.png',
              plot=rescale_golden(plot = pshape + scale_y_log10()))

# Individual Trajectories -------------------------------------------------

ptraj <- ggplot(data=d, aes(x=Time, y=CooperatorProportion, color=Replicate)) +
    draw_50line() +
    facet_grid(Shape ~ .) +
    geom_line() +
    scale_y_continuous(limits=c(0,1), breaks=c(0, 0.5, 1)) +
    scale_color_grey(guide=FALSE) +
    labs(x=label_time, y=label_producer_proportion) +
    theme_hankshaw(base_size=17)
ggsave_golden(filename = '../figures/fitnessgamma-all.png', plot = ptraj)


# Cooperator Presence -----------------------------------------------------

data_interval <- 1

presence <- d %>%
    group_by(Shape, Replicate) %>%
    summarise(Integral=data_interval*sum(CooperatorProportion)/(max(Time)-min(Time)))

pint <- ggplot(data=presence, aes(x=Shape, y=Integral)) +
    stat_summary(fun.data='figsummary', size=point_size) +
    scale_y_continuous(limits=c(0, 1)) +
    labs(x=label_gamma, y=label_producer_presence) +
    theme_hankshaw(base_size = 17)
pint <- rescale_golden(plot=pint)
ggsave_golden(filename = '../figures/fitnessgamma-integral.png', plot = pint)
