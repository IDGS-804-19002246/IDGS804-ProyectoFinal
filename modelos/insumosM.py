from db import get_connection

import sys
sys.path.append("..")
from config import db

class Insumos(db.Model):
    __tablaname__='insumos'
    id_insumo = db.Column(db.Integer, primary_key = True)
    nombre=db.Column(db.String(32))

    cantidad=db.Column(db.Integer)
    cantidad_min=db.Column(db.Integer)

    precio_U=db.Column(db.Integer)
    precio_M=db.Column(db.Integer)

    proceso=db.Column(db.String(250))
    img=db.Column(db.String(250))
    descripcion=db.Column(db.String(64))

    def InsumosSelectTodos():
        try:
            connection = get_connection()
            with connection.cursor() as cursor:
                cursor.execute('call InsumosSelectTodos()')
                resultset = cursor.fetchall()
                return resultset
        except Exception as ex:
            print(ex)
        
    def InsumosDelete(id):
        try:
            connection = get_connection()
            with connection.cursor() as cursor:
                cursor.execute('call InsumosDelete(%s)',(id,))
                connection.commit()
                connection.close()
                return 'ok'
        except Exception as ex:
            print(ex)

    def InsumosInsert(nom, can, can_min, med, cad):
        try:
            connection = get_connection()
            with connection.cursor() as cursor:
                cursor.execute(
                    'call InsumosInsert(%s,%s,%s,%s,%s)',
                    (nom, can, can_min, med, cad))
                connection.commit()
                connection.close()
                return 'ok'
        except Exception as ex:
            print(ex)
    
    def InsumosUpdate(id,nom, can, can_min, med, cad):
        try:
            connection = get_connection()
            with connection.cursor() as cursor:
                cursor.execute(
                    'call InsumosUpdate(%s,%s,%s,%s,%s,%s)',
                    (id,nom, can, can_min, med, cad))
                connection.commit()
                connection.close()
                return 'ok'
        except Exception as ex:
            print(ex)