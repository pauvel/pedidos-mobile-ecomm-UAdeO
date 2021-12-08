// To parse this JSON data, do
//
//     final orderModel = orderModelFromJson(jsonString);

import 'dart:convert';

OrderModel orderModelFromJson(String str) => OrderModel.fromJson(json.decode(str));

String orderModelToJson(OrderModel data) => json.encode(data.toJson());

class OrderModel {
    OrderModel({
        this.id,
        this.clienteId,
        this.importe,
        this.fecha,
        this.hora,
        this.entrega,
        this.localizacion,
        this.ubicacion,
        this.comentario,
    });

    int id;
    String clienteId;
    double importe;
    DateTime fecha;
    String hora;
    String entrega;
    String localizacion;
    String ubicacion;
    String comentario;

    factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
        id: json["id"],
        clienteId: json["cliente_id"],
        importe: json["importe"].toDouble(),
        fecha: DateTime.parse(json["fecha"]),
        hora: json["hora"],
        entrega: json["entrega"],
        localizacion: json["localizacion"],
        ubicacion: json["ubicacion"],
        comentario: json["comentario"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "cliente_id": clienteId,
        "importe": importe,
        "fecha": "${fecha.year.toString().padLeft(4, '0')}-${fecha.month.toString().padLeft(2, '0')}-${fecha.day.toString().padLeft(2, '0')}",
        "hora": hora,
        "entrega": entrega,
        "localizacion": localizacion,
        "ubicacion": ubicacion,
        "comentario": comentario,
    };
}
