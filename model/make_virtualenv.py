#!/usr/bin/env python

import os
import subprocess
import textwrap
import virtualenv

output = virtualenv.create_bootstrap_script(textwrap.dedent("""
import os, subprocess

def after_install(options, home_dir):
    subprocess.call([join(home_dir, 'bin', 'pip'), 'install', 'hankshaw'])
"""))
f = open('hankshaw-bootstrap.py', 'w').write(output)
