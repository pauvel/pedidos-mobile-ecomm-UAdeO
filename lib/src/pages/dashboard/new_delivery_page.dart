import 'package:flutter/material.dart';
import 'package:pedidos_mobile/src/widgets/menu_general_widget.dart';

class NewDeliveryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(),
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.help, color: Colors.lightBlueAccent, size: 30.0), 
            onPressed: () => _showHelpDialog(context)
          )
        ],
      ),
      drawer: MenuGeneral(),
      body: Container(
        width: double.infinity,
        color: Colors.deepPurple,
        child: Column(
          children: [
            Image(
              image: AssetImage('assets/images/new-food.png'),
              fit: BoxFit.cover,
            ),
            Text('¿Abrir nuevo pedido?',textAlign: TextAlign.center, style: TextStyle(fontSize: 50, color: Colors.white, fontWeight: FontWeight.w700))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add, size: 50),
        onPressed: () => Navigator.pushNamed(context, 'shop'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: Colors.purple,
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.help, size: 100, color: Colors.lightBlueAccent),
                Text('PEDIDOS', style: TextStyle(fontSize: 40, fontWeight: FontWeight.w700, color: Colors.lightBlueAccent)),
                Divider(height: 10.0, color: Colors.white),
                SizedBox(height: 10),
                Text('¿Como funcionan?', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.white)),
                SizedBox(height: 10),
                Text('Si tocas el boton de crear un nuevo pedido, estaras notificando al sistema que tu cuenta esta en proceso de un nuevo pedido por lo tanto seras totalmente libre de seleccionar y agregar productos a tu carrito de compras para posteriormente finalizar el pedido y notificar al sistema que ya has completado tu pedido.',
                 textAlign: TextAlign.justify,
                 style: TextStyle(
                   fontSize: 15, 
                   fontWeight: FontWeight.w200, 
                   color: Colors.white)
                ),
                SizedBox(height: 5),
                Text('(Si no finalizas tu pedido y lo dejas abierto, seguira asi hasta ser finalizado).', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w200, color: Colors.white, fontStyle: FontStyle.italic)),
              ],
            ),
          ),
          actions: [
            RaisedButton.icon(
              color: Colors.deepPurple,
              icon: Icon(Icons.exit_to_app), 
              label: Text('Regresar...'),
              onPressed: () => Navigator.of(context).pop(), 
            )
          ],
        );
      },
    );
  }
}