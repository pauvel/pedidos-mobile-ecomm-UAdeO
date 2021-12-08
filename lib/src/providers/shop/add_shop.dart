import 'dart:async';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:pedidos_mobile/src/models/ingredientes_model.dart';
import 'package:pedidos_mobile/src/models/product_sqlite_model.dart';
import 'package:pedidos_mobile/src/providers/product_provider.dart';
import 'package:rxdart/rxdart.dart' as rx;
import '../db_provider.dart';

class AddShopInfo with ChangeNotifier, AddShopInfoValidator {

  AddShopInfo(){
    getCarritoItems();
    setConfirmDirectionValue();
    setLocationAddress();
  }

  final _ingredients = rx.BehaviorSubject<int>();
  final _price = rx.BehaviorSubject<bool>();
  final _cantProducts = rx.BehaviorSubject<int>();
  final _ingredientsOnProduct = rx.BehaviorSubject<Map<int, bool>>();
  final _shopCart = rx.BehaviorSubject<List<ProductModelSqlite>>();
  final _shopcartTotal = rx.BehaviorSubject<List<ProductModelSqlite>>();
  final _orderComment = rx.BehaviorSubject<String>();
  final _confirmDirection = rx.BehaviorSubject<bool>();
  final _location = rx.BehaviorSubject<LocationData>();
  final _locationAddress = rx.BehaviorSubject<String>();

  Stream<List<IngredientesModel>> get ingredientsStream => _ingredients.stream.transform(getIngredients);
  Stream<bool> get precioStream => _price.stream;
  Stream<int> get cantidadStream => _cantProducts.stream;
  Stream<Map<int, bool>> get ingredientesOnProductStream => _ingredientsOnProduct.stream;
  Stream<List<ProductModelSqlite>> get shopCartStream => _shopCart.stream;
  Stream<double> get shopcartToal => _shopcartTotal.stream.transform(getTotal);
  Stream<bool> get confirmDirectionStream => _confirmDirection.stream;
  Stream<LocationData> get locationStream => _location.stream;
  Stream<String> get locationAddressStream => _locationAddress.stream;
  Stream<String> get orderCommentStream => _orderComment.stream;

  int get actualIngredients => _ingredients.value;
  bool get actualPrice => _price.value;
  int get actualCantProducts => _cantProducts.value;
  Map<int, bool> get actualIngredientsOnProduc => _ingredientsOnProduct.value;
  List<ProductModelSqlite> get actualShopCart => _shopCart.value;
  bool get actualConfirmDirection => _confirmDirection.value;
  LocationData get actualLocation => _location.value;
  String get actualLocationAddress => _locationAddress.value;
  String get actualOrderComment => _orderComment.value;

  Function(int) get putIngredients => _ingredients.sink.add;
  Function(bool) get putPrice => _price.sink.add;
  Function(int) get putCantProducts => _cantProducts.sink.add;
  Function(Map<int, bool>) get putIngredientesOnproduct =>_ingredientsOnProduct.sink.add;
  Function(List<ProductModelSqlite>) get putShopCartItems => _shopCart.sink.add;
  Function(List<ProductModelSqlite>) get putshopcartItemsForTotal => _shopcartTotal.sink.add;
  Function(bool) get putConfirmDirection => _confirmDirection.sink.add;
  Function(LocationData) get putLocation => _location.sink.add;
  Function(String) get putLocationAddress => _locationAddress.sink.add;
  Function(String) get putOrderComment => _orderComment.sink.add;

  void getCarritoItems() async{
    putShopCartItems(await DBProvider.db.getAllProducts());
  }

  void setLocationAddress(){
    putLocationAddress('Sin direccion.');
  }
  void setComment(){
    putOrderComment('');
  }
  void setConfirmDirectionValue(){
    putConfirmDirection(false);
  }

  void resetStreams(){
    putLocationAddress('Sin direccion.');
    putConfirmDirection(false);
    putOrderComment('');
    getCarritoItems();
  }

  @override
  void dispose() {
    _orderComment?.close();
    _shopcartTotal?.close();
    _locationAddress?.close();
    _location?.close();
    _confirmDirection?.close();
    _shopCart?.close();
    _ingredientsOnProduct?.close();
    _cantProducts?.close();
    _ingredients?.close();
    _price?.close();
    super.dispose();
  }

}

class AddShopInfoValidator {
  final getIngredients = StreamTransformer<int, List<IngredientesModel>>.fromHandlers(
    handleData: (productId, sink) async {
      final result = await ProductProvider().getDetailsOfProduct(productId);
      if(result != null){
        sink.add(result);
      }else{
        sink.addError('No hay opciones extra');
      }
      
    },
  );

  final getTotal = StreamTransformer<List<ProductModelSqlite>, double>.fromHandlers(
    handleData: (shopcartItems, sink) async {
      double total = 0;
      for (ProductModelSqlite product in shopcartItems) {
        if(product.size == 0) total+=product.precioch * product.cantidad;
        if(product.size == 1) total+=product.preciog * product.cantidad;
      }
      sink.add(total);
    },
  );
}