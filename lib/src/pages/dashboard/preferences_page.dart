import 'package:flutter/material.dart';
import 'package:pedidos_mobile/src/providers/login/logininfo.dart';
import 'package:pedidos_mobile/src/widgets/menu_general_widget.dart';
import 'package:provider/provider.dart';

class PreferencesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
  final loginData = Provider.of<LoginInfo>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Productos favoritos'),
      ),
      drawer: MenuGeneral(),
      body: Center(
        child: Column(
          children: [
            Text(' Telefono: ${loginData.telefono}'),
          ],
        ),
      ),
    );
  }
}