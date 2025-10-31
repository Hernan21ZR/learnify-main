import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:learnify/models/unit.dart';
import 'package:learnify/models/user_stats.dart';
import 'package:learnify/screens/friends/following_screen.dart';
import 'package:learnify/utils/constants.dart';

class PerfilScreen extends StatefulWidget {
  final List<Unit> unidades;
  final UserStats? userStats;

  const PerfilScreen({
    super.key,
    required this.unidades,
    required this.userStats,
  });

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  final List<String> _avatars = [
    'images/avatar1.png',
    'images/avatar2.png',
    'images/avatar3.png',
    'images/avatar4.png',
  ];

  late String _avatarSeleccionado;
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _avatarSeleccionado = _avatars[Random().nextInt(_avatars.length)];
  }

  Map<String, dynamic> calcularNivel(int puntos) {
    final niveles = [
      100,
      150,
      200,
      250,
      300,
      400,
      500,
      600,
      700,
      800,
      1000,
      1200,
      1400,
      1600,
      1800
    ];

    int nivel = 1;
    int xpAcumulado = 0;
    for (int req in niveles) {
      if (puntos >= xpAcumulado + req) {
        xpAcumulado += req;
        nivel++;
      } else {
        break;
      }
    }

    int xpSiguiente = (nivel <= niveles.length)
        ? niveles[nivel - 1]
        : 2000 + ((nivel - niveles.length - 1) * 500);

    int xpActual = puntos - xpAcumulado;
    int xpRestante = (xpSiguiente - xpActual).clamp(0, xpSiguiente);
    double progresoNivel = xpSiguiente > 0 ? xpActual / xpSiguiente : 0;

    String zona;
    if (nivel <= 5)
      zona = "Principiante 🟢";
    else if (nivel <= 10)
      zona = "Intermedio 🟡";
    else if (nivel <= 15)
      zona = "Avanzado 🔵";
    else
      zona = "Experto 🔥";

    return {
      "nivel": nivel,
      "zona": zona,
      "progresoNivel": progresoNivel.clamp(0.0, 1.0),
      "xpRestante": xpRestante,
    };
  }

  Future<void> _recargarPerfil() async {
    setState(() => _isRefreshing = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _isRefreshing = false);
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final stats = widget.userStats;

    if (stats == null) {
      return const Center(child: Text("No se pudo cargar la información."));
    }

    final unidades = widget.unidades;
    final totalLecciones =
        unidades.fold<int>(0, (prev, u) => prev + u.lecciones.length);
    final completadas = stats.leccionesCompletadas.length;
    final progresoGlobal =
        totalLecciones > 0 ? completadas / totalLecciones : 0.0;
    final nivelData = calcularNivel(stats.puntos);

    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: _recargarPerfil,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildHeader(user, stats),
            const SizedBox(height: 25),
            _buildMetricasPrincipales(progresoGlobal, stats, nivelData),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(User? user, UserStats stats) {
    return Column(
      children: [
        GestureDetector(
          onTap: _mostrarSelectorAvatar,
          child: CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage(_avatarSeleccionado),
            backgroundColor: Colors.transparent,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          user?.displayName ?? "Estudiante",
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 4),
        Text(user?.email ?? "", style: const TextStyle(color: Colors.grey)),
        const SizedBox(height: 8),
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(user?.uid)
              .collection('following')
              .snapshots(),
          builder: (context, snapshot) {
            final count = snapshot.data?.docs.length ?? 0;
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const FollowingScreen()),
                );
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "Seguidos: $count",
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 12),
        Text(
          "🔥 Racha de ${stats.racha} días consecutivos",
          style: const TextStyle(color: Colors.orange, fontSize: 16),
        ),
        const SizedBox(height: 8),
        const Text(
          "Toca tu avatar para cambiarlo 🦉",
          style: TextStyle(color: Colors.grey, fontSize: 13),
        ),
      ],
    );
  }

  Widget _buildMetricasPrincipales(
      double progreso, UserStats stats, Map<String, dynamic> nivelData) {
    final nivel = nivelData["nivel"];
    final zona = nivelData["zona"];
    final progresoNivel = nivelData["progresoNivel"];
    final xpRestante = nivelData["xpRestante"];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Progreso del Usuario",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _metricCard(Icons.star, "Puntos", "${stats.puntos} XP", Colors.amber),
            _metricCard(Icons.school, "Nivel $nivel", zona, AppColors.primary),
            _metricCard(Icons.book, "Curso",
                "${(progreso * 100).toStringAsFixed(0)}%", Colors.green),
            _metricCard(Icons.emoji_events, "Puntaje semanal",
                "${stats.puntosSemanales ?? 0} XP", Colors.deepPurple),
          ],
        ),
        const SizedBox(height: 24),
        LinearProgressIndicator(
          value: progresoNivel,
          backgroundColor: Colors.grey.shade300,
          color: AppColors.primary,
          minHeight: 8,
          borderRadius: BorderRadius.circular(10),
        ),
        const SizedBox(height: 8),
        Text("Te faltan $xpRestante XP → Nivel ${nivel + 1}",
            style: const TextStyle(color: Colors.grey)),
      ],
    );
  }

  Widget _metricCard(IconData icon, String label, String value, Color color) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(value,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          Text(label, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  void _mostrarSelectorAvatar() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Selecciona tu avatar",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 16),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              alignment: WrapAlignment.center,
              children: _avatars.map((avatar) {
                return GestureDetector(
                  onTap: () {
                    setState(() => _avatarSeleccionado = avatar);
                    Navigator.pop(context);
                  },
                  child: CircleAvatar(
                    radius: 35,
                    backgroundImage: AssetImage(avatar),
                    backgroundColor: avatar == _avatarSeleccionado
                        ? AppColors.primary.withOpacity(0.2)
                        : Colors.transparent,
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
