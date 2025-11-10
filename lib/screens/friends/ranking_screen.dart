import 'package:flutter/material.dart';
import 'package:learnify/services/ranking_service.dart';
import 'package:learnify/utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RankingScreen extends StatefulWidget {
  const RankingScreen({super.key});

  @override
  State<RankingScreen> createState() => _RankingScreenState();
}

class _RankingScreenState extends State<RankingScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _loading = true;
  List<Map<String, dynamic>> _global = [];
  List<Map<String, dynamic>> _friends = [];
  String? _currentUserId;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _currentUserId = FirebaseAuth.instance.currentUser?.uid;
    _loadData();
  }

  Future<void> _loadData() async {
    final global = await RankingService.getGlobalRanking();
    final friends = await RankingService.getFriendsRanking();
    setState(() {
      _global = global;
      _friends = friends;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.primary,
        toolbarHeight: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: "Amigos (Semanal)"),
            Tab(text: "Global (Semanal)"),
          ],
        ),
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            )
          : TabBarView(
              controller: _tabController,
              children: [
                _buildRankingList(
                  _friends,
                  "Tus amigos no tienen puntos aún",
                  isGlobal: false,
                ),
                _buildRankingList(
                  _global,
                  "Aún no hay usuarios en el ranking global",
                  isGlobal: true,
                ),
              ],
            ),
    );
  }

  Widget _buildRankingList(
    List<Map<String, dynamic>> data,
    String emptyMsg, {
    required bool isGlobal,
  }) {
    if (data.isEmpty) {
      return Center(
        child: Text(
          emptyMsg,
          style: const TextStyle(color: Colors.grey),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadData,
      color: AppColors.primary,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: data.length,
        itemBuilder: (context, index) {
          final user = data[index];
          final nombre = "${user['nombre']} ${user['apellidos'] ?? ''}";
          final puntos = isGlobal
              ? (user['puntosSemanales'] ?? 0)
              : (user['puntosSemanales'] ?? 0);
          final isCurrentUser = user['id'] == _currentUserId;

          // 🎖 Colores de medallas
          final colores = [
            Colors.amber,
            Colors.grey,
            Colors.brown,
            AppColors.primary,
          ];
          final color = index < 3 ? colores[index] : AppColors.primary;

          return Card(
            color: isCurrentUser
                ? Colors.greenAccent.shade100
                : Colors.white,
            elevation: isCurrentUser ? 6 : 2,
            shadowColor: isCurrentUser
                ? Colors.greenAccent.withValues(alpha: 0.4)
                : Colors.black12,
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: color,
                child: Text(
                  "${index + 1}",
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              title: Text(
                nombre,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isCurrentUser ? Colors.green.shade800 : Colors.black,
                ),
              ),
              subtitle: Text(
                isGlobal
                    ? "Puntaje semanal: $puntos"
                    : "Puntaje semanal: $puntos",
                style: TextStyle(
                  color:
                      isCurrentUser ? Colors.green.shade700 : Colors.grey[700],
                ),
              ),
              trailing: Icon(
                Icons.emoji_events_rounded,
                color: color,
              ),
            ),
          );
        },
      ),
    );
  }
}
