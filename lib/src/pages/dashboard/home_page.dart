import 'package:flutter/material.dart';
import 'package:pedidos_mobile/src/models/client_model.dart';
import 'package:pedidos_mobile/src/models/order_model.dart';
import 'package:pedidos_mobile/src/models/order_status_model.dart';
import 'package:pedidos_mobile/src/providers/appinfo.dart';
import 'package:pedidos_mobile/src/providers/order_provider.dart';
import 'package:pedidos_mobile/src/widgets/menu_general_widget.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
  final appInfo = Provider.of<AppInfo>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Mi perfil')
      ),
      drawer: MenuGeneral(),
      body: _contenido(context, appInfo)
    );
  }

  Widget _fondo(BuildContext context) {
    final size = MediaQuery.of(context).size;

   final fondoMorado = Container(
     height: size.height * 0.21,
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
     ],
   );
  }

  Widget _contenido(BuildContext context, AppInfo appInfo) {
    final size = MediaQuery.of(context).size; // size de la pantalla del dispositivo

    return SingleChildScrollView(
      child: Container(
         child: Stack(
           children: [
             _fondo(context),
              Column(
                children: [
                  _userProfileHeader(size, appInfo),
                  SizedBox(height: size.height * 0.01), // Separador de purple a blue.
                  _userData(appInfo),
                  SizedBox(height: 15.0, width: double.infinity),
                  _userHistory(context, appInfo),
                ],
              ),
           ],
         )
       ),
    );
  }

  Widget _userData(AppInfo appInfo) {
    /**
     *  Seccion De datos sobre las compras que ha hecho.
     */

    return StreamBuilder(
      stream: appInfo.clienteInfoStream,
      builder: (BuildContext context, AsyncSnapshot<ClientModel> snapshot){
        if( snapshot.hasData ){
          final client = snapshot.data;
          final ultimaVisita = client.ultVisita;
          String ultCompraString = (client.cantcompras == 0) ? 'Sin compras' : timeago.format(ultimaVisita, locale: 'es');

          appInfo.putClientFetchedData(client);
          return Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(5.0),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 3.0,
                  offset: Offset(0.0, 5.0),
                  spreadRadius: 3.0
                )    
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: Column(
                    children: [
                      Text('${client.cantcompras}', style: TextStyle(fontSize: 35, color: Colors.yellow)),
                      Text('Compras', style: TextStyle(fontSize: 18, color: Colors.white60))
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: Column(
                    children: [
                      Text(ultCompraString, style: TextStyle(fontSize: 18, color: Colors.yellow)),
                      Text('Ultima compra', style: TextStyle(fontSize: 18, color: Colors.white60))
                    ],
                  ),
                )
              ],
            ),
          );

        }else{
         return Container(height: 55, padding: EdgeInsets.all(10.0), child: CircularProgressIndicator());
        }
      },
    );
  }

 Widget _userHistory(BuildContext context, AppInfo appInfo) {
   /**
    *  Seccion de historial del cliente
    */
    return StreamBuilder(
      stream: appInfo.clienteOrdersStream,
      builder: (BuildContext context, AsyncSnapshot<List<OrderModel>> snapshot){
        if(snapshot.hasData){
        final orders = snapshot.data;
            return Container(
              child: Column(
                children: [
                  Icon(Icons.history, size: 80, color: Colors.cyan),
                  Text('Historial de compras', style: TextStyle(fontSize: 30)),
                  Divider(),
                  Column(
                    children: _loadOrders(context, orders),
                  ),
                ]
              ),
            );
        }else{
          /**
           *  Si el stream lanza error mostraremos que no tiene pedidos aun.
           */
          if(snapshot.hasError) return Container(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Icon(Icons.sentiment_very_dissatisfied, size: 70, color: Colors.red),
                SizedBox(height: 10),
                Text(snapshot.error, style: TextStyle(fontSize: 30, color: Colors.red))
              ],
            ),
          );
          /**
           *  Si aun no hay datos en el snapshot, entonces lanzamos circularprogressindicator.
           */
          return Container(
            height: 55,
            child: Padding(child: CircularProgressIndicator(), 
            padding: EdgeInsets.all(10)),
          );
        }
      },
    );
 }

 Widget _userProfileHeader(Size size, AppInfo appInfo){
   /**
    *  Seccion del perfil de usuario
    */
   return StreamBuilder(
     stream: appInfo.clienteInfoStream ,
     builder: (BuildContext context, AsyncSnapshot<ClientModel> snapshot){
       if(snapshot.hasData){
        final client = snapshot.data;
        return Container(
            child: Column(
              children: [
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    width: size.width * 0.22,
                    height: size.height * 0.10,
                    child: CircleAvatar(
                    backgroundImage: AssetImage('assets/images/profile.png'),
                    )
                  ),
                  SizedBox(height: 10.0, width: double.infinity),
                  Text(client.nombrecompleto, style: TextStyle(color: Colors.white, fontSize: 15.0)),
                  Text(client.id, style: TextStyle(color: Colors.white, fontSize: 15.0)),
              ],
            ),
          );
       }else{
         return Container(height: 55, padding: EdgeInsets.all(10.0), child: CircularProgressIndicator());
       }
     },
   );
 }

 List<Widget> _loadOrders(BuildContext context, List<OrderModel> orders) {
   return orders.map(( order ){ 
    return Container(
      padding: EdgeInsets.symmetric(vertical: 2, horizontal: 5),
      child: Card(
        elevation: 2,
        child: FutureBuilder(
          future: OrderProvider().getOrderStatus(order.clienteId, order.id),
          builder: (BuildContext context, AsyncSnapshot<OrderStatusModel> snapshot) {
            if(!snapshot.hasData) return Center(child: LinearProgressIndicator());
            final orderStatus = snapshot.data;
            return Container(
              padding: EdgeInsets.only(top: 7, bottom: 7),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Icon(Icons.delivery_dining, size: 50, color: Colors.orange)
                    ],
                  ),
                  Column(
                    children: [
                      Text('Pedido #${order.id}', style: TextStyle( fontSize: 25, fontWeight: FontWeight.w300 )),
                      SizedBox(height: 5),
                      Text('${order.fecha.day}/${order.fecha.month}/${order.fecha.year} - ${order.hora}', style: TextStyle(fontWeight: FontWeight.w300)),
                      SizedBox(height: 5),
                      Text('${orderStatus.estatus}', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.green))
                    ]
                  ),
                  Column(
                    children: [
                      IconButton(
                        icon: Icon(Icons.info, size: 30, color: Colors.blue), 
                        onPressed: (){
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: Text('Pedido #${order.id}', textAlign: TextAlign.center, style: TextStyle(color: Colors.blue)),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image.asset('assets/images/delivery-truck.png', height: 100),
                                  SizedBox(height: 5),
                                  Text(orderStatus.estatusDescription, textAlign: TextAlign.justify, style: TextStyle(fontWeight: FontWeight.w300))
                                ],
                              ),
                              actions: [
                                TextButton(
                                  child: Text('Comprobante'),
                                  // onPressed: () => _generateTicket(context, order.clienteId, order.id),
                                  onPressed: () => null,
                                ),
                                TextButton(
                                  child: Text('Ok'),
                                  onPressed: () => Navigator.of(context).pop()
                                ),
                              ],
                            )
                          );
                        }
                      )
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
   }).toList();
 }

  _generateTicket(BuildContext context, String clienteId, int orderId) {
    Navigator.of(context).pop();
    Navigator.pushNamed(context, 'ticket', arguments: {0: clienteId, 1: orderId});
  }
}