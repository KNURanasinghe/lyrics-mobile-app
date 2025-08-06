import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lyrics/Service/worship_note_service.dart';

class AddNoteScreen extends StatefulWidget {
  final String? existingNoteId;
  final String? existingNoteContent;

  const AddNoteScreen({
    super.key,
    this.existingNoteId,
    this.existingNoteContent,
  });

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final TextEditingController _noteController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isKeyboardVisible = false;
  bool _isSaving = false;
  final WorshipNotesService _notesService = WorshipNotesService();

  @override
  void initState() {
    super.initState();

    // Initialize with existing note content if editing
    if (widget.existingNoteContent != null) {
      _noteController.text = widget.existingNoteContent!;
    }

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

  Future<void> _saveNote() async {
    if (_noteController.text.trim().isEmpty) {
      Navigator.of(context).pop();
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      if (widget.existingNoteId != null) {
        // Update existing note
        final result = await _notesService.updateWorshipNote(
          noteId: widget.existingNoteId!,
          note: _noteController.text.trim(),
        );

        if (result['success']) {
          Navigator.of(context).pop({'success': true, 'isUpdate': true});
        } else {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(result['message'])));
        }
      } else {
        // Create new note
        final result = await _notesService.createWorshipNote(
          _noteController.text.trim(),
        );

        if (result['success']) {
          Navigator.of(context).pop({'success': true, 'isUpdate': false});
        } else {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(result['message'])));
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('An error occurred: $e')));
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  Future<void> _deleteNote() async {
    if (widget.existingNoteId == null) {
      Navigator.of(context).pop();
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final result = await _notesService.deleteWorshipNote(
        widget.existingNoteId!,
      );

      if (result['success']) {
        Navigator.of(context).pop({'success': true, 'deleted': true});
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(result['message'])));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('An error occurred: $e')));
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
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
          widget.existingNoteId != null ? 'Edit Note' : 'New Note',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          if (_isSaving)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                ),
              ),
            )
          else
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
                        _insertText('"');
                      },
                    ),
                    Spacer(),
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
                  Clipboard.setData(ClipboardData(text: _noteController.text));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Note copied to clipboard')),
                  );
                },
              ),
              if (widget.existingNoteId != null)
                ListTile(
                  leading: Icon(Icons.delete, color: Colors.red),
                  title: Text(
                    'Delete Note',
                    style: TextStyle(color: Colors.red),
                  ),
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
                  _deleteNote();
                },
                child: Text('Delete', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
    );
  }
}
