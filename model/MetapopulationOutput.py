# -*- coding: utf-8 -*-

#import bz2
#import csv

from OutputWriter import OutputWriter


class MetapopulationOutput(OutputWriter):

    def __init__(self, metapopulation, filename='metapopulation.csv',
                 delimiter=',', compress=False):
        super(MetapopulationOutput, self).__init__(metapopulation=metapopulation,
                                                   filename=filename,
                                                   delimiter=delimiter,
                                                   compress=compress)

        self.writer.writerow(['Time', 'Births', 'Size', 'CooperatorProportion',
                              'MaxCooperatorFitness', 'MaxDefectorFitness'])

    def update(self, time):
        fits = self.metapopulation.max_fitnesses()
        self.writer.writerow([time, self.metapopulation.num_births,
                              self.metapopulation.size(),
                              self.metapopulation.prop_producers(),
                              max(fits[0]), max(fits[1])])

