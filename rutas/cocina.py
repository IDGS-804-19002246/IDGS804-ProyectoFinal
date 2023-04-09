from flask import Blueprint, redirect, render_template, url_for,request, flash,make_response
from flask_login import LoginManager, login_user, login_required, logout_user,current_user
from werkzeug.security import generate_password_hash, check_password_hash
from datetime import date
import json

from werkzeug.utils import secure_filename
import os

from db import get_connection
import validaciones
from config import db
import sys
sys.path.append("..")
from modelos.productosM import Productos
from modelos.ventasM import Ventas
from modelos.insumosM import Insumos


coc = Blueprint('coc',__name__)


@coc.route("/entregar", methods=['GET','POST'])
def entregar():
    V = db.session.query(Ventas).filter(Ventas.id_venta == request.form.get('id')).first()
    V.entrega = 1
    db.session.add(V)
    db.session.commit()
    return redirect(url_for('coc.cocina'))

@coc.route("/cocinar", methods=['GET','POST'])
def cocinar():
    P = db.session.query(Productos).filter(
        Productos.id_producto == int(request.form.get('id'))
        and
        Productos.estado == 'ok'
        ).first()
    P.pendientes = 0
    db.session.add(P)
    db.session.commit()
    Insumos.InsumosCocinar(request.form.get('id'),request.form.get('can'))
    return redirect(url_for('coc.cocina'))

@coc.route("/cocina_eliminar", methods=['GET','POST'])
def cocina_eliminar():
    P = db.session.query(Productos).filter(Productos.id_producto == int(request.args.get('id'))).first()
    P.pendientes = 0
    db.session.add(P)
    db.session.commit()
    return redirect(url_for('coc.cocina'))

@coc.route("/cocina", methods=['GET','POST'])
def cocina():
    if current_user.rol == 'baneado':
        flash('Este usuario esta baneado')
        return redirect(url_for('usu.login'))
    pro = db.session.query(Productos.id_producto, Productos.nombre, Productos.pendientes).filter(Productos.pendientes != 0).all()
    ven = Ventas.ventasSelectPendientes()
    lista = []
    salida = []

    for v in ven:
        lista.append({
            'id_venta': v[0],
            'nombre': v[1],
            'descripcion': v[2],
            'cantidad': v[3],
            'precio': v[4],
            'fecha': v[5],
            'direccion': v[6],
            'entrega': v[7],
            'cliente': v[8]
        })

    for i in range(len(lista)):
        if i == 0:
            salida.append({
                'id_venta': lista[i]['id_venta'],
                'fecha': lista[i]['fecha'],
                'direccion': lista[i]['direccion'],
                'entrega': lista[i]['entrega'],
                'cliente': lista[i]['cliente'],
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
                    'cliente': lista[i]['cliente'],
                    'productos' : [
                        {
                        'nombre': lista[i]['nombre'],
                        'descripcion': lista[i]['descripcion'],
                        'cantidad': lista[i]['cantidad'],
                        'precio': lista[i]['precio']
                        }
                    ]
                })

    return render_template('cocina_y _envios.html', P = pro, V = salida,current_user=current_user)


@coc.route("/ventas", methods=['GET','POST'])
def ventas():
    if current_user.rol == 'baneado':
        flash('Este usuario esta baneado')
        return redirect(url_for('usu.login'))
    ven = Ventas.ventasSelectMes(request.args.get('f'))
    lista = []
    salida = []

    for v in ven:
        lista.append({
            'id_venta': v[0],
            'nombre': v[1],
            'descripcion': v[2],
            'cantidad': v[3],
            'precio': v[4],
            'fecha': v[5],
            'direccion': v[6],
            'entrega': v[7],
            'cliente': v[8]
        })

    for i in range(len(lista)):
        if i == 0:
            salida.append({
                'id_venta': lista[i]['id_venta'],
                'fecha': lista[i]['fecha'],
                'direccion': lista[i]['direccion'],
                'entrega': lista[i]['entrega'],
                'cliente': lista[i]['cliente'],
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
                    'cliente': lista[i]['cliente'],
                    'productos' : [
                        {
                        'nombre': lista[i]['nombre'],
                        'descripcion': lista[i]['descripcion'],
                        'cantidad': lista[i]['cantidad'],
                        'precio': lista[i]['precio']
                        }
                    ]
                })

    return render_template('ventas.html', V = salida,current_user=current_user)