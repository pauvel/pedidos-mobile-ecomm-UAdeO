import 'package:flutter/services.dart';

/// 
/// lowercase letters : a-z
/// capital letters : A-Z
/// lowercase vowels accented : á-ú
/// capital vowels accented : Á-Ú
/// numbers : 0-9
/// space : (a space)
/// 
/// Ejemplo: [a-z A-Z á-ú Á-Ú 0-9]
/// 
class InputValidator {

  List<TextInputFormatter> _numeroTelefonico = [
    FilteringTextInputFormatter.digitsOnly, // Solo numeros.
    LengthLimitingTextInputFormatter(10)    // MaxLength 10.
  ];
  List<TextInputFormatter> _nombreDePersona = [
    FilteringTextInputFormatter.allow(RegExp("[a-z A-Z á-ú Á-Ú]")),
    LengthLimitingTextInputFormatter(45),
  ];

  List<TextInputFormatter> _nombreDeLocalidad = [
    FilteringTextInputFormatter.allow(RegExp("[a-z A-Z á-ú Á-Ú]")),
    LengthLimitingTextInputFormatter(25)
  ];

  List<TextInputFormatter> _nombreDeDireccion = [
    FilteringTextInputFormatter.allow(RegExp("[a-z A-Z á-ú Á-Ú]")),
    LengthLimitingTextInputFormatter(100)
  ];

  List<TextInputFormatter> _textoDePassword = [
    FilteringTextInputFormatter.allow(RegExp("[a-z A-Z á-ú Á-Ú 0-9]")),
    LengthLimitingTextInputFormatter(12)
  ];

  get validateTelefono       => _numeroTelefonico;
  get validateNombrePersona  => _nombreDePersona;
  get validateLocalidad      => _nombreDeLocalidad;
  get validateDireccion      => _nombreDeDireccion;
  get validatePassword       => _textoDePassword;
}