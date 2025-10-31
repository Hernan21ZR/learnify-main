import 'dart:math';
import 'package:flutter/material.dart';
import 'package:learnify/services/friends_service.dart';
import 'package:learnify/utils/constants.dart';
import 'package:learnify/models/user_stats.dart';

class FriendProfileScreen extends StatefulWidget {
  final String friendId;

  const FriendProfileScreen({super.key, required this.friendId});

  @override
  State<FriendProfileScreen> createState() => _FriendProfileScreenState();
}

class _FriendProfileScreenState extends State<FriendProfileScreen> {
  Map<String, dynamic>? _friendData;
  bool _isLoading = true;
  late String _avatarSeleccionado;

  final List<String> _avatars = [
    'images/avatar1.png',
    'images/avatar2.png',
    'images/avatar3.png',
    'images/avatar4.png',
  ];

  @override
  void initState() {
    super.initState();
    _avatarSeleccionado = _avatars[Random().nextInt(_avatars.length)];
    _loadFriendProfile();
  }

  Future<void> _loadFriendProfile() async {
    final data = await FriendsService.getUserProfileById(widget.friendId);
    if (!mounted) return;
    setState(() {
      _friendData = data;
      _isLoading = false;
    });
  }

  Map<String, dynamic> calcularNivel(int puntos) {
    final niveles = [100, 150, 200, 250, 300, 400, 500, 600, 700, 800, 1000, 1200, 1400, 1600, 1800];
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
    double progresoNivel = xpSiguiente > 0 ? xpActual / xpSiguiente : 0;

    String zona;
    if (nivel <= 5) {
      zona = "Principiante 🟢";
    }
    else if (nivel <= 10) {
      zona = "Intermedio 🟡";
    }
    else if (nivel <= 15) {
      zona = "Avanzado 🔵";
    }
    else {
      zona = "Experto 🔥";
    }

    return {"nivel": nivel, "zona": zona, "progresoNivel": progresoNivel.clamp(0.0, 1.0)};
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    }

    if (_friendData == null) {
      return const Scaffold(
        body: Center(child: Text("No se pudo cargar el perfil.")),
      );
    }

    final stats = UserStats.fromMap(_friendData!);
    final nivelData = calcularNivel(stats.puntos);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(
          "Perfil de amigo",
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage(_avatarSeleccionado),
            ),
            const SizedBox(height: 12),
            Text(
              "${_friendData!['nombre']} ${_friendData!['apellidos']}",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.primary),
            ),
            const SizedBox(height: 4),
            Text(_friendData!['email'], style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 8),
            Text("🔥 Racha de ${stats.racha} días", style: const TextStyle(color: Colors.orange)),
            const SizedBox(height: 16),
            _metricCard(Icons.star, "Puntos", "${stats.puntos} XP", Colors.amber),
            _metricCard(Icons.school, "Nivel ${nivelData['nivel']}", nivelData['zona'], AppColors.primary),
          ],
        ),
      ),
    );
  }

  Widget _metricCard(IconData icon, String label, String value, Color color) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              Text(label, style: const TextStyle(color: Colors.grey)),
            ],
          ),
        ],
      ),
    );
  }
}
