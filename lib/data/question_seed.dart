import '../models/question.dart';

class QuestionsSeed {
  static Map<String, List<Question>> get preguntasPorLeccion => {
    // Unidad 1
    'unidad_1_leccion_1': [
      Question(
        id: 'q1',
        enunciado: '¿Cómo se dice "Hola" en inglés?',
        opciones: ['Hello', 'Bye', 'Thanks', 'Good'],
        respuestaCorrecta: 0,
      ),
      Question(
        id: 'q2',
        enunciado: '¿Cómo responderías a "Hello"?',
        opciones: ['Thanks', 'Hello', 'Goodbye', 'Yes'],
        respuestaCorrecta: 1,
      ),
    ],
    'unidad_1_leccion_2': [
      Question(
        id: 'q1',
        enunciado: '¿Cómo se dice "Me llamo Ana"?',
        opciones: ['My name is Ana', 'I am Ana', 'Ana good', 'I Ana is'],
        respuestaCorrecta: 0,
      ),
    ],

    // Unidad 2
    'unidad_2_leccion_1': [
      Question(
        id: 'q1',
        enunciado: '¿Cuál es el artículo definido en inglés?',
        opciones: ['The', 'A', 'An', 'One'],
        respuestaCorrecta: 0,
      ),
    ],
    'unidad_2_leccion_2': [
      Question(
        id: 'q1',
        enunciado:
            '¿Cuál es la forma correcta del verbo "to be" en primera persona?',
        opciones: ['I is', 'I am', 'I are', 'I be'],
        respuestaCorrecta: 1,
      ),
    ],

    'unidad_3_leccion_1': [
      Question(
        id: 'q1',
        enunciado: '¿Cómo se dice "¿Cómo estás?" en inglés?',
        opciones: [
          'How are you?',
          'Who are you?',
          'Where are you?',
          'How old are you?',
        ],
        respuestaCorrecta: 0,
      ),
      Question(
        id: 'q2',
        enunciado: '¿Cómo preguntar "¿Qué haces?"?',
        opciones: [
          'What do you do?',
          'What is your name?',
          'How are you?',
          'Where are you?',
        ],
        respuestaCorrecta: 0,
      ),
    ],
    'unidad_3_leccion_2': [
      Question(
        id: 'q1',
        enunciado: '¿Cómo responder a "How are you?"?',
        opciones: [
          'I am fine, thanks.',
          'I have 10 years.',
          'I go school.',
          'I name is John.',
        ],
        respuestaCorrecta: 0,
      ),
    ],
    'unidad_4_leccion_1': [
      Question(
        id: 'q1',
        enunciado: '¿Cómo se dice "mesa" en inglés?',
        opciones: ['Chair', 'Bed', 'Table', 'Door'],
        respuestaCorrecta: 2,
      ),
    ],
    'unidad_4_leccion_2': [
      Question(
        id: 'q1',
        enunciado: '¿Cómo se dice "pan" en inglés?',
        opciones: ['Rice', 'Bread', 'Apple', 'Milk'],
        respuestaCorrecta: 1,
      ),
    ],
  };
}
