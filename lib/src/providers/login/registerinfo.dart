import 'dart:async';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart' as rx;

class RegisterInfo with ChangeNotifier, RegisterFormValidator {
  // Streams
  final _registerStateController  = rx.BehaviorSubject<Widget>();
  final _telefonoController       = rx.BehaviorSubject<String>();
  final _nombreCompletoController = rx.BehaviorSubject<String>();
  final _password1Controller      = rx.BehaviorSubject<String>();
  final _password2Controller      = rx.BehaviorSubject<String>();

  // Recuperar datos del stream
  Stream<Widget> get registerState    => _registerStateController.stream;
  Stream<String> get telefonoStream   => _telefonoController.stream.transform(validarTelefono);
  Stream<String> get nombreStream     => _nombreCompletoController.stream.transform(validarNombre);
  Stream<String> get password1Stream  => _password1Controller.stream.transform(validarPassword1);
  Stream<String> get password2Stream  => _password2Controller.stream.transform(validarPassword2);
  Stream<bool>   get validateFormStream => rx.CombineLatestStream
                    .combine4(telefonoStream, nombreStream, password1Stream, password2Stream, (a , b, c, d) => true);
  // Data actual
  Widget get estado     => _registerStateController.value;
  String get nombre     => _nombreCompletoController.value;
  String get telefono   => _telefonoController.value;
  String get password1  => _password1Controller.value;
  String get password2  => _password2Controller.value;

  // Insertar valores al Stream
  Function(Widget) get changeState       => _registerStateController.sink.add;
  Function(String) get changeTelefono     => _telefonoController.sink.add;
  Function(String) get changeNombre       => _nombreCompletoController.sink.add;  // Cambiar estado de los avisos del login.
  Function(String) get changePassword1    => _password1Controller.sink.add;
  Function(String) get changePassword2    => _password2Controller.sink.add;

  // ignore: must_call_super
  dispose(){
    _registerStateController?.close();
    _nombreCompletoController?.close();
    _telefonoController?.close();
    _password1Controller?.close();
    _password2Controller?.close();
  }
}

class RegisterFormValidator {

  final validarTelefono = StreamTransformer<String, String>.fromHandlers(
    handleData: (telefono, sink) {
      if(telefono.length< 10){
        sink.addError('Debe tener almenos 10 digitos.');
      }else{
        sink.add(telefono);
      }
    }
  );

  final validarNombre = StreamTransformer<String, String>.fromHandlers(
    handleData: (nombre, sink){
      if(nombre.length < 12){
        sink.addError('Debe tener almenos 12 caracteres.');
      }else{
        sink.add(nombre);
      }
    }
  );

  final validarPassword1 = StreamTransformer<String, String>.fromHandlers(
    handleData: (password, sink) {
      if(password.length < 6){
        sink.addError('Debe tener almenos 6 caracteres.');
      }else{
        sink.add(password);
      }
    },
  );

    final validarPassword2 = StreamTransformer<String, String>.fromHandlers(
    handleData: (password, sink) {
      if(password.length < 6){
        sink.addError('Debe tener almenos 6 caracteres.');
      }else{
        sink.add(password);
      }
    },
  );
}