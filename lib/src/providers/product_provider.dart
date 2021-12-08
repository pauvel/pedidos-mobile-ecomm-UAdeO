import 'package:pedidos_mobile/src/models/product_model.dart';
import 'package:pedidos_mobile/src/models/ingredientes_model.dart';
import 'package:pedidos_mobile/src/utils/general/global_data.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ProductProvider {
  String _api = AppGlobalData().api;

  Future<List<ProductModel>> getAllProducts(int categoryId) async {
    final lst = new List<ProductModel>();
    final response = await http.get('$_api/shop/make/show/product_by_category/$categoryId');
    if(response.statusCode == 200){
      final decodedData = await json.decode(response.body);
      for(var product in decodedData["products"]){
        lst.add(new ProductModel.fromJson(product));
      }
    }else{
      return null;
    }
    return lst;
  }

  Future<ProductModel> getProductById(int productId) async {
    final response = await http.get('$_api/shop/make/show/$productId/product_info');
    if(response.statusCode == 200){
      final decodedData = await json.decode(response.body);
      return ProductModel.fromJson(decodedData['product']);
    }else{
      return null;
    }
  }

  Future<List<IngredientesModel>> getDetailsOfProduct(int product) async {
    final lst = new List<IngredientesModel>();
    final response = await http.get('$_api/shop/make/show/$product/ingredients');
    if(response.statusCode == 200){
      final decodedData = await json.decode(response.body);
      for(var detail in decodedData["ingredients"]){
        lst.add(new IngredientesModel.fromJson(detail));
      }
    }else{
      return null;
    }
    return lst;
  }

  Future<IngredientesModel> getIngredientById(int ingredient) async {
    final response = await http.get('$_api/shop/make/show/$ingredient/ingredient_info');
    if(response.statusCode == 200){
      final decodedData = await json.decode(response.body);
      return IngredientesModel.fromJson(decodedData['ingredient']);
    }else return null;
  }
}