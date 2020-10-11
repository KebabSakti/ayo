import 'package:ayo/pages/pengiriman/bloc/suggest_autocomplete_cubit.dart';
import 'package:ayo/widget/shimmer/box_radius_shimmer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class Destination extends StatefulWidget {
  @override
  _DestinationState createState() => _DestinationState();
}

class _DestinationState extends State<Destination> {
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showMaterialModalBottomSheet(
        context: context,
        useRootNavigator: true,
        expand: true,
        enableDrag: false,
        backgroundColor: Colors.white,
        duration: Duration(milliseconds: 200),
        builder: (context, scrollController) => BlocProvider<SuggestAutocompleteCubit>(
          create: (context) => SuggestAutocompleteCubit(),
          child: SearchLocationWidget(),
        ),
      );
    });
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
        ],
      ),
    );
  }
}

class SearchLocationWidget extends StatefulWidget {
  @override
  _SearchLocationWidgetState createState() => _SearchLocationWidgetState();
}

class _SearchLocationWidgetState extends State<SearchLocationWidget> {
  SuggestAutocompleteCubit _suggestAutocompleteCubit;

  void _suggestTextField(String value) {
    _suggestAutocompleteCubit.searchKeyword(value);
  }

  @override
  void initState() {
    // TODO: implement initState
    _suggestAutocompleteCubit = context.bloc<SuggestAutocompleteCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Tujuan pengantaran',
          style: TextStyle(color: Colors.grey[800]),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.grey[800]),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
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
                autofocus: true,
                style: TextStyle(color: Colors.grey[800]),
                cursorColor: Colors.grey[800],
                cursorWidth: 1,
                decoration: new InputDecoration(
                    border:
                        new OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(20)),
                    filled: true,
                    fillColor: Colors.grey[100],
                    hintText: 'Ketik lokasi tujuan',
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
              onTap: () {},
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
                            var name =
                                suggestion[index].description.substring(0, suggestion[index].description.indexOf(','));
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
