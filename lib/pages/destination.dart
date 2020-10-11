import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Destination extends StatefulWidget {
  @override
  _DestinationState createState() => _DestinationState();
}

class _DestinationState extends State<Destination> {
  static final String _apiKey = 'AIzaSyB7doxfW-m-TpBRogzeX2EVyIL9RmGXar0';

  static final CameraPosition _samarinda = CameraPosition(
    target: LatLng(-0.495951, 117.135010),
    zoom: 9,
  );

  GoogleMapController _controller;

  void _initGmap() async {
    Position position = await getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    _controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: (LatLng(position.latitude, position.longitude)),
          zoom: 17,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.grey[800],
        ),
      ),
      backgroundColor: Colors.white,
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
              _initGmap();
            },
            onCameraMove: (position) {
              // _cameraMoveListener(position);
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.horizontal(left: Radius.circular(20), right: Radius.circular(20)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
