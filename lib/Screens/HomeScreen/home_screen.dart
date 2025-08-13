import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:lyrics/Const/const.dart';
import 'package:lyrics/Models/artist_model.dart';
import 'package:lyrics/Models/song_model.dart';
import 'package:lyrics/Models/user_model.dart';
import 'package:lyrics/Screens/DrawerScreens/featured_songs.dart';
import 'package:lyrics/Screens/DrawerScreens/how_ro_read_lyrics.dart';
import 'package:lyrics/Screens/DrawerScreens/my_set_list.dart';
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
import 'package:lyrics/Service/language_service.dart';
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

  String? currentLanguage;
  String? languageDisplayName;

  // Loading states
  bool isLoadingArtists = true;
  bool isLoadingAlbums = true;

  bool isPremium = false;

  int _currentCarouselIndex = 0;
  final CarouselSliderController _carouselController =
      CarouselSliderController();

  String? profileImageUrl;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final List<Future> loads = [
      loadPremiumStatus().catchError(
        (e) => print('premium status load error: $e'),
      ),
      _loadProfileData().catchError((e) => print('Profile load error: $e')),
      _loadArtists().catchError((e) => print('Artists load error: $e')),
      // _loadAlbums().catchError((e) => print('Albums load error: $e')),
      getLang().catchError((e) => print('lang album load error: $e')),
      _loadLatestAlbums().catchError((e) => print('Latest albums error: $e')),
    ];

    try {
      await Future.wait(loads);
    } catch (e) {
      print('Composite load error: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> loadPremiumStatus() async {
    final ispremiun = await UserService.getIsPremium();
    setState(() {
      isPremium = ispremiun == '1';
    });
  }

  Future<void> getLang() async {
    final lang = await LanguageService.getLanguage();
    final langcode = LanguageService.getLanguageCode(lang);
    _loadAlbumsByLanguage(langcode);
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

      _currentUser = userResult['user'] as UserModel?;

      // Load extended profile details if user exists
      if (_currentUser != null) {
        final profileResult = await _userService.getFullProfile(
          _currentUser!.id.toString(),
        );

        print('profile result in home ${profileResult['profile']}');
        if (profileResult['success']) {
          _profileDetails = profileResult['profile'] as Map<String, dynamic>?;
        }
      }

      setState(() {
        profileImageUrl =
            _profileDetails?['profile']?['profile_image'] as String?;
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
        final albumsList = result['albums'] as List<dynamic>?;
        setState(() {
          latestAlbums = albumsList?.cast<AlbumModel>() ?? [];
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
      setState(() => isLoadingArtists = true);

      // Get the current language
      final lang = await LanguageService.getLanguage();
      final langcode = LanguageService.getLanguageCode(lang);

      // Use the language-specific endpoint
      final result = await _artistService.getArtistsByLanguage(langcode);
      print('Artists by language response: $result');

      if (result['success']) {
        setState(() {
          artists = result['artists'] ?? [];
          isLoadingArtists = false;
          currentLanguage = result['language'];
          languageDisplayName = result['languageDisplayName'];
        });
      } else {
        setState(() => isLoadingArtists = false);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result['message'] ?? 'Failed to load artists'),
            ),
          );
        }
      }
    } catch (e) {
      setState(() => isLoadingArtists = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading artists: ${e.toString()}')),
        );
      }
    }
  }
  // Future<void> _loadArtists() async {
  //   try {
  //     final result = await _artistService.getAllArtists();
  //     print('artist data in home: $result'); // Print the entire result first

  //     if (result['success']) {
  //       // No need to cast here since getAllArtists already returns List<ArtistModel>
  //       setState(() {
  //         artists = result['artists'] ?? [];
  //         isLoadingArtists = false;
  //       });
  //     } else {
  //       setState(() {
  //         isLoadingArtists = false;
  //       });
  //       if (mounted) {
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(
  //             content: Text(result['message'] ?? 'Failed to load artists'),
  //           ),
  //         );
  //       }
  //     }
  //   } catch (e) {
  //     setState(() {
  //       isLoadingArtists = false;
  //     });
  //     if (mounted) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Error loading artists: ${e.toString()}')),
  //       );
  //     }
  //   }
  // }

  // Future<void> _loadAlbums() async {
  //   try {
  //     setState(() => isLoadingAlbums = true);

  //     final result = await _albumService.getAllAlbums();
  //     print('Raw albums API response: ${result.toString()}');

  //     if (result['success'] == true) {
  //       // Handle both List<dynamic> and List<AlbumModel> cases
  //       final List<dynamic> rawAlbums = result['albums'] ?? [];
  //       final List<AlbumModel> loadedAlbums = [];

  //       for (var albumData in rawAlbums) {
  //         try {
  //           AlbumModel album;
  //           if (albumData is AlbumModel) {
  //             album = albumData; // Already an AlbumModel
  //           } else if (albumData is Map<String, dynamic>) {
  //             album = AlbumModel.fromJson(albumData); // Parse from JSON
  //           } else {
  //             print('Invalid album data type: ${albumData.runtimeType}');
  //             continue;
  //           }
  //           loadedAlbums.add(album);
  //         } catch (e) {
  //           print('Failed to parse album: $albumData');
  //           print('Error: $e');
  //         }
  //       }

  //       setState(() {
  //         albums = loadedAlbums;
  //         isLoadingAlbums = false;
  //       });
  //     } else {
  //       setState(() => isLoadingAlbums = false);
  //       if (mounted) {
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(
  //             content: Text(result['message'] ?? 'Failed to load albums'),
  //           ),
  //         );
  //       }
  //     }
  //   } catch (e, stack) {
  //     print('Error in _loadAlbums: $e');
  //     print('Stack trace: $stack');
  //     setState(() => isLoadingAlbums = false);
  //     if (mounted) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Error loading albums: ${e.toString()}')),
  //       );
  //     }
  //   }
  // }

  Future<void> _loadAlbumsByLanguage(String language) async {
    try {
      setState(() => isLoadingAlbums = true);

      final result = await _albumService.getAlbumsByLanguage(language);
      print('Albums by language response: ${result.toString()}');

      if (result['success'] == true) {
        final List<AlbumModel> loadedAlbums =
            (result['albums'] as List<dynamic>)
                .map(
                  (album) =>
                      album is AlbumModel ? album : AlbumModel.fromJson(album),
                )
                .toList();

        setState(() {
          albums = loadedAlbums;
          isLoadingAlbums = false;
          // You can also store the language info if needed
          currentLanguage = result['language'];
          languageDisplayName = result['languageDisplayName'];
        });
      } else {
        setState(() => isLoadingAlbums = false);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result['message'] ?? 'Failed to load albums'),
            ),
          );
        }
      }
    } catch (e, stack) {
      print('Error in _loadAlbumsByLanguage: $e');
      print('Stack trace: $stack');
      setState(() => isLoadingAlbums = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading albums: ${e.toString()}')),
        );
      }
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
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

    try {
      final result = await _searchService.search(query);

      if (mounted) {
        setState(() {
          _isSearching = false;
          if (result['success']) {
            _searchResults = [
              ...(result['artists'] as List<dynamic>? ?? []),
              ...(result['albums'] as List<dynamic>? ?? []),
              ...(result['songs'] as List<dynamic>? ?? []),
            ];
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(result['message'] ?? 'Search failed')),
            );
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isSearching = false;
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Search error: $e')));
      }
    }
  }

  // Add this method to build search results
  Widget _buildSearchResults() {
    if (!_isSearching && _searchResults.isEmpty) return const SizedBox();

    if (_isSearching) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
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
          physics: const NeverScrollableScrollPhysics(),
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
              return const SizedBox();
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
                : const AssetImage('assets/Rectangle 32.png') as ImageProvider,
      ),
      title: Text(artist.name, style: const TextStyle(color: Colors.white)),
      subtitle: const Text('Artist', style: TextStyle(color: Colors.white70)),
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
          errorBuilder: (context, error, stackTrace) {
            return Image.asset(
              'assets/Rectangle 32.png',
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            );
          },
        ),
      ),
      title: Text(album.name, style: const TextStyle(color: Colors.white)),
      subtitle: Text(
        'Album • ${album.artistName ?? 'Unknown Artist'}',
        style: const TextStyle(color: Colors.white70),
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
          errorBuilder: (context, error, stackTrace) {
            return Image.asset(
              'assets/Rectangle 32.png',
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            );
          },
        ),
      ),
      title: Text(song.songname, style: const TextStyle(color: Colors.white)),
      subtitle: Text(
        'Song • ${song.artistName ?? 'Unknown Artist'}',
        style: const TextStyle(color: Colors.white70),
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
                  id: song.id!,
                ),
          ),
        );
      },
    );
  }

  Widget _buildFeaturedAlbumsCarousel() {
    if (latestAlbums.isEmpty) {
      return const SizedBox(height: 140);
    }

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
            autoPlayInterval: const Duration(seconds: 5),
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
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'New Album Released',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 8),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.5,
                                child: Text(
                                  album.name,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                album.artistName ?? 'Unknown Artist',
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Hero Image
                      Positioned(
                        right: -5,
                        top: -20,
                        bottom: 0,
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
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
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children:
              latestAlbums.asMap().entries.map((entry) {
                return GestureDetector(
                  onTap: () => _carouselController.animateToPage(entry.key),
                  child: Container(
                    width: 8.0,
                    height: 8.0,
                    margin: const EdgeInsets.symmetric(
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
                        child: const Icon(
                          Icons.menu,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
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

                // Featured Albums Carousel
                _buildFeaturedAlbumsCarousel(),

                const SizedBox(height: 20),

                // Search Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF363636),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: TextField(
                      controller: _searchController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
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

                const SizedBox(height: 30),
                _buildSearchResults(),

                // Artists Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Artists',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (isLoadingArtists)
                        const SizedBox(
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

                const SizedBox(height: 15),

                // Artists Grid
                SizedBox(
                  height: 160,
                  child:
                      isLoadingArtists
                          ? const Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                          : artists.isEmpty
                          ? const Center(
                            child: Text(
                              'No artists found',
                              style: TextStyle(color: Colors.white70),
                            ),
                          )
                          : ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
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

                const SizedBox(height: 30),

                // Albums Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Albums',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (isLoadingAlbums)
                        const SizedBox(
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

                const SizedBox(height: 15),

                // Albums Grid
                SizedBox(
                  height: 160,
                  child:
                      isLoadingAlbums
                          ? const Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                          : albums.isEmpty
                          ? const Center(
                            child: Text(
                              'No albums found',
                              style: TextStyle(color: Colors.white70),
                            ),
                          )
                          : ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
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

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

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
            (context) => AllSongs(
              artistId: album.artistId,
              artistName: album.artistName,
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
                        backgroundImage:
                            profileImageUrl != null &&
                                    profileImageUrl!.isNotEmpty
                                ? NetworkImage(profileImageUrl!)
                                : null,
                        child:
                            profileImageUrl == null || profileImageUrl!.isEmpty
                                ? const Icon(
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
                  isPremium: !isPremium,
                  onTap:
                      isPremium
                          ? () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FeaturedSongs(),
                              ),
                            );
                          }
                          : null,
                ),
                _buildDrawerItem(
                  Icons.bookmark_outline,
                  'My Set List',
                  isPremium: !isPremium,
                  onTap:
                      isPremium
                          ? () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MySetList(),
                              ),
                            );
                          }
                          : null,
                ),
                _buildDrawerItem(
                  Icons.note_outlined,
                  'Worship Notes',
                  isPremium: !isPremium,
                  onTap:
                      isPremium
                          ? () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => WorshipNotesScreen(),
                              ),
                            );
                          }
                          : null,
                ),
                _buildDrawerItem(
                  Icons.article_outlined,
                  'How to Read Lyrics',
                  isPremium: !isPremium,
                  onTap:
                      isPremium
                          ? () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HowToReadLyrics(),
                              ),
                            );
                          }
                          : null,
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

  Widget _buildDrawerItem(
    IconData icon,
    String title, {
    Function? onTap,
    bool isPremium = false,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.white, size: 24),
      trailing:
          isPremium ? Icon(Icons.lock, color: Colors.white, size: 20) : null,
      title: Text(
        title,
        style: TextStyle(
          color: Colors.white,
          fontSize: 22,
          // fontWeight: FontWeight.w500,
        ),
      ),
      onTap: () {
        if (onTap != null) {
          onTap();
        } else {
          Navigator.pop(context);
        }
      },
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
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
              image:
                  artist.image != null
                      ? DecorationImage(
                        image: NetworkImage(artist.image!),
                        fit: BoxFit.cover,
                      )
                      : null,
              color: artist.image == null ? Colors.grey[800] : null,
            ),
            child:
                artist.image == null
                    ? const Icon(Icons.person, color: Colors.white54, size: 40)
                    : null,
          ),
          const SizedBox(height: 8),
          Text(
            artist.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            '${artist.albumCount ?? 0} Albums',
            style: const TextStyle(color: Colors.white70, fontSize: 12),
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
              image:
                  album.image != null
                      ? DecorationImage(
                        image: NetworkImage(album.image!),
                        fit: BoxFit.cover,
                      )
                      : null,
              color: album.image == null ? Colors.grey[800] : null,
            ),
            child:
                album.image == null
                    ? const Icon(Icons.album, color: Colors.white54, size: 40)
                    : null,
          ),
          const SizedBox(height: 8),
          Text(
            album.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            album.artistName ?? 'Unknown Artist',
            style: const TextStyle(color: Colors.white70, fontSize: 12),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
