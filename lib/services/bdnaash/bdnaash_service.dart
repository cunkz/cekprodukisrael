import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:cekprodukisrael_app/models/bdnaash/bdnaash_search_model.dart';
import 'package:cekprodukisrael_app/models/bdnaash/bdnaash_search_suggestions_model.dart';

class BdnaashService {
  // final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final _dio = Dio();
  final _baseUrl = "https://bdnaash.com";

  Future<BdnaashSearchSuggestionsModel> searchSuggestions(String query) async {
    try {
      final url = '$_baseUrl/home/searchSuggestions';
      Response response = await _dio.post(
        url,
        data: {
          'query': query
        },
        options: Options(
          contentType: 'application/x-www-form-urlencoded',
          headers: {
            'Accept': 'application/json, text/javascript, */*; q=0.01',
            'X-Requested-With': 'XMLHttpRequest'
          },
        ),
      );
      final result = response.data;
      var res = BdnaashSearchSuggestionsModel.fromJson(result);
      return res;
    } catch (e) {
      // await FirebaseCrashlytics.instance
      //     .recordError(e, null, reason: "bdnaash-search");
      rethrow;
    }
  }

  Future<BdnaashSearchModel> search(String query) async {
    try {
      final url = '$_baseUrl/home/search';
      Response response = await _dio.post(
        url,
        data: {
          'query': query,
          'type': 'Keyword'
        },
        options: Options(
          contentType: 'application/x-www-form-urlencoded',
          headers: {
            'Accept': 'application/json, text/javascript, */*; q=0.01',
            'X-Requested-With': 'XMLHttpRequest'
          },
        ),
      );
      final result = response.data;
      var res = BdnaashSearchModel.fromJson(json.decode(result));
      return res;
    } catch (e) {
      // await FirebaseCrashlytics.instance
      //     .recordError(e, null, reason: "bdnaash-search");
      rethrow;
    }
  }
}