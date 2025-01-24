import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:volontariat/app/utils/colors.dart';

class RapportScreen extends StatefulWidget {
  @override
  _RapportScreenState createState() => _RapportScreenState();
}

class _RapportScreenState extends State<RapportScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  List<String> _rapports = []; // Liste des rapports

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Rapports',
        ),
        titleTextStyle: TextStyle(
            color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
        backgroundColor: mainColor,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            color: Colors.blue.shade100,
            child: TableCalendar(
              firstDay: DateTime.utc(2000, 1, 1),
              lastDay: DateTime.utc(2100, 12, 31),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                  _fetchRapportsForSelectedDay();
                });
              },
              calendarStyle: CalendarStyle(
                isTodayHighlighted: true,
                selectedDecoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
                todayDecoration: BoxDecoration(
                  color: Colors.orange,
                  shape: BoxShape.circle,
                ),
              ),
              headerStyle: HeaderStyle(
                formatButtonVisible: false, // Cache le bouton de format
                titleCentered: true,
              ),
            ),
          ),
          if (_selectedDay != null)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Date sélectionnée : ${_selectedDay!.toLocal()}'.split(' ')[0],
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          Expanded(
            child: _rapports.isEmpty
                ? Center(
                    child: Text(
                      'Aucun rapport disponible.',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: _rapports.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          leading: Icon(Icons.description, color: mainColor),
                          title: Text(_rapports[index]),
                          trailing: Icon(Icons.arrow_forward_ios, size: 16),
                          onTap: () {
                            // Logique pour voir les détails du rapport
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addRapport();
        },
        backgroundColor: mainColor,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  void _addRapport() {
    if (_selectedDay == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Veuillez sélectionner une date.')),
      );
      return;
    }

    setState(() {
      _rapports.add('Rapport pour ${_selectedDay!.toLocal()}'.split(' ')[0]);
    });
  }

  void _fetchRapportsForSelectedDay() {
    // Logique pour récupérer les rapports en fonction de la date sélectionnée
    // Exemple : _rapports = getRapportsForDate(_selectedDay);
    // Remplacez ceci par votre logique de récupération des rapports
    setState(() {
      _rapports = ['Rapport 1', 'Rapport 2']; // Exemple de données
    });
  }
}
