import 'package:flutter/material.dart';
import 'package:pedidos_mobile/src/models/product_sqlite_model.dart';
import 'package:pedidos_mobile/src/providers/appinfo.dart';
import 'package:pedidos_mobile/src/providers/db_provider.dart';
import 'package:pedidos_mobile/src/providers/order_provider.dart';
import 'package:pedidos_mobile/src/providers/shop/add_shop.dart';
import 'package:provider/provider.dart';

class ConfirmPage extends StatefulWidget {

  @override
  _ConfirmPageState createState() => _ConfirmPageState();
}

class _ConfirmPageState extends State<ConfirmPage> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final addShopInfo = Provider.of<AddShopInfo>(context);
    final appInfo = Provider.of<AppInfo>(context);
    final _commentController = TextEditingController(text: addShopInfo.actualOrderComment);
    addShopInfo.putshopcartItemsForTotal(addShopInfo.actualShopCart);

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        label: Text(
          'Finalizar'
        ),
        onPressed: ()async{
          await _finishOrder(addShopInfo, appInfo);
        }, 
      ),
      body: Stack(
        children: [
          _backgroundTitle(),
          _titleText(context),
          _orderDetails(addShopInfo),
          SingleChildScrollView(
            child: Column(
              children: [
                SafeArea(
                  child: Container(
                    height: size.height * 0.32,
                  ),
                ),
                _addComments(addShopInfo, _commentController),
                _deliveryOptions(context, addShopInfo),
              ],
            ),
          )
        ],
      ),
    );
  }

  Container _orderDetails(AddShopInfo addShopInfo) {
    return Container(
        margin: EdgeInsets.only(top: 100),
        padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
        child: Card(
          color: Colors.white,
          elevation: 10,
          child: StreamBuilder<double>(
            stream: addShopInfo.shopcartToal,
            builder: (context, AsyncSnapshot<double> snapshot) {
              if(snapshot.hasData){
                final total = snapshot.data;
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _subTotal(total),
                    _taxes(),
                    _deliveryCost(),
                    Divider(),
                    _totalCost(total),
                  ],
                );
              }
              return Center(child: LinearProgressIndicator());
            }
          )
        ),
    );
  }

  Container _addComments(AddShopInfo addShopInfo, TextEditingController commentController) {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
        child: Card(
          color: Colors.white,
          elevation: 10,
          child: Column(
            children: [
              Container(
                color: Colors.blue,
                width: double.infinity,
                padding: EdgeInsets.only(left: 15, right: 15, top: 15),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Column(
                      children: [
                        Text('Comentarios (opcional)', style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.w300)),
                        Divider(),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: commentController,
                  keyboardType: TextInputType.multiline,
                    onChanged: (e) => addShopInfo.putOrderComment(e),
                    maxLength: 255,
                    maxLines: null,
                    autocorrect: true,
                    decoration: InputDecoration(
                      icon: Icon(Icons.comment),
                      hintText: 'Escriba aqui su comentario.',
                      helperText: 'Agregue un comentario a su pedido.',
                    ),
                )
              )
            ],
          )
        ),
    );
  }

  Widget _deliveryOptions(BuildContext context, AddShopInfo addShopInfo) {
    return StreamBuilder<bool>(
      stream: addShopInfo.confirmDirectionStream,
      builder: (_, AsyncSnapshot<bool> snapshot) {
        if(snapshot.hasData){
          bool confirmDirection = snapshot.data;
          final String msj = confirmDirection ? 'Este pedido es a domicilio.' : 'Realizar pedido y pasar a recogerlo.';

          return Container(
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
              child: Card(
                color: Colors.white,
                elevation: 10,
                child: Column(
                  children: [
                    Container(
                      color: Colors.blue,
                      width: double.infinity,
                      padding: EdgeInsets.only(left: 15, right: 15, top: 15),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Column(
                            children: [
                              Text('Opciones de entrega', style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.w300)),
                              Divider(),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SwitchListTile(
                      value: confirmDirection, 
                      onChanged: (e) => addShopInfo.putConfirmDirection(e),
                      title: Text(msj),
                    ),
                    RaisedButton.icon(
                      color: Colors.green,
                      textColor: Colors.white,
                      icon: Icon(Icons.add_location), 
                      label: Text('Establecer direccion de entrega'),
                      onPressed: confirmDirection ? () => _setDirection(context) : null
                    ),
                    Column(
                      children: [
                        Text('Direccion de entrega', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300)),
                        Text(
                          '${addShopInfo.actualLocationAddress}',
                          textAlign: TextAlign.center, 
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w300, fontStyle: FontStyle.italic))
                      ],
                    )
                  ],
                )
              ),
          );
        }
        return Center(child: LinearProgressIndicator());
      }
    );
  }

  Container _totalCost(double total) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Row(
          children: [
            Column(
              children: [
                Text('Total', style: TextStyle(fontSize: 30)),
              ],
            ),
            Spacer(),
            Column(
              children: [
                Text('\$$total', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 23, color: Colors.green)),
              ],
            )
          ],
        ),
    );
  }

  Container _deliveryCost() {
    return Container(
      padding: EdgeInsets.only(left: 15, right: 15, top: 5),
      child: Row(
        children: [
          Column(
            children: [
              Text('Costo de envio', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300)),
            ],
          ),
          Spacer(),
          Column(
            children: [
              Text('Gratis', style: TextStyle(fontWeight: FontWeight.w300, fontSize: 17, color: Colors.grey)),
            ],
          )
        ],
      ),
    );
  }

  Container _taxes() {
    return Container(
      padding: EdgeInsets.only(left: 15, right: 15, top: 5),
      child: Row(
        children: [
          Column(
            children: [
              Text('Impuestos', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300)),
            ],
          ),
          Spacer(),
          Column(
            children: [
              Text('I.V.A Incluido', style: TextStyle(fontWeight: FontWeight.w300, fontSize: 17, color: Colors.grey)),
            ],
          )
        ],
      ),
    );
  }

  Container _subTotal(double total) {
    return Container(
      padding: EdgeInsets.only(left: 15, right: 15, top: 15),
      child: Row(
        children: [
          Column(
            children: [
              Text('Subtotal', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300)),
            ],
          ),
          Spacer(),
          Column(
            children: [
              Text('\$$total', style: TextStyle(fontWeight: FontWeight.w300, fontSize: 17, color: Colors.grey)),
            ],
          )
        ],
      ),
    );
  }

  Row _titleText(BuildContext context) {
    return Row(
      children: [
        Container(
          margin: EdgeInsets.only(top: 40, left: 20),
          color: Colors.transparent,
          child: Card(
            color: Colors.transparent,
            elevation: 0,
            child: Text('Confirmar pedido', style: TextStyle(fontSize: 40, fontWeight: FontWeight.w700, color: Colors.white)),
          )
        ),
        Spacer(),
      ],
    );
  }

  Container _backgroundTitle() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(100), bottomRight: Radius.circular(100), )
      ),
    );
  }

  _setDirection(BuildContext context){
    Navigator.pushNamed(context, 'mapbox');
  }

  _finishOrder(AddShopInfo addShopInfo, AppInfo appInfo) async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_){
        return Center(child: LinearProgressIndicator());
      } 
    );
    ///
    ///*** */
    /// Este metodo recolecta todos los datos para crear un nuevo pedido.
    ///
    ///
    double total = 0.0;
    String comment = (addShopInfo.actualOrderComment == null) ? 'Sin comentarios' : addShopInfo.actualOrderComment;
    int entrega = (addShopInfo.actualConfirmDirection) ? 2 : 1;
    String localizacion = (addShopInfo.actualLocation!=null) ? '${addShopInfo.actualLocation.latitude},${addShopInfo.actualLocation.longitude}' : 'No disponible';
    String ubicacion = (addShopInfo.actualLocationAddress!=null) ? addShopInfo.actualLocationAddress : 'No disponible';

    List<Map<String, dynamic>> detalles = new List<Map<String, dynamic>>();
    for (ProductModelSqlite product in addShopInfo.actualShopCart) {
      final ingredients = await DBProvider.db.getProductDetail(product.sqliteId);
      final price = product.size == 0 ? product.precioch : product.preciog;
      final import = price * product.cantidad;
      total+=import;
      final ingMapped = ingredients.map(( ingredient ) {
        return ingredient.nombre;
      }).toList();
      detalles.add({
        "pedido_id": null,
        "platillo_id": product.id,
        "precio": price,
        "cantidad": product.cantidad,
        "importe": import,
        "ingredientes": ingMapped.join(', ')
      });
    }

    final fullOrder = {
      "cliente_id": appInfo.clientActualData.id,
      "importe": total,
      "fecha": '${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}',
      "hora": '${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}',
      "entrega": entrega,
      "localizacion": localizacion,
      "ubicacion": ubicacion,
      "comentario": comment,
    };
    Navigator.of(context).pop();
    showDialog(
      context: context,
      builder: (_){
       return AlertDialog(
            title: Text('¿Finalizar pedido?', textAlign: TextAlign.center),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check_circle, size: 70, color: Colors.green),
                SizedBox(height: 10),
                Text('Su pedido sera enviado a nuestra sucursal y sera puesto en espera para proceder a ser cocinado ¿Desea continuar?', textAlign: TextAlign.justify)
              ],
            ),
            actions: [
              TextButton(onPressed: () => createNewOrder(addShopInfo, context, fullOrder, detalles), child: Text('Si')),
              TextButton(onPressed: () => Navigator.of(context).pop(), child: Text('No')),
            ],
          );
      } 
    );
  }

  createNewOrder(AddShopInfo addShopInfo, BuildContext context, Map<String, Object> fullOrder, List<Map<String, dynamic>> detalles) async{
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) {
        return Center(child: LinearProgressIndicator());
      }
    );
    final res = await OrderProvider().createOrder(fullOrder, detalles);
    if(res){
      final isDeleted = await DBProvider.db.purgeDb();
      if(isDeleted){
        addShopInfo.resetStreams();
        Navigator.of(context).pushReplacementNamed('home');
      }
    }
  }
}