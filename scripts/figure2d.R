#!/usr/bin/env Rscript

source('hankshaw.R')

# How often data were logged
data_interval <- 1

data_fig2d <- read.csv('../data/csweep.csv.bz2') %>% filter(CooperationCost <= 0.5)
data_fig2d$Replicate <- as.factor(data_fig2d$Replicate)

data_fig2d_integral <- data_fig2d %>%
    group_by(CooperationCost, Replicate) %>%
    summarise(Integral=data_interval * sum(CooperatorProportion)/(max(Time)-min(Time)))

fig2d <- ggplot(data_fig2d_integral, aes(x=CooperationCost, y=Integral)) +
    draw_replicates() +
    stat_summary(fun.data='figsummary', size=point_size) +
    scale_x_continuous(breaks=as.numeric(names(cost_labels)), labels=cost_labels) +
    scale_y_continuous(limits=c(0, 1)) +
    labs(x=label_cost, y=label_producer_presence) +
    theme_hankshaw(base_size=fig2_base_size)
fig2d <- rescale_golden(plot=fig2d)

g <- ggplotGrob(fig2d)
g <- gtable_add_grob(g, textGrob(expression(bold('D')),
                                 gp=gpar(col='black', fontsize=20),
                                 x=0, hjust=0, vjust=0.5), t=1, l=2)

png('../figures/Figure2d.png', width=6, height=3.708204, units='in',
    res=figure_dpi)
grid.draw(g)
dev.off()
trim_file("../figures/Figure2d.png")
