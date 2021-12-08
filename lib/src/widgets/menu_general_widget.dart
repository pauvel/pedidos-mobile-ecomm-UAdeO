import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MenuGeneral extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        // padding: EdgeInsets.zero,
        children: [
          _menuHeader(),
          _inicioOption(context),
          Divider(height: 5),
          _verMenuDeProductosOption(context),
          Divider(height: 5),
          _abrirPedidoOption(context),
          Divider(height: 5),
          Spacer(),
          _cerrarApp(context),
        ],
      ),
    );
  }

  Widget _menuHeader() {
    return DrawerHeader(
      child: Container(),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/menubg.png'),
          fit: BoxFit.cover
        )
      ),
    );
  }

  Widget _inicioOption(BuildContext context) {
    return ListTile(
      title: Text('Mi perfil', style: TextStyle(fontSize: 18.0)),
      leading: Icon(Icons.home, color: Colors.deepPurple, size: 30.0),
      onTap: () => Navigator.pushReplacementNamed(context, 'home'),
    );
  }

  Widget _verMenuDeProductosOption(BuildContext context) {
    return ListTile(
      title: Text('Catalogo de productos', style: TextStyle(fontSize: 18.0)),
      leading: Icon(Icons.list, color: Colors.deepPurple, size: 30.0),
      onTap: () => Navigator.pushReplacementNamed(context, 'catalog'),
    );
  }

  Widget _abrirPedidoOption(BuildContext context) {
    return ListTile(
      title: Text('Nuevo pedido', style: TextStyle(fontSize: 18.0)),
      leading: Icon(Icons.add, color: Colors.deepPurple, size: 30.0),
      onTap: () => Navigator.pushReplacementNamed(context, 'newdelivery'),
    );
  }

  Widget _cerrarApp(BuildContext context) {
    return ListTile(
      tileColor: Colors.redAccent,
      title: Text('Cerrar aplicacion', style: TextStyle(fontSize: 18.0, color: Colors.white)),
      leading: Icon(Icons.cancel_sharp, color: Colors.white, size: 30.0),
      onTap: () => SystemChannels.platform.invokeMethod('SystemNavigator.pop'),
    );
  }

}