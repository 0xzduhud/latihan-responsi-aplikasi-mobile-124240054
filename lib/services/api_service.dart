import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/show_model.dart';

class ApiService {
  static const String _baseUrl = 'https://api.tvmaze.com';

  static Future<List<ShowModel>> fetchShows() async {
    final response = await http.get(Uri.parse('$_baseUrl/shows'));

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body) as List;
      return data
          .whereType<Map>()
          .map((item) => ShowModel.fromJson(Map<String, dynamic>.from(item)))
          .toList();
    }

    throw Exception('Gagal mengambil daftar show (${response.statusCode}).');
  }

  static Future<ShowModel> fetchShowDetail(int id) async {
    final response = await http.get(Uri.parse('$_baseUrl/shows/$id'));

    if (response.statusCode == 200) {
      return ShowModel.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    }

    throw Exception('Gagal mengambil detail show (${response.statusCode}).');
  }
}
