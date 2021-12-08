import 'package:flutter/material.dart';

class AppDialog {

void openSessionFailDialog(BuildContext context){
    showDialog(
      context: context,
      barrierDismissible: false, // Cerrar alerta con tap afuera.
      builder: (context){
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          title: Text('Oops! Inicio de sesion incorrecto.', textAlign:  TextAlign.center),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(Icons.error, size: 100, color: Colors.red),
              SizedBox(height: 25),
              Text('Las credenciales con las que estas intentando acceder son incorrectas!', textAlign: TextAlign.center),
            ],
          ),
          actions: <Widget>[
            FlatButton(
              onPressed: () => Navigator.of(context).pop(), 
              child: Text('Ok'),
            )
          ],
        );
      }
    );
  } 

  void passwordNotMatchDialog(BuildContext context){
    showDialog(
      context: context,
      barrierDismissible: false, // Cerrar alerta con tap afuera.
      builder: (context){
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(Icons.error, size: 70, color: Colors.red),
              SizedBox(height: 25),
              Text('Ups!', textAlign: TextAlign.center, style: TextStyle(fontSize: 22)),
              Divider(),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Text('Los campos introducidos no coinciden, por favor verifica que sean iguales.', textAlign: TextAlign.justify),
              ),
            ],
          ),
          actions: <Widget>[
            FlatButton(
              onPressed: () => Navigator.of(context).pop(), 
              child: Text('Ok'),
            )
          ],
        );
      }
    );
  } 

  void userAlreadyExistsDialog(BuildContext context, Function goBack){
    Navigator.of(context).pop();
    showDialog(
      context: context,
      barrierDismissible: false, // Cerrar alerta con tap afuera.
      builder: (context){
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(Icons.error, size: 70, color: Colors.red),
              SizedBox(height: 25),
              Text('Numero telefonico ocupado!', textAlign: TextAlign.center, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              Divider(),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Text('El numero telefonico que proporcionaste ya existe, por favor verifica tus datos.', textAlign: TextAlign.justify),
              ),
            ],
          ),
          actions: <Widget>[
            FlatButton(
              onPressed: (){
                Navigator.of(context).pop();
                goBack(); // Callback para regresar hasta la primera pantalla.
              }, 
              child: Text('Aceptar'),
            )
          ],
        );
      }
    );
  } 

}