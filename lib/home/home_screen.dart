import 'package:flutter/material.dart';
import 'package:learnify/models/unit.dart';
import 'package:learnify/models/lesson.dart';
import 'package:learnify/screens/profile/perfil_screen.dart';
import 'package:learnify/services/units_service.dart';
import 'package:learnify/lessons/lesson_screen.dart';
import 'package:learnify/utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:learnify/services/user_service.dart';
import 'package:learnify/models/user_stats.dart';
import 'package:learnify/services/auth_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Unit> _unidades = [];
  bool _isLoading = true;
  String? _error;
  int _currentIndex = 0;
  UserStats? _userStats;

  // Guardamos el progreso previo para mostrar mensajes solo al cambiar
  final Map<String, double> _progresoAnterior = {};

  @override
  void initState() {
    super.initState();
    _cargarUnidades();
    _cargarUserStats();
  }

  Future<void> _cargarUserStats() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final stats = await UserService.obtenerUserStats(user.uid);
    if (!mounted) return;
    setState(() => _userStats = stats);
  }

  Future<void> _cargarUnidades() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final unidades = await UnitsService.obtenerUnidades();
      if (!mounted) return;
      setState(() {
        _unidades = unidades;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = 'Error al cargar las unidades: $e';
        _isLoading = false;
      });
    }
  }

  void _onTabSelected(int index) => setState(() => _currentIndex = index);

  void _mostrarMenuOpciones() {
    showMenu<String>(
      context: context,
      position: const RelativeRect.fromLTRB(1000, 80, 16, 0),
      items: [
        const PopupMenuItem<String>(
          value: 'logout',
          child: Row(
            children: [
              Icon(Icons.logout, color: Colors.redAccent),
              SizedBox(width: 8),
              Text('Cerrar sesión'),
            ],
          ),
        ),
      ],
    ).then((value) async {
      if (value == 'logout') {
        await AuthService().signOut();
        await Future.delayed(const Duration(milliseconds: 300));
        if (!mounted) return;
        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil('/welcome', (route) => false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          _currentIndex == 0 ? "Mis Unidades" : "Perfil",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          if (_currentIndex == 0)
            Row(
              children: [
                const Icon(Icons.star_rounded, color: Colors.amber, size: 26),
                const SizedBox(width: 4),
                Text(
                  '${_userStats?.puntos ?? 0}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 12),
              ],
            ),
          IconButton(
            icon: const Icon(Icons.settings_rounded, color: Colors.white),
            onPressed: _mostrarMenuOpciones,
          ),
        ],
      ),
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _getBodyContent(),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onTabSelected,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          iconSize: screenWidth * 0.07,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded),
              label: 'Inicio',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_rounded),
              label: 'Perfil',
            ),
          ],
        ),
      ),
    );
  }

  Widget _getBodyContent() {
    if (_currentIndex == 1) {
      return PerfilScreen(unidades: _unidades, userStats: _userStats);
    }

    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    } else if (_error != null) {
      return Center(
        child: Text(_error!, style: const TextStyle(color: Colors.red)),
      );
    } else if (_unidades.isEmpty) {
      return const Center(
        child: Text(
          'No hay unidades disponibles',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () async {
        await _cargarUnidades();
        await _cargarUserStats();
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _unidades.length,
        itemBuilder: (context, index) {
          final unidad = _unidades[index];
          return _buildUnidadCard(unidad, index + 1);
        },
      ),
    );
  }

  Widget _buildUnidadCard(Unit unidad, int numeroUnidad) {
    final completadas = _userStats?.leccionesCompletadas ?? [];
    final total = unidad.lecciones.length;
    final completadasUnidad = unidad.lecciones
        .where((l) => completadas.contains(l.id))
        .length;
    final progreso = total > 0 ? completadasUnidad / total : 0.0;

    // 🔒 Bloqueo de unidades
    bool bloqueada = false;
    if (numeroUnidad > 1) {
      final unidadAnterior = _unidades[numeroUnidad - 2];
      final totalAnterior = unidadAnterior.lecciones.length;
      final completadasAnterior = unidadAnterior.lecciones
          .where((l) => completadas.contains(l.id))
          .length;
      final progresoAnterior = totalAnterior > 0
          ? completadasAnterior / totalAnterior
          : 0.0;
      bloqueada = progresoAnterior < 1.0;
    }

    final List<Color> unidadColors = [
      Colors.blueAccent,
      Colors.deepPurpleAccent,
      Colors.teal,
      Colors.orangeAccent,
      Colors.pinkAccent,
      Colors.indigoAccent,
      Colors.cyan,
      Colors.greenAccent,
    ];
    final Color baseColor =
        unidadColors[(numeroUnidad - 1) % unidadColors.length];

    Color getProgressColor() {
      if (progreso < 0.3) return Colors.redAccent;
      if (progreso < 0.7) return Colors.amberAccent;
      return Colors.lightGreenAccent;
    }

    // ✅ Mostrar mensaje solo si pasa de <1.0 a 1.0
    final progresoPrevio = _progresoAnterior[unidad.id] ?? 0.0;
    if (progreso == 1.0 && progresoPrevio < 1.0 && !bloqueada) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "¡Unidad $numeroUnidad completada 🎉!",
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: baseColor,
            duration: const Duration(seconds: 2),
          ),
        );
      });
    }
    _progresoAnterior[unidad.id] = progreso;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(
          colors: bloqueada
              ? [Colors.grey.shade500, Colors.grey.shade400]
              : [baseColor.withOpacity(0.9), baseColor.withOpacity(0.75)],
        ),
        boxShadow: [
          BoxShadow(
            color: baseColor.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: ExpansionTile(
          collapsedIconColor: Colors.white,
          iconColor: Colors.white,
          title: Row(
            children: [
              Icon(
                bloqueada
                    ? Icons.lock_rounded
                    : (progreso == 1.0
                          ? Icons.verified_rounded
                          : Icons.menu_book_rounded),
                color: Colors.white,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  "Unidad $numeroUnidad: ${unidad.nombre}",
                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  bloqueada
                      ? "🔒 Completa la unidad anterior para desbloquear"
                      : unidad.descripcion,
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: progreso,
                    backgroundColor: Colors.white24,
                    color: getProgressColor(),
                    minHeight: 8,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${(progreso * 100).toStringAsFixed(0)}% completado",
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.menu_book_rounded,
                          color: Colors.white70,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "$completadasUnidad/$total lecciones",
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          childrenPadding: bloqueada
              ? EdgeInsets.zero
              : const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          children: bloqueada
              ? []
              : unidad.lecciones
                    .asMap()
                    .entries
                    .map(
                      (entry) => _buildLeccionItem(
                        unidad,
                        entry.value,
                        entry.key + 1,
                        baseColor,
                      ),
                    )
                    .toList(),
        ),
      ),
    );
  }

  Widget _buildLeccionItem(
    Unit unidad,
    Lesson leccion,
    int numeroLeccion,
    Color baseColor,
  ) {
    final completadas = _userStats?.leccionesCompletadas ?? [];
    final completada = completadas.contains(leccion.id);

    bool bloqueada = false;
    if (numeroLeccion > 1) {
      final leccionAnterior = unidad.lecciones[numeroLeccion - 2];
      if (!completadas.contains(leccionAnterior.id)) bloqueada = true;
    }

    final Color colorLeccion = baseColor.withOpacity(
      (0.2 + (numeroLeccion * 0.1)).clamp(0.3, 0.9),
    );
    final backgroundColor = bloqueada
        ? Colors.grey.shade200
        : (completada ? colorLeccion : Colors.white);
    final textColor = bloqueada
        ? Colors.grey
        : (completada ? Colors.white : Colors.black87);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        splashColor: colorLeccion.withOpacity(0.25),
        onTap: bloqueada
            ? () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    "Completa la lección anterior para desbloquear esta 🚫",
                    style: TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Colors.redAccent,
                  duration: Duration(seconds: 2),
                ),
              )
            : () => _mostrarDialogoLeccion(leccion, unidad.id, colorLeccion),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: colorLeccion.withOpacity(0.5),
              width: 1.4,
            ),
          ),
          child: Row(
            children: [
              Icon(
                bloqueada
                    ? Icons.lock_outline_rounded
                    : (completada
                          ? Icons.check_rounded
                          : Icons.menu_book_rounded),
                color: bloqueada ? Colors.grey : AppColors.primary,
                size: 22,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Lección $numeroLeccion: ${leccion.titulo}",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                      ),
                    ),
                    if (leccion.descripcion != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          leccion.descripcion!,
                          style: TextStyle(
                            fontSize: 13,
                            color: bloqueada
                                ? Colors.grey
                                : (completada ? Colors.white70 : Colors.grey),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Icon(
                bloqueada
                    ? Icons.lock_rounded
                    : (completada
                          ? Icons.verified_rounded
                          : Icons.play_arrow_rounded),
                color: bloqueada ? Colors.grey : AppColors.primary,
                size: 26,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _mostrarDialogoLeccion(
    Lesson leccion,
    String unidadId,
    Color colorLeccion,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: colorLeccion, width: 2),
        ),
        title: Row(
          children: [
            Icon(Icons.book_rounded, color: colorLeccion),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                leccion.titulo,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: colorLeccion,
                ),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (leccion.descripcion != null) ...[
              Text(
                leccion.descripcion!,
                style: const TextStyle(color: Colors.black87),
              ),
              const SizedBox(height: 16),
            ],
            Text(
              '¿Listo para comenzar esta lección?',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: colorLeccion,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      LessonScreen(unidadId: unidadId, leccion: leccion),
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: colorLeccion),
            child: const Text(
              'Comenzar',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
