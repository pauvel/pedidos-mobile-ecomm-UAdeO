import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pedidos_mobile/src/models/client_model.dart';
import 'package:pedidos_mobile/src/models/order_model.dart';
import 'package:pedidos_mobile/src/providers/client_provider.dart';
import 'package:rxdart/rxdart.dart' as rx;

class AppInfo with ChangeNotifier, AppInfoFetcher {

  final _clienteOrders = rx.BehaviorSubject<String>();
  final _clienteInfo = rx.BehaviorSubject<String>();
  final _clienteFetched = rx.BehaviorSubject<ClientModel>();
  final _clienteOrderFetched = rx.BehaviorSubject<List<OrderModel>>();
  // Recuperar datos del Stream
  Stream<ClientModel> get clienteInfoStream => _clienteInfo.stream.transform(getUserData);
  Stream<List<OrderModel>> get clienteOrdersStream => _clienteOrders.stream.transform(getUserOrders);
  Stream<ClientModel> get clienteFetchedDataStream => _clienteFetched.stream;
  Stream<List<OrderModel>> get clienteFetchedOrdersStream => _clienteOrderFetched.stream;
  // Data actual
  ClientModel get clientActualData => _clienteFetched.value;
  List<OrderModel> get clientActualOrders => _clienteOrderFetched.value;
  // Insertar valores al Stream
  Function(String) get putClientData    => _clienteInfo.sink.add;
  Function(ClientModel) get putClientFetchedData  => _clienteFetched.sink.add;
  Function(String) get putClientOrderData    => _clienteOrders.sink.add;
  Function(List<OrderModel>) get putClientFetchedOrdersData    => _clienteOrderFetched.sink.add;

  addClientFetchedData(ClientModel cliente){
    putClientFetchedData(cliente);
  }

  addClientFetchedOrders(List<OrderModel> orders){
    putClientFetchedOrdersData(orders);
  }

@override
  void dispose() {
    _clienteOrderFetched.close();
    _clienteFetched.close();
    _clienteInfo?.close();
    _clienteOrders?.close();
    super.dispose();
  }
}

class AppInfoFetcher {
    final getUserData = StreamTransformer<String, ClientModel>.fromHandlers(
    handleData: ( id, sink ) async{
      await ClientProvider().fetchUserData(id).then((value){
        AppInfo().addClientFetchedData(value);
        sink.add(value);
      });
    }
  );

  final getUserOrders = StreamTransformer<String, List<OrderModel>>.fromHandlers(
    handleData: (id, sink) async {
      await ClientProvider().fetchOrdersOfClient(id).then((value){
        if(value == null){
          sink.addError('Sin pedidos aún');
        }else{
          AppInfo().addClientFetchedOrders(value);
          sink.add(value);
        }
      });
    }
  );

}