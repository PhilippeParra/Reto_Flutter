import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SelectorRepartidores extends StatefulWidget {
  const SelectorRepartidores({super.key});

  @override
  State<SelectorRepartidores> createState() => _SelectorRepartidoresState();
}

class _SelectorRepartidoresState extends State<SelectorRepartidores> {
  Map<String, dynamic> repartidores = {};

  @override
  void initState() {
    super.initState();
    cargarRepartidores();
  }

  Future<void> cargarRepartidores() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('entregas');

    if (data != null) {
      setState(() {
        repartidores = jsonDecode(data);
      });
    }
  }

  Future<void> guardarRepartidorSeleccionado(String nombre) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('rider', nombre);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Seleccionar Repartidor"),
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
        child: repartidores.isEmpty
            ? const Center(child: CircularProgressIndicator(color: Colors.white))
            : ListView(
                padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 16),
                children: repartidores.keys.map((nombre) {
                  final letra = nombre.isNotEmpty ? nombre[0].toUpperCase() : '?';
                  return GestureDetector(
                    onTap: () async {
                      await guardarRepartidorSeleccionado(nombre);
                      Navigator.pushNamed(
                        context,
                        '/rider_detail',
                        arguments: {'nombreRepartidor': nombre},
                      ).then((_) => cargarRepartidores());
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blueAccent.withOpacity(0.4),
                            blurRadius: 10,
                            spreadRadius: 1,
                          ),
                        ],
                        border: Border.all(color: Colors.blueAccent.withOpacity(0.3)),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 28,
                            backgroundColor: Colors.blueAccent,
                            child: Text(
                              letra,
                              style: const TextStyle(
                                fontSize: 22,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Text(
                              nombre,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const Icon(Icons.arrow_forward_ios, color: Colors.white70, size: 20),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
      ),
    );
  }
}
