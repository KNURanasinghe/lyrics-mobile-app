import 'package:flutter/material.dart';
import 'package:lyrics/widgets/main_background.dart';

class LyricsFormat {
  final String title;
  final String value;

  LyricsFormat({required this.title, required this.value});
}

class HowToReadLyrics extends StatefulWidget {
  const HowToReadLyrics({super.key});

  @override
  State<HowToReadLyrics> createState() => _HowToReadLyricsState();
}

class _HowToReadLyricsState extends State<HowToReadLyrics> {
  String? selectedFormat;

  final List<LyricsFormat> lyricsFormats = [
    LyricsFormat(title: "Tamil Only", value: "tamil_only"),
    LyricsFormat(
      title: "Tamil + English Transliteration",
      value: "tamil_english",
    ),
    LyricsFormat(
      title: "Tamil + Sinhala Transliteration",
      value: "tamil_sinhala",
    ),
    LyricsFormat(title: "All Three Formats", value: "all_three"),
    LyricsFormat(title: "English Transliteration Only", value: "english_only"),
    LyricsFormat(title: "Sinhala Transliteration Only", value: "sinhala_only"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'How to Read Lyrics',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF1E3A5F), // Dark blue color
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: MainBAckgound(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),

                // Options list
                Expanded(
                  child: ListView.builder(
                    itemCount: lyricsFormats.length,
                    itemBuilder: (context, index) {
                      final format = lyricsFormats[index];
                      final isSelected = selectedFormat == format.value;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0, left: 20),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                format.title,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight:
                                      isSelected
                                          ? FontWeight.w500
                                          : FontWeight.w400,
                                ),
                              ),
                            ),
                            // if (isSelected)
                            //   Icon(
                            //     Icons.check_circle,
                            //     color: Colors.white,
                            //     size: 20,
                            //   ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                // Save/Continue button
                // if (selectedFormat != null)
                //   Padding(
                //     padding: const EdgeInsets.only(top: 20),
                //     child: SizedBox(
                //       width: double.infinity,
                //       child: ElevatedButton(
                //         onPressed: () {
                //           // Handle save/continue action
                //           _saveSelectedFormat();
                //         },
                //         style: ElevatedButton.styleFrom(
                //           backgroundColor: Colors.white.withOpacity(0.2),
                //           foregroundColor: Colors.white,
                //           padding: const EdgeInsets.symmetric(vertical: 16),
                //           shape: RoundedRectangleBorder(
                //             borderRadius: BorderRadius.circular(8),
                //             side: BorderSide(
                //               color: Colors.white.withOpacity(0.3),
                //               width: 1,
                //             ),
                //           ),
                //           elevation: 0,
                //         ),
                //         child: const Text(
                //           'Save Preference',
                //           style: TextStyle(
                //             fontSize: 16,
                //             fontWeight: FontWeight.w500,
                //           ),
                //         ),
                //       ),
                //     ),
                //   ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _saveSelectedFormat() {
    // Handle saving the selected format
    final selectedFormatData = lyricsFormats.firstWhere(
      (format) => format.value == selectedFormat,
    );

    // You can save to SharedPreferences, send to API, etc.
    print('Selected format: ${selectedFormatData.title}');

    // Show confirmation or navigate back
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Preference saved: ${selectedFormatData.title}'),
        backgroundColor: Colors.green.withOpacity(0.8),
        behavior: SnackBarBehavior.floating,
      ),
    );

    // Optionally navigate back after a delay
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        Navigator.of(context).pop(selectedFormat);
      }
    });
  }
}

// Alternative simpler version without selection state
class HowToReadLyricsSimple extends StatelessWidget {
  const HowToReadLyricsSimple({super.key});

  final List<String> lyricsFormats = const [
    "Tamil Only",
    "Tamil + English Transliteration",
    "Tamil + Sinhala Transliteration",
    "All Three Formats",
    "English Transliteration Only",
    "Sinhala Transliteration Only",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MainBAckgound(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back button
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 24,
                  ),
                  padding: EdgeInsets.zero,
                  alignment: Alignment.centerLeft,
                ),

                const SizedBox(height: 30),

                // Title with dotted border
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white.withOpacity(0.6),
                        width: 1,
                        style: BorderStyle.solid,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'How to Read Lyrics',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // Options list
                Expanded(
                  child: ListView.builder(
                    itemCount: lyricsFormats.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: GestureDetector(
                          onTap: () {
                            // Handle option selection
                            _handleFormatSelection(
                              context,
                              lyricsFormats[index],
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 18,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.2),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              lyricsFormats[index],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleFormatSelection(BuildContext context, String format) {
    // Handle the selected format
    print('Selected: $format');

    // Show confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Selected: $format'),
        backgroundColor: Colors.green.withOpacity(0.8),
        behavior: SnackBarBehavior.floating,
      ),
    );

    // Navigate back with selected value
    Navigator.of(context).pop(format);
  }
}
