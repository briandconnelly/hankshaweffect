# Figure formatting: theme, axis labels, and helper functions

source('theme_hankshaw.R')
ggplot2::theme_set(theme_hankshaw())
#draw_replicates <- function() ggplot2::geom_point(shape=1, alpha=replicate_alpha, color='black')
draw_replicates <- function() NULL
#draw_50line <- function() ggplot2::geom_hline(yintercept=0.5, linetype='dotted', size=0.5, color='grey70', size=0.1)
draw_50line <- function() NULL

figure_dpi <- 600
point_size <- 0.8
max_time <- 2000

textbase_1wide <- 14
textbase_2wide <- 14
textbase_3wide <- 17

figlabels = c('time'='Time',
              'producer_proportion'='Cooperator Proportion',
              'producer_proportion_thin'='Cooperator Proportion After Initial Thinning',
              'producer_presence'='Cooperator Presence',
              'spite_proportion'='Proportion of\nSpiteful Individuals',
              'spite_presence'='Presence of\nSpiteful Individuals',
              'genome_length'='Number of Adaptive Loci',
              'migration_rate' = 'Migration Rate',
              'mu' = 'Mutation Rate',
              'socialmu' = 'Mutation Rate at Cooperation Locus',
              'stressmu' = 'Mutation Rate at Adaptive Loci',
              'benefit' = 'Benefit of Cooperation',
              'cost' = 'Cost of Cooperation',
              'envchange_freq' = 'Environmental Change Frequency',
              'envchange_period' = 'Interval Between Environmental Changes',
              'topology' = 'Migration Topology',
              'dilute_min' = 'Minimum Probability of Dilution',
              'with_stress' = 'With Stress Induced Thinning',
              'without_stress' = 'Without Stress Induced Thinning',
              'stress_strength' = 'Adaptive Loci Affected by Environmental Change',
              'gamma' = 'Shape Parameter Value',
              'carrying_capacity' = 'Subpopulation Size',
              'numones' = 'Number of Adaptations Gained',
              'fitness' = 'Fitness',
              'pop_struct' = 'Structured Population',
              'pop_unstruct' = 'Unstructured Population',
              'with_adapt' = 'With Stress Adaptation',
              'without_adapt' = 'Without Stress Adaptation')


label_genomelengths <- c('0', '1', '2', '3', '4', '5', '6', '7', expression(bold('8')), '9', '10')
label_genomelengths08 <- c('0', expression(bold('8')) )
label_structure <- c('lattice, 25x25'=expression(bold('Structured')), 'well-mixed, 625'='Unstructured')


##label_benefits <- c('0', '200', '400', '600', '800', '1000', expression(bold('1200')), '1400', '1600', '1800', '2000')
label_benefits <- c('0', '150', '300', '450', '600', '750', '900', '1050',  expression(bold('1200')), '1350', '1500', '1650')

cost_labels <- c('0.0'='0.0', '0.1'=expression(bold('0.1')), '0.2'='0.2',
                 '0.3'='0.3', '0.4'='0.4', '0.5'='0.5')

mutation_labels <- c('1e-07'='0.0000001', '1e-06'='0.000001',
                     '1e-05'=expression(bold('0.00001')), '1e-04'='0.0001',
                     '1e-03'='0.001', '1e-02'='0.01', '1e-01'='0.1')

mutation_labels2 <- c('1e-05'=expression(bold('0.00001')), '1e-04'='0.0001',
                     '1e-03'='0.001', '1e-02'='0.01', '1e-01'='0.1', '1e+00'=1)

replicate_alpha <- 0.1

color_L00 <- '#777777'
color_L08 <- '#BBBBBB'

