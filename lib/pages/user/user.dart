import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/distance.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:permission_handler/permission_handler.dart';

class User extends StatefulWidget {
  @override
  _UserState createState() => _UserState();
}

class _UserState extends State<User> {
  final String _apiKey = 'AIzaSyB7doxfW-m-TpBRogzeX2EVyIL9RmGXar0';

  GoogleMapController _controller;
  TextEditingController _textEditingController = TextEditingController();

  static final CameraPosition _samarinda = CameraPosition(
    target: LatLng(-0.495951, 117.135010),
    zoom: 9,
  );

  Future<bool> _locationPermission() async {
    return await Permission.location.request().isGranted;
  }

  Future<Position> _getCurrentPosition() async {
    return await getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  void _searchTextListener(String value) async {
    GoogleMapsPlaces places = GoogleMapsPlaces(apiKey: _apiKey);
    GoogleDistanceMatrix distanceMatrix = GoogleDistanceMatrix(apiKey: _apiKey);

    PlacesAutocompleteResponse placesAutocompleteResponse = await places.autocomplete(
      value,
      location: Location(-0.495951, 117.135010),
      radius: 10000,
      strictbounds: true,
    );

    placesAutocompleteResponse.predictions.forEach((e) async {
      PlacesDetailsResponse placesDetailsResponse = await places.getDetailsByPlaceId(e.placeId);

      List<Location> origin = [
        Location(-0.495951, 117.135010),
      ];

      List<Location> destination = [
        Location(
          placesDetailsResponse?.result?.geometry?.location?.lat,
          placesDetailsResponse?.result?.geometry?.location?.lng,
        )
      ];

      DistanceResponse distanceResponse = await distanceMatrix.distanceWithLocation(origin, destination);
      print(e.description);
      print(e.placeId);
      print(
          '${placesDetailsResponse?.result?.geometry?.location?.lat}, ${placesDetailsResponse?.result?.geometry?.location?.lng}');
      print(distanceResponse.results.first.elements.first.distance.text);
      print(distanceResponse.results.first.elements.first.duration.text);
    });
  }

  void _cameraMoveListener(CameraPosition position) {
    print('${position.target.latitude}, ${position.target.longitude}');
  }

  void _initGMAP() async {
    if (await _locationPermission()) {
      Position position = await _getCurrentPosition();
      _controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: (LatLng(position.latitude, position.longitude)),
            zoom: 17,
          ),
        ),
      );

      var addresses =
          await Geocoder.local.findAddressesFromCoordinates(Coordinates(position.latitude, position.longitude));
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: _samarinda,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            mapToolbarEnabled: false,
            rotateGesturesEnabled: false,
            tiltGesturesEnabled: false,
            zoomControlsEnabled: false,
            compassEnabled: false,
            onMapCreated: (GoogleMapController controller) {
              this._controller = controller;
              _initGMAP();
            },
            onCameraMove: (position) {
              _cameraMoveListener(position);
            },
          ),
          TextField(
            controller: _textEditingController,
            onChanged: (value) => _searchTextListener(value),
          ),
        ],
      ),
    );
  }
}
