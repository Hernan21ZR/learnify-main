class Lesson {
  final String id;
  final String titulo;
  final int orden;
  final String? descripcion;
  final List<String>? prerequisitos;

  Lesson({
    required this.id,
    required this.titulo,
    required this.orden,
    this.descripcion,
    this.prerequisitos,
  });

  // Crear desde Firestore (datos estáticos)
  factory Lesson.fromFirestore(String id, Map<String, dynamic> data) {
    return Lesson(
      id: id,
      titulo: data['titulo'] ?? '',
      orden: data['orden'] ?? 0,
      descripcion: data['descripcion'],
      prerequisitos: List<String>.from(data['prerequisitos'] ?? []),
    );
  }

  // Convertir a Map para guardar en Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'titulo': titulo,
      'orden': orden,
      'descripcion': descripcion,
      'prerequisitos': prerequisitos ?? [],
    };
  }

  Lesson copyWith({
    String? id,
    String? titulo,
    int? orden,
    String? descripcion,
    List<String>? prerequisitos,
    bool? completada,
  }) {
    return Lesson(
      id: id ?? this.id,
      titulo: titulo ?? this.titulo,
      orden: orden ?? this.orden,
      descripcion: descripcion ?? this.descripcion,
      prerequisitos: prerequisitos ?? this.prerequisitos,
    );
  }
}
