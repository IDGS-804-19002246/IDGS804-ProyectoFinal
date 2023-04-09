import flask
from flask_wtf.csrf import CSRFProtect

from werkzeug.security import generate_password_hash, check_password_hash
from flask_login import LoginManager, login_user, login_required, logout_user, current_user
from flask import render_template, request, redirect, url_for, jsonify, flash
# from flask_wtf import CSRFProtect


from config import DevelopmentConfig
from rutas.usuarios import usu
from rutas.productos import pro
from rutas.insumos import ins
from rutas.cocina import coc


# from model import db
from config import db
from modelos.usuariosM import Usuarios
from modelos.productosM import Productos


app = flask.Flask(__name__)
app.config.from_object(DevelopmentConfig)
csrf = CSRFProtect()


app.register_blueprint(usu)
app.register_blueprint(pro)
app.register_blueprint(ins)
app.register_blueprint(coc)

login_manager = LoginManager()
login_manager.init_app(app)
login_manager.login_view = 'usu.login'
login_manager.login_message = u"Inicia Sesión, Porfa :3"
@login_manager.user_loader
def load_user(user_id): return Usuarios.query.get(int(user_id))








@app.route("/index", methods=['GET', 'POST'])
@app.route("/", methods=['GET', 'POST'])
@login_required
def index():
    ga = Productos.ProductosSelectTodos()
    galletas = []
    for g in ga:
        galletas.append(            
            {
            'id_producto':g[0],
            'nombre':g[1].capitalize(),
            'cantidad':g[2],
            'cantidad_min':g[3],
            'precio_U':g[4],
            'precio_M':g[5],
            'proceso':g[6].capitalize(),
            'img':g[7],
            'descripcion':g[8].capitalize()
            }
        )

    return render_template('index.html', G=galletas,current_user=current_user)


@app.route("/nosotros", methods=['GET'])
def nosotros(): return render_template('nosotros.html',current_user=current_user)



# app.register_blueprint(pro)

if __name__ == '__main__':
    csrf.init_app(app)
    db.init_app(app)
    with app.app_context():
        db.create_all()
    app.run()
