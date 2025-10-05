
import 'lesson.dart';

class Unit {
  final String id;
  final String nombre;
  final String descripcion;
  final List<Lesson> lecciones;
  final int orden;
  final bool bloqueada;

  Unit({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.lecciones,
    required this.orden,
    this.bloqueada = false,
  });

  //Convertir datos de Firestore en un objeto
  factory Unit.fromFirestore(
    String id,
    Map<String, dynamic> data,
    List<Lesson> lecciones,
  ) {
    return Unit(
      id: id,
      nombre: data['nombre'] ?? '',
      descripcion: data['descripcion'] ?? '',
      lecciones: lecciones,
      orden: data['orden'] ?? 0,
      bloqueada: data['bloqueada'] ?? false,
    );
  }

  // Convertir a Map para guardar en Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'nombre': nombre,
      'descripcion': descripcion,
      'orden': orden,
      'bloqueada': bloqueada,
    };
  }

  @override
  String toString() => 'Unidad{id: $id, nombre: $nombre}';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Unit && runtimeType == other.runtimeType && id == other.id);

  @override
  int get hashCode => id.hashCode;

  Unit copyWith({
    String? id,
    String? nombre,
    String? descripcion,
    List<Lesson>? lecciones,
    int? orden,
    bool? bloqueada,
  }) {
    return Unit(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      descripcion: descripcion ?? this.descripcion,
      lecciones: lecciones ?? this.lecciones,
      orden: orden ?? this.orden,
      bloqueada: bloqueada ?? this.bloqueada,
    );
  }
}
