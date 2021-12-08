import 'dart:convert';
import 'package:pedidos_mobile/src/models/category_model.dart';
import 'package:pedidos_mobile/src/utils/general/global_data.dart';
import 'package:http/http.dart' as http;

class CategoryProvider {
  String _api = AppGlobalData().api;

  Future<List<CategoryModel>> getAllCategories() async{
    List<CategoryModel> lst = new  List<CategoryModel>();
    final response = await http.get('$_api/shop/make/show/categories');
    if(response.statusCode == 200){
      final decodedData = await json.decode(response.body);
      for(var category in decodedData){
        lst.add(new CategoryModel.fromJson(category));
      }
    }else{
      return null;
    }
    return lst;
  }

}