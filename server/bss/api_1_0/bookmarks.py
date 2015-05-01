from flask import jsonify, request
from .. import db
from . import api
from ..dao import Bookmark

@api.route('/bookmarks/get_all', methods=['GET'])
def get_all_bookmarks():
    #print request.json
    json_bookmarks_array=[]
    bookmarks = Bookmark.query.filter_by(userid=1).order_by('timestamp desc').all()
    for bookmark in bookmarks:
        json_bookmarks_array.append(bookmark.to_json())
    #print json_bookmarks_array
    return jsonify(all_bookmarks=json_bookmarks_array)