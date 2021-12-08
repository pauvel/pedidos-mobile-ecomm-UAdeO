import 'package:flutter/material.dart';
import 'package:badges/badges.dart';
import 'package:pedidos_mobile/src/models/category_model.dart';
import 'package:pedidos_mobile/src/models/product_model.dart';
import 'package:pedidos_mobile/src/models/product_sqlite_model.dart';
import 'package:pedidos_mobile/src/pages/dashboard/sub/product_details.dart';
import 'package:pedidos_mobile/src/pages/shop/product_shop_details.dart';
import 'package:pedidos_mobile/src/providers/home/categoryinfo.dart';
import 'package:pedidos_mobile/src/providers/home/productinfo.dart';
import 'package:pedidos_mobile/src/providers/shop/add_shop.dart';
import 'package:provider/provider.dart';

class ShopPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ///
    /// ** Streams para obtener productos y categorias.
    ///
    final categoryInfo = Provider.of<CategoryInfo>(context);
    final productInfo = Provider.of<ProductInfo>(context);
    final addShopInfo = Provider.of<AddShopInfo>(context);
    return Scaffold(
      ///
      /// ** @shopAppBar = Appbar y @shopContext = el contenido de la app
      ///
      appBar: _shopAppBar(context, addShopInfo),
      body: _shopContext(context, categoryInfo, productInfo)
    );
  }

  Column _shopContext(BuildContext context, CategoryInfo categoryInfo, ProductInfo productInfo){
    final screenSize = MediaQuery.of(context).size;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        StreamBuilder<List<CategoryModel>>(
          ///
          /// ** Stream de categorias
          ///
          stream: categoryInfo.allCategoriesStream,
          builder: (BuildContext context, AsyncSnapshot<List<CategoryModel>> snapshot) {
            if(snapshot.hasError) return Text(snapshot.error);
            if(!snapshot.hasData) return Center(child: LinearProgressIndicator());
            return _MenuOptions(screenSize: screenSize, categories: snapshot.data);
          }
        ),
        Expanded(
          child: StreamBuilder(
          ///
          /// ** Stream de productos
          ///
            stream: productInfo.allProductsStream,
            builder: (BuildContext context, AsyncSnapshot<List<ProductModel>> snapshot) {
              if(snapshot.hasError) return Center(child: Text('Sin productos'));
              if(!snapshot.hasData) return Center(child: CircularProgressIndicator());
              final products = snapshot.data;
              return ListView.builder(
                padding: EdgeInsets.all(10),
                itemCount: products.length,
                itemBuilder: (BuildContext context, int i){
                  return _productCard(i, screenSize, products[i], context);
                },
              );
            }
          ),
        )
      ],
    );
  }

  AppBar _shopAppBar(BuildContext context, AddShopInfo addShopInfo){
    return AppBar(
      title: Container(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Tienda', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700)),
            StreamBuilder(
              stream: addShopInfo.shopCartStream,
              builder: (context, AsyncSnapshot<List<ProductModelSqlite>> snapshot) {
                String count = (snapshot.hasData ? snapshot.data.length.toString() : '0');
                return Badge(
                  position: BadgePosition.topEnd(top: 1),
                  badgeContent: Text(count, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  child: IconButton(
                    icon: Icon(Icons.shopping_cart, size: 30), 
                    onPressed: () => Navigator.pushNamed(context, 'shopcart')
                  ),
                );
              }
            ),
          ],
        ),
      ),
    );
  }

  Widget _productCard(int i, Size size, ProductModel product, BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Card(
        elevation: 6,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(100)),
                    child: FadeInImage(
                      placeholder: AssetImage('assets/images/loading-sushi.gif'), 
                      image: NetworkImage(product.url),
                      fit: BoxFit.cover,
                      height: 100,
                      width: 100
                    ),
                  ),
                  Row(
                    children: [
                      Column(
                        children: [
                          Icon(Icons.favorite, color: Colors.red),
                          Text(product.likes.toString(), style: TextStyle(fontWeight: FontWeight.w300))
                        ],
                      ),
                    ],
                  )

                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(product.nombre, overflow: TextOverflow.ellipsis, maxLines: 2, style: TextStyle(color: Colors.blueGrey, fontSize: 22, fontWeight: FontWeight.w300)),
                  SizedBox(height: 5),
                  Text(product.descripcion, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontStyle: FontStyle.italic ,fontSize: 14, fontWeight: FontWeight.w300)),
                  SizedBox(height: 5),
                  Padding(
                    padding: EdgeInsets.only(right: 20),
                    child: Row(
                      children: [
                        Text('\$${product.precioch}  -', maxLines: 3, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.green, fontStyle: FontStyle.normal ,fontSize: 17, fontWeight: FontWeight.w500)),
                        SizedBox(width: 10),
                        Text('\$${product.preciog}', maxLines: 3, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.green, fontStyle: FontStyle.normal ,fontSize: 17, fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: IconButton(
                          onPressed: (){
                            showDialog(
                              context: context,
                              builder: (_) => ProductDetails(product: product),
                              barrierDismissible: true
                            );
                          }, 
                          icon: Icon(Icons.info, color: Colors.blue, size: 40) 
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: IconButton(
                          onPressed: () async {
                            return showDialog(
                              context: context, 
                              barrierDismissible: true, 
                              builder: (_) => ProductShopDetails(product: product)
                            );
                          },
                          icon: Icon(Icons.add_circle, color: Colors.green, size: 40) 
                        ),
                      ),
                    ]
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}

class _MenuOptions extends StatefulWidget {
  ///
  /// ** Se recibe una lista de categorias (Que se supone que ya estan en el stream).
  ///
  final List<CategoryModel> categories;
  final Size screenSize;
  _MenuOptions({ @required this.screenSize, @required this.categories });
  @override
  __MenuOptionsState createState() => __MenuOptionsState(categories: categories);
}

class __MenuOptionsState extends State<_MenuOptions> with SingleTickerProviderStateMixin {
  TabController _tabController;
  final List<CategoryModel> categories;

  __MenuOptionsState({@required this.categories});
  @override
  void initState() {
    _tabController = new TabController(length: categories.length, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final productInfo = Provider.of<ProductInfo>(context);
    productInfo.putNewProductCategory(categories[0].id); // Introducimos al stream de productos la primera categoria que nos envia la API.

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: <BoxShadow>[
          BoxShadow(
            blurRadius: 10,
            color: Colors.black45,
            spreadRadius: 5
          )
        ]
      ),
      height: widget.screenSize.height * 0.08,
      /// Creamos el @TabBar: Cuando hagan tap introducira el id de la categoria en base a la posicion en el tabbar.
      child: TabBar(
        onTap: ( index ) => productInfo.putNewProductCategory(categories[index].id),
        controller: _tabController,
        isScrollable: true,
        tabs: _categories(categories)
      ),
    );
  }

  List<Widget>_categories(List<CategoryModel> lst) {
    ///
    /// ** Mapeamos la lista de categorias y dividimos 1:1.
    ///
    return lst.map((e) => new CategoryTab( category: e )).toList();
  }
}

class CategoryTab extends StatelessWidget {
  final CategoryModel category;
  CategoryTab({@required this.category});
  ///
  /// ** Cada iteracion del map sera un objeto de este tipo.
  ///
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(category.nombre, style: TextStyle(color: Colors.blue, fontSize: 20, fontWeight: FontWeight.w600)),
      ),
    );
  }
}