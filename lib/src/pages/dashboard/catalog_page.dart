import 'package:flutter/material.dart';
import 'package:pedidos_mobile/src/models/category_model.dart';
import 'package:pedidos_mobile/src/models/product_model.dart';
import 'package:pedidos_mobile/src/pages/dashboard/sub/product_details.dart';
import 'package:pedidos_mobile/src/providers/appinfo.dart';
import 'package:pedidos_mobile/src/providers/client_provider.dart';
import 'package:pedidos_mobile/src/providers/home/categoryinfo.dart';
import 'package:pedidos_mobile/src/providers/home/productinfo.dart';
import 'package:pedidos_mobile/src/widgets/menu_general_widget.dart';
import 'package:provider/provider.dart';

class CatalogPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
   final sizeScreen = MediaQuery.of(context).size;
   final productInfo = Provider.of<ProductInfo>(context);
   final categoryInfo = Provider.of<CategoryInfo>(context);
   final appInfo = Provider.of<AppInfo>(context);

    return StreamBuilder(
      stream: categoryInfo.allCategoriesStream ,
      builder: (BuildContext context, AsyncSnapshot<List<CategoryModel>> snapshot){
        if(snapshot.hasData){
          final lst = snapshot.data;
          return Scaffold(
              backgroundColor: Colors.deepPurple,
              appBar: AppBar(
                title: Text('Menu de productos'),
                elevation: 5,
              ),
              drawer: MenuGeneral(),
              body: Stack(
                children: [
                  _products(sizeScreen, productInfo, lst[0].id, appInfo),
                  BottomModal(lst)
                ],
            )
          );
        }
        return Center(child: CircularProgressIndicator());
      },
    );

  }

 Widget _products(Size sizeScreen, ProductInfo productInfo, int categoryId, AppInfo appInfo) {
   productInfo.putNewProductCategory(categoryId);
   return StreamBuilder(
     stream: productInfo.allProductsStream,
     builder: (BuildContext context, AsyncSnapshot<List<ProductModel>> snapshot){
       if(snapshot.hasData){
         final lst = snapshot.data;
         return  SingleChildScrollView(
          child: Column(
            children: [
              Column(
                children: productBox(sizeScreen, productInfo, lst, context, appInfo),
              ),
              SizedBox(height: 200)
            ]
          ),
        ); 
       }else{
          if(snapshot.hasError) return Container(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Icon(Icons.sentiment_very_dissatisfied, size: 70, color: Colors.red),
                SizedBox(height: 10),
                Text(snapshot.error, style: TextStyle(fontSize: 30, color: Colors.red))
              ],
            ),
          );
          /**
           *  Si aun no hay datos en el snapshot, entonces lanzamos circularprogressindicator.
           */
          return Container(
            height: 55,
            child: Padding(child: CircularProgressIndicator(), 
            padding: EdgeInsets.all(10)),
          );
       }
     },
   );
   // stream builder
   
 }

 List<Container> productBox(Size sizeScreen, ProductInfo productInfo, List<ProductModel> products, BuildContext context, AppInfo appInfo) {
   return products.map(( product ){
     return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(5)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            blurRadius: 3.0,
            spreadRadius: 0,
            offset: Offset.zero,
            color: Colors.black38 
          )
        ]
      ),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: sizeScreen.height * 0.3,
                width: sizeScreen.width * 0.8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10))
                ),
                child: FadeInImage(
                  fadeInDuration: Duration(seconds: 2),
                  fit: BoxFit.fill,
                  placeholder: AssetImage('assets/images/loading-sushi.gif'), 
                  image: NetworkImage(product.url)
                )
              ),
            ]
          ),
          Divider(),
          ListTile(
            title: Text(product.nombre, style: TextStyle(fontSize: 25), textAlign: TextAlign.center),
            subtitle: Text(product.descripcion, style: TextStyle(fontSize: 15), textAlign: TextAlign.center, maxLines: 3, overflow: TextOverflow.ellipsis),
          ),
          SizedBox(height: 20),
          rowOptions(product, context, productInfo, appInfo)
        ],
      ),
    );
   }).toList();
 }

 Widget rowOptions(ProductModel product, BuildContext context, ProductInfo productInfo, AppInfo appInfo) {
   return FutureBuilder(
     future: ClientProvider().validateLike({'product': product.id, 'client': appInfo.clientActualData.id}),
     builder: (BuildContext context, AsyncSnapshot<IconData> snapshot) {
       return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              child: Column(
                children: [
                  IconButton(icon: Icon(snapshot.data, size: 40, color: Colors.red), onPressed: () async {
                       await ClientProvider().likeItem({'product': product.id, 'client': appInfo.clientActualData.id});
                       productInfo.putNewProductCategory(product.categoriaId);
                  }),
                  Text('${product.likes} Likes', style: TextStyle(color: Colors.red))
                ],
              ),
            ),
            RaisedButton(
              child: Text('Detalles'),
              onPressed: (){
                _openDetailsPage(product, context);
              },
            )
          ],
        );
     },
   );
 }

  void _openDetailsPage(ProductModel product, BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => ProductDetails(product: product),
    );
  }
}

class BottomModal extends StatelessWidget {
  final List<CategoryModel> categories;

  BottomModal(this.categories);

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.1,
      maxChildSize: 0.7,
      minChildSize: 0.1,
      builder: (context, scrollController){
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: <BoxShadow>[
              BoxShadow(
                blurRadius: 2.0,
                color: Colors.black45,
                spreadRadius: 1
              )
            ],
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            )
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(top: 20),
                  child: Column(
                    children: [
                      Text('Deslice esconder/mostrar', style: TextStyle(fontSize: 25)),
                      SizedBox(height: 5.0),
                      Icon(Icons.fingerprint, size: 50),
                      Divider(),
                    ],
                  ),
                ),
                CategoriesList(scrollController, categories),
              ],
            )
          ),
        );
      } 
    );
  }
}

class CategoriesList extends StatelessWidget {
  final ScrollController scrollController;
  final List<CategoryModel> categories;
  CategoriesList(this.scrollController, this.categories);

  @override
  Widget build(BuildContext context) {
    final productInfo = Provider.of<ProductInfo>(context);
    return _categorias(categories, productInfo);
  }

  Widget _categorias(List<CategoryModel> categories, ProductInfo productInfo) {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 25),
        child: Column(
          children: _categoriesList(categories, productInfo),
        ),
    );
  }

 List<Widget> _categoriesList(List<CategoryModel> categorias, ProductInfo productInfo) {
   return categorias.map((e){
     return Column(
       children: [
         ListTile(
           title: Text(e.nombre, style: TextStyle(
             fontSize: 20,
           )),
          //  subtitle: Container(padding: EdgeInsets.symmetric(vertical: 5.0), child: Text('Toque aqui para ver los productos de esta categoria.')),
           leading: Icon(Icons.grade, size: 40, color: Colors.orangeAccent),
           trailing: RaisedButton(
             child: Text('Ver'),
             onPressed: (){
               productInfo.putNewProductCategory(e.id);
               scrollController.jumpTo(0);
             },
          ),
         ),
         Divider()
       ],
     );
   }).toList();
 }
}