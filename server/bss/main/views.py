from flask import render_template, session, redirect, url_for, current_app,\
request, flash, abort
from flask.ext.login import login_required, login_user, logout_user,\
current_user
from datetime import datetime
from . import main
from ..dao import User, Bookmark, Anonymous
from .forms import BookmarkForm
from .. import db

@main.route('/')
def index_html():
    #print User.query.all()
    return render_template('index.html')

@main.route('/bookmarks/<username>')
@login_required 
def show_bookmarks(username):
    #print User.query.all()
    user = User.query.filter_by(username=username).first_or_404()
    bookmarks = Bookmark.query.filter_by(userid=user.id).order_by('timestamp desc').all()
    return render_template('bookmark_view.html',name = user.username,bookmarks = bookmarks, current_user = current_user)

@main.route('/edit/<int:id>', methods=['GET', 'POST'])
@login_required
def edit_bookmark(id):
    bookmark = Bookmark.query.get_or_404(id)
    if current_user.id != bookmark.userid :
        abort(403)
    form = BookmarkForm()
    if form.validate_on_submit():
        bookmark.text = form.body.data
        db.session.add(bookmark)
        flash('The post has been updated.')
        #return redirect(url_for('.post', id=post.id))
        return redirect(url_for('main.index_html'))
    form.body.data = bookmark.text
    return render_template('bookmark_edit.html', form=form)

@main.route('/delete/<int:id>', methods=['GET'])
@login_required
def bookmark_delete(id):
    bookmark = Bookmark.query.get_or_404(id)
    if current_user.id != bookmark.userid :
        abort(403)
    db.session.delete(bookmark)
    db.session.commit()
    return redirect(url_for('main.show_bookmarks',username = current_user.username))



    