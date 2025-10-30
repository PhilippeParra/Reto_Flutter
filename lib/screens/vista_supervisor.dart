import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../widgets/porcentaje_circulo.dart';
import 'vista_repartidor.dart';

class SupervisorScreen extends StatefulWidget {
  const SupervisorScreen({super.key});

  @override
  State<SupervisorScreen> createState() => _SupervisorScreenState();
}

class _SupervisorScreenState extends State<SupervisorScreen> {
  Map<String, dynamic> repartidores = {};

  @override
  void initState() {
    super.initState();
    cargarDatos();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    cargarDatos(); // Recargar al volver
  }

  Future<void> cargarDatos() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('entregas');
    if (data != null) {
      setState(() {
        repartidores = jsonDecode(data);
      });
    }
  }

  Future<void> agregarEntrega() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('entregas');
    Map<String, dynamic> all = {};

    if (data != null) {
      all = jsonDecode(data);
    }

    String? repartidorSeleccionado;
    TextEditingController clienteCtrl = TextEditingController();
    TextEditingController direccionCtrl = TextEditingController();
    TextEditingController pesoCtrl = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Agregar nueva entrega"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: "Repartidor"),
                items: all.keys.map((r) {
                  return DropdownMenuItem(value: r, child: Text(r));
                }).toList(),
                onChanged: (v) => repartidorSeleccionado = v,
              ),
              TextField(
                controller: clienteCtrl,
                decoration: const InputDecoration(labelText: "Cliente"),
              ),
              TextField(
                controller: direccionCtrl,
                decoration: const InputDecoration(labelText: "Dirección"),
              ),
              TextField(
                controller: pesoCtrl,
                decoration: const InputDecoration(labelText: "Peso"),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            onPressed: () async {
              if (repartidorSeleccionado != null &&
                  clienteCtrl.text.isNotEmpty &&
                  direccionCtrl.text.isNotEmpty &&
                  pesoCtrl.text.isNotEmpty) {
                final nuevaEntrega = {
                  "cliente": clienteCtrl.text,
                  "direccion": direccionCtrl.text,
                  "peso": pesoCtrl.text,
                  "entregado": false
                };

                all[repartidorSeleccionado!] ??= [];
                all[repartidorSeleccionado!]!.add(nuevaEntrega);

                await prefs.setString('entregas', jsonEncode(all));
                Navigator.pop(context);
                await cargarDatos();
              }
            },
            child: const Text("Guardar"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Panel de Supervisor"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF360000),
              Color(0xFF730000),
              Color(0xFFB30000),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: repartidores.isEmpty
              ? const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                )
              : RefreshIndicator(
                  color: Colors.white,
                  backgroundColor: Colors.black54,
                  onRefresh: cargarDatos,
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: repartidores.keys.map((rider) {
                      final entregas =
                          List<Map<String, dynamic>>.from(repartidores[rider]);
                      final total = entregas.length;
                      final completadas = entregas
                          .where((e) => e['entregado'] == true)
                          .length;
                      final progreso =
                          total == 0 ? 0.0 : completadas / total;

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  RiderScreen(riderName: rider),
                            ),
                          ).then((_) => cargarDatos());
                        },
                        child: Card(
                          color: Colors.black.withOpacity(0.25),
                          elevation: 4,
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 70,
                                  height: 70,
                                  child: ProgressCircle(progress: progreso),
                                ),
                                const SizedBox(width: 20),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        rider,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        "Entregas: $completadas / $total",
                                        style: const TextStyle(
                                            color: Colors.white70),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: agregarEntrega,
        backgroundColor: Colors.redAccent,
        child: const Icon(Icons.add),
      ),
    );
  }
}
