import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/repartidores.dart';

class RiderScreen extends StatefulWidget {
  final String riderName;
  const RiderScreen({super.key, required this.riderName});

  @override
  State<RiderScreen> createState() => _RiderScreenState();
}

class _RiderScreenState extends State<RiderScreen> {
  List<Map<String, dynamic>> entregas = [];

  @override
  void initState() {
    super.initState();
    inicializarDatos();
  }

  Future<void> inicializarDatos() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('entregas');

    if (data == null) {
      // Si no hay datos guardados, usamos los iniciales del modelo
      final inicial = {
        for (var r in repartidoresIniciales) r.nombre: r.entregas,
      };
      await prefs.setString('entregas', jsonEncode(inicial));
    }

    await cargarEntregas();
  }

  Future<void> cargarEntregas() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('entregas');
    if (data != null) {
      final all = jsonDecode(data);
      if (all[widget.riderName] != null) {
        setState(() {
          entregas = List<Map<String, dynamic>>.from(all[widget.riderName]);
        });
      }
    }
  }

  Future<void> actualizarEntrega(int index, bool nuevoValor) async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('entregas');
    if (data != null) {
      final all = jsonDecode(data);
      all[widget.riderName][index]['entregado'] = nuevoValor;
      await prefs.setString('entregas', jsonEncode(all));
      await cargarEntregas();

      // Calcular progreso tras la actualización
      final total = entregas.length;
      final completadas = entregas.where((e) => e['entregado'] == true).length;
      final progreso = total == 0 ? 0.0 : completadas / total;

      // Mostrar mensaje motivacional
      if (nuevoValor) {
        if (progreso == 1.0) {
          mostrarSnackBar("🎉 ¡Felicidades, terminaste tus entregas actuales!", Colors.greenAccent);
        } else {
          mostrarSnackBar("💪 ¡Bien hecho, tú puedes!", Colors.blueAccent);
        }
      }
    }
  }

  void mostrarSnackBar(String mensaje, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Center(
          child: Text(
            mensaje,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        backgroundColor: color.withOpacity(0.9),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final total = entregas.length;
    final completadas = entregas.where((e) => e['entregado'] == true).length;
    final progreso = total == 0 ? 0.0 : completadas / total;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text("Entregas de ${widget.riderName}"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 100, left: 16, right: 16, bottom: 8),
              child: Column(
                children: [
                  LinearProgressIndicator(
                    value: progreso,
                    color: Colors.lightBlueAccent,
                    backgroundColor: Colors.white24,
                    minHeight: 10,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Progreso: ${(progreso * 100).toStringAsFixed(0)}%",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: entregas.length,
                itemBuilder: (context, index) {
                  final e = entregas[index];
                  return Card(
                    color: Colors.black.withOpacity(0.2),
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: CheckboxListTile(
                      activeColor: Colors.lightBlueAccent,
                      checkColor: Colors.black,
                      title: Text(
                        e['cliente'],
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        "${e['direccion']} • ${e['peso']}",
                        style: const TextStyle(color: Colors.white70),
                      ),
                      value: e['entregado'] ?? false,
                      onChanged: (nuevoValor) {
                        actualizarEntrega(index, nuevoValor ?? false);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
