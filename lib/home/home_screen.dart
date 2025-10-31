import 'package:flutter/material.dart';
import 'package:learnify/models/unit.dart';
import 'package:learnify/models/lesson.dart';
import 'package:learnify/screens/friends/friends_screen.dart';
import 'package:learnify/screens/friends/ranking_screen.dart';
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
  int _currentIndex = 0;
  
  // Lista de widgets para cada pantalla
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    UserService.verificarYReiniciarPuntosSemanales();
    
    // Se inicializan las pantallas una vez
    _screens = [
      const UnitsTab(),
      const FriendsScreen(),
      const RankingScreen(),
      const PerfilTab(),
    ];
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
        Navigator.of(context).pushNamedAndRemoveUntil('/welcome', (route) => false);
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
          _currentIndex == 0
              ? "Mis Unidades"
              : _currentIndex == 1
              ? "Amigos"
              : _currentIndex == 2
              ? "Ranking Semanal"
              : "Perfil",
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
            // StreamBuilder para actualizar los puntos en tiempo real
            StreamBuilder<UserStats?>(
              stream: _getUserStatsStream(),
              builder: (context, snapshot) {
                final puntos = snapshot.data?.puntos ?? 0;
                return Row(
                  children: [
                    const Icon(Icons.star_rounded, color: Colors.amber, size: 26),
                    const SizedBox(width: 4),
                    Text(
                      '$puntos',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],
                );
              },
            ),
          IconButton(
            icon: const Icon(Icons.settings_rounded, color: Colors.white),
            onPressed: _mostrarMenuOpciones,
          ),
        ],
      ),
      body: SafeArea(
        // Mantiene activas todas las pantallas
        child: IndexedStack(
          index: _currentIndex,
          children: _screens,
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
              icon: Icon(Icons.group_rounded),
              label: 'Amigos',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.emoji_events_rounded),
              label: 'Ranking',
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

  Stream<UserStats?> _getUserStatsStream() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return Stream.value(null);
    
    return UserService.getUserStatsStream(user.uid);
  }
}

// TAB DE UNIDADES
class UnitsTab extends StatefulWidget {
  const UnitsTab({super.key});

  @override
  State<UnitsTab> createState() => _UnitsTabState();
}

class _UnitsTabState extends State<UnitsTab> with AutomaticKeepAliveClientMixin {
  List<Unit> _unidades = [];
  bool _isLoading = true;
  String? _error;
  UserStats? _userStats;

