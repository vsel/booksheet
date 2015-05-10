from flask import render_template, session, redirect, url_for, current_app,\
request, flash, abort
from flask.ext.login import login_required, login_user, logout_user,\
current_user
from datetime import datetime
from . import main
from .forms import BookmarkForm
from ..model import insert_to_db,get_all_bookmarks_with_user,remove_from_db, \
get_bookmark

@main.route('/')
def index_html():
    return render_template('index.html')

@main.route('/bookmarks/<username>')
@login_required 
def show_bookmarks(username):
    (bookmarks, user) = get_all_bookmarks_with_user(username)
    return render_template('bookmark_view.html',name = user.username,bookmarks = bookmarks, current_user = current_user)

@main.route('/edit/<int:id>', methods=['GET', 'POST'])
@login_required
def edit_bookmark(id):
    bookmark = get_bookmark(id)
    if current_user.id != bookmark.userid :
        abort(403)
    form = BookmarkForm()
    if form.validate_on_submit():
        bookmark.text = form.body.data
        insert_to_db(bookmark)
        flash('The post has been updated.')
        #return redirect(url_for('.post', id=post.id))
        return redirect(url_for('main.show_bookmarks',username = current_user.username))
    form.body.data = bookmark.text
    return render_template('bookmark_edit.html', form=form)

@main.route('/delete/<int:id>', methods=['GET'])
@login_required
def bookmark_delete(id):
    bookmark = get_bookmark(id)
    if current_user.id != bookmark.userid :
        abort(403)
    remove_from_db(bookmark)
    return redirect(url_for('main.show_bookmarks',username = current_user.username))



    