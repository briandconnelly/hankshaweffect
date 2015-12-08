#!/usr/bin/env Rscript

source('hankshaw.R')

d <- read.csv('../data/spite-envchange.csv.bz2')
d$Replicate <- as.factor(d$Replicate)

# Trajectory for single replicate ----------------------------------------------
# Note: There's some invasion in replicate 5

data_rep <- d %>% filter(Replicate == 8)
changepoints <- expand.grid(EnvChangeFrequency=1000,
                            ChangeTime=seq(from=min(data_rep$Time),
                                           to=max(data_rep$Time), by=1000))

prep <- ggplot(data=data_rep, aes(x=Time, y=CooperatorProportion)) +
    draw_50line() +
    geom_vline(data=changepoints, aes(xintercept=ChangeTime), color='grey70',  
               size=0.1, linetype='solid') + 
    geom_line(size=0.8) +
    scale_y_continuous(limits=c(0,1)) +
    labs(x=label_time, y=label_spite_proportion) +
    theme_hankshaw(base_size = figS2_base_size)
prep <- rescale_golden(plot = prep)
prep
#ggsave_golden(filename = '../figures/spite-envchange-sample.png', plot = prep)

g <- ggplotGrob(prep)                                                         
g <- gtable_add_grob(g, textGrob(expression(bold("C")),                         
                                 gp=gpar(col='black', fontsize=20),             
                                 x=0, hjust=0, vjust=0.5), t=1, l=2)            

png('../figures/spite-envchange-sample.png', width=6, height=6, units='in',                  
    res=figure_dpi)                                                             
grid.draw(g)                                                                    
dev.off()                                                                       
trim_file("../figures/spite-envchange-sample.png")
