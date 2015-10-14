# -*- coding: utf-8 -*-

from hankshaw.OutputWriter import OutputWriter


class MetapopulationOutput(OutputWriter):

    def __init__(self, metapopulation, filename='metapopulation.csv',
                 header=True, include_uuid=False, compress=False):
        fieldnames = ['Time', 'Births', 'Size', 'CooperatorProportion', 'MaxCooperatorFitness', 'MaxDefectorFitness']
        super(MetapopulationOutput, self).__init__(metapopulation=metapopulation,
                                                   filename=filename,
                                                   fieldnames=fieldnames,
                                                   header=header,
                                                   include_uuid=include_uuid,
                                                   compress=compress)


    def update(self, time):
        fits = self.metapopulation.max_fitnesses()
        record = {'Time': time,
                  'Births': self.metapopulation.num_births,
                  'Size': self.metapopulation.size(),
                  'CooperatorProportion': self.metapopulation.prop_producers(),
                  'MaxCooperatorFitness': max(fits[0]),
                  'MaxDefectorFitness': max(fits[1])}
        self.writerow(record)

