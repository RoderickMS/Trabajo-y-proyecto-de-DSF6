import 'package:flutter/material.dart';
import 'pantalla_registro.dart';
import 'tarjeta_interactiva.dart';

class PantallaInicio extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            width: double.infinity,
            color: Color.fromARGB(255, 32, 33, 32),
            padding: EdgeInsets.only(top: 60, bottom: 30, left: 24, right: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  'assets/logo.jpg',
                  width: 80,
                  height: 80,
                ),
                SizedBox(height: 12),
                Text(
                  'Tech Events',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: 1.2,
                  ),
                ),
                Text(
                  'Panamá 2026',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.greenAccent,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(24),
              child: Column(
                children: [
                  SizedBox(height: 10),

                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline,
                            color: Color.fromARGB(255, 42, 44, 42), size: 30),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Únete a la comunidad tech más grande de Centroamérica. '
                            'Inscríbete y elige los temas que más te apasionan.',
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[700],
                                height: 1.4),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 28),

                  TarjetaInteractiva(),

                  SizedBox(height: 32),


                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 24, 26, 27),
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PantallaRegistro(),
                          ),
                        );
                      },
                      icon: Icon(Icons.app_registration),
                      label: Text('Registrarme ahora'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}