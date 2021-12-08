import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:pedidos_mobile/src/models/ingredientes_model.dart';
import 'package:pedidos_mobile/src/models/product_sqlite_model.dart';
import 'package:pedidos_mobile/src/providers/product_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {

  static Database _database;
  static final DBProvider db = DBProvider._();

  DBProvider._();

  Future<Database> get database async {
    if(_database != null) return _database;
    _database = await initDB();

    return _database;
  }
  initDB() async {
    String tablaProductos = 'CREATE TABLE productos('
    'id INTEGER PRIMARY KEY AUTOINCREMENT,'
    'producto_id INTEGER,'
    'size INTEGER,'
    'cantidad INTEGER)';
    String tablaIngredientes = 'CREATE TABLE ingredientes('
    'id INTEGER PRIMARY KEY AUTOINCREMENT,'
    'producto_id INTEGER,'
    'ingrediente_id INTEGER,'
    'FOREIGN KEY(producto_id) REFERENCES productos(id) ON DELETE CASCADE )';
    String enableForeign = 'PRAGMA foreign_keys = ON';
    List<String> queries = [tablaProductos, tablaIngredientes, enableForeign];
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join( documentsDirectory.path, 'shopcart4.db' );

    return await openDatabase(
      path,
      version: 1,
      onOpen: ( db ) {},
      onCreate: (Database db, int version) async {
        for (String query in queries) {
          await db.execute(query);
        }
      }
    );
  }

  Future<int> insertProduct(int product, int cantidad, int size, List<int> ingredients) async {
    final db = await database;
    final response = await db.rawInsert('INSERT INTO productos(producto_id, size, cantidad) VALUES($product, $size, $cantidad)');
    // Ingredientes que NO iran.
    if(ingredients.length > 0){
      ///*** */
      /// Si el hubo ingredientes a quitar, insertamos los ingredientes en base al ultimo id generado. (@response)
      ///*** */
      for (int ingredienteId in ingredients) {
        await db.rawInsert('INSERT INTO ingredientes(producto_id, ingrediente_id) VALUES($response, $ingredienteId)');
      }
    }
    return response;
  }

  Future<List<ProductModelSqlite>> getAllProducts() async {
    ///
    /// ***
    /// Este metodo, hace una consulta al sqlite y obtiene el ID de cada @producto
    /// que se encuentre dentro de la tabla [productos] y llama el provider de
    /// obtener producto por su id, el cual dentro de un iterador traera un producto
    /// y lo agregara a una lista, fabricando el modelo SQLITE.
    /// 
    /// ***
    List<ProductModelSqlite> lst = new List<ProductModelSqlite>();
    final db = await database;
    final response = await db.query('productos');
    for (Map<String, dynamic> item in response) {
      await ProductProvider().getProductById(item["producto_id"])
                            .then(( resProduct ) {
                              final newObj = {
                                  "id": resProduct.id,
                                  "nombre": resProduct.nombre,
                                  "descripcion": resProduct.descripcion,
                                  "precioch": resProduct.precioch,
                                  "preciog": resProduct.preciog,
                                  "unitario": resProduct.unitario,
                                  "url": resProduct.url,
                                  "categoria_id": resProduct.categoriaId,
                                  "likes": resProduct.likes,
                                  "cantidad": item["cantidad"],
                                  "sqlite_id": item["id"],
                                  "size": item["size"],
                              };
                              
                              lst.add(new ProductModelSqlite.fromJson(newObj));
                            });
    }
    return lst;
  }

  Future<List<IngredientesModel>> getProductDetail(int sqliteId) async {
    ///
    ///*** */
    ///  Obtiene todos los ingredientes que coincidan con el @sqliteId
    ///  Consultamos primero el id del ingrediente con la API para que
    ///  nos retorne el objeto ingredientesmodel.
    ///*** */
    final db = await database;
    List<IngredientesModel> lst = new List<IngredientesModel>();
    // @producto_id = idsqlite.
    final response = await db.query('ingredientes', where: 'producto_id = ?', whereArgs: [sqliteId]);
    for (var item in response) {
      // Por cada ingrediente que coincida con @sqliteId creamos un nuevo [IngredientesModel]
      // & lo agregamos a una lista para posteriormente retornarla.
      await ProductProvider().getIngredientById(item['ingrediente_id']).then((value) => lst.add(value));
    }
    return lst;
  }

  Future<int> deleteProduct(int productSqliteId) async {
    final db = await database;
    final response = await db.delete('productos', where: 'id = ?', whereArgs: [productSqliteId]);
    await db.delete('ingredientes', where: 'producto_id = ?',      whereArgs: [productSqliteId]);
    return response;
  }

  Future<bool> purgeDb()async{
    int countRows = 0;
    final db = await database;
    countRows += await db.delete('productos');
    countRows += await db.delete('ingredientes');
    return (countRows > 0) ? true : false;
  }

}