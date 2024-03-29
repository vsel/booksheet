from datetime import datetime
from . import db, login_manager
from flask.ext.login import UserMixin, AnonymousUserMixin
from werkzeug.security import generate_password_hash, check_password_hash
from markdown import markdown
import bleach
from itsdangerous import TimedJSONWebSignatureSerializer as Serializer
from flask import current_app

#TODO: All this things to Model of MVC. In this script only dao.

def repr_all(**kwargs):
    representation = ""
    for field, value in kwargs.items():
        representation += str(field) + " is " + str(value) + ", "
    return representation

class User(UserMixin, db.Model):
    __tablename__ = 'users'
    id = db.Column(db.Integer, primary_key=True)
    email = db.Column(db.String(64), unique=True, index=True, nullable=False)
    username = db.Column(db.String(64), unique=True, index=True, nullable=False)
    #role_id = db.Column(db.Integer, db.ForeignKey('roles.id')) for future purpouse
    password_hash = db.Column(db.String(128), nullable=False)
    confirmed = db.Column(db.Boolean, default=False)
    name = db.Column(db.String(64))
    location = db.Column(db.String(64))
    about_me = db.Column(db.Text())
    #token = db.Column(db.Text()) for future purpouse
    member_since = db.Column(db.DateTime(), default=datetime.utcnow)
    last_seen = db.Column(db.DateTime(), default=datetime.utcnow)
    avatar_hash = db.Column(db.String(32))

    def __repr__(self):
        representation = repr_all(username = self.username, id = self.id)
        return representation
    
    def to_json(self):
        json_user = {
        'username': self.username
        }
        return json_user
    
    @staticmethod
    def from_json(json_post):
        username = json_post.get('username')
        return User(username=username)
    
    @property
    def password(self):
        raise AttributeError('password is not a readable attribute')
        
    @password.setter
    def password(self, password):
        self.password_hash = generate_password_hash(password)
    
    def verify_password(self, password):
        return check_password_hash(self.password_hash, password)
    
    def generate_auth_token(self, expiration):
        s = Serializer(current_app.config['SECRET_KEY'],
                       expires_in=expiration)
        return s.dumps({'id': self.id}).decode('ascii')

    @staticmethod
    def verify_auth_token(token):
        s = Serializer(current_app.config['SECRET_KEY'])
        try:
            data = s.loads(token)
        except:
            return None
        return User.query.get(data['id'])

    
class Bookmark(db.Model):
    __tablename__ = 'bookmarks'
    id = db.Column(db.Integer, primary_key=True)
    userid = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=False)
    text = db.Column(db.String(9999))
    bookname = db.Column(db.String(64), index=True)
    page = db.Column(db.Integer)
    timestamp = db.Column(db.DateTime, index=True, default=datetime.utcnow)

    def __repr__(self):
        return '<User %r , Bookname %r>' % self.userid, self.bookname
    
    def to_json(self):
        json_bookmark = {
        'bookname': self.bookname,
        'text' : self.text,
        'page' : self.page,
        'timestamp' : self.timestamp
        }
        return json_bookmark
    
    @staticmethod
    def from_json(json_post):
        userid = json_post.get('userid')
        text = json_post.get('text')
        bookname = json_post.get('bookname')
        page = json_post.get('page')
        return Bookmark(userid=userid, text = text, bookname = bookname, page = page)
    
    @staticmethod
    def on_changed_text(target, value, oldvalue, initiator):
        allowed_tags = ['a', 'abbr', 'acronym', 'b', 'blockquote', 'code',
                        'em', 'i', 'li', 'ol', 'pre', 'strong', 'ul',
                        'h1', 'h2', 'h3', 'p']
        target.body_html = bleach.linkify(bleach.clean(
            markdown(value, output_format='html'),
            tags=allowed_tags, strip=True))

db.event.listen(Bookmark.text, 'set', Bookmark.on_changed_text)

class Anonymous(AnonymousUserMixin):
    def can(self, permissions):
        return False
    def is_administrator(self):
        return False

login_manager.anonymous_user = Anonymous
    
@login_manager.user_loader
def load_user(user_id):
    return User.query.get(int(user_id))