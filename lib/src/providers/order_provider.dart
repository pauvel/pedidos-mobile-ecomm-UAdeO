import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pedidos_mobile/src/models/order_status_model.dart';
import 'package:pedidos_mobile/src/utils/general/global_data.dart';

class OrderProvider {
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

  Future<bool> createOrder(Map order, List<Map> orderDetails) async{
    final data = {
      'full_order': order,
      'details_order': orderDetails
    };
    return await processPostRequest('/orders/new/order', data);
  }

  Future<OrderStatusModel> getOrderStatus(String clientId, int orderId) async {
    final response = await http.get('$_api/client/make/show/order_status/$clientId/$orderId');
    OrderStatusModel status = new OrderStatusModel.fromJson(await json.decode(response.body));
    return status;
  }
}