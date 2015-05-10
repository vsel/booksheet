from dao import User, Bookmark
from . import db

def insert_to_db(dao_object):
    db.session.add(dao_object)
    db.session.commit()

def get_all_bookmarks_with_user(username):
    user = User.query.filter_by(username=username).first_or_404()
    bookmarks = Bookmark.query.filter_by(userid=user.id).order_by('timestamp desc').all()
    return (bookmarks, user)
    
def remove_from_db(dao_object):
    db.session.delete(dao_object)
    db.session.commit()