import 'package:ayo/bloc/reverse_geo_cubit.dart';
import 'package:ayo/pages/pengiriman/bloc/suggest_autocomplete_cubit.dart';
import 'package:ayo/widget/shimmer/box_radius_shimmer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Destination extends StatefulWidget {
  @override
  _DestinationState createState() => _DestinationState();
}

class _DestinationState extends State<Destination> with TickerProviderStateMixin {
  ReverseGeoCubit _reverseGeoCubit;
  Coordinates _coordinates;

  AnimationController _animationControllerAddress;
  AnimationController _animationControllerSuggest;

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
          zoom: 16,
        ),
      ),
    );
  }

  void _mapCameraMoveStartListener() {
    _animationControllerAddress.forward();

    _reverseGeoCubit.loadingAddress();
  }

  void _mapCameraStopListener() {
    if (_coordinates != null) _reverseGeoCubit.getAddressFromCoordinate(_coordinates);
  }

  void _mapCameraMoveListener(CameraPosition position) {
    _coordinates = Coordinates(position.target.latitude, position.target.longitude);
  }

  void _suggestionWindow() {
    _animationControllerSuggest.reverse();
  }

  void _popRule() {
    if (_animationControllerSuggest.status == AnimationStatus.completed) {
      Navigator.of(context).pop();
    } else {
      _animationControllerSuggest.forward();
    }
  }

  @override
  void initState() {
    _animationControllerAddress = AnimationController(vsync: this, duration: Duration(milliseconds: 100));
    _animationControllerSuggest = AnimationController(vsync: this, duration: Duration(milliseconds: 100));

    _animationControllerSuggest.forward();

    _reverseGeoCubit = context.bloc<ReverseGeoCubit>();

    super.initState();
  }

  @override
  void dispose() {
    _animationControllerAddress.dispose();
    _animationControllerSuggest.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _popRule();
        return false;
      },
      child: MultiBlocListener(
        listeners: [
          BlocListener<ReverseGeoCubit, ReverseGeoState>(
            listener: (context, state) {
              if (state is ReverseGeoComplete) {
                _animationControllerAddress.reverse();
              }
            },
          ),
        ],
        child: Scaffold(
          extendBodyBehindAppBar: true,
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
                onCameraMoveStarted: _mapCameraMoveStartListener,
                onCameraIdle: _mapCameraStopListener,
                onCameraMove: (position) {
                  _mapCameraMoveListener(position);
                },
                onMapCreated: (GoogleMapController controller) {
                  this._controller = controller;
                  Future.delayed(Duration(seconds: 1), () {
                    _initGmap();
                  });
                },
              ),
              Align(
                alignment: Alignment.center,
                child: Icon(
                  Icons.radio_button_checked,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: AddressMapWindow(
                  suggestWindow: _suggestionWindow,
                  animationController: _animationControllerAddress,
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: BlocProvider<SuggestAutocompleteCubit>(
                  create: (context) => SuggestAutocompleteCubit(),
                  child: SearchLocationWidget(
                    animationController: _animationControllerSuggest,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SearchLocationWidget extends StatefulWidget {
  final AnimationController animationController;

  SearchLocationWidget({@required this.animationController});

  @override
  _SearchLocationWidgetState createState() => _SearchLocationWidgetState();
}

class _SearchLocationWidgetState extends State<SearchLocationWidget> {
  Animation<Offset> _animationOffset;
  SuggestAutocompleteCubit _suggestAutocompleteCubit;

  void _suggestTextField(String value) {
    _suggestAutocompleteCubit.searchKeyword(value);
  }

  @override
  void initState() {
    _animationOffset = Tween<Offset>(begin: Offset.zero, end: Offset(0.0, 1.0)).animate(widget.animationController);
    _suggestAutocompleteCubit = context.bloc<SuggestAutocompleteCubit>();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _animationOffset,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          titleSpacing: 0,
          leading: GestureDetector(
            onTap: () {
              widget.animationController.forward();
            },
            child: Icon(
              Icons.close,
              color: Colors.grey[800],
            ),
          ),
          title: Text(
            'Cari lokasi pengiriman',
            style: TextStyle(
              color: Colors.grey[800],
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          elevation: 0,
        ),
        body: Container(
          padding: const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
          height: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Theme(
                data: new ThemeData(
                  primaryColor: Colors.transparent,
                  primaryColorDark: Colors.transparent,
                ),
                child: new TextField(
                  onChanged: (value) => _suggestTextField(value),
                  autofocus: false,
                  style: TextStyle(color: Colors.grey[800]),
                  cursorColor: Colors.grey[800],
                  cursorWidth: 1,
                  decoration: new InputDecoration(
                      border:
                          new OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(20)),
                      filled: true,
                      fillColor: Colors.grey[100],
                      hintText: 'Ketik nama jalan',
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      prefixIcon: const Icon(
                        Icons.radio_button_checked,
                        color: Colors.redAccent,
                      ),
                      suffixStyle: const TextStyle(color: Colors.green)),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  widget.animationController.forward();
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: Text(
                    'Pilih dari peta',
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.secondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                color: Colors.grey[100],
                height: 1,
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(child: BlocBuilder<SuggestAutocompleteCubit, SuggestAutocompleteState>(
                builder: (context, state) {
                  print(state);
                  if (state.placesAutocompleteResponse != null) {
                    var suggestion = state.placesAutocompleteResponse.predictions;
                    return (suggestion.length > 0)
                        ? ListView.builder(
                            itemCount: (suggestion.length > 0) ? suggestion.length : 5,
                            itemBuilder: (context, index) {
                              var name = suggestion[index]
                                  .description
                                  .substring(0, suggestion[index].description.indexOf(','));
                              return Padding(
                                padding: const EdgeInsets.only(top: 10, bottom: 10),
                                child: (state is SuggestAutoCompleteComplete)
                                    ? GestureDetector(
                                        onTap: () {
                                          print(suggestion[index].placeId);
                                        },
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            CircleAvatar(
                                              backgroundColor: Colors.grey[200],
                                              radius: 20,
                                              child: Icon(
                                                Icons.location_on,
                                                color: Theme.of(context).primaryColor,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 20,
                                            ),
                                            Flexible(
                                              fit: FlexFit.loose,
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    '$name',
                                                    style: TextStyle(
                                                      color: Colors.grey[800],
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Text(
                                                    '${suggestion[index].description}',
                                                    style: TextStyle(
                                                      color: Colors.grey[800],
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 20,
                                                  ),
                                                  Container(
                                                    color: Colors.grey[100],
                                                    height: 1,
                                                  )
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    : _suggestionShimmer(),
                              );
                            },
                          )
                        : SizedBox.shrink();
                  }

                  return SizedBox.shrink();
                },
              )),
            ],
          ),
        ),
      ),
    );
  }
}

class AddressMapWindow extends StatefulWidget {
  final VoidCallback suggestWindow;
  final AnimationController animationController;

  AddressMapWindow({
    @required this.suggestWindow,
    @required this.animationController,
  });

  @override
  _AddressMapWindowState createState() => _AddressMapWindowState();
}

class _AddressMapWindowState extends State<AddressMapWindow> {
  Animation<Offset> _animationOffset;

  @override
  void initState() {
    _animationOffset = Tween<Offset>(begin: Offset.zero, end: Offset(0.0, 0.4)).animate(widget.animationController);

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _animationOffset,
      child: Container(
        padding: EdgeInsets.all(15),
        height: 230,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.grey[350],
              blurRadius: 16.0,
              spreadRadius: 0.5,
              offset: Offset(0.0, 1),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Set lokasi tujuan',
                  style: TextStyle(
                    color: Colors.grey[800],
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                GestureDetector(
                  onTap: widget.suggestWindow,
                  child: Text(
                    'Edit',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            BlocBuilder<ReverseGeoCubit, ReverseGeoState>(
              builder: (context, state) {
                if (state is ReverseGeoComplete) {
                  var addr = state.addresses.first;
                  var name = addr.addressLine.substring(0, addr.addressLine.indexOf(','));
                  return Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.grey[200],
                            radius: 20,
                            child: Icon(
                              Icons.location_on,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Flexible(
                            fit: FlexFit.loose,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '$name',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.grey[800],
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  '${addr.addressLine}',
                                  maxLines: 4,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.grey[800],
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      FlatButton(
                        onPressed: () {},
                        minWidth: double.infinity,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        color: Theme.of(context).primaryColor,
                        child: Text(
                          'Set lokasi',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  );
                }

                return _addressShimmer();
              },
            ),
          ],
        ),
      ),
    );
  }
}

Widget _suggestionShimmer() {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      boxRadiusShimmer(radius: 20, width: 40, height: 40),
      SizedBox(
        width: 20,
      ),
      Flexible(
        fit: FlexFit.loose,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            boxRadiusShimmer(height: 10, width: 100, radius: 5),
            SizedBox(
              height: 5,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                boxRadiusShimmer(height: 10, width: double.infinity, radius: 5),
                SizedBox(
                  height: 5,
                ),
                boxRadiusShimmer(height: 10, width: 200, radius: 5),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              color: Colors.grey[100],
              height: 1,
            )
          ],
        ),
      )
    ],
  );
}

Widget _addressShimmer() {
  return Column(
    children: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          boxRadiusShimmer(radius: 20, width: 40, height: 40),
          SizedBox(
            width: 20,
          ),
          Flexible(
            fit: FlexFit.loose,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                boxRadiusShimmer(height: 10, width: 100, radius: 5),
                SizedBox(
                  height: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    boxRadiusShimmer(
                      height: 10,
                      width: double.infinity,
                      radius: 5,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    boxRadiusShimmer(
                      height: 10,
                      width: 230,
                      radius: 5,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    boxRadiusShimmer(
                      height: 10,
                      width: 220,
                      radius: 5,
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
      SizedBox(
        height: 20,
      ),
      boxRadiusShimmer(
        width: double.infinity,
        height: 35,
        radius: 25,
      ),
    ],
  );
}
