import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:fitbasix/feature/posts/model/suggestion_model.dart';
import 'package:http/http.dart';

// For storing our result
// class Suggestion {
//   final String placeId;
//   final String description;

//   Suggestion(this.placeId, this.description);

//   @override
//   String toString() {
//     return 'Suggestion(description: $description, placeId: $placeId)';
//   }
// }

class PlaceApiProvider {
  static final client = Client();

  // PlaceApiProvider(this.sessionToken);

  // final sessionToken;

  static final String androidKey = '';
  static final String iosKey = '';
  static final apiKey = Platform.isAndroid ? androidKey : iosKey;

  static Future<Suggestion?> fetchSuggestions(
      String input, String lang, String sessionToken) async {
    final request =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&types=establishment&language=$lang&components=country:in&key=$apiKey&sessiontoken=$sessionToken';
    final response = await client.get(Uri.parse(request));

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      if (result['status'] == 'OK') {
        return suggestionFromJson(response.body.toString());
      }
      if (result['status'] == 'ZERO_RESULTS') {
        return null;
      }
      throw Exception(result['error_message']);
    } else {
      throw Exception('Failed to fetch suggestion');
    }
  }

  // Future<Place> getPlaceDetailFromId(String placeId) async {
  //   // if you want to get the details of the selected place by place_id
  // }
}
