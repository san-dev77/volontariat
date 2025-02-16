import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:volontariat/app/utils/colors.dart';

class AddRapportScreen extends StatefulWidget {
  const AddRapportScreen({Key? key}) : super(key: key);

  @override
  State<AddRapportScreen> createState() => _AddRapportScreenState();
}

class _AddRapportScreenState extends State<AddRapportScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _structureController = TextEditingController();
  final TextEditingController _superieurController = TextEditingController();
  final TextEditingController _zoneController = TextEditingController();
  final TextEditingController _activitesController = TextEditingController();
  final TextEditingController _resultatsController = TextEditingController();
  final TextEditingController _difficultesController = TextEditingController();
  final TextEditingController _commentairesController = TextEditingController();

  DateTime? _selectedMonth;
  List<DateTime> _availableMonths = [];
  List<Meeting> _meetings = [];

  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _generateAvailableMonths();
  }

  void _generateAvailableMonths() {
    final now = DateTime.now();
    final currentMonth = DateTime(now.year, now.month, 1);
    _availableMonths = List.generate(12, (index) {
      return DateTime(currentMonth.year, currentMonth.month - index, 1);
    });
    _selectedMonth = _availableMonths.first;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Nouveau Rapport Mensuel',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: mainColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: mainColor,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(32),
                      bottomRight: Radius.circular(32),
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Rapport du mois',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (_selectedMonth != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            DateFormat('MMMM yyyy', 'fr_FR')
                                .format(_selectedMonth!),
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontSize: 16,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                LayoutBuilder(
                  builder: (context, constraints) {
                    return Container(
                      padding: const EdgeInsets.all(20),
                      constraints: BoxConstraints(
                        maxWidth: constraints.maxWidth > 600
                            ? 600
                            : constraints.maxWidth,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildTextField(
                            controller: _structureController,
                            label: 'Structure d\'accueil',
                            hint: 'Nom de votre structure d\'accueil',
                            icon: Icons.business,
                          ),
                          const SizedBox(height: 20),
                          _buildTextField(
                            controller: _superieurController,
                            label: 'Supérieur hiérarchique',
                            hint: 'Nom de votre supérieur',
                            icon: Icons.person,
                          ),
                          const SizedBox(height: 20),
                          _buildTextField(
                            controller: _zoneController,
                            label: 'Zone d\'intervention',
                            hint: 'Votre zone d\'intervention',
                            icon: Icons.location_on,
                          ),
                          const SizedBox(height: 20),
                          _buildMonthSelector(),
                          const SizedBox(height: 20),
                          _buildTextArea(
                            controller: _activitesController,
                            label: 'Activités réalisées',
                            hint:
                                'Décrivez les activités que vous avez réalisées ce mois-ci...',
                            icon: Icons.work,
                          ),
                          const SizedBox(height: 20),
                          _buildTextArea(
                            controller: _resultatsController,
                            label: 'Résultats concrets',
                            hint:
                                'Quels sont les résultats concrets de vos activités...',
                            icon: Icons.assessment,
                          ),
                          const SizedBox(height: 20),
                          _buildTextArea(
                            controller: _difficultesController,
                            label: 'Difficultés rencontrées',
                            hint: 'Décrivez les difficultés rencontrées...',
                            icon: Icons.warning,
                          ),
                          const SizedBox(height: 20),
                          _buildMeetingsSection(),
                          const SizedBox(height: 20),
                          _buildTextArea(
                            controller: _commentairesController,
                            label: 'Commentaires sur votre affectation',
                            hint:
                                'Veuillez préciser les commentaires relatifs à votre affectation au sein de votre structure d\'accueil...',
                            icon: Icons.comment,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: _isSubmitting
          ? const CircularProgressIndicator()
          : FloatingActionButton.extended(
              onPressed: _submitRapport,
              icon: const Icon(
                Icons.send,
                color: Colors.white,
              ),
              label: const Text(
                "Soumettre le rapport",
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: mainColor,
              elevation: 4,
            ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Icon(icon, color: mainColor),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: mainColor, width: 2),
          ),
          filled: true,
          fillColor: Colors.grey.shade50,
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Ce champ est requis';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildTextArea({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            maxLines: 5,
            decoration: InputDecoration(
              hintText: hint,
              prefixIcon: Icon(icon, color: mainColor),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: mainColor, width: 2),
              ),
              filled: true,
              fillColor: Colors.grey.shade50,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Ce champ est requis';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMonthSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Rapport du mois',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<DateTime>(
              isExpanded: true,
              value: _selectedMonth,
              icon: const Icon(Icons.arrow_drop_down),
              items: _availableMonths.map((DateTime month) {
                return DropdownMenuItem<DateTime>(
                  value: month,
                  child: Text(
                    DateFormat('MMMM yyyy', 'fr_FR').format(month),
                    style: const TextStyle(fontSize: 16),
                  ),
                );
              }).toList(),
              onChanged: (DateTime? newValue) {
                setState(() {
                  _selectedMonth = newValue;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMeetingsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Réunions du mois',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton.icon(
              onPressed: _showAddMeetingDialog,
              icon: Icon(Icons.add, color: mainColor),
              label: Text(
                'Ajouter une réunion',
                style: TextStyle(color: mainColor),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (_meetings.isEmpty)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Center(
              child: Text(
                'Aucune réunion ajoutée',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          )
        else
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: mainColor.withOpacity(0.1),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(9),
                      topRight: Radius.circular(9),
                    ),
                  ),
                  child: const Row(
                    children: [
                      Expanded(
                          flex: 2,
                          child: Text('Date',
                              style: TextStyle(fontWeight: FontWeight.bold))),
                      Expanded(
                          flex: 3,
                          child: Text('Objet',
                              style: TextStyle(fontWeight: FontWeight.bold))),
                      Expanded(
                          flex: 2,
                          child: Text('Lieu',
                              style: TextStyle(fontWeight: FontWeight.bold))),
                      Expanded(
                          flex: 3,
                          child: Text('Commentaire',
                              style: TextStyle(fontWeight: FontWeight.bold))),
                      SizedBox(width: 40),
                    ],
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: _meetings.length,
                  itemBuilder: (context, index) {
                    final meeting = _meetings[index];
                    return Container(
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(color: Colors.grey.shade300),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Text(DateFormat('dd/MM/yyyy')
                                  .format(meeting.date)),
                            ),
                            Expanded(
                              flex: 3,
                              child: Text(meeting.object),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(meeting.location),
                            ),
                            Expanded(
                              flex: 3,
                              child: Text(meeting.comment),
                            ),
                            SizedBox(
                              width: 40,
                              child: IconButton(
                                icon: Icon(Icons.delete,
                                    color: Colors.red, size: 20),
                                onPressed: () => _deleteMeeting(index),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
      ],
    );
  }

  void _showAddMeetingDialog() {
    final dateController = TextEditingController();
    final objectController = TextEditingController();
    final locationController = TextEditingController();
    final commentController = TextEditingController();
    DateTime? selectedDate;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ajouter une réunion'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (date != null) {
                    selectedDate = date;
                    dateController.text = DateFormat('dd/MM/yyyy').format(date);
                  }
                },
                child: TextFormField(
                  controller: dateController,
                  enabled: false,
                  decoration: InputDecoration(
                    labelText: 'Date',
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: objectController,
                decoration: InputDecoration(labelText: 'Objet de la réunion'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: locationController,
                decoration: InputDecoration(labelText: 'Lieu'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: commentController,
                decoration: InputDecoration(labelText: 'Commentaire'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              if (selectedDate != null &&
                  objectController.text.isNotEmpty &&
                  locationController.text.isNotEmpty) {
                setState(() {
                  _meetings.add(Meeting(
                    date: selectedDate!,
                    object: objectController.text,
                    location: locationController.text,
                    comment: commentController.text,
                  ));
                });
                Navigator.pop(context);
              }
            },
            child: Text('Ajouter'),
          ),
        ],
      ),
    );
  }

  void _deleteMeeting(int index) {
    setState(() {
      _meetings.removeAt(index);
    });
  }

  Future<void> _submitRapport() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez remplir tous les champs requis'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      setState(() {
        _isSubmitting = true;
      });

      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('Utilisateur non connecté');
      }

      // Création du document rapport
      final rapportData = {
        'userId': user.uid,
        'dateSubmission': Timestamp.now(),
        'periode': Timestamp.fromDate(_selectedMonth!),
        'structure': _structureController.text,
        'superieur': _superieurController.text,
        'zone': _zoneController.text,
        'activites': _activitesController.text,
        'resultats': _resultatsController.text,
        'difficultes': _difficultesController.text,
        'commentaires': _commentairesController.text,
        'meetings': _meetings.map((meeting) => meeting.toMap()).toList(),
        'status': 'submitted', // Pour un éventuel système de validation
      };

      // Vérification si un rapport existe déjà pour ce mois
      final existingRapports = await FirebaseFirestore.instance
          .collection('rapports')
          .where('userId', isEqualTo: user.uid)
          .where('periode', isEqualTo: Timestamp.fromDate(_selectedMonth!))
          .get();

      if (existingRapports.docs.isNotEmpty) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Un rapport existe déjà pour ce mois'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      // Ajout du rapport à Firestore
      await FirebaseFirestore.instance.collection('rapports').add(rapportData);

      if (!mounted) return;

      // Affichage du message de succès
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Rapport soumis avec succès'),
          backgroundColor: Colors.green,
        ),
      );

      // Retour à l'écran précédent
      Navigator.pop(context);
    } catch (e) {
      print('Erreur lors de la soumission du rapport: $e');
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors de la soumission: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _commentairesController.dispose();
    _structureController.dispose();
    _superieurController.dispose();
    _zoneController.dispose();
    _activitesController.dispose();
    _resultatsController.dispose();
    _difficultesController.dispose();
    super.dispose();
  }
}

class Meeting {
  final DateTime date;
  final String object;
  final String location;
  final String comment;

  Meeting({
    required this.date,
    required this.object,
    required this.location,
    required this.comment,
  });

  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'object': object,
      'location': location,
      'comment': comment,
    };
  }
}
