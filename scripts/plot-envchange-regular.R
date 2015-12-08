#!/usr/bin/env Rscript

source('hankshaw.R')

d <- read.csv('../data/envchange-regular.csv.bz2')
d$Replicate <- as.factor(d$Replicate)

# Trajectory for single replicate ----------------------------------------------

data_rep <- d %>% filter(EnvChangeFrequency == 750) %>% filter(Replicate == 17)
changepoints <- expand.grid(EnvChangeFrequency=750, ChangeTime=seq(from=min(d$Time), to=max(d$Time), by=750))

prep <- ggplot(data=data_rep, aes(x=Time, y=CooperatorProportion)) +
    draw_50line() +
    geom_vline(data=changepoints, aes(xintercept=ChangeTime), color='grey70',  
               size=0.1, linetype='solid') + 
    geom_line() +
    scale_y_continuous(limits=c(0,1)) +
    labs(x=label_time, y=label_producer_proportion) +
    theme_hankshaw(base_size=fig2_base_size)
prep <- rescale_golden(plot = prep)

g <- ggplotGrob(prep)
g <- gtable_add_grob(g, textGrob(expression(bold("A")),
                                 gp=gpar(col='black', fontsize=20),
                                 x=0, hjust=0, vjust=0.5), t=1, l=2)

png('../figures/envchange-regular-rep.png', width=6, height=3.708204, units='in',
    res=figure_dpi)
grid.draw(g)
dev.off()
trim_file('../figures/envchange-regular-rep.png')

# Integral for different env change rates --------------------------------------

data_interval <- 1

presence <- d %>%
    filter(EnvChangeFrequency >= 100) %>%
    group_by(EnvChangeFrequency, Replicate) %>%
    summarise(Integral=data_interval*sum(CooperatorProportion)/(max(Time)-min(Time)))

breakpoints <- c(50,100,5000,1000,500, 250, 2000)
breaks <- 1/sort(breakpoints, decreasing = TRUE)
label_breaks <- sprintf('1/%d', sort(breakpoints, decreasing = TRUE))

figX <- ggplot(presence, aes(x=1/EnvChangeFrequency, y=Integral)) +
    stat_summary(fun.data='figsummary', size=point_size) +
    scale_y_continuous(limits=c(0,1)) +
    scale_x_log10(breaks=breaks, labels=label_breaks) +
#     scale_x_continuous(trans=log10_trans(),
#                        breaks=breaks,
#                        labels=label_breaks) +
    labs(x=label_envchange_freq, y=label_producer_presence) +
    theme_hankshaw(base_size=fig2_base_size)
figX <- rescale_golden(plot=figX)
ggsave_golden(filename = '../figures/envchange-regular-integral.png', plot = figX)


# All trajectories -------------------------------------------------------------
dsub <- filter(d, EnvChangeFrequency >= 250 & EnvChangeFrequency < 5000)
changemarkers <- data.frame()                                                   

for (r in unique(dsub$EnvChangeFrequency))                              
{                                                                               
    changemarkers <- rbind(changemarkers,                                       
                           expand.grid(EnvChangeFrequency=r,                    
                                       ChangeTime=seq(from=min(dsub$Time),
                                                      to=max(dsub$Time),
                                                      by=r)))                   
}


pall <- ggplot(data=dsub, aes(x=Time, y=CooperatorProportion, color=Replicate)) +
    facet_grid(EnvChangeFrequency ~ .) +
    draw_50line() +
    geom_vline(data=changemarkers, aes(xintercept=ChangeTime), color='grey70',  
               size=0.1, linetype='solid') +
    geom_line(size=0.2) +
    scale_y_continuous(breaks=c(0, 0.5, 1)) +
    scale_color_grey(guide=FALSE) +
    labs(x=label_time, y=label_producer_proportion) +
    theme_hankshaw(base_size = fig2_base_size) +
    theme(strip.text = element_text(size=rel(0.66), vjust=0.2, face='bold')) +
    theme(axis.text.y = element_text(size=rel(0.66), hjust=1))
#ggsave_golden(filename = '../figures/envchange-regular-all.png', plot = pall)

g <- ggplotGrob(pall)
g <- gtable_add_grob(g, textGrob(expression(bold("B")),
                                 gp=gpar(col='black', fontsize=20),
                                 x=0, hjust=0, vjust=0.5), t=1, l=2)

png('../figures/envchange-regular-all.png', width=6, height=3.708204, units='in',
    res=figure_dpi)
grid.draw(g)
dev.off()
trim_file('../figures/envchange-regular-all.png')
