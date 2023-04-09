from flask import Blueprint, redirect, render_template, url_for,request, flash
from flask_login import LoginManager, login_user, login_required, logout_user,current_user
from werkzeug.security import generate_password_hash, check_password_hash
from db import get_connection

# from model import Usuarios
import sys
sys.path.append("..")
from modelos.insumosM import Insumos
import validaciones

ins = Blueprint('ins',__name__)



@ins.route("/insumos", methods=['GET','POST'])
def insumos():
    if current_user.rol == 'baneado':
        flash('Este usuario esta baneado')
        return redirect(url_for('usu.login'))
    create_form = validaciones.insumos(request.form)
    if request.method == 'POST' and create_form.validate():
        if request.form.get('accion') == 'add':
            msg = Insumos.InsumosInsert(
                    create_form.nombre.data,
                    create_form.cantidad.data,
                    create_form.cantidad_min.data,
                    request.form.get('medida'),
                    request.form.get('caducidad') if request.form.get('perecedero') is None else '1111-11-11'
                )
            return redirect(url_for('ins.insumos'))
            
        if request.form.get('accion') == 'update':
            msg = Insumos.InsumosUpdate(
                    request.form.get('id_insumo'),
                    create_form.nombre.data,
                    create_form.cantidad.data,
                    create_form.cantidad_min.data,
                    request.form.get('medida'),
                    request.form.get('caducidad') if request.form.get('perecedero') is None else '1111-11-11'
                )
            return redirect(url_for('ins.insumos'))


    ins = Insumos.InsumosSelectTodos()
    insumos = []
    for i in ins:insumos.append({'id_insumo':i[0],'nombre':i[1].capitalize(),'cantidad':i[2],'cantidad_min':i[3],'medida':i[4],'caducidad':str(i[5])})
    return render_template('insumos.html', I=insumos, form=create_form,current_user=current_user)




@ins.route("/insumoDelete", methods=['GET','POST'])
def insumoDelete():
    if request.method == 'GET':
        id = request.args.get('id')
        msg = Insumos.InsumosDelete(id)
    return redirect(url_for('ins.insumos'))