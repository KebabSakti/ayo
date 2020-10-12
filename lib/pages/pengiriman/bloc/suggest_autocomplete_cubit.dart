import 'package:ayo/constant/constant.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_webservice/places.dart';

part 'suggest_autocomplete_state.dart';

class SuggestAutocompleteCubit extends Cubit<SuggestAutocompleteState> {
  SuggestAutocompleteCubit() : super(SuggestAutocompleteInitial(null));

  GoogleMapsPlaces places = GoogleMapsPlaces(apiKey: googleMapKey);

  void searchKeyword(String keyword) async {
    emit(SuggestAutoCompleteLoading(state.placesAutocompleteResponse));

    PlacesAutocompleteResponse placesAutocompleteResponse = await places.autocomplete(
      keyword,
      location: Location(-0.495951, 117.135010),
      radius: 10000,
      strictbounds: true,
    );
    emit(SuggestAutoCompleteComplete(placesAutocompleteResponse));
  }
}
