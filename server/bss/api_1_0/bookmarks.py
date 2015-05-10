from flask import jsonify, request, g, abort, url_for, current_app
from . import api
from ..dao import Bookmark
from flask.ext.login import login_required
from ..model import insert_to_db, get_all_bookmarks_with_userid

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
    #print(g.current_user.id)
    json_bookmarks_array=[]
    bookmarks = get_all_bookmarks_with_userid(g.current_user.id)
    for bookmark in bookmarks:
        json_bookmarks_array.append(bookmark.to_json())
    #print json_bookmarks_array
    return jsonify(all_bookmarks=json_bookmarks_array)