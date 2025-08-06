import 'package:flutter/material.dart';
import 'package:lyrics/Screens/add_note_screen.dart';
import 'package:lyrics/Service/worship_note_service.dart'
    show WorshipNotesService;
import 'package:intl/intl.dart';

class WorshipNotesScreen extends StatefulWidget {
  const WorshipNotesScreen({super.key});

  @override
  State<WorshipNotesScreen> createState() => _WorshipNotesScreenState();
}

class _WorshipNotesScreenState extends State<WorshipNotesScreen> {
  final WorshipNotesService _notesService = WorshipNotesService();
  String selectedFilter = 'All';
  List<NoteItem> allNotes = [];
  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    _fetchNotes();
  }

  Future<void> _fetchNotes() async {
    setState(() {
      isLoading = true;
      hasError = false;
    });

    try {
      final result = await _notesService.getUserWorshipNotes();
      if (result['success']) {
        final notesData = result['notes'] as List<dynamic>;
        setState(() {
          allNotes =
              notesData.map((note) {
                return NoteItem(
                  id: note['id'].toString(),
                  title: note['note'] ?? 'No title',
                  date: DateTime.parse(note['created_at']),
                  content: note['note'],
                );
              }).toList();
        });
      } else {
        setState(() {
          hasError = true;
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(result['message'])));
      }
    } catch (e) {
      setState(() {
        hasError = true;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to load notes: $e')));
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  List<NoteItem> getFilteredNotes() {
    final now = DateTime.now();
    final sevenDaysAgo = now.subtract(Duration(days: 7));
    final thirtyDaysAgo = now.subtract(Duration(days: 30));

    if (selectedFilter == 'All') return allNotes;
    if (selectedFilter == 'Previous 7 Days') {
      return allNotes.where((note) => note.date.isAfter(sevenDaysAgo)).toList();
    }
    if (selectedFilter == 'Previous 30 Days') {
      return allNotes
          .where((note) => note.date.isAfter(thirtyDaysAgo))
          .toList();
    }
    return allNotes;
  }

  Map<String, List<NoteItem>> groupNotesByDate() {
    final filteredNotes = getFilteredNotes();
    final Map<String, List<NoteItem>> grouped = {};
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(Duration(days: 1));

    for (final note in filteredNotes) {
      final noteDate = DateTime(note.date.year, note.date.month, note.date.day);
      String category;

      if (noteDate == today) {
        category = 'Today';
      } else if (noteDate == yesterday) {
        category = 'Yesterday';
      } else if (noteDate.isAfter(now.subtract(Duration(days: 7)))) {
        category = 'Previous 7 Days';
      } else if (noteDate.isAfter(now.subtract(Duration(days: 30)))) {
        category = 'Previous 30 Days';
      } else {
        category = DateFormat('MMMM yyyy').format(noteDate);
      }

      if (!grouped.containsKey(category)) {
        grouped[category] = [];
      }
      grouped[category]!.add(note);
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
              ...['All', 'Previous 7 Days', 'Previous 30 Days'].map(
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
    final groupedNotes = groupNotesByDate();

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
            icon: Icon(Icons.add, color: Colors.white, size: 24),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddNoteScreen()),
              );
              if (result != null && result['success']) {
                _fetchNotes(); // Refresh the list after adding a new note
              }
            },
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
        child:
            isLoading
                ? Center(child: CircularProgressIndicator(color: Colors.white))
                : hasError
                ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Failed to load notes',
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _fetchNotes,
                        child: Text('Retry'),
                      ),
                    ],
                  ),
                )
                : allNotes.isEmpty
                ? Center(
                  child: Text(
                    'No notes found',
                    style: TextStyle(color: Colors.white),
                  ),
                )
                : RefreshIndicator(
                  onRefresh: _fetchNotes,
                  color: Colors.white,
                  backgroundColor: Color(0xFF1E3A5F),
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
                                top:
                                    category == groupedNotes.keys.first
                                        ? 0
                                        : 24,
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
                              (note) => GestureDetector(
                                onTap: () async {
                                  final result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => AddNoteScreen(
                                            existingNoteId: note.id,
                                            existingNoteContent: note.content,
                                          ),
                                    ),
                                  );
                                  if (result != null && result['success']) {
                                    _fetchNotes(); // Refresh after editing
                                  }
                                },
                                child: Container(
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
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              note.title.length > 50
                                                  ? '${note.title.substring(0, 50)}...'
                                                  : note.title,
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
                                                color: Colors.white.withOpacity(
                                                  0.7,
                                                ),
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
                            ),
                          ],
                        );
                      }),
                    ],
                  ),
                ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    final hour = date.hour % 12;
    final period = date.hour < 12 ? 'AM' : 'PM';

    return '${months[date.month - 1]} ${date.day}, ${date.year} • '
        '${hour == 0 ? 12 : hour}:${date.minute.toString().padLeft(2, '0')} $period';
  }
}

class NoteItem {
  final String id;
  final String title;
  final DateTime date;
  final String content;

  NoteItem({
    required this.id,
    required this.title,
    required this.date,
    required this.content,
  });
}
