// To parse this JSON data, do
//
//     final extrasModel = extrasModelFromJson(jsonString);

import 'dart:convert';

ExtrasModel extrasModelFromJson(String str) => ExtrasModel.fromJson(json.decode(str));

String extrasModelToJson(ExtrasModel data) => json.encode(data.toJson());

class ExtrasModel {
    ExtrasModel({
        this.id,
        this.nombre,
        this.precio,
        this.estatus,
    });

    int id;
    String nombre;
    double precio;
    int estatus;

    factory ExtrasModel.fromJson(Map<String, dynamic> json) => ExtrasModel(
        id: json["id"],
        nombre: json["nombre"],
        precio: json["precio"].toDouble(),
        estatus: json["estatus"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
        "precio": precio,
        "estatus": estatus,
    };
}
