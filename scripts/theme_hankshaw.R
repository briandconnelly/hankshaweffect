# Theme for ggplot2

theme_hankshaw <- function (base_size=12, base_family="", grid.x=FALSE,
                            grid.y=FALSE, ticks.x=TRUE, ticks.y=TRUE)
{
    theme(complete=TRUE,
          line = element_line(colour="grey70", size=0.5, linetype=1,
                              lineend="square"),
          rect= element_rect(fill="white", colour="grey70", size=0.5,
                             linetype=1),
          text = element_text(family=base_family, face="plain",
                              colour="black", size=base_size, hjust=0.5,
                              vjust=0.5, angle=0, lineheight=0.9),
          title = element_text(family=base_family, face="bold", colour="black",
                               vjust=0.0, hjust=0.5, angle=0),
          
          plot.background = element_rect(fill="transparent", colour=NA),
          plot.title = element_text(size=rel(1.2), vjust=0.8),
          plot.margin = grid::unit(c(1, 1, 1, 1), "lines"),
          
          panel.background = element_rect(fill="white", colour=NA),
          panel.border = element_rect(fill="transparent"),
          panel.grid.major = element_line(color=NA, size=0.1),
          panel.grid.major.x = element_line(color=ifelse(grid.x, "grey90", NA)),
          panel.grid.major.y = element_line(color=ifelse(grid.y, "grey90", NA)),
          panel.grid.minor = element_line(color=NA), 
          panel.margin = grid::unit(0.5, "lines"),
          
          strip.background = element_rect(fill="grey90", colour=NA),
          strip.text = element_text(size=rel(0.8)),
          strip.text.x = element_text(),
          strip.text.y = element_text(angle=-90),
          
          axis.text = element_text(size=rel(0.8)),
          axis.line = element_line(color=NA),
          axis.text.x = element_text(), 
          axis.text.y = element_text(hjust=1),
          axis.title.x = element_text(),
          axis.title.y = element_text(angle=90, vjust=1), 
          axis.ticks.x = element_line(size=ifelse(ticks.x, 0.3, 0)), 
          axis.ticks.y = element_line(size=ifelse(ticks.y, 0.3, 0)), 
          axis.ticks.length = grid::unit(0.15, "cm"),
          axis.ticks.margin = grid::unit(0.1, "cm"),
          
          legend.background = element_rect(fill="transparent", colour=NA), 
          legend.margin = grid::unit(0, "cm"),
          legend.key = element_rect(fill="transparent", color=NA),
          legend.key.size = grid::unit(0.5, "lines"), 
          legend.key.height = grid::unit(0.5, "lines"),
          legend.key.width = grid::unit(1.3, "lines"),
          legend.text = element_text(size=rel(0.66), colour="grey40"),
          legend.text.align = 0.5,
          legend.title = element_text(size=rel(0.7)),
          legend.title.align = 0,
          legend.position = c(.5, 1.035),
          legend.direction = "horizontal",
          legend.justification = c(0.5, 0.5),
          legend.box = "horizontal"
          )
}

