import 'package:flutter/material.dart';
import 'package:learnify/lessons/lesson_completed_screen.dart';
import 'package:learnify/lessons/lesson_failed_screen.dart';
import 'package:learnify/models/lesson.dart';
import 'package:learnify/models/question.dart';
import 'package:learnify/services/question_service.dart';
import 'package:learnify/services/user_service.dart';
import 'package:learnify/utils/constants.dart';

class LessonScreen extends StatefulWidget {
  final String unidadId;
  final Lesson leccion;

  const LessonScreen({
    super.key,
    required this.unidadId,
    required this.leccion,
  });

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  int preguntaActual = 0;
  int puntos = 0;
  bool respuestaVerificada = false;
  bool respuestaCorrecta = false;
  int? respuestaSeleccionada;
  List<Question> _preguntas = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _cargarPreguntas();
  }

  Future<void> _cargarPreguntas() async {
    final preguntas = await QuestionsService.obtenerPreguntas(
      widget.unidadId,
      widget.leccion.id,
    );
    setState(() {
      _preguntas = preguntas;
      _isLoading = false;
    });
  }

  void verificarRespuesta() {
    if (_preguntas.isEmpty) return;
    setState(() {
      respuestaVerificada = true;
      respuestaCorrecta =
          respuestaSeleccionada == _preguntas[preguntaActual].respuestaCorrecta;

      if (respuestaCorrecta) {
        puntos += 10;
        _mostrarSnackBar('¡Correcto! +10 puntos', true);
      } else {
        _mostrarSnackBar(
          'Incorrecto. La respuesta correcta es: ${_preguntas[preguntaActual].opciones[_preguntas[preguntaActual].respuestaCorrecta]}',
          false,
        );
      }
    });
  }

  Future<void> continuar() async {
    if (_preguntas.isEmpty) return;

    if (preguntaActual < _preguntas.length - 1) {
      setState(() {
        preguntaActual++;
        respuestaSeleccionada = null;
        respuestaVerificada = false;
        respuestaCorrecta = false;
      });
    } else {
      final totalPreguntas = _preguntas.length;
      final puntajeMaximo = totalPreguntas * 10;
      final porcentaje = (puntos / puntajeMaximo) * 100;

      // Guarda el resultado en Firestore
      await UserService.registrarResultadoLeccion(
        widget.leccion.id,
        puntos,
        totalPreguntas,
      );

      // Lógica de desbloqueo
      if (porcentaje >= 75) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => LessonCompletedScreen(
              puntos: puntos,
              leccionId: widget.leccion.id,
              porcentaje: porcentaje,
            ),
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => LessonFailedScreen(
              puntos: puntos,
              porcentaje: porcentaje,
            ),
          ),
        );
      }
    }
  }

  void _mostrarSnackBar(String mensaje, bool exito) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        backgroundColor: exito ? Colors.green : Colors.red,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    }

    if (_preguntas.isEmpty) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.close, color: Colors.grey),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text('Lección', style: TextStyle(color: Colors.white)),
        ),
        body: Center(
          child: Text(
            'No hay preguntas disponibles para esta lección.',
            style: TextStyle(color: Colors.grey.shade300),
          ),
        ),
      );
    }

    final pregunta = _preguntas[preguntaActual];
    final progreso = (_preguntas.isEmpty)
        ? 0.0
        : (preguntaActual + 1) / _preguntas.length;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.grey),
          onPressed: () => Navigator.pop(context),
        ),
        title: LinearProgressIndicator(
          value: progreso,
          backgroundColor: Colors.grey.shade300,
          valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pregunta ${preguntaActual + 1} de ${_preguntas.length}',
              style: TextStyle(color: Colors.grey.shade400, fontSize: 14),
            ),
            const SizedBox(height: 16),
            Text(
              pregunta.enunciado,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 32),

            // Opciones idénticas al diseño original
            ...List.generate(pregunta.opciones.length, (i) {
              final opcion = pregunta.opciones[i];
              final esSeleccionada = respuestaSeleccionada == i;
              final esCorrecta = i == pregunta.respuestaCorrecta;

              Color backgroundColor = Colors.grey.shade200;
              Color borderColor = Colors.transparent;

              if (respuestaVerificada) {
                if (esCorrecta) {
                  backgroundColor = Colors.green.shade200;
                  borderColor = Colors.green;
                } else if (esSeleccionada && !esCorrecta) {
                  backgroundColor = Colors.red.shade200;
                  borderColor = Colors.red;
                } else {
                  backgroundColor = Colors.grey.shade100;
                }
              } else if (esSeleccionada) {
                backgroundColor = Colors.blue.shade100;
                borderColor = Colors.blue;
              }

              final textColor = backgroundColor.computeLuminance() > 0.5
                  ? Colors.black
                  : Colors.white;

              final ButtonStyle optionStyle = ButtonStyle(
                backgroundColor: WidgetStateProperty.all(backgroundColor),
                foregroundColor: WidgetStateProperty.all(textColor),
                padding: WidgetStateProperty.all(const EdgeInsets.all(14)),
                shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: borderColor, width: 2),
                  ),
                ),
                elevation: WidgetStateProperty.all(0),
              );

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                child: ElevatedButton(
                  onPressed: respuestaVerificada
                      ? null
                      : () => setState(() => respuestaSeleccionada = i),
                  style: optionStyle,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            opcion,
                            style: TextStyle(fontSize: 16, color: textColor),
                          ),
                        ),
                        if (respuestaVerificada && esCorrecta)
                          const Icon(Icons.check_circle, color: Colors.green),
                        if (respuestaVerificada &&
                            esSeleccionada &&
                            !esCorrecta)
                          const Icon(Icons.cancel, color: Colors.red),
                      ],
                    ),
                  ),
                ),
              );
            }),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: respuestaSeleccionada == null
                    ? null
                    : (respuestaVerificada ? continuar : verificarRespuesta),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  respuestaVerificada
                      ? (preguntaActual == _preguntas.length - 1
                          ? 'TERMINAR'
                          : 'CONTINUAR')
                      : 'COMPROBAR',
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 35),
          ],
        ),
      ),
    );
  }
}
