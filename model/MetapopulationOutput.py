# -*- coding: utf-8 -*-

import bz2
import csv

from OutputWriter import OutputWriter


class MetapopulationOutput(OutputWriter):

    def __init__(self, metapopulation, filename='metapopulation.csv.bz2', delimiter=','):
        super(MetapopulationOutput, self).__init__(metapopulation=metapopulation,
                                                   filename=filename,
                                                   delimiter=delimiter)

        self.writer.writerow(['Time', 'Size', 'CooperatorProportion',
                              'MaxCooperatorFitness', 'MaxDefectorFitness'])

    def update(self, time):
        fits = self.metapopulation.max_fitnesses()
        self.writer.writerow([time, self.metapopulation.size(),
                              self.metapopulation.prop_producers(),
                              max(fits[0]), max(fits[1])])

