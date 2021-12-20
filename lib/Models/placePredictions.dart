class PlacePredictions {
  String secondary_text;
  String main_text;
  String place_id;

  PlacePredictions({this.secondary_text, this.main_text, this.place_id});

  PlacePredictions.fromJson(Map<String, dynamic> json) {
    place_id = json['place_id'];
    main_text = json['structured_formatting']['main_text'];
    secondary_text = json['structured_formatting']['secondary_text'];
  }
  /* factory PlacePredictions.fromJson(Map<String, dynamic> json) {
    return PlacePredictions(
      place_id: json['place_id'],
      main_text: json['structured_formatting']['main_taxt'],
      secondary_text: json['structured_formatting']['secondary_text'],
    );
  } */
}
