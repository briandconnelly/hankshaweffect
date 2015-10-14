# -*- coding: utf-8 -*-

import bz2
import csv

class OutputWriter(object):

    def __init__(self, metapopulation, filename, fieldnames, header=True,
                 include_uuid=False, compress=False):
        self.metapopulation = metapopulation
        self.filename = filename
        self.fieldnames = fieldnames
        self.include_uuid = include_uuid
        self.compress = compress

        if compress:
            self.filename += ".bz2"

            try:
                self.outfile = bz2.open(filename=self.filename, mode='wt',
                                        newline='', encoding='UTF-8')
            except AttributeError:
                self.outfile = bz2.BZ2File(self.filename, 'w')

        else:
            self.outfile = open(self.filename, mode='wt')

        if self.include_uuid:
            self.fieldnames.insert(0, 'UUID')

        self.writer = csv.DictWriter(self.outfile, fieldnames=self.fieldnames)

        if header:
            self.writer.writeheader()

    def update(self, time):
        pass

    def writerow(self, record):
        if self.include_uuid:
            record['UUID'] = self.metapopulation.config['Simulation']['UUID']

        self.writer.writerow(record)

    def close(self):
        self.outfile.close()

