// To parse this JSON data, do
//
//     final ingredientesModel = ingredientesModelFromJson(jsonString);

import 'dart:convert';

IngredientesModel ingredientesModelFromJson(String str) => IngredientesModel.fromJson(json.decode(str));

String ingredientesModelToJson(IngredientesModel data) => json.encode(data.toJson());

class IngredientesModel {
    IngredientesModel({
        this.id,
        this.nombre,
        this.estatus,
    });

    int id;
    String nombre;
    int estatus;

    factory IngredientesModel.fromJson(Map<String, dynamic> json) => IngredientesModel(
        id: json["id"],
        nombre: json["nombre"],
        estatus: json["estatus"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
        "estatus": estatus,
    };
}