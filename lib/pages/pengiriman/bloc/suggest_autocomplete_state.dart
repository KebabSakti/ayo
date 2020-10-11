part of 'suggest_autocomplete_cubit.dart';

abstract class SuggestAutocompleteState extends Equatable {
  final PlacesAutocompleteResponse placesAutocompleteResponse;
  const SuggestAutocompleteState(this.placesAutocompleteResponse);
}

class SuggestAutocompleteInitial extends SuggestAutocompleteState {
  SuggestAutocompleteInitial(PlacesAutocompleteResponse placesAutocompleteResponse) : super(placesAutocompleteResponse);

  @override
  List<Object> get props => [];
}

class SuggestAutoCompleteLoading extends SuggestAutocompleteState {
  SuggestAutoCompleteLoading(PlacesAutocompleteResponse placesAutocompleteResponse) : super(placesAutocompleteResponse);

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class SuggestAutoCompleteComplete extends SuggestAutocompleteState {
  final PlacesAutocompleteResponse placesAutocompleteResponse;
  SuggestAutoCompleteComplete(this.placesAutocompleteResponse) : super(placesAutocompleteResponse);

  @override
  // TODO: implement props
  List<Object> get props => [placesAutocompleteResponse];
}
