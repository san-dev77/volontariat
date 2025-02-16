import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:volontariat/app/modules/views/add_rapport.dart';
import 'package:volontariat/app/utils/colors.dart';

class RapportScreen extends StatefulWidget {
  const RapportScreen({Key? key}) : super(key: key);

  @override
  _RapportScreenState createState() => _RapportScreenState();
}

class _RapportScreenState extends State<RapportScreen> {
  bool _isLoading = true;
  String? _error;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final User? _currentUser = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    try {
      await initializeDateFormatting('fr_FR', null);
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _error = null;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = 'Erreur d\'initialisation: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _refreshData() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });
      await _initializeData();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = 'Erreur lors du rafraîchissement: $e';
        _isLoading = false;
      });
    }
  }

  Stream<QuerySnapshot> _getRapportsStream() {
    if (_currentUser == null) {
      throw Exception('Utilisateur non connecté');
    }

    return _firestore
        .collection('rapports')
        .where('userId', isEqualTo: _currentUser!.uid)
        .orderBy('periode', descending: true)
        .snapshots()
        .handleError((error) {
      print('Erreur Firestore: $error');
      setState(() {
        _error = 'Erreur de chargement des données: $error';
      });
    });
  }

  String _formatTimestamp(dynamic timestamp) {
    if (timestamp == null) return 'Date inconnue';

    try {
      if (timestamp is Timestamp) {
        return DateFormat('dd/MM/yyyy', 'fr_FR').format(timestamp.toDate());
      } else if (timestamp is DateTime) {
        return DateFormat('dd/MM/yyyy', 'fr_FR').format(timestamp);
      }
      return 'Format de date invalide';
    } catch (e) {
      print('Erreur de formatage de date: $e');
      return 'Erreur de date';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_currentUser == null) {
      return _buildErrorScreen('Utilisateur non connecté');
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Rapports Mensuels',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: mainColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.insights, color: Colors.white),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Statistiques à venir !')),
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: _buildRapportsList(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddRapportScreen()),
          );
          if (result == true) {
            _refreshData();
          }
        },
        icon: const Icon(Icons.add_box, color: Colors.white, size: 40),
        label: const Text("Nouveau Rapport",
            style: TextStyle(color: Colors.white)),
        backgroundColor: mainColor,
        elevation: 4,
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      decoration: BoxDecoration(
        color: mainColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Suivi des rapports',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('rapports')
                .where('userId',
                    isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text(
                  'Erreur de chargement',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                );
              }

              final count = snapshot.data?.docs.length ?? 0;
              return Text(
                '$count rapports soumis',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontSize: 16,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> _showDeleteConfirmation(
      String rapportId, DateTime periode) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text('Confirmer la suppression'),
          content: Text(
            'Êtes-vous sûr de vouloir supprimer le rapport de ${DateFormat('MMMM yyyy', 'fr_FR').format(periode)} ?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () async {
                try {
                  Navigator.of(context).pop();
                  await _firestore
                      .collection('rapports')
                      .doc(rapportId)
                      .delete();

                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Rapport supprimé avec succès'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } catch (e) {
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Erreur lors de la suppression: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.error,
              ),
              child: const Text('Supprimer'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildRapportsList() {
    return StreamBuilder<QuerySnapshot>(
      stream: _getRapportsStream(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print('StreamBuilder Error: ${snapshot.error}');
          return _buildErrorState(context);
        }

        if (snapshot.connectionState == ConnectionState.waiting && _isLoading) {
          return _buildLoadingState();
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return _buildEmptyState();
        }

        return LayoutBuilder(
          builder: (context, constraints) {
            return ListView.builder(
              padding: EdgeInsets.symmetric(
                horizontal: constraints.maxWidth > 600
                    ? (constraints.maxWidth - 600) / 2
                    : 16,
                vertical: 16,
              ),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                try {
                  final rapport = snapshot.data!.docs[index];
                  final data = rapport.data() as Map<String, dynamic>;
                  final periode = (data['periode'] as Timestamp).toDate();

                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ExpansionTile(
                      key: ValueKey(rapport.id),
                      title: Text(
                        'Rapport de ${_formatTimestamp(data['periode'])}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 14,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Soumis le ${_formatTimestamp(data['dateSubmission'])}',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                      leading: CircleAvatar(
                        backgroundColor:
                            Theme.of(context).colorScheme.primaryContainer,
                        child: Icon(
                          Icons.description,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.delete,
                              color: Theme.of(context).colorScheme.error,
                            ),
                            onPressed: () => _showDeleteConfirmation(
                              rapport.id,
                              periode,
                            ),
                          ),
                          const Icon(Icons.expand_more),
                        ],
                      ),
                      children: [
                        _buildRapportDetails(data),
                      ],
                    ),
                  );
                } catch (e) {
                  print('Erreur de rendu du rapport: $e');
                  return ListTile(
                    title: Text('Erreur d\'affichage du rapport: $e'),
                    tileColor: Colors.red.withOpacity(0.1),
                  );
                }
              },
            );
          },
        );
      },
    );
  }

  Widget _buildRapportDetails(Map<String, dynamic> data) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.1),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailSection(
              'Structure d\'accueil', data['structure'] ?? '', Icons.business),
          _buildDetailSection(
              'Supérieur', data['superieur'] ?? '', Icons.person),
          _buildDetailSection(
              'Zone d\'intervention', data['zone'] ?? '', Icons.location_on),
          _buildDetailSection(
              'Activités réalisées', data['activites'] ?? '', Icons.work),
          _buildDetailSection(
              'Résultats', data['resultats'] ?? '', Icons.assessment),
          _buildDetailSection(
              'Difficultés', data['difficultes'] ?? '', Icons.warning),
          if (data['commentaires'] != null &&
              data['commentaires'].toString().isNotEmpty)
            _buildDetailSection(
                'Commentaires', data['commentaires'], Icons.comment),
          if (data['meetings'] != null && (data['meetings'] as List).isNotEmpty)
            _buildMeetingsSection(data['meetings'] as List),
        ],
      ),
    );
  }

  Widget _buildDetailSection(String title, String content, IconData icon) {
    if (content.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: mainColor),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(content),
        ],
      ),
    );
  }

  Widget _buildMeetingsSection(List meetings) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.groups, size: 20, color: mainColor),
            const SizedBox(width: 8),
            Text(
              'Réunions',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...meetings.map(
            (meeting) => _buildMeetingItem(meeting as Map<String, dynamic>)),
      ],
    );
  }

  Widget _buildMeetingItem(Map<String, dynamic> meeting) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Date: ${_formatTimestamp(meeting['date'])}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text('Objet: ${meeting['object']}'),
            Text('Lieu: ${meeting['location']}'),
            if (meeting['comment'] != null &&
                meeting['comment'].toString().isNotEmpty)
              Text('Commentaire: ${meeting['comment']}'),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingScreen() {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(color: mainColor),
      ),
    );
  }

  Widget _buildErrorScreen(String error) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(error),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => setState(() => _error = null),
              child: const Text('Réessayer'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            const Text(
              'Une erreur est survenue lors du chargement',
              textAlign: TextAlign.center,
            ),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  _error!,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _refreshData,
              child: const Text('Réessayer'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Chargement des rapports...'),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.description_outlined,
              size: 64,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Aucun rapport mensuel',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Commencez par soumettre votre premier rapport mensuel',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
