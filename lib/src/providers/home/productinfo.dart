import 'dart:async';
import 'package:pedidos_mobile/src/providers/product_provider.dart';
import 'package:rxdart/rxdart.dart' as rx;
import 'package:flutter/material.dart';
import 'package:pedidos_mobile/src/models/product_model.dart';


class ProductInfo with ChangeNotifier, ProductValidator {

  final _products = rx.BehaviorSubject<int>();
  // Recuperar datos del Stream
  Stream<List<ProductModel>> get allProductsStream => _products.stream.transform(getList);
  // Data actual(ultima dato introducido)
  int get actualProductCategoryId => _products.value;
  int get actualCategoryId => _products.value;

  // Insertar valores al Stream
  Function(int) get putNewProductCategory => _products.sink.add;

  @override
  void dispose() {
    _products?.close();
    super.dispose();
  }
}

class ProductValidator {
  final getList = StreamTransformer<int, List<ProductModel>>.fromHandlers(
    handleData: (catId, sink) async{
      await ProductProvider().getAllProducts(catId).then( (lstProducts) {
        if(lstProducts != null){
          sink.add(lstProducts);
        }else{
          sink.addError('No hay productos en esta categoria.');
        }
      });
    },
  );
}