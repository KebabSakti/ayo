part of 'reverse_geo_cubit.dart';

abstract class ReverseGeoState extends Equatable {
  final List<Address> addresses;
  const ReverseGeoState(this.addresses);
}

class ReverseGeoInitial extends ReverseGeoState {
  ReverseGeoInitial(List<Address> addresses) : super(addresses);

  @override
  List<Object> get props => [];
}

class ReverseGeoLoading extends ReverseGeoState {
  ReverseGeoLoading(List<Address> addresses) : super(addresses);

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class ReverseGeoComplete extends ReverseGeoState {
  final List<Address> addresses;
  ReverseGeoComplete(this.addresses) : super(addresses);

  @override
  // TODO: implement props
  List<Object> get props => [];
}
