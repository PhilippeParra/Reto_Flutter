import 'package:flutter/material.dart';

class vista_inicio extends StatefulWidget {
  const vista_inicio({super.key});

  @override
  State<vista_inicio> createState() => _vista_inicioState();
}

class _vista_inicioState extends State<vista_inicio> with SingleTickerProviderStateMixin {
  bool isRider = true;
  late AnimationController _controller;
  late Animation<double> _bikeAnimation;
  late Animation<double> _screenAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 2));

    _bikeAnimation = Tween<double>(begin: -150, end: 0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _screenAnimation = Tween<double>(begin: 1.2, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutExpo),
    );
  }

  void _chooseRole(bool rider) {
    setState(() {
      isRider = rider;
    });
    _controller.forward(from: 0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _navigateNext() {
    if (isRider) {
      Navigator.pushNamed(context, '/rider_select');
    } else {
      Navigator.pushNamed(context, '/supervisor');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('GreenGo Logistics')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(isRider ? _bikeAnimation.value : 0, 0),
                  child: Transform.scale(
                    scale: isRider ? 1.0 : _screenAnimation.value,
                    child: Icon(
                      isRider ? Icons.pedal_bike : Icons.desktop_mac,
                      color: Colors.blueAccent,
                      size: 120,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 30),
            Text(
              isRider ? "Modo Repartidor" : "Modo Supervisor",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _chooseRole(true),
                  icon: const Icon(Icons.pedal_bike),
                  label: const Text('Repartidor'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isRider ? Colors.blueAccent : Colors.grey[800],
                    foregroundColor: Colors.white,
                  ),
                ),
                const SizedBox(width: 20),
                ElevatedButton.icon(
                  onPressed: () => _chooseRole(false),
                  icon: const Icon(Icons.desktop_mac),
                  label: const Text('Supervisor'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: !isRider ? Colors.blueAccent : Colors.grey[800],
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: _navigateNext,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              child: const Text("Entrar", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}