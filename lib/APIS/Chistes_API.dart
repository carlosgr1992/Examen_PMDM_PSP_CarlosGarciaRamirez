import 'package:http/http.dart' as http;
import 'dart:convert';

Future<String> buscaChistes() async {
  var url = Uri.parse('https://v2.jokeapi.dev/joke/Programming?lang=es');
  var response = await http.get(url);

  if (response.statusCode == 200) {
    var jsonResponse = json.decode(response.body);
    if (jsonResponse['type'] == 'single') {
      return jsonResponse['joke'];
    } else {
      return '${jsonResponse['setup']} - ${jsonResponse['delivery']}';
    }
  } else {
    return 'Error: no se pudo cargar un chiste.';
  }
}
