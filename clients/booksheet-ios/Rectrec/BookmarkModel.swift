//
//  BookmarkModel.swift
//  Rectrec
//
//  Created by Volodymyr Selyukh on 04.05.15.
//  Copyright (c) 2015 D4F. All rights reserved.
//

struct Bookmark {
    
    var bookmarkText : String?
    var bookname : String?
    var date : String?
    var page : String?
    
    subscript(nameOfFileld: String) -> String{
        get{
            switch nameOfFileld{
                case "bookmarkText":
                    return bookmarkText ?? ""
                case "bookname":
                    return bookname ?? ""
                case "date":
                    return date ?? ""
                case "page":
                    return page ?? ""
                default:
                    return "Something Wrong"
            }
        }
        set{
            switch nameOfFileld{
            case "text":
                bookmarkText = newValue
            case "bookname":
                bookname = newValue
            case "timestamp":
                date = newValue
            case "page":
                page = newValue
            default:
                assert(true,"Something Wrong")
            }
        }
    }
    
    func initWithJSON(data:JSON) -> Bookmark{
        var bookmark = Bookmark()
        for (key,value) in data {
                bookmark[key] = value.stringValue
        }
        return bookmark
    }
    static func initForSend(text: String,page: String,bookname: String) -> [String:String]{
        var forJSON =  ["userid": CredentialStore.sharedInstance.userid,"bookname": bookname,"text":text,"page": page]
        return forJSON
    }
}