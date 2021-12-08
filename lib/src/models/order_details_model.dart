// To parse this JSON data, do
//
//     final orderDetailsModel = orderDetailsModelFromJson(jsonString);

import 'dart:convert';

OrderDetailsModel orderDetailsModelFromJson(String str) => OrderDetailsModel.fromJson(json.decode(str));

String orderDetailsModelToJson(OrderDetailsModel data) => json.encode(data.toJson());

class OrderDetailsModel {
    OrderDetailsModel({
        this.order,
        this.orderProducts,
    });

    Order order;
    List<OrderProduct> orderProducts;

    factory OrderDetailsModel.fromJson(Map<String, dynamic> json) => OrderDetailsModel(
        order: Order.fromJson(json["order"]),
        orderProducts: List<OrderProduct>.from(json["order_products"].map((x) => OrderProduct.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "order": order.toJson(),
        "order_products": List<dynamic>.from(orderProducts.map((x) => x.toJson())),
    };
}

class Order {
    Order({
        this.id,
        this.telefono,
        this.cliente,
        this.importe,
        this.fecha,
        this.hora,
        this.entrega,
        this.localizacion,
        this.ubicacion,
        this.comentario,
        this.estatus,
    });

    int id;
    String telefono;
    String cliente;
    int importe;
    DateTime fecha;
    String hora;
    String entrega;
    String localizacion;
    String ubicacion;
    String comentario;
    int estatus;

    factory Order.fromJson(Map<String, dynamic> json) => Order(
        id: json["id"],
        telefono: json["telefono"],
        cliente: json["cliente"],
        importe: json["importe"],
        fecha: DateTime.parse(json["fecha"]),
        hora: json["hora"],
        entrega: json["entrega"],
        localizacion: json["localizacion"],
        ubicacion: json["ubicacion"],
        comentario: json["comentario"],
        estatus: json["estatus"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "telefono": telefono,
        "cliente": cliente,
        "importe": importe,
        "fecha": fecha.toIso8601String(),
        "hora": hora,
        "entrega": entrega,
        "localizacion": localizacion,
        "ubicacion": ubicacion,
        "comentario": comentario,
        "estatus": estatus,
    };
}

class OrderProduct {
    OrderProduct({
        this.nombre,
        this.precio,
        this.cantidad,
        this.importe,
        this.ingredientes,
        this.url,
    });

    String nombre;
    int precio;
    int cantidad;
    int importe;
    String ingredientes;
    String url;

    factory OrderProduct.fromJson(Map<String, dynamic> json) => OrderProduct(
        nombre: json["nombre"],
        precio: json["precio"],
        cantidad: json["cantidad"],
        importe: json["importe"],
        ingredientes: json["ingredientes"],
        url: json["url"],
    );

    Map<String, dynamic> toJson() => {
        "nombre": nombre,
        "precio": precio,
        "cantidad": cantidad,
        "importe": importe,
        "ingredientes": ingredientes,
        "url": url,
    };
}
