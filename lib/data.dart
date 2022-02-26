import 'package:dio/dio.dart';

class Api {
  Future<List> getHttp() async {
    List result = [];
    try {
      var response =
          await Dio().get('https://jsonplaceholder.typicode.com/posts');
      result = response.data as List;
      return result;
    } catch (e) {
      print(e);
    }
    return result;
  }

  Future<Map> getHttpId(String id) async {
    var result;
    try {
      var response =
          await Dio().get('https://jsonplaceholder.typicode.com/posts/$id');
      result = response.data;
      return result;
    } catch (e) {
      print(e);
    }
    return result;
  }
}
