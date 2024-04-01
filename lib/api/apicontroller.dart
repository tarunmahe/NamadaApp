// create a flutter  api repositorr that fetches data from the server
// class ApiRepository {import 'package:get/get.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:http/http.dart' as http;

class ApiController extends GetxController {
  final List<String> endpoints = [
    '/balance',
    '/transactions',
    '/epoch',
    '/bonds'
  ];
  final List<dynamic> data = List.filled(4, null, growable: false).obs;

  @override
  void onInit() {
    //httpClient.timeout = const Duration(seconds: 60);

    super.onInit();
    //fetchData();
  }

  Future<dynamic> fetchData(String endpoint) async {
    var response = await http.get(
      //Uri.parse('http://127.0.0.1:38660${endpoint}'),
      Uri.parse('${dotenv.env['BASE_URL']}$endpoint'),

      headers: {'Authorization': 'your-authorization-key'},
    ).timeout(1.minutes);
    if (response.statusCode == 200) {
      print('fetching data from  ${response.body}');

      return response.body;
    } else {
      print('Error fetching data from ${endpoint}: ${response.statusCode}');
      return null;
    }
  }
}
