import 'package:http/http.dart' as http;
import 'package:pray_quiet/data/constant.dart';
import 'package:pray_quiet/data/prayer_api_model.dart';

class ApiDataFetch {
  static Future<PrayerApiModel> getPrayerTime(String city) async {
    try {
      var url = Uri.parse('$kBaseUrl/$city');
      var response = await http.get(url);
      if (response.statusCode == 200) {
        return PrayerApiModel.fromRawJson(response.body);
      } else {
        throw Exception(
            'Failed to load data ${response.statusCode} : ${response.body}');
      }
    } catch (e) {
      rethrow;
    }
  }
}
