import 'package:flutter/material.dart';
import 'package:pedidos_mobile/src/models/ingredientes_model.dart';
import 'package:pedidos_mobile/src/models/product_sqlite_model.dart';
import 'package:pedidos_mobile/src/providers/db_provider.dart';
import 'package:pedidos_mobile/src/providers/shop/add_shop.dart';
import 'package:provider/provider.dart';

class ShopCart extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final addShopinfo = Provider.of<AddShopInfo>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Mi carrito de compras'),
      ),
      body: Column(
        children: [
          SizedBox(height: 10),
          Container(
            width: double.infinity,
            margin: EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  blurRadius: 2,
                  color: Colors.black45,
                  spreadRadius: 2
                )
              ]
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image(
                  image: AssetImage('assets/images/searchbox.png'),
                  height: 70,
                  width: 70,
                ),
                StreamBuilder(
                  stream: addShopinfo.shopCartStream,
                  builder: (context, AsyncSnapshot<List<ProductModelSqlite>> snapshot) {
                    if(snapshot.hasData){
                      if(snapshot.data.length == 0){
                        return Center(
                          child: Text('CARRITO VACIO', style: TextStyle(fontSize: 40, fontWeight: FontWeight.w300, color: Colors.deepPurple)),
                        );
                      }
                      double total = 0;
                      for (ProductModelSqlite product in snapshot.data) {
                        if(product.size == 0) total+=product.precioch * product.cantidad;
                        if(product.size == 1) total+=product.preciog * product.cantidad;
                      }
                      return Text(
                        '\$$total',
                        style: TextStyle(fontSize: 25, fontWeight: FontWeight.w300, color: Colors.deepPurple),
                      );
                    }
                    return Center(child: LinearProgressIndicator());
                  }
                )
              ],
            ),
          ),
          Expanded(child: _ShopCartItems(addShopinfo: addShopinfo)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          if(addShopinfo.actualShopCart.length == 0)  _noProductsDialog(context);
          if(addShopinfo.actualShopCart.length > 0) _newOrderDialog(context);
        },
        child: Icon(Icons.done),
        tooltip: 'Finalizar pedido.',
      ),
    );
  }

  _noProductsDialog(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => _ShopCartNoItemsAlert(),
    );
  }

  _newOrderDialog(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => _ShopCartNewOrderDialog(),
    );
  }
}

class _ShopCartNewOrderDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final addShopinfo = Provider.of<AddShopInfo>(context);

    return AlertDialog(
      titlePadding: EdgeInsets.all(0),
      title: Container(
        width: double.infinity,
        color: Colors.green,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle, color: Colors.white70, size: 60)
          ],
        )
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          StreamBuilder(
            stream: addShopinfo.shopCartStream,
            builder: (_, AsyncSnapshot<List<ProductModelSqlite>> snapshot) {
              if(snapshot.hasData){
                double total = 0;
                for (ProductModelSqlite product in snapshot.data) {
                  if(product.size == 0) total+=product.precioch * product.cantidad;
                  if(product.size == 1) total+=product.preciog * product.cantidad;
                }
                return Column(
                  children: [
                    Text(
                      'Usted cuenta con ${addShopinfo.actualShopCart.length} '
                      'elementos en su carrito de compras lo cual genera un importe total de \$$total '
                      '¿Desea usted realizar su pedido ahora?',
                      textAlign: TextAlign.justify,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 0, vertical: 25),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          RaisedButton.icon(
                            onPressed: () => Navigator.of(context).pop(), 
                            icon: Icon(Icons.cancel), 
                            label: Text('No'),
                            color: Colors.red,
                            textColor: Colors.white70,
                          ),
                          RaisedButton.icon(
                            onPressed: () {
                              Navigator.of(context).pop();
                              return Navigator.pushNamed(context, 'confirmorder', arguments: total);
                            }, 
                            icon: Icon(Icons.check), 
                            label: Text('Si'),
                            color: Colors.green,
                            textColor: Colors.white70,
                          ),
                        ],
                      ),
                    )
                  ],
                );
              }
              return Center(child: CircularProgressIndicator());
            }
          )
        ],
      ),
    );
  }
}

class _ShopCartNoItemsAlert extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Container(
        color: Colors.red,
        width: double.infinity,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.remove_shopping_cart, color: Colors.white70, size: 25),
          ],
        ),
      ),
      titlePadding: EdgeInsets.all(0),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.warning, color: Colors.red, size: 100),
          SizedBox(height: 15),
          Text(
            'No hay productos en tu carrito de compras, por lo tanto no puedes solicitar un pedido.',
            textAlign: TextAlign.justify,
            style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.w300
            ),
          )
        ],
      ),
      actions: [
        RaisedButton.icon(
          label: Text('Aceptar'),
          color: Colors.red,
          textColor: Colors.white70,
          icon: Icon(Icons.exit_to_app), 
          onPressed: () => Navigator.of(context).pop()
        )
      ],
    );
  }
}

