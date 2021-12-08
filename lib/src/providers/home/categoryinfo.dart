import 'package:pedidos_mobile/src/models/category_model.dart';
import 'package:pedidos_mobile/src/providers/category_provider.dart';
import 'dart:async';
import 'package:rxdart/rxdart.dart' as rx;
import 'package:flutter/material.dart';


class CategoryInfo with ChangeNotifier, CategoryValidator {

  final _categories = rx.BehaviorSubject<List<CategoryModel>>();

  CategoryInfo(){
    getAllCategories();
  }

  // Recuperar datos del Stream
  Stream<List<CategoryModel>> get allCategoriesStream => _categories.stream.transform(refreshList);

  // Data actual(ultima dato introducido)
  List<CategoryModel> get allActualCategories => _categories.value;

  // Insertar valores al Stream
  Function(List<CategoryModel>) get putAllCategories => _categories.sink.add;

  getAllCategories() async {
    final cats = await CategoryProvider().getAllCategories();
    putAllCategories(cats);
    notifyListeners();
    return cats;
  }

  @override
  void dispose() {
    _categories?.close();
    super.dispose();
  }
}

class CategoryValidator{
  final refreshList = StreamTransformer<List<CategoryModel>, List<CategoryModel>>.fromHandlers(
    handleData: (categories, sink) async{
      await CategoryProvider().getAllCategories().then((data){
        if(data != null){
          sink.add(data);
        }else{
          sink.addError('No hay categorias por mostrar');
        }
      });
    },
  );
}