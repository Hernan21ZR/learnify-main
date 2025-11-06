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
    Unit(
      id: 'unidad_5',
      nombre: 'Verbos y acciones',
      descripcion: 'Aprende a expresar acciones cotidianas y rutinas',
      orden: 5,
      bloqueada: true,
      lecciones: [
        Lesson(
          id: 'unidad_5_leccion_1',
          titulo: 'Verbos comunes',
          orden: 1,
          descripcion: 'Conoce los verbos más usados en la vida diaria.',
        ),
        Lesson(
          id: 'unidad_5_leccion_2',
          titulo: 'Rutinas diarias',
          orden: 2,
          descripcion: 'Aprende a hablar de lo que haces cada día.',
          prerequisitos: ['unidad_5_leccion_1'],
        ),
      ],
    ),

    Unit(
      id: 'unidad_6',
      nombre: 'El tiempo y el clima',
      descripcion: 'Aprende a hablar sobre el clima y las estaciones.',
      orden: 6,
      bloqueada: true,
      lecciones: [
        Lesson(
          id: 'unidad_6_leccion_1',
          titulo: 'El clima',
          orden: 1,
          descripcion: 'Vocabulario y frases para describir el tiempo.',
        ),
        Lesson(
          id: 'unidad_6_leccion_2',
          titulo: 'Las estaciones del año',
          orden: 2,
          descripcion: 'Aprende los nombres y características de las estaciones.',
          prerequisitos: ['unidad_6_leccion_1'],
        ),
      ],
    ),
    Unit(
      id: 'unidad_7',
      nombre: 'Viajes y transporte',
      descripcion: 'Aprende a moverte y comunicarte en viajes.',
      orden: 7,
      bloqueada: true,
      lecciones: [
        Lesson(
          id: 'unidad_7_leccion_1',
          titulo: 'Medios de transporte',
          orden: 1,
          descripcion: 'Aprende vocabulario sobre transporte y movimiento.',
        ),
        Lesson(
          id: 'unidad_7_leccion_2',
          titulo: 'En el aeropuerto',
          orden: 2,
          descripcion: 'Frases útiles para viajar y moverte por el aeropuerto.',
          prerequisitos: ['unidad_7_leccion_1'],
        ),
      ],
    ),
    Unit(
      id: 'unidad_8',
      nombre: 'Compras y dinero',
      descripcion: 'Aprende a comprar, vender y manejar dinero.',
      orden: 8,
      bloqueada: true,
      lecciones: [
        Lesson(
          id: 'unidad_8_leccion_1',
          titulo: 'En la tienda',
          orden: 1,
          descripcion: 'Frases y vocabulario para comprar productos.',
        ),
        Lesson(
          id: 'unidad_8_leccion_2',
          titulo: 'Dinero y precios',
          orden: 2,
          descripcion: 'Aprende a preguntar y hablar sobre precios y dinero.',
          prerequisitos: ['unidad_8_leccion_1'],
        ),
      ],
    ),
    Unit(
      id: 'unidad_9',
      nombre: 'Salud y cuerpo',
      descripcion: 'Aprende vocabulario relacionado con el cuerpo y la salud.',
      orden: 9,
      bloqueada: true,
      lecciones: [
        Lesson(
          id: 'unidad_9_leccion_1',
          titulo: 'Partes del cuerpo',
          orden: 1,
          descripcion: 'Conoce el vocabulario del cuerpo humano.',
        ),
        Lesson(
          id: 'unidad_9_leccion_2',
          titulo: 'En el médico',
          orden: 2,
          descripcion: 'Aprende frases para describir síntomas y pedir ayuda médica.',
          prerequisitos: ['unidad_9_leccion_1'],
        ),
      ],
    ),
  ];
}
