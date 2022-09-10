import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider {
  final String urlLogin = "https://adm.imte.education/api/user/loginv2";
  final String urlRegister = "https://adm.imte.education/api/user/registerv2";

  login(email, password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final response = await http.post(Uri.parse(urlLogin), headers: {
      "Accept": "application/json"
    }, body: {
      "email": email,
      "password": password,
    });

    final data = await json.decode(response.body);
    if (response.statusCode == 200) {
      prefs.setString("token", data['token']);
      prefs.setInt("user", data['user']);
      prefs.setString("email", email);
      return data[''];
    } else {
      return data['message'];
    }
  }

  register(unit, firstName, lastName, email, mobile, password,
      confirmPassword) async {
    final response = await http.post(
        Uri.parse('https://adm.imte.education/api/user/registerv2'),
        headers: {
          "Accept": "application/json"
        },
        body: {
          "first_name": firstName,
          "last_name": 'lastName',
          "email": email,
          "unit": unit,
          "mobile": mobile,
          "password": password,
          "confirm": confirmPassword,
        });

    print(response.body);

    final data = await json.decode(response.body);
    print('firstName :' + firstName);
    print('lastName :' + lastName);
    print('email :' + email);
    print('unit :' + unit);
    print('mobile :' + mobile);
    print('password :' + password);
    print('confirmPassword :' + confirmPassword);
    if (response.statusCode == 200) {
      return data['message'];
    } else {
      return data['errors'].toString();
    }
  }
}

class NetworkError extends Error {}
