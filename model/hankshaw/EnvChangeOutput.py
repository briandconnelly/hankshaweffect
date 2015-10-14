# -*- coding: utf-8 -*-

from hankshaw.OutputWriter import OutputWriter


class EnvChangeOutput(OutputWriter):

    def __init__(self, metapopulation, filename='environmental_change.csv',
                 header=True, include_uuid=False, compress=False):
        fieldnames = ['Time', 'EnvironmentChanged']
        super(EnvChangeOutput, self).__init__(metapopulation=metapopulation,
                                              filename=filename,
                                              fieldnames=fieldnames,
                                              header=header,
                                              include_uuid=include_uuid,
                                              compress=compress)

    def update(self, time):
        record = {'Time': time,
                  'EnvironmentChanged': self.metapopulation.environment_changed}
        self.writerow(record)
