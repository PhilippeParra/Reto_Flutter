import 'package:flutter/material.dart';

class DeliveryCard extends StatelessWidget {
  final String cliente;
  final String peso;
  final String direccion;
  final bool entregado;
  final VoidCallback onToggle;

  const DeliveryCard({
    super.key,
    required this.cliente,
    required this.peso,
    required this.direccion,
    required this.entregado,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[900],
      elevation: 3,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        leading: Icon(
          entregado ? Icons.check_circle : Icons.delivery_dining,
          color: entregado ? Colors.blueAccent : Colors.grey,
          size: 32,
        ),
        title: Text(
          "$cliente ($peso)",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            decoration: entregado ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Text(direccion),
        trailing: IconButton(
          icon: Icon(entregado ? Icons.undo : Icons.done, color: Colors.blueAccent),
          onPressed: onToggle,
        ),
      ),
    );
  }
}
