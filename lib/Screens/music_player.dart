import 'package:flutter/material.dart';
import 'package:lyrics/Service/language_service.dart';
import 'package:lyrics/Service/song_service.dart';

class MusicPlayer extends StatefulWidget {
  final String backgroundImage;
  final String song;
  final String artist;
  final String? lyrics;
  final String? language;

  const MusicPlayer({
    super.key,
    required this.backgroundImage,
    required this.song,
    required this.artist,
    this.lyrics,
    this.language,
  });

  @override
  State<MusicPlayer> createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer> {
  bool isPlaying = false;
  bool isFavorite = false;
  bool showLyrics = true;
  String selectedLanguage = 'English';
  Map<String, String> multiLanguageLyrics = {};
  final SongService _songService = SongService();
  bool isLoadingLyrics = false;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    final language = await LanguageService.getLanguage();
    if (widget.lyrics != null) {
      multiLanguageLyrics[widget.language ?? 'English'] = widget.lyrics!;
    }

    setState(() {
      selectedLanguage = language;
      isLoadingLyrics = !multiLanguageLyrics.containsKey(language);
    });

    await _loadLyricsForCurrentLanguage();

    setState(() {
      isLoadingLyrics = false;
    });
  }

  Future<void> _loadLyricsForCurrentLanguage() async {
    if (multiLanguageLyrics.containsKey(selectedLanguage)) {
      return; // Already have lyrics for this language
    }

    try {
      final result = await _songService.getSongLyrics(
        widget.song,
        LanguageService.getLanguageCode(selectedLanguage),
      );

      if (result['success'] && result['lyrics'] != null) {
        setState(() {
          multiLanguageLyrics[selectedLanguage] = result['lyrics'];
        });
      }
    } catch (e) {
      // Optionally show error to user
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to load lyrics: $e')));
    }
  }

  String _getCurrentLyrics() {
    if (multiLanguageLyrics.containsKey(selectedLanguage)) {
      return multiLanguageLyrics[selectedLanguage]!;
    }

    // Fallback to any available lyrics
    if (multiLanguageLyrics.isNotEmpty) {
      return multiLanguageLyrics.values.first;
    }

    // Default fallback lyrics
    return _getDefaultLyrics();
  }

  String _getDefaultLyrics() {
    return '''
    Lyrics not available in $selectedLanguage.

    Please check back later or try a different language.
    
    You can change the language using the language button in the top right corner.
    ''';
  }

  // Future<void> _changeLanguage() async {
  //   final newLanguage = await showDialog<String>(
  //     context: context,
  //     builder:
  //         (context) => AlertDialog(
  //           backgroundColor: const Color(0xFF2A2A2A),
  //           title: const Text(
  //             'Select Language for Lyrics',
  //             style: TextStyle(color: Colors.white),
  //           ),
  //           content: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children:
  //                 ['Sinhala', 'English', 'Tamil'].map((language) {
  //                   return ListTile(
  //                     title: Text(
  //                       language,
  //                       style: const TextStyle(color: Colors.white),
  //                     ),
  //                     subtitle: Text(
  //                       multiLanguageLyrics.containsKey(language)
  //                           ? 'Lyrics available'
  //                           : 'Will try to load',
  //                       style: TextStyle(
  //                         color:
  //                             multiLanguageLyrics.containsKey(language)
  //                                 ? Colors.green
  //                                 : Colors.orange,
  //                         fontSize: 12,
  //                       ),
  //                     ),
  //                     leading: Radio<String>(
  //                       value: language,
  //                       groupValue: selectedLanguage,
  //                       onChanged: (value) => Navigator.pop(context, value),
  //                       activeColor: Colors.white,
  //                     ),
  //                   );
  //                 }).toList(),
  //           ),
  //           actions: [
  //             TextButton(
  //               onPressed: () => Navigator.pop(context),
  //               child: const Text(
  //                 'Cancel',
  //                 style: TextStyle(color: Colors.white70),
  //               ),
  //             ),
  //           ],
  //         ),
  //   );

  //   if (newLanguage != null && newLanguage != selectedLanguage) {
  //     setState(() {
  //       selectedLanguage = newLanguage;
  //       isLoadingLyrics = !multiLanguageLyrics.containsKey(newLanguage);
  //     });

  //     await LanguageService.saveLanguage(newLanguage);
  //     await _loadLyricsForCurrentLanguage();

  //     setState(() {
  //       isLoadingLyrics = false;
  //     });
  //   }
  // }

