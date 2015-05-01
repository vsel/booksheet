import unittest
from flask import current_app, url_for
from bss import create_app, db
from bss.dao import User, Bookmark

class DAOTestCase(unittest.TestCase):
    def setUp(self):
        self.app = create_app('testing')
        self.app_context = self.app.app_context()
        self.app_context.push()
        self.client = self.app.test_client(use_cookies=True)
        db.create_all()

    def tearDown(self):
        db.session.remove()
        db.drop_all()
        self.app_context.pop()

    def test_useradd_noemail(self):
        user = User(username="test12",
                    password="test1234")
        db.session.add(user)
        #This must be broken!!!! Used for "must have errors" searching
        with self.assertRaises(Exception) as context:
            db.session.commit()
        self.assertTrue(context.exception)
        
        
    def test_useradd_everything_fine(self):
        user = User(username="test12",
                    email = "123@123.ua",
                    password="test1234")
        db.session.add(user)
        self.assertTrue(db.session.commit() is not False)
    
    def test_bookmark_add_notext(self):
        bookmark = Bookmark(text="test12")
        db.session.add(bookmark)
        #This must be broken!!!! Used for "must have errors" searching
        with self.assertRaises(Exception) as context:
            db.session.commit()
        self.assertTrue(context.exception)
        
        
    def test_bookmark_add_fine(self):
        bookmark = Bookmark(text="test12",
                    userid = 1)
        db.session.add(bookmark)
        self.assertTrue(db.session.commit() is not False)
        