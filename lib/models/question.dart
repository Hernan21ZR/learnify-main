class Question {
  final String id;
  final String enunciado;
  final List<String> opciones;
  final int respuestaCorrecta;

  Question({
    required this.id,
    required this.enunciado,
    required this.opciones,
    required this.respuestaCorrecta,
  });

  factory Question.fromFirestore(String id, Map<String, dynamic> data) {
    return Question(
      id: id,
      enunciado: data['enunciado'] ?? '',
      opciones: List<String>.from(data['opciones'] ?? []),
      respuestaCorrecta: data['respuestaCorrecta'] ?? 0,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'enunciado': enunciado,
      'opciones': opciones,
      'respuestaCorrecta': respuestaCorrecta,
    };
  }
}
