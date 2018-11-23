# -*- coding: cp1252 -*-
#Erick Aquino
#Juan Pablo Gomes
from Tkinter import *
import serial
import time
import sys

#Config interfaz
ventana = Tk()
ventana.title('Proyecto Final')
ventana.resizable(0,0)
ventana.geometry("300x200")
#ventana.geometry('450x250+500+300')
ventana.configure(background = 'black' )
#Box
box=Frame()
box.pack()
box.config(width='500',height="200")
#Iniciar grabación de rutina
grabar_rutina = Label(box,text='Iniciar Grabación de Rutina',fg='black',bg='yellow')
grabar_rutina.place(x=80,y=10)
#Ejecutar Grabación
angulo = Label(box, text='Ejecutar grabación',fg='black',bg='yellow').place(x=100,y=100)

def grabar():
    global var
    var = ser.read()
def ejecutar():
    var2 = ser.write(var)
    print var
    


push = Button(box,text='Grabar',command = grabar)#,command = mapear)
push.place(x=130,y=50)

push2 = Button(box,text = 'Ejecutar',command = ejecutar)
push2.place(x=130,y=135)
global ser
ser= serial.Serial(port='COM18',baudrate=9600, parity=serial.PARITY_NONE, stopbits=serial.STOPBITS_ONE,bytesize=serial.EIGHTBITS, timeout=0)
while 1:
    ser.flushInput()
    ser.flushOutput()
    time.sleep(.3)
    recibido1=ser.read()
    #ser.write(mapeo)
    numero2 = ord(recibido1)
    numero=float(numero2)
    numero=(numero*5.0)/255.0
    #print(numero2)
    ventana.update()

#Hacer funcionar botones
#def mapear():
    #angulo = textbox.get()
    #numero = int(angulo)
    #mapeo = ((numero*35)/(180))#255 variable dependiendo del los valores
    #print mapeo
    #pasar el numero mapeado a enter y luego a un caracter para poder ser enviado
    #gradosint = int(mapeo)
    #grados_envio = chr(gradosint)
    #ser.write(grados_envio)
    #print'El angulo se envio'
    #print 'Los grados enviados fueron',gradosint


#ventana.mainloop()
#ventana.update()
