import '../models/unit.dart';
import '../models/lesson.dart';

/// Datos iniciales para poblar Firestore (seeding)
class UnitsSeed {
  static List<Unit> get unidades => [
    Unit(
      id: 'unidad_1',
      nombre: 'Fundamentos',
      descripcion: 'Aprende los conceptos básicos del idioma.',
      orden: 1,
      lecciones: [
        Lesson(
          id: 'unidad_1_leccion_1',
          titulo: 'Saludos',
          orden: 1,
          descripcion: 'Aprende a saludar y presentarte.',
        ),
        Lesson(
          id: 'unidad_1_leccion_2',
          titulo: 'Presentaciones',
          orden: 2,
          descripcion: 'Aprende a decir tu nombre y preguntar el de otros.',
          prerequisitos: ['unidad_1_leccion_1'],
        ),
      ],
    ),
    Unit(
      id: 'unidad_2',
      nombre: 'Gramática básica',
      descripcion: 'Construye frases simples y útiles.',
      orden: 2,
      bloqueada: true,
      lecciones: [
        Lesson(
          id: 'unidad_2_leccion_1',
          titulo: 'Artículos y sustantivos',
          orden: 1,
          descripcion: 'Aprende el uso de artículos definidos e indefinidos.',
        ),
        Lesson(
          id: 'unidad_2_leccion_2',
          titulo: 'Verbos básicos',
          orden: 2,
          descripcion: 'Aprende los verbos más comunes en presente.',
          prerequisitos: ['unidad_2_leccion_1'],
        ),
      ],
    ),

    Unit(
      id: 'unidad_3',
      nombre: 'Conversación básica',
      descripcion: 'Aprende frases comunes para conversar.',
      orden: 3,
      bloqueada: true,
      lecciones: [
        Lesson(
          id: 'unidad_3_leccion_1',
          titulo: 'Preguntas comunes',
          orden: 1,
          descripcion: 'Aprende cómo preguntar cosas básicas en inglés.',
        ),
        Lesson(
          id: 'unidad_3_leccion_2',
          titulo: 'Respuestas comunes',
          orden: 2,
          descripcion: 'Aprende cómo responder preguntas simples.',
          prerequisitos: ['unidad_3_leccion_1'],
        ),
      ],
    ),
    Unit(
      id: 'unidad_4',
      nombre: 'Vocabulario diario',
      descripcion: 'Aprende palabras útiles del día a día.',
      orden: 4,
      bloqueada: true,
      lecciones: [
        Lesson(
          id: 'unidad_4_leccion_1',
          titulo: 'La casa',
          orden: 1,
          descripcion: 'Palabras sobre el hogar y los muebles.',
        ),
        Lesson(
          id: 'unidad_4_leccion_2',
          titulo: 'La comida',
          orden: 2,
          descripcion: 'Palabras sobre alimentos y bebidas.',
          prerequisitos: ['unidad_4_leccion_1'],
        ),
      ],
    ),
  ];
}
