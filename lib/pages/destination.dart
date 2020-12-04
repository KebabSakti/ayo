import 'package:ayo/bloc/delivery_detail_cubit.dart';
import 'package:ayo/bloc/order_detail_cubit.dart';
import 'package:ayo/bloc/order_summary_cubit.dart';
import 'package:ayo/bloc/reverse_geo_cubit.dart';
import 'package:ayo/model/ordersummary/delivery_detail_model.dart';
import 'package:ayo/model/ordersummary/order_detail_model.dart';
import 'package:ayo/model/ordersummary/order_summary.dart';
import 'package:ayo/pages/pengiriman/bloc/suggest_autocomplete_cubit.dart';
import 'package:ayo/widget/shimmer/box_radius_shimmer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Destination extends StatefulWidget {
  final List<OrderDetail> orderDetail;

  Destination({@required this.orderDetail});

  @override
  _DestinationState createState() => _DestinationState();
}

class _DestinationState extends State<Destination> with TickerProviderStateMixin {
  ReverseGeoCubit _reverseGeoCubit;
  OrderSummaryCubit _orderSummaryCubit;
  DeliveryDetailCubit _deliveryDetailCubit;
  OrderDetailCubit _orderDetailCubit;

  Coordinates _coordinates;
  GoogleMapController _controller;

  static final CameraPosition _samarinda = CameraPosition(
    target: LatLng(-0.495951, 117.135010),
    zoom: 9,
  );

