import 'package:flutter/material.dart';
import 'package:google_maps_directions/service/direction_service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapView extends StatefulWidget {
  const MapView({Key? key}) : super(key: key);

  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {

  final Set<Marker> _markers = <Marker>{};
  final Set<Polyline> _polylines = <Polyline>{};

  static const CameraPosition _initialCameraPosition = CameraPosition(
    target: LatLng(41.025662407888696, 28.974232958230843),
    zoom: 17,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: GoogleMap(
      initialCameraPosition: _initialCameraPosition,
      mapType: MapType.normal,
      markers: _markers,
      polylines:_polylines,
      onTap: (position) async {
        addMakers(position);
        addPolyline(position);
      },
    ));
  }

  addMakers(LatLng position) {
    return setState(() {
      _markers.clear();
      _markers.add(Marker(markerId: MarkerId(position.toString()), position: position, icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed)));
    });
  }

  addPolyline(LatLng position) async {
    Polyline polyline =await DirectionService().addPolyLine(_initialCameraPosition.target, position);
    setState(() {
      _polylines.add(polyline);
    });
  }
}
