#!/usr/bin/env python
import os
from bss import create_app, db
from flask.ext.script import Manager, Shell, Server
from flask.ext.migrate import Migrate, MigrateCommand

bss = create_app(os.getenv('FLASK_CONFIG') or 'default')
manager = Manager(bss)
migrate = Migrate(bss, db)

manager.add_command("runserver", Server(host="0.0.0.0", port=8080))


def make_shell_context():
    return dict(bss=bss, db=db)
    
manager.add_command("shell", Shell(make_context=make_shell_context))
manager.add_command('db', MigrateCommand)

@manager.command
def test(coverage=False):
    import unittest
    tests = unittest.TestLoader().discover('tests')
    unittest.TextTestRunner(verbosity=2).run(tests)

if __name__ == '__main__':
    manager.run()
    