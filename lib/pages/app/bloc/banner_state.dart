import 'package:ayo/model/banner/slide_banner.dart';
import 'package:equatable/equatable.dart';

abstract class BannerState extends Equatable {
  final Map<String, List<SlideBanner>> banners;
  const BannerState(this.banners);
}

class BannerInitial extends BannerState {
  BannerInitial(Map<String, List<SlideBanner>> banners) : super(banners);

  @override
  List<Object> get props => [];
}

class BannerLoading extends BannerState {
  BannerLoading(Map<String, List<SlideBanner>> banners) : super(banners);

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class BannerCompleted extends BannerState {
  final Map<String, List<SlideBanner>> banners;
  BannerCompleted({this.banners}) : super(banners);

  @override
  // TODO: implement props
  List<Object> get props => [banners];
}

class BannerError extends BannerState {
  final String message;
  BannerError({this.message}) : super(null);

  @override
  // TODO: implement props
  List<Object> get props => [message];
}
