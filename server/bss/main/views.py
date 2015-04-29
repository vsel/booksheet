from flask import render_template, session, redirect, url_for, current_app
from . import main
from ..dao import User

@main.route('/')
def test_proto():
    print User.query.all()
    return render_template('proto.html',name = User.query.all()[0].username)
    
@main.route('/<username>')
def test_proto2(username):
    print User.query.all()
    user = User.query.filter_by(username=username).first_or_404()
    return render_template('proto.html',name = user.username)




    