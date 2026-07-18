import 'package:flutter/material.dart';
import 'dart:math';

void main() => runApp(const AppNaturalezaRM());

class AppNaturalezaRM extends StatelessWidget {
  const AppNaturalezaRM({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Examen Roderick Munoz',
      initialRoute: '/home',
      routes: {
        '/home': (context) => const PantallaPrincipal(),
        '/galeria': (context) => const SeccionAleatoria(),
        '/perfil': (context) => const PerfilDelUsuario(),
      },
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
      ),
    );
  }
}

class PantallaPrincipal extends StatelessWidget {
  const PantallaPrincipal({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          "Belleza Natural",
          style: TextStyle(fontSize: 26, color: Colors.black87),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: Image.asset(
              "assets/images/n1.jpg", 
              height: 220,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              _bloqueImagenNet(
                "https://images.unsplash.com/photo-1441974231531-c6227db76b6e", 
                "Lindo bosque"
              ),
              const SizedBox(width: 15),
              _bloqueImagenNet(
                "https://images.unsplash.com/photo-1464822759023-fed622ff2c3b", 
                "Hermoso paisaje"
              ),
            ],
          ),
          const SizedBox(height: 35),
          const Text(
            "Explora la naturaleza y su magia",
            style: TextStyle(
              fontSize: 24, 
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 50),
        ],
      ),
      floatingActionButton: FloatingActionButton.large(
        backgroundColor: const Color(0xFFF3E5F5),
        onPressed: () => Navigator.pushNamed(context, '/galeria'),
        child: const Icon(Icons.arrow_forward_rounded, size: 35),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.teal,
        onTap: (index) {
          if (index == 2) Navigator.pushNamed(context, '/perfil');
        },
        items: const [
          BottomNavigationBarItem(
            icon: Tooltip(message: "Inicio", child: Icon(Icons.home_outlined)),
            label: "Inicio",
          ),
          BottomNavigationBarItem(
            icon: Tooltip(message: "Favoritos", child: Icon(Icons.favorite_border)),
            label: "Favoritos",
          ),
          BottomNavigationBarItem(
            icon: Tooltip(message: "Perfil", child: Icon(Icons.person_outline)),
            label: "Perfil",
          ),
        ],
      ),
    );
  }

  Widget _bloqueImagenNet(String url, String texto) {
    return Expanded(
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.network(
              url,
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 8),
          Text(texto, style: const TextStyle(color: Colors.grey, fontSize: 15)),
        ],
      ),
    );
  }
}

class SeccionAleatoria extends StatefulWidget {
  const SeccionAleatoria({super.key});

  @override
  State<SeccionAleatoria> createState() => _SeccionAleatoriaState();
}

class _SeccionAleatoriaState extends State<SeccionAleatoria> {
  late String _pathImagen;

  @override
  void initState() {
    super.initState();
    _refrescarFoto();
  }

  void _refrescarFoto() {
    final carpetas = ["assets/images/n1.jpg", "assets/images/n2.jpg", "assets/images/n3.jpg"];
    setState(() {
      _pathImagen = carpetas[Random().nextInt(carpetas.length)];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Explorar")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Image.asset(_pathImagen, width: 320, height: 320, fit: BoxFit.cover),
            ),
            const SizedBox(height: 30),
            const Text(
              "VISTAS EXPLORADAS", 
              style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.5)
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("REGRESAR"),
            )
          ],
        ),
      ),
    );
  }
}

class PerfilDelUsuario extends StatelessWidget {
  const PerfilDelUsuario({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Usuario")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 70,
              backgroundColor: Colors.teal,
              child: Icon(Icons.person, size: 80, color: Colors.white),
            ),
            const SizedBox(height: 20),
            const Text(
              "Roderick Munoz", 
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const Text(
              "Estudiante de Software",
              style: TextStyle(fontSize: 18, color: Colors.blueGrey),
            ),
            const SizedBox(height: 50),
            OutlinedButton(
              onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/home', (r) => false),
              child: const Text("SALIR AL INICIO"),
            )
          ],
        ),
      ),
    );
  }
}