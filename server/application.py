#!/usr/bin/env python
import os
from bss import create_app
from flask.ext.script import Server


application = create_app(os.getenv('FLASK_CONFIG') or 'default')

if __name__ == '__main__':
    bss.debug = True
    bss.run()
