import 'dart:async';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart' as rx;

class LoginInfo with ChangeNotifier, LoginInfoValidator {

  final _loginStateController   = rx.BehaviorSubject<Widget>();
  final _telefonoController     = rx.BehaviorSubject<String>();
  final _passwordController     = rx.BehaviorSubject<String>();
  // Recuperar datos del Stream
  Stream<Widget> get loginState         => _loginStateController.stream; // Stream de los widgets de avisos al login.
  Stream<String> get telefonoStream     => _telefonoController.stream.transform(validarTelefono);
  Stream<String> get passwordStream     => _passwordController.stream.transform(validarPassword);
  Stream<bool>   get validateFormStream => rx.CombineLatestStream.combine2(telefonoStream, passwordStream, (a, b) => true);
  // Data actual
  Widget get estado => _loginStateController.value; // Estado de los avisos del login.
  String get telefono => _telefonoController.value;
  String get password => _passwordController.value;
  // Insertar valores al Stream
  Function(Widget) get changeState      => _loginStateController.sink.add;  // Cambiar estado de los avisos del login.
  Function(String) get changeTelefono    => _telefonoController.sink.add;
  Function(String) get changePassword    => _passwordController.sink.add;

  
  // ignore: must_call_super
  dispose(){
    _loginStateController?.close();
    _telefonoController?.close();
    _passwordController?.close();
  }
}

class LoginInfoValidator {
  
  final validarTelefono = StreamTransformer<String, String>.fromHandlers(
    handleData: (telefono, sink) {
      if(telefono.length < 10){
        sink.addError('Debe tener almenos 10 digitos.'); // Si es menor a 10 digitos siempre envia error, nunca texto.
      }else{
        sink.add(telefono); // Enviando texto.
      }
    }
  );

    final validarPassword = StreamTransformer<String, String>.fromHandlers(
    handleData: (password, sink) {
      if(password.length < 4){
        sink.addError('No dejar vacio este campo.'); // Si es menor a 5 nunca envia texto, solo error.
      }else{
        sink.add(password); // Enviando texto.
      }
    }
  );

}