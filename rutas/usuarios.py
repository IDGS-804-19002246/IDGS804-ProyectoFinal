from flask import Blueprint, redirect, render_template, url_for,request, flash,current_app
from flask_login import login_user, login_required, logout_user,current_user
from werkzeug.security import generate_password_hash, check_password_hash
from itertools import groupby
from operator import itemgetter

from db import get_connection
from config import db
import validaciones
# from model import Usuarios
import sys
sys.path.append("..")
from modelos.usuariosM import Usuarios
from modelos.ventasM import Ventas
usu = Blueprint('usu',__name__)


@usu.route('/login')
def login():
    return render_template('login.html')


@usu.route("/login", methods=['GET','POST'])
def login_post():
    # if request.method == 'POST':
    correo = request.form.get('correo')
    contrasena = request.form.get('contrasena')
    U = Usuarios.query.filter_by(correo=correo).first()

    if not U or not check_password_hash(U.contrasena, contrasena) :
        flash('El usuario y/o la contraseña son incorrectos\n NO MAME COMPA, NO SIRVE')
        return render_template('login.html')
    
    login_user(U)
    
    return redirect(url_for('index'))
    # else:
    #     return render_template('login.html')
    
@usu.route('/logout')
@login_required
def logout():
    logout_user()
    return redirect(url_for('usu.login'))


@usu.route('/singup', methods=['GET','POST'])
def signup_post():
    if request.method == 'POST':
        nombre = request.form.get('nombre')

        apellidoP = request.form.get('apellidoP')
        apellidoM = request.form.get('apellidoM')

        correo = request.form.get('correo')
        contrasena = request.form.get('contrasena')

        user = Usuarios.query.filter_by(correo=correo).first()
        if user:
            flash('El Correo ya esta en uso')
            return redirect(url_for('usu.singup'))
        
        new_u = Usuarios(
            nombre=nombre,
            rol = 'comun',
            apellidoP=apellidoP,
            apellidoM=apellidoM,

            correo=correo,
            contrasena=generate_password_hash(contrasena, method='sha256'))
        
        db.session.add(new_u)
        db.session.commit()
        current_app.logger.warning('USUARIO CREADO')
        return redirect(url_for('usu.login'))
    else:
        return render_template('singup.html')


@usu.route("/micuenta", methods=['GET','POST'])
@login_required
def micuenta():
    if request.method == 'POST':
        return 'f'
    ventas = Ventas.ventasSelectUsuario(current_user.id)
    lista = []
    salida = []
    for v in ventas:
        lista.append({
            'id_venta': v[0],
            'nombre': v[1],
            'descripcion': v[2],
            'cantidad': v[3],
            'precio': v[4],
            'fecha': v[5],
            'direccion': v[6],
            'entrega': v[7]
        })

    for i in range(len(lista)):
        if i == 0:
            salida.append({
                'id_venta': lista[i]['id_venta'],
                'fecha': lista[i]['fecha'],
                'direccion': lista[i]['direccion'],
                'entrega': lista[i]['entrega'],
                'productos' : [
                        {
                        'nombre': lista[i]['nombre'],
                        'descripcion': lista[i]['descripcion'],
                        'cantidad': lista[i]['cantidad'],
                        'precio': lista[i]['precio']
                        }
                    ]
                }
            )
        else:
            if lista[i]['id_venta'] == lista[i-1]['id_venta']:
                salida[-1]['productos'].append({
                    'nombre': lista[i]['nombre'],
                    'descripcion': lista[i]['descripcion'],
                    'cantidad': lista[i]['cantidad'],
                    'precio': lista[i]['precio']
                })
            else:
                salida.append({
                    'id_venta': lista[i]['id_venta'],
                    'fecha': lista[i]['fecha'],
                    'direccion': lista[i]['direccion'],
                    'entrega': lista[i]['entrega'],
                    'productos' : [
                        {
                        'nombre': lista[i]['nombre'],
                        'descripcion': lista[i]['descripcion'],
                        'cantidad': lista[i]['cantidad'],
                        'precio': lista[i]['precio']
                        }
                    ]
                })
    return render_template('micuenta.html', U = current_user, L = salida)

@usu.route('/micuenta_editar', methods=['GET','POST'])
def micuenta_editar():
    if request.method == 'POST':
        if request.form.get('accion') == 'update':
            id = request.form.get('id')
            nombre = request.form.get('nombre')
            apellidoP = request.form.get('apellidoP')
            apellidoM = request.form.get('apellidoM')
            correo = request.form.get('correo')

            user = Usuarios.query.filter_by(correo=correo).filter(Usuarios.id != id).all()
            if user:
                flash('El Correo ya esta siendo usado por otra cuenta')
                return redirect(url_for('usu.micuenta_editar'))
            
            Usuarios.usuariosUpdate(id,nombre,apellidoP,apellidoM,correo)
            return 'update'
            
        if request.form.get('accion') == 'pass':
            id = request.form.get('id')
            pass1 = request.form.get('pass1')
            pass2 = request.form.get('pass2')

            if not pass1 == pass2:
                flash('La contraseñas no son iguales')
                return redirect(url_for('usu.micuenta_editar'))
            pas = generate_password_hash(pass1, method='sha256')
            Usuarios.usuariosNuevaContrasena(id,pas)
            return 'new password'
    return redirect(url_for('usu.micuenta'))







# {% for key, group in L|groupby('id_venta') %}
#             <!-- <h4>{{ group|length }}</h4> -->
#             <h6>{{ group[0].fecha }}</h6>
#                 <div class="rounded bg-danger">
#                     <!-- <li>Grupo {{ key }}:</li> -->
#                     <!-- <h4>{{ loop.index }} </h4> -->

#                     {% for item in group %}
#                     <div class="px-4 py-3 text-light fw-bold">

#                         <h4 class="d-inline-block px-4" style="width: 8%;">X{{ item.cantidad }}</h4>
#                         <h4 class="d-inline-block px-4 w-50">{{ item.nombre }}</h4>
                        
#                         <h4 class="d-inline-block px-4 float-end">${{ item.precio }}</h4>
#                     </div>
#                     {% endfor %}
                
#                 </div>
#             {% endfor %}