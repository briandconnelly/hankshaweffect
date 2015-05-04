#!/usr/bin/env Rscript

library(magrittr)
library(dplyr)
library(ggplot2)
library(ggplot2bdc)
library(scales)
library(gtable)

source('formatting.R')
source('figsummary.R')

data_fig3b <- read.csv('../data/figure3.csv')

# How often data were logged
data_interval <- 10

data_fig3b_integral <- data_fig3b %>%                                                             
    filter(Time <= integral_maxtime) %>%
    group_by(EnvChangeFreq, Replicate) %>%                                      
    summarise(Integral=data_interval * sum(ProducerProportion)/(max(Time)-min(Time)))    

breaks <- 1/c(78, 156, 312, 625, 1250, 2500, 5000)
label_breaks <- c('1/78', '1/156', '1/312', '1/625', '1/1250', '1/2500', '1/5000')

# Version that plots the frequency
fig3b <- ggplot(data_fig3b_integral, aes(x=1/EnvChangeFreq, y=Integral)) +
    #geom_point(shape=1, alpha=replicate_alpha) +
    stat_summary(fun.data='figsummary') +
    scale_y_continuous(limits=c(0,1)) +
    scale_x_continuous(trans=log2_trans(),
                       breaks=breaks,
                       labels=label_breaks) +
    labs(x=label_envchange_freq, y=label_producer_presence)
fig3b <- rescale_golden(plot=fig3b)

g <- ggplotGrob(fig3b)
g <- gtable_add_grob(g, textGrob(expression(bold("B")), gp=gpar(col='black', fontsize=20), x=0, hjust=0, vjust=0.5), t=1, l=2)

png('../figures/Figure3b.png', width=6, height=3.708204, units='in', res=figure_dpi)
grid.newpage()
grid.draw(g)
dev.off()


# Time Series Plot -------------------------------------------------------------

change_points <- data.frame()

for(p in sort(unique(data_fig3b$EnvChangeFreq)))                                       
{                                                                               
    times <- seq(from=0, to=max(data_fig3b$Time), by=p)                                
    newdata <- data.frame(EnvChangeFreq=rep(p, length(times)), TimeStep=times)  
    change_points <- rbind(change_points, newdata)                              
}

figX_time <- ggplot(data_fig3b, aes(x=Time, y=MeanProducerProportion, group=Replicate)) +           
    geom_vline(data=change_points, aes(xintercept=TimeStep), alpha=0.1, size=0.1) +
    geom_hline(yintercept=0.5, linetype='dotted', size=0.5, color='grey70', size=0.1) +
    geom_line(alpha=0.3, color='#3B51A0') +                                     
    facet_grid(EnvChangeFreq ~ .) +                                             
    scale_y_continuous(limits=c(0,1), breaks=c(0, 0.5, 1)) +                    
    labs(x='Time', y='Producer Proportion') +                                   
    theme_bdc_paneled(grid.y=FALSE) + theme(axis.text.y=element_text(size=8))
ggsave(plot=figX_time, '../figures/Supp Periodic Change: Cooperator Proportion over Time.png', width=6, dpi=figure_dpi)

# Plot for just the 1000 data
data_1000 <- filter(data_fig3b, EnvChangeFreq==1000)
cp_1000 <- filter(change_points, EnvChangeFreq==1000)
figX_time1000 <- ggplot(data_1000, aes(x=Time, y=MeanProducerProportion, group=Replicate)) +           
    geom_vline(data=cp_1000, aes(xintercept=TimeStep), color='grey70', size=0.1) +
    geom_hline(yintercept=0.5, linetype='dotted', size=0.5, color='grey70', size=0.1) +
    geom_line(alpha=0.1, color='#3B51A0') +                                     
    labs(x='Time', y='Producer Proportion') +                                   
    theme_bdc_grey()
rescale_golden(figX_time1000)
ggsave(plot=fig3_time, '../figures/Supp Periodic Change Every 1000: Cooperator Proportion over Time.png', width=6, dpi=figure_dpi)

