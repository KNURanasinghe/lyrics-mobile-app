import 'package:flutter/material.dart';
import 'package:lyrics/Service/language_service.dart';
import 'package:lyrics/Service/lyrics_service.dart';
import 'package:lyrics/Service/setting_service.dart';
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
  String selectedLyricsFormat = 'tamil_only';
  Map<String, String> multiLanguageLyrics = {};
  final SongService _songService = SongService();
  bool isLoadingLyrics = false;

  List<String> _currentDisplayOrder = [];

  // Font settings
  double baseFontSize = 18.0;
  bool isBoldText = false;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
    _reloadFontSettings();
  }

  Future<void> _initializePlayer() async {
    // Get saved lyrics format preference
    final lyricsFormat = await HowToReadLyricsService.getLyricsFormat();
    final fontSize = await FontSettingsService.getFontSize();
    final boldText = await FontSettingsService.getBoldText();

    setState(() {
      selectedLyricsFormat = lyricsFormat;
      baseFontSize = fontSize;
      isBoldText = boldText;
      isLoadingLyrics = true;
    });

    await _loadLyricsForCurrentFormat();

    setState(() {
      isLoadingLyrics = false;
    });
  }

  Future<void> _loadLyricsForCurrentFormat() async {
    try {
      print('Loading lyrics for format: $selectedLyricsFormat');

      final result = await _songService.getSongLyricsByFormat(
        widget.song,
        selectedLyricsFormat,
      );

      print('Full result: $result'); // Debug print

      if (result['success'] == true) {
        final lyricsData = result['lyrics'];
        final displayOrderData = result['displayOrder'];

        if (lyricsData == null) {
          print('Lyrics data is null');
          setState(() {
            multiLanguageLyrics.clear();
            multiLanguageLyrics['error'] = 'No lyrics data received';
          });
          return;
        }

        final lyricsMap =
            lyricsData is Map<String, dynamic>
                ? lyricsData
                : <String, dynamic>{};

        final displayOrder =
            displayOrderData is List
                ? displayOrderData.cast<String>()
                : <String>[];

        print('Received lyrics for languages: ${lyricsMap.keys.toList()}');
        print('Display order: $displayOrder');

        // Clear existing lyrics
        multiLanguageLyrics.clear();

        // Populate lyrics from API response in the correct order
        for (String languageCode in displayOrder) {
          if (lyricsMap.containsKey(languageCode) &&
              lyricsMap[languageCode] != null &&
              lyricsMap[languageCode].toString().trim().isNotEmpty) {
            multiLanguageLyrics[languageCode] =
                lyricsMap[languageCode].toString();
            print('Added lyrics for language: $languageCode');
          }
        }

        // If no lyrics were added from display order, try all available lyrics
        if (multiLanguageLyrics.isEmpty) {
          lyricsMap.forEach((key, value) {
            if (value != null && value.toString().trim().isNotEmpty) {
              multiLanguageLyrics[key] = value.toString();
              displayOrder.add(key);
            }
          });
        }

        // Store display order for UI
        _currentDisplayOrder = displayOrder;

        setState(() {});

        print('Final lyrics map: ${multiLanguageLyrics.keys.toList()}');

        if (multiLanguageLyrics.isEmpty) {
          setState(() {
            multiLanguageLyrics['error'] =
                'No lyrics available for this format';
          });
        }
      } else {
        print('API returned failure: ${result['message']}');
        // Handle error - set fallback message
        setState(() {
          multiLanguageLyrics.clear();
          multiLanguageLyrics['error'] =
              result['message'] ?? 'Lyrics not available for this format';
        });
      }
    } catch (e, stackTrace) {
      print('Exception in _loadLyricsForCurrentFormat: $e');
      print('Stack trace: $stackTrace');
      setState(() {
        multiLanguageLyrics.clear();
        multiLanguageLyrics['error'] = 'Failed to load lyrics: ${e.toString()}';
      });
    }
  }

  Widget _buildLyricsContent() {
    // Check if there's an error
    if (multiLanguageLyrics.containsKey('error')) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.red.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 32),
            const SizedBox(height: 12),
            Text(
              multiLanguageLyrics['error']!,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () async {
                setState(() {
                  isLoadingLyrics = true;
                });
                await _loadLyricsForCurrentFormat();
                setState(() {
                  isLoadingLyrics = false;
                });
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.withOpacity(0.2),
                foregroundColor: Colors.red,
              ),
            ),
          ],
        ),
      );
    }

    // Use the display order from API response, fallback to service order
    final displayOrder =
        _currentDisplayOrder.isNotEmpty
            ? _currentDisplayOrder
            : HowToReadLyricsService.getLanguageDisplayOrder(
              selectedLyricsFormat,
            );

    if (HowToReadLyricsService.isMultiLanguageFormat(selectedLyricsFormat)) {
      // Multi-language format - show only languages that have lyrics
      final availableLyrics =
          displayOrder
              .where(
                (languageCode) =>
                    multiLanguageLyrics.containsKey(languageCode) &&
                    multiLanguageLyrics[languageCode] != null &&
                    multiLanguageLyrics[languageCode]!.isNotEmpty,
              )
              .toList();

      if (availableLyrics.isEmpty) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.orange.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.orange.withOpacity(0.3)),
          ),
          child: Column(
            children: [
              const Icon(Icons.warning_amber, color: Colors.orange, size: 32),
              const SizedBox(height: 12),
              Text(
                'No lyrics available for ${HowToReadLyricsService.getFormatTitle(selectedLyricsFormat)} format',
                style: const TextStyle(
                  color: Colors.orange,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:
            availableLyrics.map((languageCode) {
              final languageName =
                  HowToReadLyricsService.getLanguageDisplayName(languageCode);
              final lyrics = multiLanguageLyrics[languageCode]!;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Language header with improved styling
                  // Container(
                  //   margin: const EdgeInsets.only(bottom: 12),
                  //   padding: const EdgeInsets.symmetric(
                  //     horizontal: 12,
                  //     vertical: 8,
                  //   ),
                  //   decoration: BoxDecoration(
                  //     gradient: LinearGradient(
                  //       colors: [
                  //         Colors.white.withOpacity(0.2),
                  //         Colors.white.withOpacity(0.1),
                  //       ],
                  //     ),
                  //     borderRadius: BorderRadius.circular(20),
                  //     border: Border.all(color: Colors.white.withOpacity(0.3)),
                  //   ),
                  //   child: Row(
                  //     mainAxisSize: MainAxisSize.min,
                  //     children: [
                  //       Icon(
                  //         _getLanguageIcon(languageCode),
                  //         size: 16,
                  //         color: Colors.white,
                  //       ),
                  //       const SizedBox(width: 8),
                  //       Text(
                  //         languageName,
                  //         style: const TextStyle(
                  //           color: Colors.white,
                  //           fontSize: 14,
                  //           fontWeight: FontWeight.w600,
                  //           letterSpacing: 0.5,
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  SizedBox(height: 5),

                  // Lyrics content with improved styling
                  Text(
                    lyrics,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.95),
                      fontSize: FontSettingsService.getAdjustedFontSize(
                        baseFontSize,
                        languageCode,
                      ),
                      height: _getLineHeightForLanguage(languageCode),
                      fontWeight:
                          isBoldText ? FontWeight.bold : FontWeight.w400,
                      letterSpacing: 0.2,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ],
              );
            }).toList(),
      );
    } else {
      // Single language format
      final languageCode = displayOrder.first;
      final lyrics = multiLanguageLyrics[languageCode];

      if (lyrics == null || lyrics.isEmpty) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.orange.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.orange.withOpacity(0.3)),
          ),
          child: Column(
            children: [
              const Icon(Icons.warning_amber, color: Colors.orange, size: 32),
              const SizedBox(height: 12),
              Text(
                'Lyrics not available in ${HowToReadLyricsService.getLanguageDisplayName(languageCode)}',
                style: const TextStyle(
                  color: Colors.orange,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      }

      return Text(
        lyrics,
        style: TextStyle(
          color: Colors.white.withOpacity(0.9),
          fontSize: FontSettingsService.getAdjustedFontSize(
            baseFontSize,
            languageCode,
          ),
          height: _getLineHeightForLanguage(languageCode),
          fontWeight: isBoldText ? FontWeight.bold : FontWeight.w400,
          letterSpacing: 0.2,
        ),
        textAlign: TextAlign.left,
      );
    }
  }

  Future<void> _reloadFontSettings() async {
    final fontSize = await FontSettingsService.getFontSize();
    final boldText = await FontSettingsService.getBoldText();

    setState(() {
      baseFontSize = fontSize;
      isBoldText = boldText;
    });
  }

  IconData _getLanguageIcon(String languageCode) {
    switch (languageCode) {
      case 'ta':
        return Icons.translate;
      case 'si':
        return Icons.language;
      case 'en':
        return Icons.abc;
      default:
        return Icons.text_fields;
    }
  }

  double _getFontSizeForLanguage(String languageCode) {
    switch (languageCode) {
      case 'ta':
        return 20; // Larger for Tamil script
      case 'si':
        return 19; // Medium for Sinhala script
      case 'en':
        return 18; // Standard for English
      default:
        return 18;
    }
  }

  double _getLineHeightForLanguage(String languageCode) {
    switch (languageCode) {
      case 'ta':
        return 2.2; // More spacing for Tamil script readability
      case 'si':
        return 2.1; // Slightly more for Sinhala script
      case 'en':
        return 2.0; // Standard for English
      default:
        return 2.0;
    }
  }

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

  Future<void> _changeLyricsFormat() async {
    final newFormat = await showDialog<String>(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: const Color(0xFF2A2A2A),
            title: const Text(
              'How would you like to read lyrics?',
              style: TextStyle(color: Colors.white),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children:
                  [
                    'tamil_only',
                    'tamil_english',
                    'tamil_sinhala',
                    'all_three',
                    'english_only',
                    'sinhala_only',
                  ].map((format) {
                    return ListTile(
                      title: Text(
                        HowToReadLyricsService.getFormatTitle(format),
                        style: const TextStyle(color: Colors.white),
                      ),
                      leading: Radio<String>(
                        value: format,
                        groupValue: selectedLyricsFormat,
                        onChanged: (value) => Navigator.pop(context, value),
                        activeColor: Colors.white,
                      ),
                    );
                  }).toList(),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.white70),
                ),
              ),
            ],
          ),
    );

    if (newFormat != null && newFormat != selectedLyricsFormat) {
      // Save preference
      await HowToReadLyricsService.saveLyricsFormat(newFormat);

      setState(() {
        selectedLyricsFormat = newFormat;
        isLoadingLyrics = true;
      });

      await _loadLyricsForCurrentFormat();

      setState(() {
        isLoadingLyrics = false;
      });
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
                  const Color(0xFF173857).withOpacity(0.9),
                  const Color(0xFF000000).withOpacity(0.9),
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
                      // Lyrics format selector button
                      IconButton(
                        icon: const Icon(
                          Icons.format_list_bulleted,
                          color: Colors.white,
                          size: 20,
                        ),
                        onPressed: _changeLyricsFormat,
                      ),
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

                // Format indicator
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
                      Icon(
                        Icons.format_list_bulleted,
                        color: Colors.white70,
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        HowToReadLyricsService.getFormatTitle(
                          selectedLyricsFormat,
                        ),
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

                //const SizedBox(height: 20),

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
          // Row(
          //   children: [
          //     const Icon(Icons.lyrics, color: Colors.white, size: 24),
          //     const SizedBox(width: 8),
          //     Text(
          //       'Lyrics - ${HowToReadLyricsService.getFormatTitle(selectedLyricsFormat)}',
          //       style: const TextStyle(
          //         color: Colors.white,
          //         fontSize: 18,
          //         fontWeight: FontWeight.bold,
          //       ),
          //     ),
          //   ],
          // ),
          //const SizedBox(height: 20),

          // Lyrics content based on selected format
          _buildLyricsContent(),

          //const SizedBox(height: 20),
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
          _buildInfoCard(
            'Reading Format',
            HowToReadLyricsService.getFormatTitle(selectedLyricsFormat),
          ),

          if (multiLanguageLyrics.isNotEmpty) ...[
            const SizedBox(height: 16),
            _buildInfoCard(
              'Available Languages',
              multiLanguageLyrics.keys
                  .map(
                    (code) =>
                        HowToReadLyricsService.getLanguageDisplayName(code),
                  )
                  .join(', '),
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
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _changeLyricsFormat,
                  icon: const Icon(Icons.format_list_bulleted),
                  label: const Text('Change Format'),
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
