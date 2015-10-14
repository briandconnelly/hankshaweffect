# -*- coding: utf-8 -*-

from hankshaw.OutputWriter import OutputWriter


class FitnessOutput(OutputWriter):

    def __init__(self, metapopulation, filename='max_fitness.csv',
                 header=True, include_uuid=False, compress=False):
        fieldnames = ['Time', 'Producers', 'Nonproducers']
        super(FitnessOutput, self).__init__(metapopulation=metapopulation,
                                            filename=filename,
                                            fieldnames=fieldnames,
                                            header=header,
                                            include_uuid=include_uuid,
                                            compress=compress)

    def update(self, time):
        maxfit = self.metapopulation.max_fitnesses()
        record = {'Time': time,
                  'Producers': max(maxfit[0]),
                  'Nonproducers': max(maxfit[1])}
        self.writerow(record)

