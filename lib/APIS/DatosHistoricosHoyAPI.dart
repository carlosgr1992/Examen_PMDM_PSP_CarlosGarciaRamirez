import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;

class DatosHistoricosHoyAPI {

  Future<String> fetchHistoricalEvent() async {
    var now = DateTime.now();
    var url = Uri.parse('http://history.muffinlabs.com/date/${now.month}/${now.day}');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      var events = jsonResponse['data']['Events'] as List;
      var randomEvent = events[Random().nextInt(events.length)];
      return '${randomEvent['year']}: ${randomEvent['text']}';
    } else {
      return 'Error: no se pudo cargar el evento histórico.';
    }
  }
}