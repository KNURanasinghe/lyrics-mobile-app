import 'package:flutter/material.dart';
import 'package:lyrics/Const/const.dart';
import 'package:lyrics/Models/artist_model.dart';
import 'package:lyrics/Models/song_model.dart';
import 'package:lyrics/Screens/DrawerScreens/how_ro_read_lyrics.dart';
import 'package:lyrics/Screens/DrawerScreens/privacy_policy.dart';
import 'package:lyrics/Screens/DrawerScreens/setting_screen.dart';
import 'package:lyrics/Screens/DrawerScreens/worship_note_screen.dart';
import 'package:lyrics/Screens/Profile/profile.dart';
import 'package:lyrics/Screens/DrawerScreens/premium_screen.dart';
import 'package:lyrics/Screens/music_player.dart';
import 'package:lyrics/widgets/main_background.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<Artist> artists = [
    Artist(
      name: 'Billie Eilish',
      title: 'Bad Guy',
      imageUrl: 'assets/Rectangle 32.png',
    ),
    Artist(
      name: 'Ed Sheeran',
      title: 'Shape of You',
      imageUrl: 'assets/Rectangle 32.png',
    ),
    Artist(
      name: 'Taylor Swift',
      title: 'Anti-Hero',
      imageUrl: 'assets/Rectangle 32.png',
    ),
    Artist(
      name: 'The Weeknd',
      title: 'Blinding Lights',
      imageUrl: 'assets/Rectangle 32.png',
    ),
    Artist(
      name: 'Dua Lipa',
      title: 'Levitating',
      imageUrl: 'assets/Rectangle 32.png',
    ),
  ];

  final List<Song> songs = [
    Song(
      title: '1 Album',
      artist: 'The Beatles',
      imageUrl: 'assets/Rectangle 32.png',
    ),
    Song(
      title: 'Bad Guy',
      artist: 'Billie Eilish',
      imageUrl: 'assets/Rectangle 32.png',
    ),
    Song(
      title: 'Shape of You',
      artist: 'Ed Sheeran',
      imageUrl: 'assets/Rectangle 32.png',
    ),
    Song(
      title: 'Anti-Hero',
      artist: 'Taylor Swift',
      imageUrl: 'assets/Rectangle 32.png',
    ),
    Song(
      title: 'Blinding Lights',
      artist: 'The Weeknd',
      imageUrl: 'assets/Rectangle 32.png',
    ),
    Song(
      title: 'Levitating',
      artist: 'Dua Lipa',
      imageUrl: 'assets/Rectangle 32.png',
    ),
  ];
  String profile_image_url = 'assets/profile_image.png';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        drawer: _buildCustomDrawer(),
        body: MainBAckgound(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          _scaffoldKey.currentState?.openDrawer();
                        },
                        child: Icon(Icons.menu, color: Colors.white, size: 24),
                      ),
                      SizedBox(width: 12),
                      Text(
                        'Home',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

                // Featured Album Card
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Container(
                    width: double.infinity,
                    height: 140,
                    decoration: BoxDecoration(
                      gradient: Const.heroBackgrounf,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        // Text Content
                        Positioned(
                          left: 20,
                          top: 20,
                          bottom: 20,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'New Album Released',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Happier Than Ever',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Billie Eilish',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Hero Image - Positioned to extend beyond container
                        Positioned(
                          right: -5, // Extends beyond the right edge
                          top: -20, // Extends beyond the top edge
                          bottom: 0, // Extends beyond the bottom edge
                          child: ClipRRect(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(16),
                              bottomRight: Radius.circular(16),
                            ),
                            child: SizedBox(
                              width: 180, // Larger width
                              height: 160, // Larger height
                              child: Image.asset(
                                'assets/hero.png',
                                fit:
                                    BoxFit
                                        .cover, // Ensures image covers the area properly
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 20),

                // Search Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xFF363636),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: TextField(
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Search By Artist Name',
                        hintStyle: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        prefixIcon: Icon(Icons.search, color: Colors.white54),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 15,
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 30),

                // Artists Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    'Artists',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                SizedBox(height: 15),

                // Artists Grid
                SizedBox(
                  height: 160,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    itemCount: artists.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(
                          right: index < artists.length - 1 ? 15 : 0,
                        ),
                        child: _buildArtistCard(artists[index]),
                      );
                    },
                  ),
                ),

                SizedBox(height: 30),

                // Songs Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    'Songs',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                SizedBox(height: 15),

                // Songs Grid
                SizedBox(
                  height: 160,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    itemCount: songs.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(
                          right: index < songs.length - 1 ? 15 : 0,
                        ),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => MusicPlayer(
                                      backgroundImage: songs[index].imageUrl,
                                      song: songs[index].title,
                                      artist: songs[index].artist,
                                    ),
                              ),
                            );
                          },
                          child: _buildSongCard(songs[index]),
                        ),
                      );
                    },
                  ),
                ),

                SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCustomDrawer() {
    return Drawer(
      backgroundColor: Color(0xFF909090),
      child: Column(
        children: [
          // Profile Header - FIXED SECTION
          Container(
            height: MediaQuery.of(context).size.height * 0.2,
            padding: EdgeInsets.only(top: 40, left: 20, right: 20, bottom: 20),
            decoration: BoxDecoration(color: Color(0xFF555555)),
            child: Row(
              children: [
                // Profile Avatar and Name Column
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Profile Image
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.grey[600],
                      backgroundImage: AssetImage(profile_image_url),

                      child:
                          profile_image_url == null
                              ? Icon(
                                Icons.person,
                                color: Colors.white,
                                size: 35,
                              )
                              : null,
                    ),
                    SizedBox(height: 7),
                    // Profile Name
                    SizedBox(
                      width: 150,
                      child: Text(
                        'Peter Wilson Johnson Shan',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                // Spacer to push icons to the right
                Spacer(),
                // Notification and Settings Icons
                Align(
                  alignment: Alignment.topRight,
                  child: Row(
                    children: [
                      Icon(
                        Icons.notifications_outlined,
                        color: Colors.white,
                        size: 24,
                      ),
                      SizedBox(width: 12),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Profile()),
                          );
                        },
                        child: Icon(
                          Icons.settings_outlined,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Menu Items
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDrawerItem(Icons.home_outlined, 'Home'),
                _buildDrawerItem(Icons.language_outlined, 'Languages'),
                _buildDrawerItem(Icons.star_outline, 'Featured Songs'),
                _buildDrawerItem(Icons.bookmark_outline, 'My Set List'),
                _buildDrawerItem(
                  Icons.note_outlined,
                  'Worship Notes',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WorshipNotesScreen(),
                      ),
                    );
                  },
                ),
                _buildDrawerItem(
                  Icons.article_outlined,
                  'How to Read Lyrics',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HowToReadLyrics(),
                      ),
                    );
                  },
                ),
                _buildDrawerItem(Icons.search_outlined, 'Search Songs'),
                _buildDrawerItem(
                  Icons.workspace_premium_outlined,
                  'Go Premium',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PremiumScreen()),
                    );
                  },
                ),
                _buildDrawerItem(Icons.share_outlined, 'Share this App'),
                _buildDrawerItem(
                  Icons.settings_outlined,
                  'App Settings',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SettingsScreen()),
                    );
                  },
                ),
                _buildDrawerItem(
                  Icons.privacy_tip_outlined,
                  'Privacy Policy',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PrivacyPolicy()),
                    );
                  },
                ),
                _buildDrawerItem(Icons.info_outline, 'About this App'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, {Function? onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.white, size: 24),
      title: Text(
        title,
        style: TextStyle(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: () {
        if (onTap != null) {
          onTap(); // This actually calls the function
        } else {
          Navigator.pop(context); // Handle default behavior for other items
        }
      },
      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
    );
  }

  Widget _buildArtistCard(Artist artist) {
    return SizedBox(
      width: 110,
      child: Column(
        children: [
          Container(
            width: 110,
            height: 110,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                image: AssetImage(artist.imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 8),
          Text(
            artist.title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            artist.name,
            style: TextStyle(color: Colors.white70, fontSize: 12),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildSongCard(Song song) {
    return SizedBox(
      width: 110,
      child: Column(
        children: [
          Container(
            width: 110,
            height: 110,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                image: AssetImage(song.imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 8),
          Text(
            song.title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            song.artist,
            style: TextStyle(color: Colors.white70, fontSize: 12),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
