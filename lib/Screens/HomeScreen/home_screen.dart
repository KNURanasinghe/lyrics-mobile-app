import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:lyrics/Const/const.dart';
import 'package:lyrics/Models/artist_model.dart';
import 'package:lyrics/Models/song_model.dart';
import 'package:lyrics/Models/user_model.dart';
// Add these imports for your API services
// You'll need to import the correct path based on your file structure
// import 'package:lyrics/Services/artist_service.dart';
// import 'package:lyrics/Services/album_service.dart';
import 'package:lyrics/Screens/DrawerScreens/how_ro_read_lyrics.dart';
import 'package:lyrics/Screens/DrawerScreens/privacy_policy.dart';
import 'package:lyrics/Screens/DrawerScreens/setting_screen.dart';
import 'package:lyrics/Screens/DrawerScreens/worship_note_screen.dart';
import 'package:lyrics/Screens/Profile/profile.dart';
import 'package:lyrics/Screens/DrawerScreens/premium_screen.dart';
import 'package:lyrics/Screens/all_songs.dart';
import 'package:lyrics/Screens/language_screen.dart';
import 'package:lyrics/Screens/music_player.dart';
import 'package:lyrics/Service/album_service.dart';
import 'package:lyrics/Service/artist_service.dart';
import 'package:lyrics/Service/search_service.dart';
import 'package:lyrics/Service/song_service.dart';
import 'package:lyrics/Service/user_service.dart';
import 'package:lyrics/widgets/main_background.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final SearchService _searchService = SearchService(
    baseUrl: 'http://145.223.21.62:3100',
  );
  final UserService _userService = UserService();
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  List<dynamic> _searchResults = [];
  // API Services
  final ArtistService _artistService = ArtistService();
  final AlbumService _albumService = AlbumService();

  // Data lists
  List<ArtistModel> artists = [];
  List<AlbumModel> albums = [];
  List<AlbumModel> latestAlbums = [];
  bool _isLoading = true;
  String? _errorMessage;

  UserModel? _currentUser;
  Map<String, dynamic>? _profileDetails;

  // Loading states
  bool isLoadingArtists = true;
  bool isLoadingAlbums = true;

  int _currentCarouselIndex = 0;
  final CarouselSliderController _carouselController =
      CarouselSliderController();

  String profile_image_url = 'assets/profile_image.png';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await Future.wait([
      _loadArtists(),
      _loadAlbums(),
      _loadLatestAlbums(),
      _loadProfileData(),
    ]);
  }

  Future<void> _loadProfileData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Load basic user info
      final userResult = await _userService.getCurrentUserProfile();
      if (!userResult['success']) {
        throw Exception(userResult['message'] ?? 'Failed to load user profile');
      }

      _currentUser = userResult['user'] as UserModel;

      // Load extended profile details if user exists
      if (_currentUser != null) {
        final profileResult = await _userService.getFullProfile(
          _currentUser!.id.toString(),
        );
        if (profileResult['success']) {
          _profileDetails = profileResult['profile'];
        }
      }

      setState(() {
        profile_image_url = _profileDetails?['profile']['profile_image'];
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load profile: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  Future<void> _loadLatestAlbums() async {
    try {
      final result = await _albumService.getLatestAlbums();
      if (result['success']) {
        setState(() {
          latestAlbums = result['albums'] ?? [];
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading latest albums: $e')),
        );
      }
    }
  }

  Future<void> _loadArtists() async {
    try {
      final result = await _artistService.getAllArtists();
      print('art ${result['artists']}');
      if (result['success']) {
        setState(() {
          artists = result['artists'] ?? [];
          isLoadingArtists = false;
        });
      } else {
        setState(() {
          isLoadingArtists = false;
        });
        // Show error message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result['message'] ?? 'Failed to load artists'),
            ),
          );
        }
      }
    } catch (e) {
      setState(() {
        isLoadingArtists = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error loading artists: $e')));
      }
    }
  }

  Future<void> _loadAlbums() async {
    try {
      final result = await _albumService.getAllAlbums();
      print('art ${result['albums']}');
      if (result['success']) {
        setState(() {
          albums = result['albums'] ?? [];
          isLoadingAlbums = false;
        });
      } else {
        setState(() {
          isLoadingAlbums = false;
        });
        // Show error message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result['message'] ?? 'Failed to load albums'),
            ),
          );
        }
      }
    } catch (e) {
      setState(() {
        isLoadingAlbums = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error loading albums: $e')));
      }
    }
  }

  @override
  void dispose() {
    _artistService.dispose();
    _albumService.dispose();
    super.dispose();
  }

  void _searchArtists(String query) async {
    if (query.trim().isEmpty) {
      setState(() {
        _isSearching = false;
        _searchResults.clear();
      });
      return;
    }

    setState(() {
      _isSearching = true;
    });

    final result = await _searchService.search(query);

    if (mounted) {
      setState(() {
        _isSearching = false;
        if (result['success']) {
          _searchResults = [
            ...result['artists'],
            ...result['albums'],
            ...result['songs'],
          ];
        } else {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(result['message'])));
        }
      });
    }
  }

  // Add this method to build search results
  Widget _buildSearchResults() {
    if (!_isSearching && _searchResults.isEmpty) return SizedBox();

    if (_isSearching) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
          child: Text(
            'Search Results',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: _searchResults.length,
          itemBuilder: (context, index) {
            final item = _searchResults[index];

            if (item is ArtistModel) {
              return _buildArtistSearchItem(item);
            } else if (item is AlbumModel) {
              return _buildAlbumSearchItem(item);
            } else if (item is SongModel) {
              return _buildSongSearchItem(item);
            } else {
              return SizedBox();
            }
          },
        ),
      ],
    );
  }

  Widget _buildArtistSearchItem(ArtistModel artist) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage:
            artist.image != null
                ? NetworkImage(artist.image!)
                : AssetImage('assets/Rectangle 32.png') as ImageProvider,
      ),
      title: Text(artist.name, style: TextStyle(color: Colors.white)),
      subtitle: Text('Artist', style: TextStyle(color: Colors.white70)),
      onTap: () => _navigateToArtistAlbums(artist),
    );
  }

  Widget _buildAlbumSearchItem(AlbumModel album) {
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          album.image ?? 'assets/Rectangle 32.png',
          width: 50,
          height: 50,
          fit: BoxFit.cover,
        ),
      ),
      title: Text(album.name, style: TextStyle(color: Colors.white)),
      subtitle: Text(
        'Album • ${album.artistName ?? 'Unknown Artist'}',
        style: TextStyle(color: Colors.white70),
      ),
      onTap: () => _navigateToAlbumSongs(album),
    );
  }

  Widget _buildSongSearchItem(SongModel song) {
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          song.image ?? song.albumImage ?? 'assets/Rectangle 32.png',
          width: 50,
          height: 50,
          fit: BoxFit.cover,
        ),
      ),
      title: Text(song.songname, style: TextStyle(color: Colors.white)),
      subtitle: Text(
        'Song • ${song.artistName ?? 'Unknown Artist'}',
        style: TextStyle(color: Colors.white70),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => MusicPlayer(
                  backgroundImage:
                      song.image ??
                      song.albumImage ??
                      'assets/Rectangle 32.png',
                  song: song.songname,
                  artist: song.artistName ?? 'Unknown Artist',
                ),
          ),
        );
      },
    );
  }

  Widget _buildFeaturedAlbumsCarousel() {
    return Column(
      children: [
        CarouselSlider.builder(
          carouselController: _carouselController,
          itemCount: latestAlbums.length,
          options: CarouselOptions(
            height: 140,
            viewportFraction: 0.9,
            enlargeCenterPage: true,
            autoPlay: true,
            autoPlayInterval: Duration(seconds: 5),
            onPageChanged: (index, reason) {
              setState(() {
                _currentCarouselIndex = index;
              });
            },
          ),
          itemBuilder: (context, index, realIndex) {
            final album = latestAlbums[index];
            return GestureDetector(
              onTap: () {
                _navigateToAlbumSongs(album);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: Container(
                  width: double.infinity,
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
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.5,
                              child: Text(
                                album.name,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              album.artistName ?? 'Unknown Artist',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Hero Image
                      Positioned(
                        right: -5,
                        top: -20,
                        bottom: 0,
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(16),
                            bottomRight: Radius.circular(16),
                          ),
                          child: SizedBox(
                            width: 180,
                            height: 160,
                            child:
                                album.image != null
                                    ? Image.network(
                                      album.image!,
                                      fit: BoxFit.cover,
                                      errorBuilder: (
                                        context,
                                        error,
                                        stackTrace,
                                      ) {
                                        return Image.asset(
                                          'assets/hero.png',
                                          fit: BoxFit.cover,
                                        );
                                      },
                                    )
                                    : Image.asset(
                                      'assets/hero.png',
                                      fit: BoxFit.cover,
                                    ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children:
              latestAlbums.asMap().entries.map((entry) {
                return GestureDetector(
                  onTap: () => _carouselController.animateToPage(entry.key),
                  child: Container(
                    width: 8.0,
                    height: 8.0,
                    margin: EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 4.0,
                    ),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: (Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black)
                          .withOpacity(
                            _currentCarouselIndex == entry.key ? 0.9 : 0.4,
                          ),
                    ),
                  ),
                );
              }).toList(),
        ),
      ],
    );
  }

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
                _buildFeaturedAlbumsCarousel(),
                // Featured Album Card
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 20.0),
                //   child: Container(
                //     width: double.infinity,
                //     height: 140,
                //     decoration: BoxDecoration(
                //       gradient: Const.heroBackgrounf,
                //       borderRadius: BorderRadius.circular(16),
                //     ),
                //     child: Stack(
                //       clipBehavior: Clip.none,
                //       children: [
                //         // Text Content
                //         Positioned(
                //           left: 20,
                //           top: 20,
                //           bottom: 20,
                //           child: Column(
                //             crossAxisAlignment: CrossAxisAlignment.start,
                //             mainAxisAlignment: MainAxisAlignment.center,
                //             children: [
                //               Text(
                //                 'New Album Released',
                //                 style: TextStyle(
                //                   color: Colors.white70,
                //                   fontSize: 12,
                //                   fontWeight: FontWeight.w500,
                //                 ),
                //               ),
                //               SizedBox(height: 8),
                //               Text(
                //                 albums.isNotEmpty
                //                     ? albums.first.name
                //                     : 'Featured Album',
                //                 style: TextStyle(
                //                   color: Colors.white,
                //                   fontSize: 20,
                //                   fontWeight: FontWeight.bold,
                //                 ),
                //               ),
                //               SizedBox(height: 4),
                //               Text(
                //                 albums.isNotEmpty
                //                     ? (albums.first.artistName ??
                //                         'Unknown Artist')
                //                     : 'Artist Name',
                //                 style: TextStyle(
                //                   color: Colors.white70,
                //                   fontSize: 14,
                //                 ),
                //               ),
                //             ],
                //           ),
                //         ),
                //         // Hero Image - Positioned to extend beyond container
                //         Positioned(
                //           right: -5,
                //           top: -20,
                //           bottom: 0,
                //           child: ClipRRect(
                //             borderRadius: BorderRadius.only(
                //               topRight: Radius.circular(16),
                //               bottomRight: Radius.circular(16),
                //             ),
                //             child: SizedBox(
                //               width: 180,
                //               height: 160,
                //               child:
                //                   albums.isNotEmpty &&
                //                           albums.first.image != null
                //                       ? Image.network(
                //                         albums.first.image!,
                //                         fit: BoxFit.cover,
                //                         errorBuilder: (
                //                           context,
                //                           error,
                //                           stackTrace,
                //                         ) {
                //                           return Image.asset(
                //                             'assets/hero.png',
                //                             fit: BoxFit.cover,
                //                           );
                //                         },
                //                       )
                //                       : Image.asset(
                //                         'assets/hero.png',
                //                         fit: BoxFit.cover,
                //                       ),
                //             ),
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
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
                      controller: _searchController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Search songs, albums, artists...',
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
                      onChanged: (value) {
                        if (value.isEmpty) {
                          setState(() {
                            _isSearching = false;
                            _searchResults.clear();
                          });
                        }
                      },
                      onSubmitted: _searchArtists,
                    ),
                  ),
                ),

                SizedBox(height: 30),
                _buildSearchResults(),
                // Artists Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Artists',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (isLoadingArtists)
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                SizedBox(height: 15),

                // Artists Grid
                SizedBox(
                  height: 160,
                  child:
                      isLoadingArtists
                          ? Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                          : artists.isEmpty
                          ? Center(
                            child: Text(
                              'No artists found',
                              style: TextStyle(color: Colors.white70),
                            ),
                          )
                          : ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            itemCount: artists.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: EdgeInsets.only(
                                  right: index < artists.length - 1 ? 15 : 0,
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    _navigateToArtistAlbums(artists[index]);
                                  },
                                  child: _buildArtistCard(artists[index]),
                                ),
                              );
                            },
                          ),
                ),

                SizedBox(height: 30),

                // Albums Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Albums',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (isLoadingAlbums)
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                SizedBox(height: 15),

                // Albums Grid
                SizedBox(
                  height: 160,
                  child:
                      isLoadingAlbums
                          ? Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                          : albums.isEmpty
                          ? Center(
                            child: Text(
                              'No albums found',
                              style: TextStyle(color: Colors.white70),
                            ),
                          )
                          : ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            itemCount: albums.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: EdgeInsets.only(
                                  right: index < albums.length - 1 ? 15 : 0,
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    _navigateToAlbumSongs(albums[index]);
                                  },
                                  child: _buildAlbumCard(albums[index]),
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

  // void _searchArtists(String query) async {
  //   if (query.trim().isEmpty) return;

  //   // You can implement artist search here
  //   // For now, filter existing artists
  //   setState(() {
  //     isLoadingArtists = true;
  //   });

  //   // Simulate search delay
  //   await Future.delayed(Duration(milliseconds: 500));

  //   setState(() {
  //     // Filter artists by name
  //     artists =
  //         artists
  //             .where(
  //               (artist) =>
  //                   artist.name.toLowerCase().contains(query.toLowerCase()),
  //             )
  //             .toList();
  //     isLoadingArtists = false;
  //   });
  // }

  void _navigateToArtistAlbums(ArtistModel artist) async {
    // Navigate to artist's albums/songs
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => AllSongs(artistId: artist.id, artistName: artist.name),
      ),
    );
  }

  void _navigateToAlbumSongs(AlbumModel album) async {
    // Navigate to album's songs
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => MusicPlayer(
              backgroundImage: album.image ?? 'assets/Rectangle 32.png',
              song: album.name,
              artist: album.artistName ?? 'Unknown Artist',
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
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Profile Image
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.grey[600],
                        backgroundImage: NetworkImage(profile_image_url),
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
                          _profileDetails?['fullname'],
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
                _buildDrawerItem(
                  Icons.home_outlined,
                  'Home',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                    );
                  },
                ),
                _buildDrawerItem(
                  Icons.language_outlined,
                  'Languages',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LanguageScreen()),
                    );
                  },
                ),
                _buildDrawerItem(
                  Icons.star_outline,
                  'Featured Songs',
                  onTap: () {
                    // Navigator.pop(context);
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => WorshipNotesScreen(),
                    //   ),
                    // );
                  },
                ),
                _buildDrawerItem(
                  Icons.bookmark_outline,
                  'My Set List',
                  onTap: () {
                    // Navigator.pop(context);
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => WorshipNotesScreen(),
                    //   ),
                    // );
                  },
                ),
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
          onTap();
        } else {
          Navigator.pop(context);
        }
      },
      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
    );
  }

  Widget _buildArtistCard(ArtistModel artist) {
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
                image:
                    artist.image != null
                        ? NetworkImage(artist.image!)
                        : AssetImage('assets/Rectangle 32.png')
                            as ImageProvider,
                fit: BoxFit.cover,
              ),
            ),
            child:
                artist.image == null
                    ? Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.grey[800],
                      ),
                      child: Icon(
                        Icons.person,
                        color: Colors.white54,
                        size: 40,
                      ),
                    )
                    : null,
          ),
          SizedBox(height: 8),
          Text(
            artist.name,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            '${artist.albumCount ?? 0} Albums',
            style: TextStyle(color: Colors.white70, fontSize: 12),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildAlbumCard(AlbumModel album) {
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
                image:
                    album.image != null
                        ? NetworkImage(album.image!)
                        : AssetImage('assets/Rectangle 32.png')
                            as ImageProvider,
                fit: BoxFit.cover,
              ),
            ),
            child:
                album.image == null
                    ? Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.grey[800],
                      ),
                      child: Icon(Icons.album, color: Colors.white54, size: 40),
                    )
                    : null,
          ),
          SizedBox(height: 8),
          Text(
            album.name,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            album.artistName ?? 'Unknown Artist',
            style: TextStyle(color: Colors.white70, fontSize: 12),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
