// To parse this JSON data, do
//
//     final clientModel = clientModelFromJson(jsonString);

import 'dart:convert';

ClientModel clientModelFromJson(String str) => ClientModel.fromJson(json.decode(str));

String clientModelToJson(ClientModel data) => json.encode(data.toJson());

class ClientModel {
    ClientModel({
        this.id,
        this.nombrecompleto,
        this.localidad,
        this.direccion,
        this.cantcompras,
        this.impcompras,
        this.ultVisita,
        this.password,
        this.estatus,
    });

    String id;
    String nombrecompleto;
    String localidad;
    String direccion;
    int cantcompras;
    int impcompras;
    DateTime ultVisita;
    String password;
    int estatus;

    factory ClientModel.fromJson(Map<String, dynamic> json) => ClientModel(
        id: json["id"],
        nombrecompleto: json["nombrecompleto"],
        localidad: json["localidad"],
        direccion: json["direccion"],
        cantcompras: json["cantcompras"],
        impcompras: json["impcompras"],
        ultVisita: DateTime.parse(json["ult_visita"]),
        password: json["password"],
        estatus: json["estatus"],
    );

    Map<String, dynamic> toJson() => {
        "telefono": id,
        "nombrecompleto": nombrecompleto,
        "localidad": localidad,
        "direccion": direccion,
        "cantcompras": cantcompras,
        "impcompras": impcompras,
        "ult_visita": ultVisita,
        "password": password,
        "estatus": estatus,
    };
}
