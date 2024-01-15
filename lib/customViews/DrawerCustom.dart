import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:examen_pmdm_psp_carlosgarciaramirez/singletone/GeolocAdmin.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../fireStoreObjets/FbUsuario.dart';
import '../onBoarding/AjustesView.dart';
import '../singletone/DataHolder.dart';

import '../singletone/HttpAdmin.dart';


class DrawerCustom extends StatelessWidget {
  final FbUsuario? currentUser;

TextEditingController _pokemonNameController = TextEditingController();
  DrawerCustom({this.currentUser});

  Function(int indice)? onItemTap;



  @override
  Widget build(BuildContext context) {
    // Verifica si la URL es válida
    bool esUrlValida = Uri.tryParse(currentUser?.urlImagen ?? '')?.hasAbsolutePath ?? false;

    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Mostrar imagen de perfil o ícono por defecto
                esUrlValida
                    ? CircleAvatar(
                  backgroundImage: NetworkImage(currentUser!.urlImagen!),
                  radius: 40,
                )
                    : CircleAvatar(
                  child: Icon(Icons.person, size: 40),
                  radius: 40,
                ),
                SizedBox(height: 10), // Espacio entre la imagen y el texto
                Text(
                  'Bienvenido, ${currentUser?.nombre ?? 'Invitado'}',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ],
            ),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () {
              Navigator.of(context).popAndPushNamed("/homeView");
            },
          ),
          ListTile(
            title: const Text('Consultar Pokemon'),
            onTap: () {
               showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Buscar Pokémon'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _pokemonNameController,
                  decoration: InputDecoration(labelText: 'Nombre del Pokémon'),
                ),
              ],
            ),
            actions: [
              TextButton(
                child: Text('Buscar'),
                onPressed: () async {
                  String pokemonName = _pokemonNameController.text.trim().toLowerCase();
                  if (pokemonName.isNotEmpty) {
                    Navigator.of(context).pop(); // Cerrar el diálogo de búsqueda

                    Map<String, dynamic> pokemonData =
                    await DataHolder.httpAdmin.fetchPokemonData(pokemonName);
                    List<String> abilities = [];

    // Verificar si el diccionario contiene la clave 'abilities'
    if (pokemonData.containsKey('abilities')) {
      // Obtener la lista de habilidades
      List<dynamic> abilitiesList = pokemonData['abilities'];

      // Extraer los nombres de las habilidades
      abilities = abilitiesList
          .map<String>((ability) => ability['ability']['name'])
          .toList();
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Información'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Nombre: ${pokemonData['name']}'),
              Text('Habilidades: ${abilities.join(', ')}'),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Aceptar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
                  }
                },
              ),
              TextButton(
                child: Text('Cancelar'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
            },
          ),
          ListTile(
            title: const Text('Chiste Aleatorio'),
            onTap: () async {
              String chiste = await DataHolder.httpAdmin.buscaChistes();
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Información'),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Chiste informático: $chiste'),
                ],
              ),
              actions: [
                TextButton(
                  child: Text('Aceptar'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
            },

          ),
          ListTile(
            leading: Icon(Icons.search),
            title: Text('Busca Usuario'),
            onTap: () {
              TextEditingController _searchController = TextEditingController();

              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Buscar Edad por usuario'),
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: 'Ingrese el usuario a buscar',
                            contentPadding: EdgeInsets.all(16.0),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            String searchValue = _searchController.text.trim();
                            if (searchValue.isNotEmpty) {
                              Navigator.of(context).pop(); // Cerrar el diálogo de búsqueda

                              List<Map<String, dynamic>> searchResults =
                              await DataHolder.firebaseAdmin.searchAgeByName(searchValue);

                              if (searchResults.isNotEmpty) {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Resultados de la Búsqueda'),
                                      content: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          for (var result in searchResults)
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text('Nombre: ${result['nombre']}'),
                                                Text('Edad: ${result['edad']}'),
                                                // Agrega aquí otros campos que desees mostrar
                                              ],
                                            ),
                                        ],
                                      ),
                                      actions: [
                                        TextButton(
                                          child: Text('Aceptar'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Resultados de la Búsqueda'),
                                      content: Text('No se encontraron posts con el título proporcionado.'),
                                      actions: [
                                        TextButton(
                                          child: Text('Aceptar'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                            }
                          },
                          child: Text('Buscar'),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.map),
            title: Text('Busqueda 5KM'),
            onTap: () async {
              Position currentPosition = await DataHolder.geolocAdmin.registrarCambiosLoc();
              GeoPoint currentGeoPoint = GeoPoint(currentPosition.latitude, currentPosition.longitude);
              await DataHolder.geolocAdmin.agregarUbicacionEnFirebase(currentGeoPoint);
              List<String> usersInRange = await DataHolder.geolocAdmin.obtenerUsuariosEnRango();

              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Usuarios en rango de 5 km:'),
                    content: Column(
                      children: usersInRange
                          .map(
                            (userId) => Text(
                          userId ?? 'Usuario sin ID',
                          // 'Usuario sin ID' se mostrará si userId es nulo
                        ),
                      )
                          .toList(),
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: Text('Cerrar'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Ajustes'),
            onTap: () {
              // Navegar a la vista de detalles del usuario
              if (currentUser != null) {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => AjustesView(usuario: currentUser!, uid: currentUser!.id,),
                ));
              }
            },
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () {
              Navigator.of(context).popAndPushNamed("/loginView");
            },
          ),

        ],
      ),
    );
  }
}
