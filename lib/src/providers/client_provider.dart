import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:pedidos_mobile/src/models/order_details_model.dart';
import 'package:pedidos_mobile/src/utils/general/global_data.dart';
import 'package:pedidos_mobile/src/models/client_model.dart';
import 'package:pedidos_mobile/src/models/order_model.dart';
import 'package:flutter/material.dart';

class ClientProvider {
  String _api = AppGlobalData().api;
   /// ***
  /// Metodo para hacer las request y obtener
  /// El codigo de estado del resultado 
  /// ***
  Future<bool> processPostRequest(String endpoint, Map body)async{
    final response = await http.post(
      Uri.parse('$_api$endpoint'),
      headers: {
        'Content-Type': 'application/json'
      },
      body: json.encode(body),
      encoding: Encoding.getByName("utf-8")
    );
    return response.statusCode == 200 ? true : false;
  }

  /// ***
  /// Metodo para agregar un nuevo usuario al sistema.
  /// 
  /// ***
  Future<bool> postNewClient( ClientModel client )async => await processPostRequest('/client/make/new', client.toJson());

  
  Future<ClientModel> fetchUserData(String telefono) async{
    /// ***
    /// Obtener todos los datos pertenecientes a un [@telefono].
    /// 
    /// ***
    final response = await http.get('$_api/client/make/show/$telefono'); 
    final decodedData = json.decode(response.body);  /// {response { data: {} }}
    final client = new ClientModel.fromJson(decodedData['response']['data']);
    return client;
  }

  Future<List<OrderModel>> fetchOrdersOfClient(String telefono) async{
    List<OrderModel> ordersList = new List<OrderModel>();
    /// ***
    /// Obtener los pedidos hechos por este @cliente
    ///
    /// ***
    final response = await http.get('$_api/client/make/show/orders/$telefono');
    if(response.statusCode == 404) return null;
    final decodedData = json.decode(response.body); // Arr: orders: { Order Objects }
    Map mappedData = decodedData;

    for (var i = 0; i < mappedData['orders'].length; i++) {
      final order = new OrderModel.fromJson(mappedData['orders'][i]);
      ordersList.add(order);
    }
    return ordersList;
  }
  ///
  /// ***
  ///   Dar like/dislike a un producto
  /// ***
  ///
  Future<bool> likeItem(Map<String, dynamic> data)    async  => await processPostRequest('/shop/make/like', data);
  
  ///
  ///*** 
  ///   Validar si un usuario le ha dado like a un producto.
  ///*** 
  ///
  Future<IconData> validateLike(Map<String, dynamic> data) async {
    final res = await processPostRequest('/shop/make/like/validate', data);
    if(res){
      return Icons.favorite;
    }else{
      return Icons.favorite_border;
    }
  }
  
  Future<bool> validateSession(String telefono, String password) async{
    /// ***
    /// Valida el login en base a [@telefono] & [@password]
    /// 
    /// ***
    final clientCredentials = {
        'phone': telefono,
        'password': password
    };
    return await processPostRequest('/client/make/validate', clientCredentials);
  }

  Future<OrderDetailsModel> getOrderDetails(String telefono, int orderId) async {
    OrderDetailsModel order = new OrderDetailsModel();
    /// ***
    /// Obtener todos los detalles de un pedido.
    ///
    /// ***
    final response = await http.get('$_api/client/make/show/order_details/$telefono/$orderId');
    if(response.statusCode == 404) return null;
    final decodedData = json.decode(response.body);
    Map mappedData = decodedData;
    order = OrderDetailsModel.fromJson(mappedData);
    return order;
  }
}