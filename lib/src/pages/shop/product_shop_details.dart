import 'package:flutter/material.dart';
import 'package:pedidos_mobile/src/models/ingredientes_model.dart';
import 'package:pedidos_mobile/src/models/product_model.dart';
import 'package:pedidos_mobile/src/providers/db_provider.dart';
import 'package:pedidos_mobile/src/providers/shop/add_shop.dart';
import 'package:provider/provider.dart';
import 'package:slimy_card/slimy_card.dart';

class ProductShopDetails extends StatelessWidget {
  final ProductModel product;
  ProductShopDetails({@required this.product});

  @override
  Widget build(BuildContext context) {

    return AlertDialog(
      content: SlimyCard(
          color: Colors.deepOrangeAccent,
          topCardWidget: _TopCardWidget(product: product),
          bottomCardWidget: _BottomCardWidget(product: product),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
    );

    

  }
}

class _TopCardWidget extends StatelessWidget {
  final ProductModel product;
  _TopCardWidget({@required this.product});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        topOptions(context),
        topContent(context, product),
      ],
    );
  }

  Row topOptions(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(Icons.close),
            iconSize: 30,
            color: Colors.black,
            tooltip: 'Atras',
            hoverColor: Colors.white, 
            onPressed: () => Navigator.of(context).pop()
          ),
          IconButton(
            icon: Icon(Icons.info), 
            onPressed: (){}
          ),
        ],
      );
  }

  Widget topContent(BuildContext context, ProductModel product) {
    final addShopInfo = Provider.of<AddShopInfo>(context);
    addShopInfo.putPrice(true);
    addShopInfo.putCantProducts(1);
    return StreamBuilder(
      stream: addShopInfo.precioStream,
      builder: (context,  AsyncSnapshot<bool> snapshot) {
        if(snapshot.hasData){
          String contextPrice = (snapshot.data) ? 'Grande: \$${product.preciog}' : 'Chico: \$${product.precioch}';
          return Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(100)),
                  child: FadeInImage(
                    placeholder: AssetImage('assets/images/loading-sushi.gif'), 
                    image: NetworkImage(product.url),
                    fit: BoxFit.cover,
                    height: 50,
                    width: 50
                  ),
                ),
                Text(
                  product.nombre, 
                  textAlign: TextAlign.center,
                  maxLines: 1, 
                  overflow: TextOverflow.ellipsis, 
                  style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.w700)
                ),
                Divider(color: Colors.white),
                RaisedButton.icon(
                  onPressed: () async {
                    // Obtenemos el tamaño que acaba de solicitar el usuario del producto en curso.
                    final size = (addShopInfo.actualPrice) ? 1 : 0;
                    // Obtenemos los ingredientes actuales y eliminamos los que si llevara para enviar los que no llevara a la db.
                    final ing = addShopInfo.actualIngredientsOnProduc;
                    ing.removeWhere((key, value) => value == true);
                    // Insertamos el producto a la base de datos y enviamos la lista de los id de los ingredientes que no llevaremos.
                    final res = await DBProvider.db.insertProduct(product.id, addShopInfo.actualCantProducts, size, ing.keys.toList());
                    if(res > 0 || res != null){
                      // Pedimos obtener los productos de nuevo.
                      addShopInfo.putShopCartItems(await DBProvider.db.getAllProducts());
                      Navigator.of(context).pop();
                    }
                  }, 
                  icon: Icon(Icons.check), 
                  label: Text('Añadir al carrito'), 
                  color: Colors.green
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Text(contextPrice, style: TextStyle(color: Colors.white)),
                        Switch(
                          value: addShopInfo.actualPrice, 
                          onChanged: (e) => addShopInfo.putPrice(e)
                        ),
                      ],
                    ),
                    StreamBuilder<int>(
                      stream: addShopInfo.cantidadStream,
                      builder: (context, AsyncSnapshot<int> snapshot) {
                        return Column(
                          children: [
                            Text('Cant.', style: TextStyle(color: Colors.white)),
                            DropdownButton(
                              value: snapshot.data,
                              items: <DropdownMenuItem>[
                                DropdownMenuItem(child: Text('Uno'), value: 1),
                                DropdownMenuItem(child: Text('Dos'), value: 2),
                                DropdownMenuItem(child: Text('Tres'), value: 3),
                              ], 
                              onChanged: (e) => addShopInfo.putCantProducts(e)
                            )
                          ],
                        );
                      }
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Text(
                  'Opciones extra',
                  textAlign: TextAlign.justify,
                  style: TextStyle(color: Colors.white60),
                ),
              ],
            );
        }
        return Text('Obteniendo data...');
      }
    );
  }
}

class _BottomCardWidget extends StatelessWidget {
  final ProductModel product;
  _BottomCardWidget({@required this.product});

  @override
  Widget build(BuildContext context) {
    final addShopInfo = Provider.of<AddShopInfo>(context);
    addShopInfo.putIngredients(product.id);
      return StreamBuilder(
        stream: addShopInfo.ingredientsStream,
        builder: (BuildContext context, AsyncSnapshot<List<IngredientesModel>> snapshot){
          if(snapshot.hasData){
            final ingredientes = snapshot.data;
            // Extramos el id de cada ingrediente y le asignamos true en el mapa. (Selected)
            Map<int, bool> mappedData = new Map<int, bool>();
            for (IngredientesModel ingrediente in ingredientes) {
              mappedData.addAll({ingrediente.id: true});
            }
            // Agregamos el mapa elaborado al stream.
            addShopInfo.putIngredientesOnproduct(mappedData);
            if(ingredientes.length == 0) return Center(child: Text('Sin ingredientes extra.'));
            return ListView.builder(
              itemExtent: 200,
              itemCount: ingredientes.length,
              itemBuilder: (context, index){
                return ExtraItem(ingrediente: ingredientes[index]);
              },
              scrollDirection: Axis.horizontal,
            );
          }else{
            return Center(child: CircularProgressIndicator());
          }
        },
      );
    }
}

class ExtraItem extends StatelessWidget {
  final IngredientesModel ingrediente;
  ExtraItem({this.ingrediente});
  @override
  Widget build(BuildContext context) {
    final addShopInfo = Provider.of<AddShopInfo>(context);

    return StreamBuilder(
      stream: addShopInfo.ingredientesOnProductStream,
      builder: (BuildContext context, AsyncSnapshot<Map<int, bool>> snapshot){
        final ingredientSelection = snapshot.data;
        if(snapshot.hasData){
          return SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.arrow_back_ios, size: 35, color: Colors.white60),
                    Text('Deslice para mas', style: TextStyle(color: Colors.white)),
                    Icon(Icons.arrow_forward_ios, size: 35, color: Colors.white60),
                  ],
                ),
                Text(
                  ingrediente.nombre, 
                  textAlign: TextAlign.center,
                  maxLines: 1, 
                  overflow: TextOverflow.ellipsis, 
                  style: TextStyle(fontSize: 30, color: Colors.white, fontWeight: FontWeight.w700)
                ),
                Switch(
                  value: ingredientSelection[ingrediente.id],
                  onChanged: (e) {
                    ///
                    /// Cuando cambia obtenemos el valor
                    /// actual del mapa que introducimos al stream al crear el widget.
                    /// actualizamos el valor donde coincida con el id del ingrediente.
                    ///
                      Map<int, bool> mappedData = addShopInfo.actualIngredientsOnProduc;
                      mappedData.update(ingrediente.id, (value) => e);
                      addShopInfo.putIngredientesOnproduct(mappedData);
                  }
                ),
              ],
            ),
          );
        }
        return Center(child: CircularProgressIndicator());
        },
      );
  }
}