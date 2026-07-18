import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Scaffold(
      body: SafeArea(child: EjercicioResponsivo()),
    ),
  ));
}

class EjercicioResponsivo extends StatelessWidget {
  const EjercicioResponsivo({super.key});

  @override
  Widget build(BuildContext context) {
    const String imgMovil = 'assets/images/cachetes.jpg';
    const String imgTablet = 'assets/images/dientes.jpg';
    const String imgEscritorio = 'assets/images/nariz.jpg';

    return LayoutBuilder(
      builder: (context, constraints) {

        if (constraints.maxWidth < 600) {

          return GridView.count(
            padding: const EdgeInsets.all(8),
            crossAxisCount: 1,
            childAspectRatio: 1.4,
            children: const [
              Tarjeta(color: Colors.blue, imagePath: imgMovil, titulo: "Móvil 1"),
              Tarjeta(color: Colors.blue, imagePath: imgMovil, titulo: "Móvil 2"),
            ],
          );
        } else if (constraints.maxWidth < 1200) {

          return Row(
            children: const [
              Expanded(child: Tarjeta(color: Colors.green, imagePath: imgTablet, titulo: "Tab 1")),
              Expanded(child: Tarjeta(color: Colors.green, imagePath: imgTablet, titulo: "Tab 2")),
              Expanded(child: Tarjeta(color: Colors.green, imagePath: imgTablet, titulo: "Tab 3")),
              Expanded(child: Tarjeta(color: Colors.green, imagePath: imgTablet, titulo: "Tab 4")),
            ],
          );
        } else {

          return GridView.count(
            padding: const EdgeInsets.all(8),
            crossAxisCount: 3,
            children: List.generate(
              6,
                  (index) => Tarjeta(
                color: Colors.orange,
                imagePath: imgEscritorio,
                titulo: "Escritorio ${index + 1}",
              ),
            ),
          );
        }
      },
    );
  }
}

class Tarjeta extends StatelessWidget {
  final Color color;
  final String imagePath;
  final String titulo;

  const Tarjeta({
    super.key,
    required this.color,
    required this.imagePath,
    required this.titulo,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      elevation: 4,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        color: color.withOpacity(0.15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            Expanded(
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,

              ),
            ),
            //Texto
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                titulo,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: color,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}