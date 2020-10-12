import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geocoder/geocoder.dart';

part 'reverse_geo_state.dart';

class ReverseGeoCubit extends Cubit<ReverseGeoState> {
  ReverseGeoCubit() : super(ReverseGeoInitial(List<Address>()));

  void loadingAddress() {
    emit(ReverseGeoLoading(state.addresses));
  }

  void getAddressFromCoordinate(Coordinates coordinates) async {
    var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    emit(ReverseGeoComplete(addresses));
  }
}
