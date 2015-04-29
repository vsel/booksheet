from . import db

class User(db.Model):
    __tablename__ = 'users'
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(64), unique=True, index=True)

    def __repr__(self):
        return '<User %r>' % self.username
    
    def to_json(self):
        json_user = {
        #'url': url_for('api.get_post', id=self.id),
        'username': self.username
        }
        return json_user
    
    @staticmethod
    def from_json(json_post):
        username = json_post.get('username')
        return User(username=username)