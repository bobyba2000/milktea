import 'dart:convert';

import 'package:dio/dio.dart';

class ApiService {
  static Future<int?> calculateTotal(Map request) async {
    try {
      var dio = Dio();
      print(request);
      final response = await dio.request<String>(
        'https://milk-tea-api.herokuapp.com/sumProduct',
        options: Options(method: 'POST'),
        data: request,
      );
      if (response.statusCode == 200) {
        final result = jsonDecode(response.data ?? '');
        return result['sum'];
      }
      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
