import 'dart:convert';

import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class HttpAdmin {

  HttpAdmin();


  Future<Map<String, dynamic>> fetchPokemonData(String pokemonName) async {
    var url = Uri.https('pokeapi.co', '/api/v2/pokemon/$pokemonName');

    var response = await http.get(url);

    if (response.statusCode == 200) {
      return convert.jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Error al obtener datos del Pokémon');
    }
  }

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

}