  Widget _buildImage() {
    final imageUrl = widget.backgroundImage;

    if (imageUrl.startsWith('http') || imageUrl.startsWith('https')) {
      return Image.network(
        imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Image.asset('assets/Rectangle 29.png', fit: BoxFit.cover);
        },
      );
    } else {
      return Image.asset(
        imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.grey,
            child: const Icon(Icons.music_note, color: Colors.white, size: 50),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF272727),
      bottomNavigationBar: Container(
        height: 80,
        color: const Color(0xFF272727),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Left side - Song info and favorite
            Expanded(
              child: Row(
                children: [
                  // Album cover
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: _buildImage(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Song info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.song,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.artist,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  // Favorite button
                  IconButton(
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.red : Colors.white,
                      size: 24,
                    ),
                    onPressed: () {
                      setState(() {
                        isFavorite = !isFavorite;
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image:
                  widget.backgroundImage.startsWith('http') ||
                          widget.backgroundImage.startsWith('https')
                      ? NetworkImage(widget.backgroundImage) as ImageProvider
                      : AssetImage(widget.backgroundImage),
              fit: BoxFit.fitHeight,
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFF173857).withOpacity(0.6),
                  const Color(0xFF000000).withOpacity(0.6),
                ],
              ),
            ),
            child: Column(
              children: [
                // Header with controls
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                          size: 20,
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      const Spacer(),
                      // Song title
                      Expanded(
                        flex: 3,
                        child: Text(
                          widget.song,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const Spacer(),
                      // Language selector button
                      // IconButton(
                      //   icon: const Icon(
                      //     Icons.language,
                      //     color: Colors.white,
                      //     size: 20,
                      //   ),
                      //   onPressed: _changeLanguage,
                      // ),
                      // Toggle lyrics/info button
                      IconButton(
                        icon: Icon(
                          showLyrics ? Icons.info : Icons.lyrics,
                          color: Colors.white,
                          size: 20,
                        ),
                        onPressed: () {
                          setState(() {
                            showLyrics = !showLyrics;
                          });
                        },
                      ),
                    ],
                  ),
                ),

                // Language indicator
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.language, color: Colors.white70, size: 16),
                      const SizedBox(width: 6),
                      Text(
                        selectedLanguage,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (isLoadingLyrics) ...[
                        const SizedBox(width: 8),
                        const SizedBox(
                          width: 12,
                          height: 12,
                          child: CircularProgressIndicator(
                            strokeWidth: 1.5,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white70,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Main content area
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24.0),
                    child:
                        showLyrics ? _buildLyricsView() : _buildSongInfoView(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLyricsView() {
    if (isLoadingLyrics) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
            SizedBox(height: 16),
            Text(
              'Loading lyrics...',
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Lyrics header
          Row(
            children: [
              const Icon(Icons.lyrics, color: Colors.white, size: 24),
              const SizedBox(width: 8),
              Text(
                'Lyrics in $selectedLanguage',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Lyrics content
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.white.withOpacity(0.1),
                width: 1,
              ),
            ),
            child: Text(
              _getCurrentLyrics(),
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 18,
                height: 2,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.left,
            ),
          ),

          const SizedBox(height: 20),

          // Language options for lyrics
          if (multiLanguageLyrics.length > 1) ...[
            const Text(
              'Available in:',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children:
                  multiLanguageLyrics.keys.map((language) {
                    final isSelected = language == selectedLanguage;
                    return GestureDetector(
                      onTap: () async {
                        if (!isSelected) {
                          await LanguageService.saveLanguage(language);
                          setState(() {
                            selectedLanguage = language;
                          });
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color:
                              isSelected
                                  ? Colors.white.withOpacity(0.2)
                                  : Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color:
                                isSelected
                                    ? Colors.white.withOpacity(0.5)
                                    : Colors.white.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          language,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.white70,
                            fontSize: 12,
                            fontWeight:
                                isSelected ? FontWeight.w600 : FontWeight.w400,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSongInfoView() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Song info header
          Row(
            children: [
              const Icon(Icons.info_outline, color: Colors.white, size: 24),
              const SizedBox(width: 8),
              const Text(
                'Song Information',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Song details
          _buildInfoCard('Title', widget.song),
          const SizedBox(height: 16),
          _buildInfoCard('Artist', widget.artist),
          const SizedBox(height: 16),
          _buildInfoCard('Language', widget.language ?? selectedLanguage),

          if (multiLanguageLyrics.isNotEmpty) ...[
            const SizedBox(height: 16),
            _buildInfoCard(
              'Available Languages',
              multiLanguageLyrics.keys.join(', '),
            ),
          ],

          const SizedBox(height: 32),

          // Action buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      showLyrics = true;
                    });
                  },
                  icon: const Icon(Icons.lyrics),
                  label: const Text('View Lyrics'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.1),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(color: Colors.white.withOpacity(0.3)),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Expanded(
              //   child: ElevatedButton.icon(
              //     onPressed: _changeLanguage,
              //     icon: const Icon(Icons.language),
              //     label: const Text('Change Language'),
              //     style: ElevatedButton.styleFrom(
              //       backgroundColor: Colors.white.withOpacity(0.1),
              //       foregroundColor: Colors.white,
              //       padding: const EdgeInsets.symmetric(vertical: 12),
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(8),
              //         side: BorderSide(color: Colors.white.withOpacity(0.3)),
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, String value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _songService.dispose();
    super.dispose();
  }
}
