import 'package:http/http.dart' as http;

class Network {
  static Future<http.Response> getResponse({required String uri}) async =>
      await http.get(Uri.parse(uri));
}
