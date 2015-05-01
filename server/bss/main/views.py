from flask import render_template, session, redirect, url_for, current_app,\
request
from datetime import datetime
from . import main
from ..dao import User, Bookmark
from .. import db

@main.route('/')
def index_html():
    #print User.query.all()
    return render_template('index.html')

@main.route('/bookmarks/<username>')
def show_bookmarks(username):
    #print User.query.all()
    bookmarks = Bookmark.query.filter_by(userid=1).order_by('timestamp desc').all()
    return render_template('bookmark_view.html',bookmarks = bookmarks, name = username)