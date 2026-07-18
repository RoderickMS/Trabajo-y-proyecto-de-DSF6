import 'package:flutter/material.dart';

class TarjetaInteractiva extends StatefulWidget {
  @override
  _TarjetaInteractivaState createState() => _TarjetaInteractivaState();
}

class _TarjetaInteractivaState extends State<TarjetaInteractiva> {
  Color _fondo = Color(0xFFE8F5E9);

  final List<Color> _colores = [
    Color(0xFFE8F5E9), 
    Color.fromARGB(255, 5, 130, 32), 
    Color.fromARGB(255, 182, 49, 5), 
    Color.fromARGB(255, 5, 34, 182), 
    Color.fromARGB(255, 146, 6, 154), 
  ];

  int _indiceColor = 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(

      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('👆 ¡Toque simple detectado!'),
            backgroundColor: Color.fromARGB(255, 19, 20, 20),
            behavior: SnackBarBehavior.floating,
          ),
        );
      },

      
      onDoubleTap: () {
        setState(() {
          _indiceColor = (_indiceColor + 1) % _colores.length;
          _fondo = _colores[_indiceColor];
        });
      },

      
      onLongPress: () {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Row(
              children: [
                Icon(
                  Icons.back_hand,
                  color: Color.fromARGB(255, 19, 20, 20),
                ),
                SizedBox(width: 8),
                Text('¡Presión larga!'),
              ],
            ),
            content: Text(
              'Mantuviste el dedo sobre la tarjeta. ¡Buen trabajo probando los gestos!',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text(
                  'Entendido',
                  style: TextStyle(
                    color: Color.fromARGB(255, 19, 20, 20),
                  ),
                ),
              ),
            ],
          ),
        );
      },

      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: _fondo,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Color.fromARGB(255, 19, 20, 20).withOpacity(0.4),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(
              Icons.gesture,
              size: 40,
              color: Color.fromARGB(255, 19, 20, 20),
            ),
            SizedBox(height: 8),
            Text(
              'Tarjeta Interactiva',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Toca • Doble toca (cambia color) • Mantén presionado',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }
}