  // Mantener activo el estado cuando cambiamos de pestaña
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  Future<void> _cargarDatos() async {
    await Future.wait([
      _cargarUnidades(),
      _cargarUserStats(),
    ]);
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

  @override
  Widget build(BuildContext context) {
    // Para mantener el estado con AutomaticKeepAliveClientMixin
    super.build(context);

    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    } else if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_error!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _cargarDatos,
              child: const Text('Reintentar'),
            ),
          ],
        ),
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
      onRefresh: _cargarDatos,
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
    final Color baseColor = unidadColors[(numeroUnidad - 1) % unidadColors.length];

    Color getProgressColor() {
      if (progreso < 0.3) return Colors.redAccent;
      if (progreso < 0.7) return Colors.amberAccent;
      return Colors.lightGreenAccent;
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(
          colors: bloqueada
              ? [Colors.grey.shade500, Colors.grey.shade400]
              : [
                  baseColor.withValues(alpha: 0.9),
                  baseColor.withValues(alpha: 0.75),
                ],
        ),
        boxShadow: [
          BoxShadow(
            color: baseColor.withValues(alpha: 0.3),
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
                      style: const TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.menu_book_rounded, color: Colors.white70, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          "$completadasUnidad/$total lecciones",
                          style: const TextStyle(color: Colors.white70, fontSize: 13),
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
                    .map((entry) => _buildLeccionItem(
                          unidad,
                          entry.value,
                          entry.key + 1,
                          baseColor,
                        ))
                    .toList(),
        ),
      ),
    );
  }

  Widget _buildLeccionItem(Unit unidad, Lesson leccion, int numeroLeccion, Color baseColor) {
    final completadas = _userStats?.leccionesCompletadas ?? [];
    final completada = completadas.contains(leccion.id);

    bool bloqueada = false;
    if (unidad.orden == 1 && numeroLeccion == 1) {
      bloqueada = false;
    } else {
      final indexActual = unidad.lecciones.indexOf(leccion);
      if (indexActual > 0) {
        final leccionAnterior = unidad.lecciones[indexActual - 1];
        bloqueada = !completadas.contains(leccionAnterior.id);
      } else {
        final indexUnidad = _unidades.indexOf(unidad);
        if (indexUnidad > 0) {
          final unidadAnterior = _unidades[indexUnidad - 1];
          final todasCompletadas = unidadAnterior.lecciones.every(
            (l) => completadas.contains(l.id),
          );
          bloqueada = !todasCompletadas;
        }
      }
    }

    final double intensidad = 0.2 + (numeroLeccion * 0.1);
    final Color colorLeccion = baseColor.withValues(alpha: intensidad.clamp(0.2, 0.8));
    final Color backgroundColor = completada
        ? colorLeccion
        : bloqueada
        ? Colors.grey.shade200
        : Colors.white;
    final Color borderColor = completada
        ? colorLeccion
        : bloqueada
        ? Colors.grey.shade400
        : colorLeccion.withValues(alpha: 0.4);
    final Color textColor = completada
        ? Colors.white
        : bloqueada
        ? Colors.grey
        : Colors.black87;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          splashColor: bloqueada ? Colors.transparent : colorLeccion.withValues(alpha: 0.25),
          onTap: bloqueada
              ? () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Completa la lección anterior para desbloquear esta.'),
                      backgroundColor: Colors.orangeAccent,
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              : () => _mostrarDialogoLeccion(leccion, unidad.id, colorLeccion),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: borderColor, width: 1.4),
              boxShadow: [
                BoxShadow(
                  color: colorLeccion.withValues(alpha: 0.25),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(
                  completada
                      ? Icons.check_circle_rounded
                      : bloqueada
                      ? Icons.lock_rounded
                      : Icons.menu_book_rounded,
                  color: completada
                      ? Colors.white
                      : bloqueada
                      ? Colors.grey
                      : colorLeccion,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    "Lección $numeroLeccion: ${leccion.titulo}",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                ),
                if (!bloqueada)
                  Icon(
                    completada ? Icons.verified_rounded : Icons.play_arrow_rounded,
                    color: completada ? Colors.white : colorLeccion,
                    size: 26,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _mostrarDialogoLeccion(Lesson leccion, String unidadId, Color colorLeccion) {
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
                  builder: (_) => LessonScreen(unidadId: unidadId, leccion: leccion),
                ),
              ).then((_) {
                // Recargar stats cuando vuelva de la lección
                _cargarUserStats();
              });
            },
            style: ElevatedButton.styleFrom(backgroundColor: colorLeccion),
            child: const Text('Comenzar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

// TAB DE PERFIL
class PerfilTab extends StatefulWidget {
  const PerfilTab({super.key});

  @override
  State<PerfilTab> createState() => _PerfilTabState();
}

class _PerfilTabState extends State<PerfilTab> with AutomaticKeepAliveClientMixin {
  List<Unit> _unidades = [];
  bool _isLoading = true;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _cargarUnidades();
  }

  Future<void> _cargarUnidades() async {
    setState(() => _isLoading = true);
    
    final unidades = await UnitsService.obtenerUnidades();
    
    if (!mounted) return;
    setState(() {
      _unidades = unidades;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const Center(child: Text('No hay usuario autenticado'));
    }

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator(color: AppColors.primary));
    }
    
    // StreamBuilder para obtener stats en tiempo real
    return StreamBuilder<UserStats?>(
      stream: UserService.getUserStatsStream(user.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: AppColors.primary));
        }
        
        return PerfilScreen(
          unidades: _unidades,
          userStats: snapshot.data,
        );
      },
    );
  }
}