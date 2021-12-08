import 'package:flutter/material.dart';
import 'package:pedidos_mobile/src/providers/appinfo.dart';
import 'package:provider/provider.dart';
import 'package:pedidos_mobile/src/utils/inputs/input_validation_util.dart';
import 'package:pedidos_mobile/src/providers/client_provider.dart';
import 'package:pedidos_mobile/src/providers/login/logininfo.dart';

class LoginPage extends StatelessWidget {
  final clientProvier = new ClientProvider();
  final passwordController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
  final loginInfo = Provider.of<LoginInfo>(context);
  final appInfo = Provider.of<AppInfo>(context);

    return Scaffold(
      body: Stack(
        children: [
          _crearFondo(context),
          _loginForm(context, loginInfo, appInfo)
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
             Icon(Icons.fastfood, color: Colors.white, size: 100.0),
             SizedBox(height: 10.0, width: double.infinity),
             Text('Pedidos Mobile v1', style: TextStyle(color: Colors.white, fontSize: 25.0))
           ],
         ),
       )
     ],
   );
 }

  Widget  _loginForm(BuildContext context, LoginInfo bloc, AppInfo appInfo) {
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
            child: StreamBuilder(
              stream: bloc.loginState ,
              builder: (BuildContext context, AsyncSnapshot snapshot){
                return Column(
                  children: [
                    Text('Ingreso', style: TextStyle(fontSize: 20.0)),
                    SizedBox(height: 8.0),
                    _loginState(bloc),
                    SizedBox(height: 15.0),
                    _crearTelefono(bloc),
                    SizedBox(height: 15.0),
                    _crearPassword(bloc),
                    SizedBox(height: 30.0),
                    _crearBoton(context, bloc, appInfo),
                    SizedBox(height: 5.0),
                    _olvidePassword(),
                  ],
                );
              },
            ),
          ),
          Text('No tienes una cuenta?'),
          SizedBox(height: 7.0),
          _crearBotonRegistro(context),
          SizedBox(height: 100.0)
        ],
      ),
    );
  }

  Widget _crearTelefono(LoginInfo bloc) {
    return StreamBuilder(
      stream: bloc.telefonoStream,
      builder: (BuildContext context, AsyncSnapshot snapshot){
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
            inputFormatters: InputValidator().validateTelefono,
            keyboardType: TextInputType.phone,
            onChanged: bloc.changeTelefono,
            decoration: InputDecoration(
              icon: Icon(Icons.phone, color: Colors.deepPurple),
              hintText: '(000) 000-0000',
              labelText: 'Numero telefonico',
              errorText: snapshot.error
            ),
          ),
        );
      },
    );
  }

  Widget _crearPassword(LoginInfo bloc) {
    return StreamBuilder(
      stream: bloc.passwordStream ,
      builder: (BuildContext context, AsyncSnapshot snapshot){
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
            obscureText: true,
            onChanged: bloc.changePassword,
            inputFormatters: InputValidator().validatePassword,
            controller: passwordController,
            decoration: InputDecoration(
              icon: Icon(Icons.lock_outline, color: Colors.deepPurple),
              labelText: 'Contraseña',
              errorText: snapshot.error
            ),
          ),
        );
      },
    );
  }

  Widget _crearBoton(BuildContext context, LoginInfo bloc, AppInfo appInfo) {

    return StreamBuilder(
      stream: bloc.validateFormStream ,
      builder: (BuildContext context, AsyncSnapshot snapshot){
        return RaisedButton(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 80.0),
            child: Text('Ingresar'),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0)
          ),
          elevation: 0.0,
          color: Colors.deepPurple,
          textColor: Colors.white,
          onPressed: snapshot.hasData ? () => _access(context, bloc, appInfo) : null
        );
      },
    );


  }

  Widget _crearBotonRegistro(BuildContext context){
    return RaisedButton(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 80.0),
        child: Text('Crear'),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0)
      ),
      elevation: 0.0,
      color: Colors.green,
      textColor: Colors.white,
      onPressed: () => Navigator.pushNamed(context, 'register'),
    );
  }

  ///
  /// Al presionar el boton [Ingresar] ejecutara este metodo
  /// El cual cambiara el estado del login poniendo un CircularProgressBar
  /// Indicando que esta conectandose y validando las credenciales
  /// Una vez obtenida la respuesta del servidor, si este fue [true] entonces dirigiremos a home,
  /// si la respuesta fue [false] Mostraremos texto de error.
  ///
  _access(BuildContext context, LoginInfo bloc, AppInfo appInfo) async {
    final password = bloc.password;
    final telefono = bloc.telefono;

    bloc.changePassword(''); // Limpiamos el stream para deshabilitar el boton ingresar.
    passwordController.clear(); // Limpiamos el input password.
    FocusScope.of(context).unfocus(); // Quitamos todos los focus.
    bloc.changeState(Container(height: 55, padding: EdgeInsets.all(10.0), child: CircularProgressIndicator()));
      // Se le puso timer para poder ver la funcionalidad. debido a que el servidor response demasiado veloz.
    final authenticated = await clientProvier.validateSession(telefono, password);
    bloc.changeState(Container());
    if(authenticated){
      appInfo.putClientOrderData(telefono);
      appInfo.putClientData(telefono);
      bloc.dispose();
      Navigator.pushReplacementNamed(context, 'home');
    }else{
      bloc.changeState(Text('Telefono o contaseña incorrectos.', style: TextStyle(color: Colors.red, fontSize: 15.0 ) ));
    }
  }

  /* 
   *  =====  Maneja el estado del login =====
   *  Muestra los avisos necesarios para el estado del inicio de sesion
   *  @param: Recibe el Widget de aviso que queremos poner al top del login.
   */
  Widget _loginState(LoginInfo bloc) {
    if(bloc.estado==null) return Container();
    return bloc.estado;
  }

  Widget _olvidePassword() {
    return FlatButton(
      child: Text('Olvide mi contraseña', style: ThemeData().textTheme.caption),
      onPressed: (){} 
    );
  }

}