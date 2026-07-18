import 'package:flutter/material.dart';
import 'pantalla_resumen.dart';

class PantallaRegistro extends StatefulWidget {
  @override
  _PantallaRegistroState createState() => _PantallaRegistroState();
}

class _PantallaRegistroState extends State<PantallaRegistro> {
  final _formKey = GlobalKey<FormState>();

  String _nombre = '';
  String _correo = '';
  String _telefono = '';
  String? _tipoParticipante;

  Map<String, bool> _tecnologias = {
    'Flutter': false,
    'Inteligencia Artificial': false,
    'Ciberseguridad': false,
    'Desarrollo Web': false,
    'Bases de Datos': false,
  };

  void _guardarRegistro() {

    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();


    if (_tipoParticipante == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Selecciona tu tipo de participante.'),
          backgroundColor: Colors.orange[800],
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    bool hayTecnologia = _tecnologias.values.any((v) => v);
    if (!hayTecnologia) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16)),
          title: Text('Falta algo'),
          content: Text(
              'Por favor selecciona al menos una tecnología de interés.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text('OK', style: TextStyle(color: Color.fromARGB(255, 40, 42, 41))),
            ),
          ],
        ),
      );
      return;
    }

    List<String> seleccionadas = _tecnologias.entries
        .where((e) => e.value)
        .map((e) => e.key)
        .toList();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PantallaResumen(
          nombre: _nombre,
          correo: _correo,
          telefono: _telefono,
          tipoParticipante: _tipoParticipante!,
          tecnologias: seleccionadas,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double ancho = MediaQuery.of(context).size.width;
    bool esTablet = ancho > 600;

    return Scaffold(
      appBar: AppBar(title: Text('Nueva Inscripción')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: esTablet
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 3, child: _buildFormulario()),
                  SizedBox(width: 20),
                  Expanded(flex: 2, child: _buildPanelLateral()),
                ],
              )
            : _buildFormulario(),
      ),
    );
  }

  Widget _buildPanelLateral() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 29, 30, 29),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(  
            'assets/logo.jpg',
            width: 80,
            height: 80,
          ),
          SizedBox(height: 12),
          Text('Tech Events Panamá',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Text(
            'Rellena el formulario de la izquierda para completar tu inscripción.',
            style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.5),
          ),
          SizedBox(height: 20),
          _itemInfo(Icons.calendar_month, 'Agosto – Diciembre 2026'),
          _itemInfo(Icons.location_on, 'Ciudad de Panamá'),
          _itemInfo(Icons.people, 'Cupos limitados'),
        ],
      ),
    );
  }

  Widget _itemInfo(IconData icono, String texto) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icono, color: Colors.greenAccent, size: 18),
          SizedBox(width: 8),
          Text(texto, style: TextStyle(color: Colors.white70, fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildFormulario() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _seccion('Datos Personales', Icons.badge),
          SizedBox(height: 10),

          TextFormField(
            decoration: InputDecoration(
              labelText: 'Nombre completo',
              prefixIcon: Icon(Icons.person_outline),
            ),
            validator: (v) =>
                (v == null || v.isEmpty) ? 'El nombre no puede estar vacío' : null,
            onSaved: (v) => _nombre = v!,
          ),
          SizedBox(height: 12),

          TextFormField(
            decoration: InputDecoration(
              labelText: 'Correo electrónico',
              prefixIcon: Icon(Icons.alternate_email),
            ),
            keyboardType: TextInputType.emailAddress,
            validator: (v) =>
                (v == null || v.isEmpty) ? 'El correo no puede estar vacío' : null,
            onSaved: (v) => _correo = v!,
          ),
          SizedBox(height: 12),

          TextFormField(
            decoration: InputDecoration(
              labelText: 'Número de teléfono',
              prefixIcon: Icon(Icons.smartphone),
            ),
            keyboardType: TextInputType.phone,
            onSaved: (v) => _telefono = v ?? '',
          ),
          SizedBox(height: 24),

          _seccion('Categoría', Icons.category),
          ...[
            ('Estudiante', Icons.school),
            ('Profesional', Icons.work),
            ('Docente', Icons.cast_for_education),
          ].map(
            (item) => RadioListTile<String>(
              title: Row(children: [
                Icon(item.$2, size: 18, color: Colors.grey[600]),
                SizedBox(width: 8),
                Text(item.$1),
              ]),
              value: item.$1,
              groupValue: _tipoParticipante,
              activeColor: Color.fromARGB(255, 19, 20, 20),
              onChanged: (v) => setState(() => _tipoParticipante = v),
            ),
          ),
          SizedBox(height: 24),

          _seccion('Áreas de Interés', Icons.interests),
          ..._tecnologias.keys.map(
            (tec) => CheckboxListTile(
              title: Text(tec),
              value: _tecnologias[tec],
              activeColor: Color.fromARGB(255, 17, 17, 17),
              controlAffinity: ListTileControlAffinity.leading,
              onChanged: (v) => setState(() => _tecnologias[tec] = v!),
            ),
          ),
          SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 19, 20, 20),
                padding: EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: _guardarRegistro,
              icon: Icon(Icons.check_circle_outline),
              label: Text('Guardar Registro'),
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _seccion(String titulo, IconData icono) {
    return Row(
      children: [
        Icon(icono, color: Color.fromARGB(255, 39, 41, 39)),
        SizedBox(width: 8),
        Text(titulo,
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 42, 45, 43))),
      ],
    );
  }
}