class Repartidor {
  final String nombre;
  final List<Map<String, dynamic>> entregas;

  Repartidor({required this.nombre, required this.entregas});
}

List<Repartidor> repartidoresIniciales = [
  Repartidor(
    nombre: "Carlos López",
    entregas: [
      {"cliente": "Juan Pérez", "direccion": "Calle 10 #23-45", "peso": "2 kg", "entregado": false},
      {"cliente": "Laura Gómez", "direccion": "Carrera 5 #8-10", "peso": "1.5 kg", "entregado": false},
      {"cliente": "Pedro Ruiz", "direccion": "Av. 80 #45-23", "peso": "3 kg", "entregado": false},
      {"cliente": "Sofía Méndez", "direccion": "Calle 20 #14-33", "peso": "2.5 kg", "entregado": false},
    ],
  ),
  Repartidor(
    nombre: "Ana Martínez",
    entregas: [
      {"cliente": "Carlos Rojas", "direccion": "Carrera 45 #23-12", "peso": "1.2 kg", "entregado": false},
      {"cliente": "María Torres", "direccion": "Calle 8 #19-20", "peso": "2.8 kg", "entregado": false},
      {"cliente": "Luis Ramírez", "direccion": "Transv. 3 #11-22", "peso": "3.5 kg", "entregado": false},
      {"cliente": "Elena Gutiérrez", "direccion": "Av. 33 #7-50", "peso": "4 kg", "entregado": false},
    ],
  ),
  Repartidor(
    nombre: "Miguel Castillo",
    entregas: [
      {"cliente": "Andrés Silva", "direccion": "Calle 100 #12-14", "peso": "1 kg", "entregado": false},
      {"cliente": "Patricia Mora", "direccion": "Carrera 90 #23-45", "peso": "2.3 kg", "entregado": false},
      {"cliente": "Julio Díaz", "direccion": "Av. 15 #8-30", "peso": "1.8 kg", "entregado": false},
      {"cliente": "Daniela Cárdenas", "direccion": "Calle 40 #10-50", "peso": "3 kg", "entregado": false},
    ],
  ),
  Repartidor(
    nombre: "Lucía Fernández",
    entregas: [
      {"cliente": "Fernando Ríos", "direccion": "Carrera 25 #45-10", "peso": "2 kg", "entregado": false},
      {"cliente": "Tatiana Pardo", "direccion": "Calle 60 #9-12", "peso": "1.5 kg", "entregado": false},
      {"cliente": "Esteban Vargas", "direccion": "Av. 30 #14-44", "peso": "2.7 kg", "entregado": false},
      {"cliente": "Gloria Suárez", "direccion": "Transv. 12 #6-20", "peso": "3 kg", "entregado": false},
    ],
  ),
];
