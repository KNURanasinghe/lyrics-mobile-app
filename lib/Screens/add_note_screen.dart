import 'package:flutter/material.dart';

class AddNoteScreen extends StatefulWidget {
  const AddNoteScreen({super.key});

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final TextEditingController _noteController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isKeyboardVisible = false;

  @override
  void initState() {
    super.initState();
    // Auto focus the text field when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });

    // Listen to keyboard visibility
    _focusNode.addListener(() {
      setState(() {
        _isKeyboardVisible = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _noteController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _saveNote() {
    if (_noteController.text.trim().isNotEmpty) {
      // Here you would typically save the note to your database or state management
      Navigator.of(
        context,
      ).pop({'note': _noteController.text.trim(), 'date': DateTime.now()});
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
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
          TextButton(
            onPressed: _saveNote,
            child: Text(
              'Done',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.more_vert, color: Colors.white, size: 24),
            onPressed: () {
              _showMoreOptions();
            },
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
        child: Column(
          children: [
            // Main text area
            Expanded(
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(16),
                child: TextField(
                  controller: _noteController,
                  focusNode: _focusNode,
                  maxLines: null,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    height: 1.5,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Start typing your worship notes...',
                    hintStyle: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 16,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                  cursorColor: Colors.white,
                ),
              ),
            ),

            // Bottom toolbar when keyboard is visible
            if (_isKeyboardVisible)
              Container(
                height: 50,
                color: Color(0xFF2A4A6B),
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    // Text formatting options
                    IconButton(
                      icon: Icon(
                        Icons.format_bold,
                        color: Colors.white.withOpacity(0.7),
                        size: 20,
                      ),
                      onPressed: () {
                        // Add bold formatting
                        _insertFormatting('**', '**');
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.format_italic,
                        color: Colors.white.withOpacity(0.7),
                        size: 20,
                      ),
                      onPressed: () {
                        // Add italic formatting
                        _insertFormatting('*', '*');
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.format_list_bulleted,
                        color: Colors.white.withOpacity(0.7),
                        size: 20,
                      ),
                      onPressed: () {
                        // Add bullet point
                        _insertText('• ');
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.format_quote,
                        color: Colors.white.withOpacity(0.7),
                        size: 20,
                      ),
                      onPressed: () {
                        // Add quote
                        _insertText('"');
                      },
                    ),
                    Spacer(),
                    // Word count
                    Text(
                      '${_noteController.text.split(' ').where((word) => word.isNotEmpty).length} words',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _insertFormatting(String startTag, String endTag) {
    final text = _noteController.text;
    final selection = _noteController.selection;

    if (selection.isValid) {
      final newText = text.replaceRange(
        selection.start,
        selection.end,
        '$startTag${text.substring(selection.start, selection.end)}$endTag',
      );

      _noteController.value = TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(
          offset:
              selection.start +
              startTag.length +
              (selection.end - selection.start) +
              endTag.length,
        ),
      );
    }
  }

  void _insertText(String textToInsert) {
    final text = _noteController.text;
    final selection = _noteController.selection;

    final newText = text.replaceRange(
      selection.start,
      selection.end,
      textToInsert,
    );

    _noteController.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(
        offset: selection.start + textToInsert.length,
      ),
    );
  }

  void _showMoreOptions() {
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
            children: [
              ListTile(
                leading: Icon(Icons.share, color: Colors.white),
                title: Text(
                  'Share Note',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pop(context);
                  // Handle share
                },
              ),
              ListTile(
                leading: Icon(Icons.copy, color: Colors.white),
                title: Text(
                  'Copy to Clipboard',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pop(context);
                  // Handle copy
                },
              ),
              ListTile(
                leading: Icon(Icons.delete, color: Colors.red),
                title: Text('Delete Note', style: TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.pop(context);
                  _showDeleteConfirmation();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: Color(0xFF1E3A5F),
            title: Text('Delete Note', style: TextStyle(color: Colors.white)),
            content: Text(
              'Are you sure you want to delete this note? This action cannot be undone.',
              style: TextStyle(color: Colors.white.withOpacity(0.8)),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel', style: TextStyle(color: Colors.white)),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: Text('Delete', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
    );
  }
}
