// To parse this JSON data, do
//
//     final orderStatusModel = orderStatusModelFromJson(jsonString);

import 'dart:convert';

OrderStatusModel orderStatusModelFromJson(String str) => OrderStatusModel.fromJson(json.decode(str));

String orderStatusModelToJson(OrderStatusModel data) => json.encode(data.toJson());

class OrderStatusModel {
    OrderStatusModel({
        this.estatusId,
        this.estatus,
        this.estatusDescription,
    });

    int estatusId;
    String estatus;
    String estatusDescription;

    factory OrderStatusModel.fromJson(Map<String, dynamic> json) => OrderStatusModel(
        estatusId: json["estatus_id"],
        estatus: json["estatus"],
        estatusDescription: json["estatus_description"],
    );

    Map<String, dynamic> toJson() => {
        "estatus_id": estatusId,
        "estatus": estatus,
        "estatus_description": estatusDescription,
    };
}
