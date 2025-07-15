import 'package:flutter/material.dart';

class WorshipNotesScreen extends StatefulWidget {
  const WorshipNotesScreen({super.key});

  @override
  State<WorshipNotesScreen> createState() => _WorshipNotesScreenState();
}

class _WorshipNotesScreenState extends State<WorshipNotesScreen> {
  String selectedFilter = 'All';

  // Sample data
  final List<NoteItem> allNotes = [
    NoteItem(
      title: 'New Note',
      date: DateTime.now().subtract(Duration(days: 1)),
      category: 'Previous 7 Days',
    ),
    NoteItem(
      title: 'New Note',
      date: DateTime.parse('2025-06-28'),
      category: 'Previous 30 Days',
    ),
    NoteItem(
      title: 'New Note',
      date: DateTime.parse('2025-06-20'),
      category: 'Previous 30 Days',
    ),
    NoteItem(
      title: 'New Note',
      date: DateTime.parse('2025-06-08'),
      category: 'Previous 30 Days',
    ),
    NoteItem(
      title: 'New Note',
      date: DateTime.parse('2025-05-28'),
      category: 'May',
    ),
    NoteItem(
      title: 'New Note',
      date: DateTime.parse('2025-05-20'),
      category: 'May',
    ),
    NoteItem(
      title: 'New Note',
      date: DateTime.parse('2025-05-08'),
      category: 'May',
    ),
    NoteItem(
      title: 'New Note',
      date: DateTime.parse('2025-05-05'),
      category: 'May',
    ),
    NoteItem(
      title: 'New Note',
      date: DateTime.parse('2025-04-28'),
      category: 'April',
    ),
  ];

  List<NoteItem> getFilteredNotes() {
    if (selectedFilter == 'All') return allNotes;
    return allNotes.where((note) => note.category == selectedFilter).toList();
  }

  Map<String, List<NoteItem>> groupNotesByCategory() {
    final filteredNotes = getFilteredNotes();
    final Map<String, List<NoteItem>> grouped = {};

    for (final note in filteredNotes) {
      if (!grouped.containsKey(note.category)) {
        grouped[note.category] = [];
      }
      grouped[note.category]!.add(note);
    }

    return grouped;
  }

  void _showFilterMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Color(0xFF1E3A5F),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Filter by',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 20),
              ...[
                'All',
                'Previous 7 Days',
                'Previous 30 Days',
                'May',
                'April',
              ].map(
                (filter) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    filter,
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  trailing:
                      selectedFilter == filter
                          ? Icon(Icons.check, color: Colors.white)
                          : null,
                  onTap: () {
                    setState(() {
                      selectedFilter = filter;
                    });
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final groupedNotes = groupNotesByCategory();

    return Scaffold(
      backgroundColor: Color(0xFF1E3A5F),
      appBar: AppBar(
        backgroundColor: Color(0xFF1E3A5F),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Worship Notes',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.open_in_new, color: Colors.red, size: 24),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.more_vert, color: Colors.white, size: 24),
            onPressed: _showFilterMenu,
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1E3A5F), Color(0xFF0F1B2E)],
          ),
        ),
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            ...groupedNotes.entries.map((entry) {
              final category = entry.key;
              final notes = entry.value;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category Header
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: 12,
                      top: category == groupedNotes.keys.first ? 0 : 24,
                    ),
                    child: Text(
                      category,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  // Notes in this category
                  ...notes.map(
                    (note) => Container(
                      margin: EdgeInsets.only(bottom: 8),
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.1),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  note.title,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  _formatDate(note.date),
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.7),
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white.withOpacity(0.5),
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     // Handle add new note
      //   },
      //   backgroundColor: Color(0xFF4A90E2),
      //   child: Icon(Icons.add, color: Colors.white),
      // ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(Duration(days: 1));
    final noteDate = DateTime(date.year, date.month, date.day);

    if (noteDate == today) {
      return 'Today';
    } else if (noteDate == yesterday) {
      return 'Yesterday';
    } else {
      return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    }
  }
}

class NoteItem {
  final String title;
  final DateTime date;
  final String category;

  NoteItem({required this.title, required this.date, required this.category});
}
