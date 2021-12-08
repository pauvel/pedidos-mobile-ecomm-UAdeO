import 'package:flutter/material.dart';
import 'package:pedidos_mobile/src/pages/checkout/confirm_page.dart';
import 'package:pedidos_mobile/src/pages/checkout/map_page.dart';
import 'package:pedidos_mobile/src/pages/dashboard/catalog_page.dart';
import 'package:pedidos_mobile/src/pages/dashboard/home_page.dart';
import 'package:pedidos_mobile/src/pages/dashboard/new_delivery_page.dart';
import 'package:pedidos_mobile/src/pages/dashboard/preferences_page.dart';
// import 'package:pedidos_mobile/src/pages/dashboard/sub/ticket.dart';
import 'package:pedidos_mobile/src/pages/main/login_page.dart';
import 'package:pedidos_mobile/src/pages/main/register_page.dart';
import 'package:pedidos_mobile/src/pages/shop/shop_cart.dart';
import 'package:pedidos_mobile/src/pages/shop/shop_page.dart';
import 'package:pedidos_mobile/src/providers/appinfo.dart';
import 'package:pedidos_mobile/src/providers/home/categoryinfo.dart';
import 'package:pedidos_mobile/src/providers/home/productinfo.dart';
import 'package:pedidos_mobile/src/providers/login/logininfo.dart';
import 'package:pedidos_mobile/src/providers/login/registerinfo.dart';
import 'package:pedidos_mobile/src/providers/shop/add_shop.dart';
import 'package:provider/provider.dart';
 
void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {    
    return MultiProvider(
        providers: [
          ChangeNotifierProvider( create: (context) => LoginInfo() ),
          ChangeNotifierProvider( create: (context) => RegisterInfo() ),
          ChangeNotifierProvider( create: (context) => AppInfo() ),
          ChangeNotifierProvider( create: (context) => CategoryInfo() ),
          ChangeNotifierProvider( create: (context) => ProductInfo() ),
          ChangeNotifierProvider( create: (context) => AddShopInfo() ),
        ], 
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Material App',
          initialRoute: 'login',
          routes: {
            'login'           : (BuildContext context)      => LoginPage(),
            'register'        : (BuildContext context)      => RegisterPage(),
            'home'            : (BuildContext context)      => HomePage(),
            'catalog'         : (BuildContext context)      => CatalogPage(),
            'newdelivery'     : (BuildContext context)      => NewDeliveryPage(),
            'preferences'     : (BuildContext context)      => PreferencesPage(),
            'shop'            : (BuildContext context)      => ShopPage(),
            'shopcart'        : (BuildContext context)      => ShopCart(),
            'confirmorder'    : (BuildContext context)      => ConfirmPage(),
            'mapbox'          : (BuildContext context)      => MapPage(),
            // 'ticket'          : (BuildContext context)      => Ticket(),
          },
          theme: ThemeData(primaryColor: Colors.deepPurple),
      ) 
    );  

  }
}