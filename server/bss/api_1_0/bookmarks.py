from flask import jsonify, request, g, abort, url_for, current_app
from . import api
from ..dao import Bookmark
from flask.ext.login import login_required
from ..model import insert_to_db

@api.route('/bookmarks/add', methods=['POST'])
def add_new_bookmark_with_json():
    #print request.json
    bookmark = Bookmark.from_json(request.json)
    if g.current_user.id == bookmark["userid"]:
        insert_to_db(bookmark)
    return jsonify(bookmark.to_json()) 

@api.route('/bookmarks/get_all', methods=['GET'])
def get_all_bookmarks():
    #print request.json
    print(g.current_user.id)
    json_bookmarks_array=[]
    bookmarks = Bookmark.query.filter_by(userid=g.current_user.id).order_by('timestamp desc').all()
    for bookmark in bookmarks:
        json_bookmarks_array.append(bookmark.to_json())
    #print json_bookmarks_array
    return jsonify(all_bookmarks=json_bookmarks_array)