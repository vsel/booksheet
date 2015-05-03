from flask.ext.wtf import Form
from flask.ext.pagedown.fields import PageDownField
from wtforms import StringField, TextAreaField, BooleanField, SelectField,\
SubmitField
from wtforms.validators import Required, Length, Email, Regexp
from wtforms import ValidationError

class BookmarkForm(Form):
    body = PageDownField("Is Something Wrong?", validators=[Required()])
    submit = SubmitField('Submit')