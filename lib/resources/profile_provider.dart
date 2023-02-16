import 'dart:convert';

import 'package:imte_mobile/models/profile-model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';

class ProfileProvider {
  final String urlGet = "https://adm.imte.education/api/user/profile?id=";
  final String urlEdit = "https://adm.imte.education/api/user/updatev2/";

  fetchProfileList() async {
    final dio = Dio();
    SharedPreferences pref = await SharedPreferences.getInstance();
    var token = pref.getString("token");
    var user = pref.getInt('user');

    try {
      final response = await dio.get(
        'https://adm.imte.education/api/user/profile?id=${user}',
        options: Options(
            headers: {
              'Authorization': 'Bearer ${token.toString()}',
              'Accept': 'application/json',
            },
            followRedirects: false,
            validateStatus: (status) {
              return status! < 500;
            }),
      );

      print(response.statusCode.toString());

      if (response.data['message'] == 'Unauthenticated.') {
        return 'expired';
      } else {
        pref.setString(
            'unit', response.data['profile'][0]['tab_unit_id'].toString());
        pref.setString(
            'tabUserId', response.data['profile'][0]['id'].toString());
        pref.setInt('id', response.data['profile'][0]['id']);

        return GetProfile.fromJson(response.data);
      }
    } catch (error, stacktrace) {
      // ignore: avoid_print
      print('Exception Occured: $error stackTrace: $stacktrace');
      return GetProfile.withError('Data not found / Connection Issues');
    }

    // try {
    //   final response = await http.get(
    //     Uri.parse('https://adm.imte.education/api/user/profile?id=${user}'),
    //     headers: {
    //       'Authorization': 'Bearer ' + token.toString(),
    //       'Accept': 'application/json',
    //     },
    //   );
    //   final data = jsonDecode(response.body);

    //   // print('response : ' + data['profile'].toString());
    //   print('user : ' + user.toString());
    //   if (data['message'] == 'Unauthenticated.') {
    //     return 'expired';
    //   } else {
    //     pref.setString('unit', data['profile'][0]['tab_unit_id'].toString());
    //     pref.setString('tabUserId', data['profile'][0]['id'].toString());
    //     pref.setInt('id', data['profile'][0]['id']);

    //     return GetProfile.fromJson(data);
    //   }
    // } catch (error, stacktrace) {
    //   // ignore: avoid_print
    //   print('Exception Occured: $error stackTrace: $stacktrace');
    //   return GetProfile.withError('Data not found / Connection Issues');
    // }
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
