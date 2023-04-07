from db import get_connection

import sys
sys.path.append("..")
from config import db

class Ventas():

    def ventasSelectUsuario(id):
        try:
            connection = get_connection()
            with connection.cursor() as cursor:
                cursor.execute('call ventasSelectUsuario(%s)',(id,))
                resultset = cursor.fetchall()
                return resultset
        except Exception as ex:
            print(ex)

    def ventasInsert(id):
        try:
            connection = get_connection()
            with connection.cursor() as cursor:
                cursor.execute('call ventasInsert(%s)',(id,))
                connection.commit()
                connection.close()
                return 'ok: '
        except Exception as ex:
            print(ex)

    def venta_productoInsert(id_pro,can,pre):
        try:
            connection = get_connection()
            with connection.cursor() as cursor:
                cursor.execute('call venta_productoInsert(%s,%s,%s)',(id_pro,can,pre))
                connection.commit()
                connection.close()
                return ' ok '
        except Exception as ex:
            print(ex)

    def enviosInsert(dir):
        try:
            connection = get_connection()
            with connection.cursor() as cursor:
                cursor.execute('call enviosInsert(%s)',(dir,))
                connection.commit()
                connection.close()
                return 'ok: '
        except Exception as ex:
            print(ex)

    # def ProductosSelectUno(id):
    #     try:
    #         connection = get_connection()
    #         with connection.cursor() as cursor:
    #             cursor.execute('call ProductosSelectUno(%s)',(id,))
    #             resultset = cursor.fetchall()
    #             return resultset
    #     except Exception as ex:
    #         print(ex)

    # def ProductosSelectReseta(id):
    #     try:
    #         connection = get_connection()
    #         with connection.cursor() as cursor:
    #             cursor.execute('call ProductosSelectReseta(%s)',(id,))
    #             resultset = cursor.fetchall()
    #             return resultset
    #     except Exception as ex:
    #         print(ex)