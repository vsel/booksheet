#!/usr/bin/env python
import os
from bss import create_app, db
from flask.ext.script import Manager, Shell, Server
from flask.ext.migrate import Migrate, MigrateCommand

bss = create_app(os.getenv('FLASK_CONFIG') or 'default')

if __name__ == '__main__':
    bss.debug = True
    bss.run(host="0.0.0.0", port=8080)