  void _initGmap() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
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
    _reverseGeoCubit.loadingAddress();
  }

  void _mapCameraStopListener() {
    if (_coordinates != null) _reverseGeoCubit.getAddressFromCoordinate(_coordinates);
  }

  void _mapCameraMoveListener(CameraPosition position) {
    _coordinates = Coordinates(position.target.latitude, position.target.longitude);
  }

  void _setOrderSummary(OrderSummary orderSummary) {
    _orderSummaryCubit.addOrderSummary(orderSummary);
  }

  void _setOrderDetail(List<OrderDetail> orderDetails) {
    _orderDetailCubit.setOrderDetail(orderDetails: orderDetails);
  }

  void _setDeliveryDetail(List<DeliveryDetail> deliveryDetail) {
    _deliveryDetailCubit.setDeliveryDetail(deliveryDetails: deliveryDetail);
  }

  void _popRule() {
    // if (_animationControllerSuggest.status == AnimationStatus.completed) {
    //   Navigator.of(context).pop();
    // } else {
    //   _animationControllerSuggest.forward();
    // }
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    _reverseGeoCubit = context.bloc<ReverseGeoCubit>();
    _orderSummaryCubit = context.bloc<OrderSummaryCubit>();
    _deliveryDetailCubit = context.bloc<DeliveryDetailCubit>();
    _orderDetailCubit = context.bloc<OrderDetailCubit>();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _setOrderDetail(widget.orderDetail);
    });

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<OrderDetailCubit, OrderDetailState>(
          listener: (context, state) {
            if (state is OrderDetailComplete) {
              _setOrderSummary(OrderSummary(orderDetails: state.orderDetails));
            }
          },
        ),
        BlocListener<DeliveryDetailCubit, DeliveryDetailState>(
          listener: (context, state) {
            if (state is DeliveryDetailComplete) {
              _setOrderSummary(OrderSummary(deliveryDetails: state.deliveryDetails));
            }
          },
        ),
      ],
      child: WillPopScope(
        onWillPop: () async {
          _popRule();
          return false;
        },
        child: MultiBlocListener(
          listeners: [
            BlocListener<ReverseGeoCubit, ReverseGeoState>(
              listener: (context, state) {
                if (state is ReverseGeoComplete) {
                  // _animationControllerAddress.reverse();
                }
              },
            ),
          ],
          child: Scaffold(
            extendBodyBehindAppBar: true,
            backgroundColor: Colors.white,
            resizeToAvoidBottomPadding: false,
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
                  child: BlocProvider<SuggestAutocompleteCubit>(
                    create: (context) => SuggestAutocompleteCubit(),
                    child: BlocProvider.value(
                      value: _deliveryDetailCubit,
                      child: SearchLocationWidget(
                        setOrderSummary: _setOrderSummary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SearchLocationWidget extends StatefulWidget {
  final ValueSetter<OrderSummary> setOrderSummary;

  SearchLocationWidget({@required this.setOrderSummary});

  @override
  _SearchLocationWidgetState createState() => _SearchLocationWidgetState();
}

class _SearchLocationWidgetState extends State<SearchLocationWidget> {
  final FocusNode _focusNode = FocusNode();
  DeliveryDetailCubit _deliveryDetailCubit;
  SuggestAutocompleteCubit _suggestAutocompleteCubit;
  double _offset = 0.6;

  void _suggestTextField(String value) {
    _suggestAutocompleteCubit.searchKeyword(value);
  }

  void _setOffset(double value) {
    setState(() {
      _offset = value;
    });
  }

  void _focusNodeListener() {
    if (_focusNode.hasFocus) _setOffset(0.0);
  }

  @override
  void initState() {
    _suggestAutocompleteCubit = context.bloc<SuggestAutocompleteCubit>();
    _focusNode.addListener(_focusNodeListener);
    _deliveryDetailCubit = context.bloc<DeliveryDetailCubit>();

    super.initState();
  }

  @override
  void dispose() {
    _focusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: TweenAnimationBuilder(
        duration: Duration(milliseconds: 300),
        tween: Tween<Offset>(begin: Offset(0.0, 0.6), end: Offset(0.0, _offset)),
        child: Container(
          padding: const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
          height: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10, bottom: 15, top: 10),
                child: Text(
                  'Set lokasi pengiriman',
                  style: TextStyle(
                    color: Colors.grey[800],
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
              ),
              Theme(
                data: new ThemeData(
                  primaryColor: Colors.transparent,
                  primaryColorDark: Colors.transparent,
                ),
                child: new TextField(
                  onChanged: (value) => _suggestTextField(value),
                  focusNode: _focusNode,
                  autofocus: false,
                  style: TextStyle(color: Colors.grey[800]),
                  cursorColor: Colors.grey[800],
                  cursorWidth: 1,
                  decoration: new InputDecoration(
                      border:
                          new OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(20)),
                      isDense: true,
                      filled: true,
                      contentPadding: EdgeInsets.all(10),
                      fillColor: Colors.grey[100],
                      hintText: 'Cari di sini',
                      hintStyle: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 14,
                      ),
                      prefixIcon: const Icon(
                        Icons.radio_button_checked,
                        color: Colors.redAccent,
                      ),
                      suffixStyle: const TextStyle(color: Colors.green)),
                ),
              ),
              (_offset == 0.0)
                  ? GestureDetector(
                      onTap: () {
                        _focusNode.unfocus();
                        _setOffset(1.0);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 4, top: 10),
                        child: Text(
                          'Pilih dari peta',
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).colorScheme.secondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    )
                  : SizedBox.shrink(),
              SizedBox(
                height: 20,
              ),
              // Container(
              //   color: Colors.grey[100],
              //   height: 1,
              // ),
              Expanded(child: BlocBuilder<SuggestAutocompleteCubit, SuggestAutocompleteState>(
                builder: (context, state) {
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
                                          // widget.setOrderSummary(OrderSummary(deliveryDetails: ));
                                          _setOffset(1.0);
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
                                                  (index + 1 != suggestion.length)
                                                      ? Container(
                                                          color: Colors.grey[100],
                                                          height: 1,
                                                        )
                                                      : SizedBox.shrink(),
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
        builder: (context, value, child) {
          return FractionalTranslation(
            translation: value,
            child: child,
          );
        },
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
    _animationOffset =
        Tween<Offset>(begin: Offset(0.0, 0.6), end: Offset(0.0, 0.6)).animate(widget.animationController);

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SlideTransition(
        position: _animationOffset,
        child: Container(
          padding: EdgeInsets.all(15),
          height: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
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
                          onPressed: () {
                            Navigator.of(context).pushNamed('/pengiriman');
                          },
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
