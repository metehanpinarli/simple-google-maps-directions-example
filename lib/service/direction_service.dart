import 'package:flutter/material.dart';
import 'package:google_directions_api/google_directions_api.dart';
import 'package:google_maps_directions/manager/convert_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DirectionService {
  final _apiKey = "YOUR_API_KEY";

  Future<List<LatLng>> getDirectionData(LatLng origin, LatLng destination) async {
    DirectionsService.init(_apiKey);
    List<LatLng> polylineCoordinates = [];
    final directionsService = DirectionsService();

    final request = DirectionsRequest(
      origin: GeoCoord(origin.latitude, origin.longitude), //Başlangıç Konumu-Zorunlu
      destination: GeoCoord(destination.latitude, destination.longitude), //Bitiş Konumu-Zorunu
      travelMode: TravelMode.driving, //Sürüş Modu
      // drivingOptions: DrivingOptions(departureTime:DateTime.now(),trafficModel: TrafficModel.bestGuess),
      // alternatives:false,//Başka yol altarnetifleri olsun mu?
      // avoidFerries:true, //Feribotlardan kaçınsın mı?
      // avoidHighways:false,// Otoyollardan kaçınsın mı ?
      // unitSystem: UnitSystem.imperial, //Kullanılan birim sistemini belirtir
      // language:"tr",//dönen metin cevaplarının dilini belirtir
    );

    await directionsService.route(request, (DirectionsResult response, DirectionsStatus? status) async {
      if (status == DirectionsStatus.ok) {
        var steps = response.routes![0].legs![0].steps;
        for (int z = 0; z < steps!.length; z++) {
          var point = steps[z].polyline!.points.toString();
          polylineCoordinates.addAll(convertPolyline(point));
        }
      } else {
        throw Exception("Error!");
      }
    });

    return polylineCoordinates;
  }


  Future<Polyline> addPolyLine(LatLng origin, LatLng destination) async {
    List<LatLng> polylineCoordinates = await getDirectionData(origin, destination);
    Polyline polyline = Polyline(
      polylineId:const PolylineId("Poly"),
      color: Colors.blue,
      points: polylineCoordinates,
      width: 8,
      startCap: Cap.roundCap,
      endCap: Cap.roundCap,
    );
    return polyline;
  }

}
