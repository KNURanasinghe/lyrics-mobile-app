import 'package:flutter/material.dart';

class MusicPlayer extends StatefulWidget {
  final String backgroundImage;
  final String song;
  final String artist; // Add artist parameter

  const MusicPlayer({
    super.key,
    required this.backgroundImage,
    required this.song,
    required this.artist, // Add this
  });

  @override
  State<MusicPlayer> createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer> {
  bool isPlaying = false;
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF272727),
      bottomNavigationBar: Container(
        height: 80,
        color: Color(0xFF272727),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                      image: DecorationImage(
                        image: AssetImage(widget.backgroundImage),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  // Song info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.song,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4),
                        Text(
                          widget.artist,
                          style: TextStyle(color: Colors.grey, fontSize: 14),
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
            // Right side - Control buttons
            // Row(
            //   children: [
            //     // Play/Pause button
            //     IconButton(
            //       icon: Icon(
            //         isPlaying ? Icons.pause : Icons.play_arrow,
            //         color: Colors.white,
            //         size: 30,
            //       ),
            //       onPressed: () {
            //         setState(() {
            //           isPlaying = !isPlaying;
            //         });
            //       },
            //     ),
            //     SizedBox(width: 8),
            //     // Next button
            //     IconButton(
            //       icon: Icon(Icons.skip_next, color: Colors.white, size: 30),
            //       onPressed: () {
            //         // Handle next song action
            //       },
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(widget.backgroundImage),
              fit: BoxFit.fitHeight,
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(
                    0xFF173857,
                  ).withOpacity(0.6), // Top left color with 60% opacity
                  Color(
                    0xFF000000,
                  ).withOpacity(0.6), // Bottom right color with 60% opacity
                ],
              ),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                          size: 20,
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width * 0.25),
                      Text(
                        widget.song,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                // Add more content here for the main music player UI
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(24.0),
                    child: SingleChildScrollView(
                      child: Text(
                        '''
          Sleepin', you're on your tippy toes
          Creepin' around like no one knows
          Think you're so criminal
          Bruises on both my knees for you
          Don't say thank you or please
          I do what I want when I'm wanting to
          
          My soul so cynical
          
          Sleepin', you're on your tippy toes
          Creepin' around like no one knows
          Think you're so criminal
          Bruises on both my knees for you
          Don't say thank you or please''',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 18,
                          height: 2,
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
