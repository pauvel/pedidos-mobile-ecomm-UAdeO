import 'package:flutter/material.dart';
import 'package:pedidos_mobile/src/models/product_model.dart';

class ProductDetails extends StatelessWidget {
  final ProductModel product;

  const ProductDetails({ @required this.product });

  @override
  Widget build(BuildContext context) {
    return _showProductDetails(context, product);
  }
    
  Widget _showProductDetails(BuildContext context, ProductModel product) {

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _DetailsHeader(product: product),
            _DetailsBody(product: product),
          ],
        ),
      ),
      actions: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Divider(),
            RaisedButton.icon(
              onPressed: () => Navigator.of(context).pop(), 
              icon: Icon(Icons.exit_to_app), 
              label: Text('Aceptar'),
              color: Colors.deepPurple,
            ),
          ],
        )
      ],
    );
  }
}

class _DetailsHeader extends StatelessWidget {
  final ProductModel product;
  const _DetailsHeader({@required this.product});
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    String isProductUnit = (product.unitario == 'no') ? 'Desde \$${product.precioch} Hasta \$${product.preciog}' : 'Desde \$${product.precioch}';
    
    return Column(
      children: [
        Container(
            height: screenSize.height * 0.20,
            width: screenSize.width * 0.45,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(150),
              child: FadeInImage(
                placeholder: AssetImage('assets/images/loading-sushi.gif'), 
                image: NetworkImage(product.url),
                fit: BoxFit.cover
              ),
            ),
        ),
        SizedBox(height: 5),
        Text(product.nombre, style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700), textAlign: TextAlign.center,),
        SizedBox(height: 5),
        Text(isProductUnit, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w200), textAlign: TextAlign.center,),
        Text('(El precio puede variar acorde extras).', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w200), textAlign: TextAlign.center,),
        SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.star, color: Colors.deepOrange),
            Icon(Icons.star, color: Colors.deepOrange),
            Icon(Icons.star, color: Colors.deepOrange),
            Icon(Icons.star, color: Colors.deepOrange),
            Icon(Icons.star, color: Colors.deepOrange),
          ],
        ),
        SizedBox(height: 5),
        Icon(Icons.favorite, color: Colors.red, size: 40),
        Text('A ${product.likes} personas les gusta este producto.', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w300), textAlign: TextAlign.center),
        Divider(),
      ],
    );
  }
}

class _DetailsBody extends StatelessWidget {
  final ProductModel product;
  const _DetailsBody({@required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 10),
      child: Column(
        children: [
          SizedBox(height: 10),
          Text(product.descripcion, textAlign: TextAlign.justify)
        ],
      ),
    );
  }
}