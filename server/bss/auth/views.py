from flask import render_template, redirect, request, url_for, flash
from flask.ext.login import login_user, logout_user, login_required, \
    current_user
from . import auth
from .. import db
from ..dao import User
#from ..email import send_email
from .forms import LoginForm, RegistrationForm

#TODO:For future confirmation of auth NO HACKER
#@auth.before_app_request
#def before_request():
#    if current_user.is_authenticated():
#        current_user.ping()
#        if not current_user.confirmed \
#                and request.endpoint[:5] != 'auth.' \
#                and request.endpoint != 'static':
#            return redirect(url_for('auth.unconfirmed'))


@auth.route('/unconfirmed')
def unconfirmed():
    if current_user.is_anonymous() or current_user.confirmed:
        return redirect(url_for('main.index_html'))
    #TODO FUTURE Redirection
    #return render_template('auth/unconfirmed.html')
    return redirect(url_for('main.index_html'))

@auth.route('/login', methods=['GET', 'POST'])
def login():
    form = LoginForm()
    if form.validate_on_submit():
        user = User.query.filter_by(email=form.email.data).first()
        if user is not None and user.verify_password(form.password.data):
            #login_user(user, form.remember_me.data)'
            login_user(user)
            return redirect(request.args.get('next') or url_for('main.show_bookmarks', username = current_user.username))
        flash('Invalid username or password.')
    return render_template('auth/login.html', form=form)


@auth.route('/logout')
@login_required
def logout():
    logout_user()
    flash('You have been logged out.')
    return redirect(url_for('main.index_html'))


@auth.route('/register', methods=['GET', 'POST'])
def register():
    form = RegistrationForm()
    if form.validate_on_submit():
        user = User(email=form.email.data,
                    username=form.username.data,
                    password=form.password.data)
        db.session.add(user)
        db.session.commit()
        #TODO: Future check by mail send and token
        #token = user.generate_confirmation_token()
        #send_email(user.email, 'Confirm Your Account',
        #           'auth/email/confirm', user=user, token=token)
        flash('A confirmation email has been sent to you by email.')
        return redirect(url_for('auth.login'))
    return render_template('auth/register.html', form=form)