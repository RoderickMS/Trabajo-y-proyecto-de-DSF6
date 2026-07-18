import 'package:flutter/material.dart';

class PantallaResumen extends StatelessWidget {
  final String nombre;
  final String correo;
  final String telefono;
  final String tipoParticipante;
  final List<String> tecnologias;

  const PantallaResumen({
    required this.nombre,
    required this.correo,
    required this.telefono,
    required this.tipoParticipante,
    required this.tecnologias,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tu Inscripción')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 34, 35, 34),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  Icon(Icons.verified, color: Colors.greenAccent, size: 36),
                  SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('¡Registro exitoso!',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18)),
                      Text('Revisa tu información a continuación.',
                          style: TextStyle(
                              color: Colors.white70, fontSize: 13)),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

            _bloque(
              titulo: 'Datos Personales',
              icono: Icons.badge,
              hijo: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _fila(Icons.person_outline, 'Nombre', nombre),
                  _fila(Icons.alternate_email, 'Correo', correo),
                  _fila(Icons.smartphone, 'Teléfono',
                      telefono.isEmpty ? '—' : telefono),
                ],
              ),
            ),
            SizedBox(height: 14),

            _bloque(
              titulo: 'Categoría',
              icono: Icons.category,
              hijo: Chip(
                label: Text(tipoParticipante,
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
                backgroundColor: Color.fromARGB(255, 29, 32, 29),
                avatar:
                    Icon(Icons.check, color: Colors.greenAccent, size: 16),
              ),
            ),
            SizedBox(height: 14),

            _bloque(
              titulo: 'Áreas de Interés',
              icono: Icons.interests,
              hijo: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: tecnologias
                    .map((t) => Chip(
                          label: Text(t, style: TextStyle(fontSize: 12)),
                          backgroundColor: Color(0xFFE8F5E9),
                          side: BorderSide(color: Color.fromARGB(255, 30, 32, 30)),
                        ))
                    .toList(),
              ),
            ),
            SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () =>
                    Navigator.popUntil(context, (r) => r.isFirst),
                icon: Icon(Icons.home_outlined),
                label: Text('Volver al Inicio'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bloque({
    required String titulo,
    required IconData icono,
    required Widget hijo,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
              color: Colors.black12, blurRadius: 6, offset: Offset(0, 3))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(icono, color: Color.fromARGB(255, 24, 25, 24), size: 20),
            SizedBox(width: 6),
            Text(titulo,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Color.fromARGB(255, 46, 48, 46))),
          ]),
          Divider(height: 16),
          hijo,
        ],
      ),
    );
  }

  Widget _fila(IconData icono, String etiqueta, String valor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icono, size: 16, color: Colors.grey),
          SizedBox(width: 6),
          Text('$etiqueta: ',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
          Expanded(
              child: Text(valor,
                  style:
                      TextStyle(fontSize: 13, color: Colors.grey[700]))),
        ],
      ),
    );
  }
}