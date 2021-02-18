import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String url = "http://3.15.204.27/APIs/";

class ApiCall {
  static Future<Response> post(String path, Map<String, dynamic> parameters,
      {auth = false}) async {
    Dio dio = Dio();
    if (auth) {
      var pref = await SharedPreferences.getInstance();
      dio.options.headers["Authorization"] = pref.getString("token");
    }
    Response response =
        await dio.post(url + path, data: FormData.fromMap(parameters));
    return response;
  }

  static Future<Response> get(String path) async {
    Dio dio = Dio();
    Response response = await dio.get(url + path);
    return response;
  }
}
