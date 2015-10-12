# -*- coding: utf-8 -*-

import bz2
import csv

class OutputWriter(object):

    def __init__(self, metapopulation, filename, delimiter=',', compress=False):
        self.metapopulation = metapopulation
        self.filename = filename
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

        self.writer = csv.writer(self.outfile, delimiter=delimiter)

    def update(self, time):
        pass

    def close(self):
        self.outfile.close()

