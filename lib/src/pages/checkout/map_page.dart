import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:pedidos_mobile/src/providers/shop/add_shop.dart';
import 'package:provider/provider.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  GoogleMapController mapController;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  final location = new Location().getLocation(); // Obtenemos la ubicacion del dispositivo.
  LocationData pinPos; // posicion del pin.
  LocationData actualLocation; // Posicion actual del dispositivo : location.

  void _onMapCreated(GoogleMapController controller){
    /// 
    /// ***
    ///   Al crear el mapa inyectamos dependencias.
    ///   Agregamos el pin con el method _add acorde la ubicacion actual.
    /// ***
    ///
    mapController = controller;
    _add(LatLng(pinPos.latitude, pinPos.longitude));
  }

  @override
  Widget build(BuildContext context) {
    final addShopInfo = Provider.of<AddShopInfo>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Seleccione una ubicacion')),
      floatingActionButton: _floatingButtons(context, addShopInfo),
      floatingActionButtonLocation: FloatingActionButtonLocation.startDocked,
      body: Stack(
        children: [
          _createMap(),
        ],
      ),
    );
  }

 Widget _createMap() {
    return FutureBuilder(
      future: location,
      builder: (BuildContext context, AsyncSnapshot<LocationData> snapshot) {
        if(snapshot.hasData){
          final pos = snapshot.data;
          pinPos = pos;
          actualLocation = pos;
          return SafeArea(
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              myLocationEnabled: true,
              initialCameraPosition: CameraPosition(    
                target: LatLng(pos.latitude, pos.longitude),
                zoom: 15
              ),
              markers: Set<Marker>.of(markers.values),
            ),
          );
        }else{
          return Center(child: LinearProgressIndicator());
        }
    });
   }

  void _add(LatLng latlng) {
      final MarkerId markerId = MarkerId('normal');
      // Creamos un nuevo marker.
      final Marker marker = Marker(
        markerId: markerId,
        draggable: true,
        onDragEnd: (latlng){
          // Cuando termine de arrastrar
          // Cambiara el valor de pinPos por el actual.
          pinPos = new LocationData.fromMap({
            'latitude': latlng.latitude,
            'longitude': latlng.longitude,
          });
        },
        position: latlng,
        infoWindow: InfoWindow(title: 'Mi Pedido', snippet: 'Aqui se entregara su pedido'),
        onTap: () {

        },
      );
      setState(() {
        // Agregar el marker a la lista de markers.
        markers[markerId] = marker;
      });
  }

  Future<String> _getLocationAddress(LocationData latlng) async {
    ////
    ///   Obtiene los datos de direccion acorde @LocationData.
    ///
    ///
    List<geocoding.Placemark> placemarks = await geocoding.placemarkFromCoordinates(latlng.latitude, latlng.longitude);
    return 
    '${placemarks.first.thoroughfare.isNotEmpty ? placemarks.first.thoroughfare + ', ' : ''}'
    '${placemarks.first.subLocality.isNotEmpty ? placemarks.first.subLocality+ ', ' : ''}'
    '${placemarks.first.locality.isNotEmpty ? placemarks.first.locality+ ', ' : ''}'
    '${placemarks.first.subAdministrativeArea.isNotEmpty ? placemarks.first.subAdministrativeArea + ', ' : ''}'
    '${placemarks.first.postalCode.isNotEmpty ? placemarks.first.postalCode + ', ' : ''}'
    '${placemarks.first.administrativeArea.isNotEmpty ? placemarks.first.administrativeArea : ''}';
  }

  _floatingButtons(BuildContext context, AddShopInfo addShopInfo) {
    final size = MediaQuery.of(context).size;

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: size.height * 0.13),
          FloatingActionButton.extended(
            heroTag: UniqueKey(),
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            onPressed: () => _useActualLocation(context, addShopInfo, actualLocation), 
            label: Row(
              children: [
                Icon(Icons.check),
                Text('Usar mi ubicacion actual'),
              ],
            )
          ),
          SizedBox(height: 5),
          FloatingActionButton.extended(
            heroTag: UniqueKey(),
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            onPressed: () => _useActualLocation(context, addShopInfo, pinPos), 
            label: Row(
              children: [
                Icon(Icons.pin_drop_rounded),
                Text('Usar ubicacion del pin'),
              ],
            )
          ),
          SizedBox(height: 5),
          Spacer(),
        ],
      ),
    );
  }

  _useActualLocation(BuildContext context, AddShopInfo addShopInfo, LocationData location) {
    String locationAddress = 'Direccion no detectada';
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_){
        return AlertDialog(
          title: Text('¿Esta es la direccion de entrega?'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FutureBuilder(
                future: _getLocationAddress(location),
                builder: (_, AsyncSnapshot<String> snapshot){
                  if(snapshot.hasData){
                    locationAddress = snapshot.data;
                    return Text(locationAddress);
                  } 
                  return Center(child: LinearProgressIndicator());
                },
              )
            ],
          ),
          actions: [
            TextButton(
              child: Text('SI'),
              onPressed: () {
                addShopInfo.putLocation(location);
                addShopInfo.putLocationAddress(locationAddress);
                return Navigator.pushReplacementNamed(context, 'confirmorder');
              }, 
            ),
            TextButton(
              child: Text('NO'),
              onPressed: () => Navigator.of(context).pop(), 
            ),
          ],
        );
      }
    );
  }
}