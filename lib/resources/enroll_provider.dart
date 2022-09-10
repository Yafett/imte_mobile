import 'dart:convert';

import 'package:imte_mobile/models/history-model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class EnrollProvider {
  final urlEnroll = "https://adm.imte.education/api/enroll/show";
  final urlPeriod = "https://adm.imte.education/api/period";
  final urlActive = "https://adm.imte.education/api/activity/getImteStatus";

  Future<List<History>> fetchHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getInt('id');

    try {
      final uri = Uri.parse(urlEnroll);
      final response =
          await http.post(uri, body: {'tab_user_id': id.toString()});
      print(response.body);
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as List;
        final history = json.map((e) => History.fromJson(e)).toList();
        return history;
      } else {
        throw Exception("Failed to load history");
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<History>> fetchEnroll() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getInt('id');

    try {
      final uri = Uri.parse(urlEnroll);
      final response =
          await http.post(uri, body: {'tab_user_id': id.toString()});

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as List;
        final enroll = json.map((e) => History.fromJson(e)).toList();
        return enroll;
      } else {
        throw Exception("Failed to load history");
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Period>> fetchPeriod() async {
    try {
      final uri = Uri.parse(urlPeriod);
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as List;
        final period = json.map((e) => Period.fromJson(e)).toList();
        return period;
      } else {
        throw Exception("Failed to load period");
      }
    } catch (e) {
      rethrow;
    }
  }
}
