// To parse this JSON data, do
//
//     final productModel = productModelFromJson(jsonString);

import 'dart:convert';

ProductModelSqlite productModelFromJson(String str) => ProductModelSqlite.fromJson(json.decode(str));

String productModelToJson(ProductModelSqlite data) => json.encode(data.toJson());

class ProductModelSqlite {
    ProductModelSqlite({
        this.id,
        this.nombre,
        this.descripcion,
        this.precioch,
        this.preciog,
        this.unitario,
        this.url,
        this.categoriaId,
        this.likes,
        this.cantidad,
        this.sqliteId,
        this.size
    });

    int id;
    String nombre;
    String descripcion;
    int precioch;
    int preciog;
    String unitario;
    String url;
    int categoriaId;
    int likes;
    int cantidad;
    int sqliteId;
    int size;

    factory ProductModelSqlite.fromJson(Map<String, dynamic> json) => ProductModelSqlite(
        id: json["id"],
        nombre: json["nombre"],
        descripcion: json["descripcion"],
        precioch: json["precioch"],
        preciog: json["preciog"],
        unitario: json["unitario"],
        url: json["url"],
        categoriaId: json["categoria_id"],
        likes: json["likes"],
        cantidad: json["cantidad"],
        sqliteId: json["sqlite_id"],
        size: json["size"]
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
        "descripcion": descripcion,
        "precioch": precioch,
        "preciog": preciog,
        "unitario": unitario,
        "url": url,
        "categoria_id": categoriaId,
        "likes": likes,
        "cantidad": cantidad,
        "sqlite_id": sqliteId,
        "size": size,
    };
}
