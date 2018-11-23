# -*- coding: cp1252 -*-
#Erick Aquino
#Juan Pablo Gomes
#Roberto Arriola
from Tkinter import *
import serial
import time
import sys

#Config interfaz
ventana = Tk()
ventana.title('Proyecto Final')
ventana.resizable(0,0)
ventana.geometry("700x350")
#ventana.geometry('450x250+500+300')
ventana.configure(background = 'black')
#Box
box=Frame()
box.pack()
box.config(width='700',height="350")
#Iniciar grabación de rutina
grabar_rutina = Label(box,text='Iniciar Grabación de Rutina 1',fg='black',bg='yellow').place(x=80,y=10)
grabar_rutina2 = Label(box,text='Iniciar Grabación de Rutina 2',fg='black',bg='yellow').place(x=250,y=10)
grabar_rutina3 = Label(box,text='Iniciar Grabación de Rutina 3',fg='black',bg='yellow').place(x=470,y=10)

#Detener Grabación
Detener1 = Label(box, text='Detener grabación',fg='black',bg='yellow').place(x=100,y=100)
Detener2 = Label(box, text='Detener grabación 2',fg='black',bg='yellow').place(x=270,y=100)
Detener3 = Label(box, text='Detener grabación 3',fg='black',bg='yellow').place(x=480,y=100)

#Reprodicir grabacion
reproducir1 = Label(box,text='Reproducir Rutina 1',fg='black',bg='yellow').place(x=100,y=200)
reproducir2 = Label(box,text='Reproducir Rutina 2',fg='black',bg='yellow').place(x=270,y=200)
reproducir3 = Label(box,text='Reproducir Rutina 3',fg='black',bg='yellow').place(x=480,y=200)

Rutina1 = 3
Rutina2 = 3
Rutina3 = 3

def grabar1():
    global Rutina1
    Rutina1 = 1      
def detener1():
    global Rutina1
    Rutina1 = 0
def enviar1():
    global Rutina1
    Rutina1 = 2

    
def grabar2():
    global Rutina2
    Rutina2 = 1 
def detener2():
    global Rutina2
    Rutina2 = 0
def enviar2():
    global Rutina2
    Rutina2 = 2

    
def grabar3():
    global Rutina3
    Rutina3 = 1
def detener3():
    global Rutina3
    Rutina3 = 0
def enviar3():
    global Rutina3
    Rutina3 = 2






        
#Botones Grabar
grabar1 = Button(box,text='Grabar 1',command = grabar1).place(x=130,y=50)
grabar2 = Button(box,text='Grabar 2',command = grabar2).place(x=305,y=50)
grabar3 = Button(box,text='Grabar 3',command = grabar3).place(x=500,y=50)
#Botones Detener
detener1 = Button(box,text = 'Detener 1',command = detener1).place(x=130,y=135)
detener2 = Button(box,text = 'Detener 2',command = detener2).place(x=300,y=135)
detener3 = Button(box,text = 'Detener 3',command = detener3).place(x=500,y=135)

#Botones Reproducir
Reproducir1 = Button(box,text = 'Reproducir 1',command = enviar1).place(x=115,y=250)
Reproducir2 = Button(box,text = 'Reproducir 2',command = enviar2).place(x=280,y=250)
Reproducir3 = Button(box,text = 'Reproducir 3',command = enviar3).place(x=500,y=250)

ser= serial.Serial(port='COM18',baudrate=9600, parity=serial.PARITY_NONE, stopbits=serial.STOPBITS_ONE,bytesize=serial.EIGHTBITS, timeout=0)
while 1:
    ser.flushInput()
    ser.flushOutput()
    time.sleep(.3)
    recibido1=ser.read()
    numero2 = ord(recibido1)
    print(numero2)
    while Rutina1==1:
        global Rutina1
        f = open('rutina1.txt','a')
        leer1 = ser.read()
        #leer2= ord(leer1)
        f.writelines(leer1)
        f.close()
        ventana.update()
    while Rutina1 == 0:
        print 'No hace nada la rutina1'
        time.sleep(0.5)
        ventana.update()
    while Rutina1==2:
        texto1 = open('rutina1.txt','r')
        linea1 = texto1.readlines()
        for elemento in linea1:
            print elemento
            envio = chr(elemento)
            ser.write(envio)
            texto1.close()
        print'Reproduciendo grabacion 1'
        ventana.update()

        
    while Rutina2==1:
        global Rutina2
        f = open('rutina2.txt','a')
        leer1 = ser.read()
        #leer2= ord(leer1)
        f.writelines(leer1)
        f.close()
        ventana.update()
    while Rutina2 == 0:
        print 'No hace nada la rutina2'
        time.sleep(0.5)
        ventana.update()
    while Rutina2==2:
        texto2 = open('rutina2.txt','r')
        linea2 = texto2.readlines()
        for elemento in linea2:
            print elemento
            envio2 = chr(elemento)
            ser.write(envio2)
            texto1.close()
        print'Reproduciendo grabacion 2'
        ventana.update()
        

    while Rutina3==1:
        global Rutina3
        f = open('rutina3.txt','a')
        leer1 = ser.read()
        #leer2= ord(leer1)
        f.writelines(leer1)
        f.close()
        ventana.update()
    while Rutina3 == 0:
        print 'No hace nada la rutina3'
        time.sleep(0.5)
        ventana.update()
    while Rutina3==2:
        texto3 = open('rutina2.txt','r')
        linea3 = texto3.readlines()
        for elemento in linea3:
            print elemento
            envio3 = chr(elemento)
            ser.write(envio3)
            texto1.close()
        print'Reproduciendo grabacion 2'
        ventana.update()
    ventana.update()

    
        
    #ventana.update()

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
