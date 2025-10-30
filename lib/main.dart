import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'screens/selector_repartidores.dart';
import 'screens/vista_inicio.dart';
import 'screens/vista_repartidor.dart';
import 'screens/vista_supervisor.dart';
import 'models/repartidores.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  //await prefs.clear(); //borra lo guardado en sharedpreferences para reiniciar si hay cambios en codigo

  if (!prefs.containsKey('entregas')) {
  final inicial = {
    for (var r in repartidoresIniciales)
      r.nombre: r.entregas.map((e) => {
        "cliente": e["cliente"],
        "direccion": e["direccion"],
        "peso": e["peso"],
        "entregado": e["entregado"],
      }).toList(),
  };
  await prefs.setString('entregas', jsonEncode(inicial));
}


  runApp(const GreenGoApp());
}

class GreenGoApp extends StatelessWidget {
  const GreenGoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GreenGo Logistics',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blueAccent,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blueAccent,
          foregroundColor: Colors.white,
          centerTitle: true,
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const vista_inicio(),
        '/rider_select': (context) => const SelectorRepartidores(),
        
        '/supervisor': (context) => const SupervisorScreen(),
        '/rider_detail': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
          final nombre = args?['nombreRepartidor'] ?? 'Desconocido';
          return RiderScreen(riderName: nombre);
        },
      },
    );
  }
}
