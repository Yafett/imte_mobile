import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../models/profile-model.dart';

class ProfileProvider {
  final String urlGet = "https://adm.imte.education/api/user/profile?id=";
  final String urlEdit = "https://adm.imte.education/api/user/updatev2/";

  Future<GetProfile> fetchProfileList() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var token = pref.getString("token");
    var user = pref.getInt('user');

    try {
      final response = await http.get(
        Uri.parse('https://adm.imte.education/api/user/profile?id=${user}'),
        headers: {
          'Authorization': 'Bearer ' + token.toString(),
          'Accept': 'application/json',
        },
      );
      final data = jsonDecode(response.body);

      pref.setInt('id', data['profile'][0]['id']);

      return GetProfile.fromJson(data);
    } catch (error, stacktrace) {
      // ignore: avoid_print
      print('Exception Occured: $error stackTrace: $stacktrace');
      return GetProfile.withError('Data not found / Connection Issues');
    }
  }

  editProfile(firstName, lastName, gender, place, birth, mobile, address, wali,
      city, noWali) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var user = prefs.getInt('user');
    var token = prefs.getString("token");

    final response = await http.put(
      Uri.parse(urlEdit + user.toString()),
      headers: {
        "Accept": "application/json",
        'Authorization': "Bearer ${token}"
      },
      body: {
        "first_name": firstName,
        "last_name": lastName,
        "gender": gender == 'Perempuan' ? 'P' : 'L',
        "place": place,
        "date_of_birth": birth,
        "mobile": mobile,
        "address": address,
        "wali": wali,
        "city": city,
        "no_wali": noWali,
      },
    );

    final data = await json.decode(response.body);
    if (response.statusCode == 200) {
      return data['message'];
    } else {
      return data['message'];
    }
  }
}

class NetworkError extends Error {}
