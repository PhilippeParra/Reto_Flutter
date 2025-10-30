import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class RiderDetailScreen extends StatefulWidget {
  final String nombreRepartidor;
  const RiderDetailScreen({super.key, required this.nombreRepartidor});

  @override
  State<RiderDetailScreen> createState() => _RiderDetailScreenState();
}

class _RiderDetailScreenState extends State<RiderDetailScreen> {
  List entregas = [];

  @override
  void initState() {
    super.initState();
    cargarEntregas();
  }

  Future<void> cargarEntregas() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('entregas');
    if (data != null) {
      final all = jsonDecode(data);
      setState(() {
        entregas = List<Map<String, dynamic>>.from(all[widget.nombreRepartidor]);
      });
    }
  }

  Future<void> actualizarEntrega(int index, bool nuevoValor) async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('entregas');
    if (data != null) {
      final all = jsonDecode(data);
      all[widget.nombreRepartidor][index]['entregado'] = nuevoValor;
      await prefs.setString('entregas', jsonEncode(all));
      cargarEntregas();
    }
  }

  @override
  Widget build(BuildContext context) {
    final total = entregas.length;
    final completadas = entregas.where((e) => e['entregado'] == true).length;
    final progreso = total == 0 ? 0.0 : completadas / total;

    return Scaffold(
      appBar: AppBar(title: Text("Entregas de ${widget.nombreRepartidor}")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                LinearProgressIndicator(value: progreso, color: Colors.blueAccent, minHeight: 8),
                const SizedBox(height: 8),
                Text("Progreso: ${(progreso * 100).toStringAsFixed(0)}%"),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: entregas.length,
              itemBuilder: (context, index) {
                final e = entregas[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    title: Text(e['cliente']),
                    subtitle: Text("${e['direccion']} • ${e['peso']}"),
                    trailing: Switch(
                      value: e['entregado'],
                      onChanged: (v) => actualizarEntrega(index, v),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