class _ShopCartItems extends StatelessWidget {
  final AddShopInfo addShopinfo;
  const _ShopCartItems({@required this.addShopinfo});


  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: addShopinfo.shopCartStream,
      builder: (BuildContext context, AsyncSnapshot<List<ProductModelSqlite>> snapshot){
        if(snapshot.hasData){
          final products = snapshot.data;
          return ListView.builder(
            padding: EdgeInsets.all(2),
            itemCount: products.length,
            itemBuilder: (context, index){
              ///
              /// ***
              /// @size = Si el  p.size = 0 es chico.
              /// @import = p.size es chico entonces multiplicar precioch por la cantidad. 
              /// y viceversa.
              /// *** 
              ///
              final size = (products[index].size == 0) ? 'Chico' : 'Grande';
              final import = (products[index].size == 0) 
                                              ? products[index].precioch * products[index].cantidad 
                                              : products[index].preciog  * products[index].cantidad;
              return Dismissible(
                background: Container(
                  color: Colors.red,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Text('REMOVIDO', textAlign: TextAlign.center, style: TextStyle(fontSize: 40, color: Colors.white, fontWeight: FontWeight.w900)),
                  ),
                ),
                key: UniqueKey(),
                onDismissed: ( direction ) async {
                  final sqliteid = products[index].sqliteId;
                  await DBProvider.db.deleteProduct(sqliteid);
                  addShopinfo.putShopCartItems(await DBProvider.db.getAllProducts());
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        blurRadius: 2,
                        color: Colors.black26,
                        spreadRadius: 2
                      )
                    ]
                  ),
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: Column(
                    children: [
                      ListTile(
                        leading: FadeInImage(
                          placeholder: AssetImage('assets/images/loading-sushi.gif'), 
                          image: NetworkImage(products[index].url),
                        ),
                        trailing: Icon(Icons.info, size: 30, color: Colors.blue),
                        title: Text(products[index].nombre),
                        subtitle: Text('Cant. ${products[index].cantidad}\nTamaño: $size'),
                        onTap: (){
                          showDialog(
                            barrierDismissible: true,
                            context: context,
                            builder: (_) => Column(
                              children: [
                                AlertDialog(
                                  content: FutureBuilder(
                                    future: DBProvider.db.getProductDetail(products[index].sqliteId),
                                    builder: (_, AsyncSnapshot<List<IngredientesModel>> snapshot) {
                                      // Obtener los ingredientes que no iran en el platillo.
                                      if(snapshot.hasData){
                                        final ingredientsList = snapshot.data;
                                        if(ingredientsList.length == 0){
                                          return Column(
                                            children: [
                                              Image(
                                                image: AssetImage('assets/images/clipboard.png'),
                                                height: 150,
                                                width: 150,
                                              ),
                                              Text(
                                                products[index].nombre,
                                                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w200),
                                              ),
                                              Divider(),
                                              SizedBox(height: 20),
                                              Text('Este producto está completo, llevará todos los ingredientes que este incluye en su elaboracion.', textAlign: TextAlign.center, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.green)),
                                              SizedBox(height: 10)
                                            ],
                                          );
                                        }
                                        return Column(
                                          children: [
                                            Image(
                                              image: AssetImage('assets/images/clipboard.png'),
                                              height: 150,
                                              width: 150,
                                            ),
                                            Text(
                                              products[index].nombre,
                                              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w200),
                                            ),
                                            Divider(),
                                            SizedBox(height: 20),
                                            Text('Este producto no contendra:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w300, color: Colors.red)),
                                            SizedBox(height: 10),
                                            Column(
                                              children: _getIngredients(ingredientsList),
                                            )
                                          ],
                                        );
                                      }
                                      return Center(child: LinearProgressIndicator());
                                    }
                                  ),
                                  actions: [
                                    RaisedButton.icon(onPressed: () => Navigator.of(context).pop() , icon: Icon(Icons.close), label: Text('Aceptar'))
                                  ],
                                )
                              ],
                            )
                          );
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Total:'),
                          Text('\$$import', style: TextStyle(color: Colors.green, fontWeight: FontWeight.w900),)
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }

 List<Widget> _getIngredients(List<IngredientesModel> ingredientsList) {
    return ingredientsList.map((e) => Text(e.nombre)).toList();
  }
}