import os
from sqlalchemy import create_engine
from flask_sqlalchemy import SQLAlchemy
import urllib

db=SQLAlchemy()
class Config(object):
    SECRET_KEY='MY_SECRET_KEY'
    SESSION_COOKIE_SECURE=False

class DevelopmentConfig(Config):
    DEBUG=True
    SQLALCHEMY_DATABASE_URI='mysql+pymysql://root:@127.0.0.1/idgs804_galletas'
    SQLALCHEMY_TRACK_MODIFICATIONS=False
