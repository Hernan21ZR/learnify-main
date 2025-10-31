import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:learnify/screens/friends/friend_profile_screen.dart';
import 'package:learnify/services/friends_service.dart';
import 'package:learnify/utils/constants.dart';
import 'package:learnify/screens/friends/requests_screen.dart';

class FriendsScreen extends StatefulWidget {
  const FriendsScreen({super.key});

  @override
  State<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _friends = [];
  List<Map<String, dynamic>> _searchResults = [];
  bool _isSearching = false;
  bool _isRefreshing = false; // 👈 Nuevo
  final Set<String> _seguidores = {};

  @override
  void initState() {
    super.initState();
    _loadFriends();
  }

  Future<void> _loadFriends() async {
    // Activa loading global
    setState(() => _isRefreshing = true); 
    final friends = await FriendsService.getFriends();
    if (!mounted) return;
    setState(() {
      _friends = friends;
      // Desactiva loading al terminar
      _isRefreshing = false;
    });
  }

  Future<void> _searchUsers(String query) async {
    if (query.trim().isEmpty) {
      setState(() {
        _isSearching = false;
        _searchResults = [];
      });
      return;
    }

    setState(() => _isSearching = true);
    final results = await FriendsService.searchUsers(query);
    if (!mounted) return;
    setState(() {
      _searchResults = results;
      _isSearching = false;
    });
  }

  Future<void> _sendRequest(String userId) async {
    await FriendsService.sendFriendRequest(userId);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Solicitud enviada con éxito')),
    );
    _searchUsers(_searchController.text);
  }

  void _toggleSeguir(String userId, bool isCurrentlyFollowing) async {
    await FriendsService.toggleFollow(userId, isCurrentlyFollowing);
    setState(() {
      if (isCurrentlyFollowing) {
        _seguidores.remove(userId);
      } else {
        _seguidores.add(userId);
      }
    });
  }

  Stream<int> _getPendingRequestsCount() {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return const Stream.empty();

    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('friendRequests')
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: AppColors.background,
          body: RefreshIndicator(
            color: AppColors.primary,
            onRefresh: _loadFriends,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const Text(
                  "Buscar usuarios",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _searchController,
                  textCapitalization: TextCapitalization.none,
                  textInputAction: TextInputAction.search,
                  onChanged: _searchUsers,
                  decoration: InputDecoration(
                    hintText: "Buscar por nombre, apellido o correo...",
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // 🔍 Resultados de búsqueda
                if (_isSearching)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    ),
                  )
                else if (_searchController.text.isNotEmpty)
                  _searchResults.isEmpty
                      ? const Text(
                          "No se encontraron usuarios",
                          style: TextStyle(color: Colors.grey),
                        )
                      : Column(
                          children: _searchResults.map((u) {
                            final isFollowing = _seguidores.contains(u['id']);
                            final isFriend = u['isFriend'] == true;
                            final hasRequest = u['hasRequest'] == true;

                            return Card(
                              child: ListTile(
                                leading: const CircleAvatar(
                                  backgroundColor: AppColors.primary,
                                  child: Icon(
                                    Icons.person,
                                    color: Colors.white,
                                  ),
                                ),
                                title: Text("${u['nombre']} ${u['apellidos']}"),
                                subtitle: Text(u['email']),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: Icon(
                                        isFollowing
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        color: isFollowing
                                            ? Colors.red
                                            : Colors.redAccent,
                                      ),
                                      onPressed: () =>
                                          _toggleSeguir(u['id'], isFollowing),
                                    ),
                                    if (isFriend)
                                      const Icon(
                                        Icons.check_circle,
                                        color: Colors.green,
                                        size: 27,
                                      )
                                    else if (hasRequest)
                                      const Icon(
                                        Icons.hourglass_top_rounded,
                                        color: Colors.orange,
                                        size: 27,
                                      )
                                    else
                                      IconButton(
                                        icon: const Icon(
                                          Icons.add_circle,
                                          color: AppColors.primary,
                                          size: 27,
                                        ),
                                        onPressed: () => _sendRequest(u['id']),
                                      ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),

                const SizedBox(height: 20),
                const Divider(),
                const Text(
                  "Mis Amigos",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                  ),
                ),
                const SizedBox(height: 10),

                if (_friends.isEmpty)
                  const Text(
                    "Aún no tienes amigos agregados",
                    style: TextStyle(color: Colors.grey),
                  )
                else
                  ..._friends.map(
                    (f) => Card(
                      child: ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: Colors.blueAccent,
                          child: Icon(Icons.person, color: Colors.white),
                        ),
                        title: Text("${f['nombre']} ${f['apellidos']}"),
                        subtitle: Text(f['email']),
                        trailing: const Icon(
                          Icons.chevron_right,
                          color: Colors.grey,
                          size: 28,
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  FriendProfileScreen(friendId: f['id']),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
              ],
            ),
          ),
          floatingActionButton: StreamBuilder<int>(
            stream: _getPendingRequestsCount(),
            builder: (context, snapshot) {
              final count = snapshot.data ?? 0;

              return FloatingActionButton.extended(
                onPressed: () async {
                  // Esperar a que regrese de la pantalla
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const FriendRequestsScreen(),
                    ),
                  );

                  // recargar si se aceptó/rechazó alguna solicitud
                  if (result == true) {
                    _loadFriends();
                  }
                },
                backgroundColor: AppColors.primary,
                icon: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    const Icon(Icons.group_add_rounded, color: Colors.white),
                    if (count > 0)
                      Positioned(
                        right: -6,
                        top: -4,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '$count',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                label: const Text(
                  "Solicitudes",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            },
          ),
        ),

        // Overlay de carga al refrescar
        if (_isRefreshing)
          Container(
            color: Colors.black.withValues(alpha: 0.3),
            child: const Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
                strokeWidth: 5,
              ),
            ),
          ),
      ],
    );
  }
}
