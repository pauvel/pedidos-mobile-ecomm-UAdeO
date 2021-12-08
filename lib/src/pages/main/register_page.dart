import 'package:flutter/material.dart';
import 'package:pedidos_mobile/src/models/client_model.dart';
import 'package:pedidos_mobile/src/providers/appinfo.dart';
import 'package:pedidos_mobile/src/providers/client_provider.dart';
import 'package:pedidos_mobile/src/providers/login/registerinfo.dart';
import 'package:pedidos_mobile/src/utils/inputs/input_validation_util.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final formKey = GlobalKey<FormState>();
  final clientModel = new ClientModel();

  @override
  Widget build(BuildContext context) {
  final registerInfo = Provider.of<RegisterInfo>(context);
  final appInfo = Provider.of<AppInfo>(context);


    return Scaffold(
      body: Stack(
        children: [
          _crearFondo(context),
          _registerForm(context, registerInfo, appInfo)
        ],
      )
    );
  }

  Widget _crearFondo(BuildContext context) {
   final size = MediaQuery.of(context).size;

   final fondoMorado = Container(
     height: size.height * 0.4,
     width: double.infinity,
     decoration: BoxDecoration(
       color: Colors.deepPurple
     ),
   );

  final circulo = Container(
    width: 100.0,
    height: 100.0,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(100.0),
      color: Color.fromRGBO(255, 255, 255, 0.05)
    ),
  );

   return Stack(
     children: [
       fondoMorado,
       Positioned( child: circulo, top: 90.0, left: 30.0),
       Positioned( child: circulo, top: -40.0, right: 30.0),
       Positioned( child: circulo, bottom: -50.0, right: -10.0),
       Positioned( child: circulo, bottom: 120.0, right: 20.0),
       Positioned( child: circulo, bottom: -50.0, left: -20.0),
       Container(
         padding: EdgeInsets.only(top: 80.0),
         child: Column(
           children: [
             Icon(Icons.star, color: Colors.white, size: 100.0),
             SizedBox(height: 10.0, width: double.infinity),
             Text('Unete a Pedidos mobile!', style: TextStyle(color: Colors.white, fontSize: 25.0))
           ],
         ),
       )
     ],
   );
 }

 Widget _registerForm(BuildContext context, RegisterInfo registerBloc, AppInfo appInfo) {
  final size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        children: [
          SafeArea(
            child: Container(
              height: size.height * 0.25, // 20% de la pantalla a vertical.
            ),
          ),
          Container(
            width: size.width * 0.85,
            padding: EdgeInsets.symmetric(vertical: 20.0),
            margin: EdgeInsets.symmetric(vertical: 20.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5.0),
              boxShadow: <BoxShadow> [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 3.0,
                  offset: Offset(0.0, 5.0),
                  spreadRadius: 3.0
                )                
              ]
            ),
            child: Form(
              key: formKey,
              child: StreamBuilder(
                stream: registerBloc.registerState,
                builder: (BuildContext context, AsyncSnapshot snapshot){
                return Column(
                  children: [
                    Text('Complete los campos', style: TextStyle(fontSize: 20.0)),
                    SizedBox(height: 5.0),
                    _registerStateController(registerBloc),
                    SizedBox(height: 15.0),
                    _inputTelefono(context, registerBloc),
                    SizedBox(height: 5.0),
                    _inputNombrePersona(context, registerBloc),
                    SizedBox(height: 5.0),
                    _inputPassword(context, registerBloc),
                    SizedBox(height: 5.0),
                    _inputRepeatPassword(context, registerBloc),
                    SizedBox(height: 15.0),
                    _rowBotones(context, registerBloc, appInfo),
                  ]
                );
               }
              )
            )
          )
        ],
      ),
    );
 }

 Widget _inputTelefono(BuildContext context, RegisterInfo registerBloc) {
   return StreamBuilder(
     stream: registerBloc.telefonoStream ,
     builder: (BuildContext context, AsyncSnapshot snapshot){
      return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextFormField(
            onSaved: (telefono) => clientModel.id = telefono,
            inputFormatters: InputValidator().validateTelefono,
            keyboardType: TextInputType.phone,
            onChanged: registerBloc.changeTelefono,
            decoration: InputDecoration(
              icon: Icon(Icons.phone, color: Colors.deepPurple),
              hintText: '(000) 000-0000',
              labelText: 'Numero telefonico',
              errorText: snapshot.error
            ),
            validator: (e) => e.length < 10 ? 'Debe tener almenos 10 digitos.' : null,
          ),
        ); 
     },
   );
 }

 Widget _inputNombrePersona(BuildContext context, RegisterInfo registerBloc) {
   return StreamBuilder(
     stream: registerBloc.nombreStream,
     builder: (BuildContext context, AsyncSnapshot snapshot){
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextFormField(
            onSaved: (nombre) => clientModel.nombrecompleto = nombre,
            inputFormatters: InputValidator().validateNombrePersona,
            onChanged: registerBloc.changeNombre,
            decoration: InputDecoration(
              icon: Icon(Icons.person, color: Colors.deepPurple),
              hintText: 'Bill Gates L.',
              labelText: 'Nombre completo',
              errorText: snapshot.error
            ),
            validator: (e) => e.length < 12 ? 'Debe tener almenos 12 caracteres.' : null,
          ),
        );
     },
   );
 }

 Widget _inputPassword(BuildContext context, RegisterInfo registerBloc) {
   return StreamBuilder(
     stream: registerBloc.password1Stream,
     builder: (BuildContext context, AsyncSnapshot snapshot){
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextFormField(
            onSaved: (pass) => clientModel.password = pass,
            obscureText: true,
            autocorrect: false,
            inputFormatters: InputValidator().validatePassword,
            onChanged: registerBloc.changePassword1,
            decoration: InputDecoration(
              errorText: snapshot.error,
              icon: Icon(Icons.lock_outline, color: Colors.deepPurple),
              labelText: 'Contraseña',
            ),
            validator: (e){
              final password2 = registerBloc.password2;
              if(password2 != e.trim()){
                return 'Las contraseñas no coinciden.';
              }else{
                return null;
              }
            },
          ),
        );
     },
   );
 }

 Widget _inputRepeatPassword(BuildContext context, RegisterInfo registerBloc) {
   return StreamBuilder(
     stream: registerBloc.password2Stream,
     builder: (BuildContext context, AsyncSnapshot snapshot){
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextFormField(
            obscureText: true,
            autocorrect: false,
            inputFormatters: InputValidator().validatePassword,
            onChanged: registerBloc.changePassword2,
            decoration: InputDecoration(
              errorText: snapshot.error,
              icon: Icon(Icons.lock, color: Colors.deepPurple),
              labelText: 'Repetir contraseña',
            ),
            validator: (e){
              final password1 = registerBloc.password1;
              if(password1 != e.trim()){
                return 'Las contraseñas no coinciden.';
              }else{
                return null;
              }
            },
          ),
        );
     },
   );
 }

 Widget _rowBotones(BuildContext context, RegisterInfo registerBloc, AppInfo appInfo) {
   return Row(
     mainAxisAlignment: MainAxisAlignment.center,
     children: [
      Expanded(child: Container()),
      Container(
        child: RaisedButton.icon(
           onPressed: () => Navigator.pop(context), 
           icon: Icon(Icons.arrow_back), 
           label: Text('Regresar'),
           color: Colors.red,
           textColor: Colors.white,
        ),
      ),
      Expanded(child: Container()),
      StreamBuilder(
        stream: registerBloc.validateFormStream,
        builder: (BuildContext context, AsyncSnapshot snapshot){
          return Container(
            child: RaisedButton.icon(
              onPressed: snapshot.hasData ? () => _registerClient(context, registerBloc, appInfo) : null, 
              icon: Icon(Icons.add), 
              label: Text('Registrarme'),
              color: Colors.deepPurple,
              textColor: Colors.white
            ),
          );
        },
      ),
      Expanded(child: Container()),
     ],
   );
 }

  _registerClient(BuildContext context, RegisterInfo registerBloc, AppInfo appInfo) async {
    // Si la validacion es false del formulario solo retornamos.
    if(!formKey.currentState.validate()) return;
    FocusScope.of(context).unfocus(); // Quitamos todos los focus.
    formKey.currentState.save(); // Guardamos el estado del form con sus values.
    registerBloc.changeState(Container(height: 55, padding: EdgeInsets.all(10.0), child: CircularProgressIndicator()));
    final r = await ClientProvider().postNewClient(clientModel);
    if(r){
      // Insertado
      appInfo.putClientData(clientModel.id);
      appInfo.putClientOrderData(clientModel.id);
      registerBloc.changeState(Container());
      registerBloc.dispose();
      Navigator.pushReplacementNamed(context, 'home');
    }else{
      // No insertado
      registerBloc.changeState(Text('El numero telefonico ya existe.', style: TextStyle(color: Colors.red, fontSize: 15.0 ) ));
    }
  }

 Widget _registerStateController(RegisterInfo registerBloc) {
   if(registerBloc.estado == null) return Container();
   return registerBloc.estado;
 }
}