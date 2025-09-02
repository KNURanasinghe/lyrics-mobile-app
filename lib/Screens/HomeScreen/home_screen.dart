import 'package:carousel_slider/carousel_slider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:lyrics/Const/const.dart';
import 'package:lyrics/Models/artist_model.dart';
import 'package:lyrics/Models/song_model.dart';
import 'package:lyrics/Models/user_model.dart';
import 'package:lyrics/OfflineService/connectivity_manager.dart';
import 'package:lyrics/OfflineService/offline_album_service.dart';
import 'package:lyrics/OfflineService/offline_artist_service.dart';
import 'package:lyrics/OfflineService/offline_groupe_service.dart';
import 'package:lyrics/OfflineService/offline_user_service.dart';
import 'package:lyrics/OfflineService/sync_manager.dart';
import 'package:lyrics/Screens/DrawerScreens/about_app.dart';
import 'package:lyrics/Screens/DrawerScreens/featured_songs.dart';
import 'package:lyrics/Screens/DrawerScreens/how_ro_read_lyrics.dart';
import 'package:lyrics/Screens/DrawerScreens/my_set_list.dart';
import 'package:lyrics/Screens/DrawerScreens/privacy_policy.dart';
import 'package:lyrics/Screens/DrawerScreens/setting_screen.dart';
import 'package:lyrics/Screens/DrawerScreens/worship_note_screen.dart';
import 'package:lyrics/Screens/Profile/profile.dart';
import 'package:lyrics/Screens/DrawerScreens/premium_screen.dart';
import 'package:lyrics/Screens/ablum_page.dart';
import 'package:lyrics/Screens/all_songs.dart';
import 'package:lyrics/Screens/artist_page.dart';
import 'package:lyrics/Screens/language_screen.dart';
import 'package:lyrics/Screens/music_player.dart';
import 'package:lyrics/Screens/worship_team.dart';
import 'package:lyrics/Service/album_service.dart';
import 'package:lyrics/Service/artist_service.dart';
import 'package:lyrics/Service/language_service.dart';
import 'package:lyrics/Service/search_service.dart';
import 'package:lyrics/Service/song_service.dart';
import 'package:lyrics/Service/theme_service.dart';
import 'package:lyrics/Service/user_service.dart';
import 'package:lyrics/widgets/cached_image_widget.dart';
import 'package:lyrics/widgets/main_background.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // final SearchService _searchService = SearchService(
  //   baseUrl: 'http://145.223.21.62:3100',
  // );
  // final UserService _userService = UserService();
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  List<dynamic> _searchResults = [];

  String selectedTheme = 'Dark';
  bool isAutomaticTheme = false;

  // API Services
  // final ArtistService _artistService = ArtistService();
  // final AlbumService _albumService = AlbumService();

  final OfflineArtistService _artistService = OfflineArtistService();
  final OfflineAlbumService _albumService = OfflineAlbumService();
  final OfflineUserService _userService = OfflineUserService();
  final OfflineGroupSongService _groupSongService = OfflineGroupSongService();
  late final OfflineSearchService _searchService;

  final ConnectivityManager _connectivityManager = ConnectivityManager();
  final SyncManager _syncManager = SyncManager();
  bool _isOnline = false;

  // Data lists
  List<ArtistModel> artists = [];
  List<AlbumModel> albums = [];
  List<AlbumModel> latestAlbums = [];
  List<GroupSongModel> groupSongs = [];
  bool _isLoading = true;
  String? _errorMessage;

  UserModel? _currentUser;
  Map<String, dynamic>? _profileDetails;

  String? currentLanguage;
  String? languageDisplayName;

  // Loading states
  bool isLoadingArtists = true;
  bool isLoadingAlbums = true;
  bool isLoadingGroupSongs = true;

  bool isPremium = false;

  int _currentCarouselIndex = 0;
  final CarouselSliderController _carouselController =
      CarouselSliderController();

  String? profileImageUrl;

  @override
  void initState() {
    super.initState();
    _searchService = OfflineSearchService(baseUrl: 'http://145.223.21.62:3100');
    _initializeConnectivity();
    _loadThemeSettings();
    _loadData();
  }

  Future<void> _loadThemeSettings() async {
    try {
      final theme = await ThemeService.getTheme();
      final automaticTheme = await ThemeService.getAutomaticTheme();

      setState(() {
        selectedTheme = theme;
        isAutomaticTheme = automaticTheme;
      });
    } catch (e) {
      print('Error loading theme settings: $e');
    }
  }
  // Future<void> _loadData() async {
  //   setState(() {
  //     _isLoading = true;
  //     _errorMessage = null;
  //   });

  //   final List<Future> loads = [
  //     loadPremiumStatus().catchError(
  //       (e) => print('premium status load error: $e'),
  //     ),
  //     _loadProfileData().catchError((e) => print('Profile load error: $e')),
  //     _loadArtists().catchError((e) => print('Artists load error: $e')),
  //     // _loadAlbums().catchError((e) => print('Albums load error: $e')),
  //     getLang().catchError((e) => print('lang album load error: $e')),
  //     _loadLatestAlbums().catchError((e) => print('Latest albums error: $e')),
  //   ];

  //   try {
  //     await Future.wait(loads);
  //   } catch (e) {
  //     print('Composite load error: $e');
  //   } finally {
  //     if (mounted) {
  //       setState(() => _isLoading = false);
  //     }
  //   }
  // }

  Future<void> _initializeConnectivity() async {
    // Check initial connectivity
    _isOnline = await _connectivityManager.isConnected();

    // Listen to connectivity changes
    _connectivityManager.connectivityStream.listen((result) {
      final wasOffline = !_isOnline;
      _isOnline = result != ConnectivityResult.none;

      if (mounted) {
        setState(() {});

        // Show connectivity status
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_isOnline ? '🌐 Back online' : '📱 Offline mode'),
            duration: Duration(seconds: 2),
            backgroundColor: _isOnline ? Colors.green : Colors.orange,
          ),
        );

        // Trigger sync when coming back online
        if (_isOnline && wasOffline) {
          _performBackgroundSync();
        }
      }
    });
  }

  Future<void> _performBackgroundSync() async {
    try {
      await _syncManager.performFullSync();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✅ Data synchronized'),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.blue,
          ),
        );
        // Reload data after sync
        _loadData();
      }
    } catch (e) {
      print('Background sync failed: $e');
    }
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
      getLang().catchError((e) => print('lang album load error: $e')),
      _loadLatestAlbums().catchError((e) => print('Latest albums error: $e')),
      _loadGroupSongs().catchError((e) => print('Group songs load error: $e')),
    ];

    try {
      await Future.wait(loads);
    } catch (e) {
      print('Composite load error: $e');
      // Even if some operations fail, we should show what we can
      setState(() {
        _errorMessage = 'Some content may not be up to date';
      });
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _loadGroupSongs() async {
    try {
      setState(() => isLoadingGroupSongs = true);

      // Get the current language
      final lang = await LanguageService.getLanguage();
      final langcode = LanguageService.getLanguageCode(lang);
      print('Loading group songs for language: $langcode');

      // Load group songs by language
      final result = await _groupSongService.getGroupSongsByLanguage(langcode);
      print('Group songs by language response: $result');

      if (result['success']) {
        final List<GroupSongModel> loadedGroupSongs = [];

        // Parse group songs with error handling
        final groupSongsData = result['groupSongs'] as List<dynamic>? ?? [];
        for (var songData in groupSongsData) {
          try {
            GroupSongModel groupSong;
            if (songData is GroupSongModel) {
              groupSong = songData;
            } else if (songData is Map<String, dynamic>) {
              groupSong = GroupSongModel.fromJson(songData);
            } else {
              continue;
            }
            loadedGroupSongs.add(groupSong);
          } catch (e) {
            print('Error parsing group song: $e');
          }
        }

        setState(() {
          groupSongs = loadedGroupSongs;
          isLoadingGroupSongs = false;
        });

        // Show offline indicator if using cached data
        if (result['source'] == 'cache' ||
            result['source'] == 'cache_fallback') {
          _showOfflineMessage('Group songs loaded from offline cache');
        }
      } else {
        setState(() => isLoadingGroupSongs = false);
        _showErrorMessage(result['message'] ?? 'Failed to load group songs');
      }
    } catch (e) {
      print('Group songs load error: $e');
      setState(() => isLoadingGroupSongs = false);
      _showErrorMessage('Error loading group songs: ${e.toString()}');
    }
  }

  void _showOfflineMessage(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.wifi_off, color: Colors.white, size: 16),
              SizedBox(width: 8),
              Expanded(child: Text(message)),
            ],
          ),
          backgroundColor: Colors.orange,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  void _showErrorMessage(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  Future<void> loadPremiumStatus() async {
    final ispremiun = await UserService.getIsPremium();
    print('premium state is: $ispremiun');
    setState(() {
      isPremium = ispremiun == '1';
    });
  }

  Future<void> getLang() async {
    try {
      final lang = await LanguageService.getLanguage();
      final langcode = LanguageService.getLanguageCode(lang);
      print('Loading data for language: $langcode');

      // Store current language for comparison
      final oldLanguage = currentLanguage;
      currentLanguage = langcode;

      // If language changed or first load, refresh albums
      if (oldLanguage != langcode || albums.isEmpty) {
        await _loadAlbumsByLanguage(langcode);
      }
    } catch (e) {
      print('Error in getLang: $e');
      // Fallback to default language
      await _loadAlbumsByLanguage('en');
    }
  }

  Future<void> _loadProfileData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Load basic user info
      // final userResult = await _userService.getCurrentUserProfile();
      // if (!userResult['success']) {
      //   throw Exception(userResult['message'] ?? 'Failed to load user profile');
      // }

      // _currentUser = userResult['user'] as UserModel?;
      final userID = await UserService.getUserID();

      // Load extended profile details if user exists
      final profileResult = await _userService.getFullProfile(userID);

      print('profile result in home ${profileResult['profile']}');
      if (profileResult['success']) {
        _profileDetails = profileResult['profile'] as Map<String, dynamic>?;
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
        final List<ArtistModel> loadedArtists = [];

        // Parse artists with error handling
        final artistsData = result['artists'] as List<dynamic>? ?? [];
        for (var artistData in artistsData) {
          try {
            ArtistModel artist;
            if (artistData is ArtistModel) {
              artist = artistData;
            } else if (artistData is Map<String, dynamic>) {
              artist = ArtistModel.fromJson(artistData);
            } else {
              continue;
            }
            loadedArtists.add(artist);
          } catch (e) {
            print('Error parsing artist: $e');
          }
        }

        setState(() {
          artists = loadedArtists;
          isLoadingArtists = false;
          currentLanguage = result['language'] ?? langcode;
          languageDisplayName =
              result['languageDisplayName'] ?? langcode.toUpperCase();
        });

        // Show offline indicator if using cached data
        if (result['source'] == 'cache' ||
            result['source'] == 'cache_fallback') {
          _showOfflineMessage('Artists loaded from offline cache');
        }
      } else {
        setState(() => isLoadingArtists = false);
        _showErrorMessage(result['message'] ?? 'Failed to load artists');
      }
    } catch (e) {
      setState(() => isLoadingArtists = false);
      _showErrorMessage('Error loading artists: ${e.toString()}');
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
        final List<AlbumModel> loadedAlbums = [];

        // Parse albums with error handling
        final albumsData = result['albums'] as List<dynamic>? ?? [];
        for (var albumData in albumsData) {
          try {
            AlbumModel album;
            if (albumData is AlbumModel) {
              album = albumData;
            } else if (albumData is Map<String, dynamic>) {
              album = AlbumModel.fromJson(albumData);
            } else {
              continue;
            }
            loadedAlbums.add(album);
          } catch (e) {
            print('Error parsing album: $e');
          }
        }

        setState(() {
          albums = loadedAlbums;
          isLoadingAlbums = false;
          currentLanguage = result['language'] ?? language;
          languageDisplayName =
              result['languageDisplayName'] ?? language.toUpperCase();
        });

        // Show offline indicator if using cached data
        if (result['source'] == 'cache' ||
            result['source'] == 'cache_fallback') {
          _showOfflineMessage('Albums loaded from offline cache');
        }
      } else {
        setState(() => isLoadingAlbums = false);
        _showErrorMessage(result['message'] ?? 'Failed to load albums');
      }
    } catch (e, stack) {
      print('Error in _loadAlbumsByLanguage: $e');
      print('Stack trace: $stack');
      setState(() => isLoadingAlbums = false);
      _showErrorMessage('Error loading albums: ${e.toString()}');
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _groupSongService.dispose();
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
      final groupSongResult = await _groupSongService.searchGroupSongs(query);

      if (mounted) {
        setState(() {
          _isSearching = false;
          if (result['success']) {
            _searchResults = [
              ...(result['artists'] as List<dynamic>? ?? []),
              ...(result['albums'] as List<dynamic>? ?? []),
              ...(result['songs'] as List<dynamic>? ?? []),
              ...(groupSongResult['groupSongs'] as List<dynamic>? ?? []),
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

  Widget _buildGroupSongSearchItem(GroupSongModel groupSong) {
    return ListTile(
      leading: CachedImageWidget(
        imageUrl: groupSong.image,
        width: 50,
        height: 50,
        fit: BoxFit.cover,
        borderRadius: BorderRadius.circular(8),
        errorWidget: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.grey[800],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(Icons.group, color: Colors.white54, size: 24),
        ),
      ),
      title: Text(
        groupSong.songName,
        style: const TextStyle(color: Colors.white),
      ),
      subtitle: Text(
        'Group Song • ${groupSong.artists.map((a) => a.name).join(', ')}',
        style: const TextStyle(color: Colors.white70),
        overflow: TextOverflow.ellipsis,
      ),
      onTap: () {
        // Your navigation logic here
      },
    );
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
            } else if (item is GroupSongModel) {
              // Add this condition
              return _buildGroupSongSearchItem(item);
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
      leading: CachedImageWidget(
        imageUrl: artist.image,
        width: 40,
        height: 40,
        fit: BoxFit.cover,
        borderRadius: BorderRadius.circular(20), // Make it circular
        errorWidget: CircleAvatar(
          radius: 20,
          backgroundColor: Colors.grey[800],
          child: Icon(Icons.person, color: Colors.white54, size: 20),
        ),
      ),
      title: Text(artist.name, style: const TextStyle(color: Colors.white)),
      subtitle: const Text('Artist', style: TextStyle(color: Colors.white70)),
      onTap: () => _navigateToArtistAlbums(artist),
    );
  }

  Widget _buildAlbumSearchItem(AlbumModel album) {
    return ListTile(
      leading: CachedImageWidget(
        imageUrl: album.image,
        width: 50,
        height: 50,
        fit: BoxFit.cover,
        borderRadius: BorderRadius.circular(8),
        errorWidget: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.grey[800],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(Icons.album, color: Colors.white54, size: 24),
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
      leading: CachedImageWidget(
        imageUrl: song.image ?? song.albumImage,
        width: 50,
        height: 50,
        fit: BoxFit.cover,
        borderRadius: BorderRadius.circular(8),
        errorWidget: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.grey[800],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(Icons.music_note, color: Colors.white54, size: 24),
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
                  backgroundImage: song.image ?? song.albumImage ?? '',
                  song: song.songname,
                  artist: song.artistName ?? 'Unknown Artist',
                  id: song.id!,
                ),
          ),
        );
      },
    );
  }

  Widget _buildGroupSongCard(GroupSongModel groupSong) {
    return SizedBox(
      width: 110,
      child: Column(
        children: [
          CachedImageWidget(
            imageUrl: groupSong.image,
            width: 110,
            height: 110,
            fit: BoxFit.cover,
            borderRadius: BorderRadius.circular(12),
            placeholder: Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white54),
                ),
              ),
            ),
            errorWidget: Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.group, color: Colors.white54, size: 40),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            groupSong.songName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
          Text(
            '${groupSong.artists.length} Artists',
            style: const TextStyle(color: Colors.white70, fontSize: 12),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // Add this method to navigate to group song
  void _navigateToGroupSong(GroupSongModel groupSong) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => MusicPlayer(
              backgroundImage: groupSong.image,
              song: groupSong.songName,
              id: groupSong.id,
              artists: groupSong.artists,
            ),
      ),
    );
  }

  Widget _buildFeaturedAlbumsCarousel() {
    if (latestAlbums.isEmpty) {
      return const SizedBox(height: 140);
    }

    return Column(
      children: [
        // Add padding to give space for the overflowing image
        Padding(
          padding: const EdgeInsets.only(
            top: 0.0,
          ), // More space for image overflow
          child: SizedBox(
            height: 200, // Increase total height to accommodate overflow
            child: CarouselSlider.builder(
              carouselController: _carouselController,
              itemCount: latestAlbums.length,
              options: CarouselOptions(
                height: 160,
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
                        clipBehavior: Clip.none, // Allow overflow
                        children: [
                          // Artist Image - positioned to extend out from top
                          Positioned(
                            right: 15,
                            top: 0, // More negative value to extend further out
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: SizedBox(
                                width: 120,
                                height: 160, // Taller image
                                child:
                                    album.artistImage != null
                                        ? CachedImageWidget(
                                          imageUrl: album.artistImage,
                                          width: 120,
                                          height: 160,
                                          fit: BoxFit.cover,
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          errorWidget: Container(
                                            width: 120,
                                            height: 160,
                                            decoration: BoxDecoration(
                                              color: Colors.grey[800],
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: Icon(
                                              Icons.person,
                                              color: Colors.white54,
                                              size: 40,
                                            ),
                                          ),
                                        )
                                        : Image.asset(
                                          'assets/hero.png',
                                          fit: BoxFit.cover,
                                        ),
                              ),
                            ),
                          ),
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
                                    width:
                                        MediaQuery.of(context).size.width * 0.5,
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
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
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
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ArtistPage(),
                            ),
                          );
                        },
                        icon: Icon(Icons.arrow_forward_ios_rounded),
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
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AblumPage(),
                            ),
                          );
                        },
                        icon: Icon(Icons.arrow_forward_ios_rounded),
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

                //group songs
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Worship Teams & Collaborations',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (isLoadingGroupSongs)
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
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const WorshipTeam(),
                            ),
                          );
                        },
                        icon: Icon(Icons.arrow_forward_ios_rounded),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 15),

                // Albums Grid
                SizedBox(
                  height: 160,
                  child:
                      isLoadingGroupSongs
                          ? const Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                          : groupSongs.isEmpty
                          ? const Center(
                            child: Text(
                              'No group songs found',
                              style: TextStyle(color: Colors.white70),
                            ),
                          )
                          : ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            itemCount: groupSongs.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: EdgeInsets.only(
                                  right: index < groupSongs.length - 1 ? 15 : 0,
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    _navigateToGroupSong(groupSongs[index]);
                                  },
                                  child: _buildGroupSongCard(groupSongs[index]),
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
    final drawerBgColor = ThemeService.getDrawerBackgroundColor(
      selectedTheme,
      isAutomaticTheme,
    );
    final headerBgColor = ThemeService.getProfileHeaderColor(
      selectedTheme,
      isAutomaticTheme,
    );
    Color fColor;

    if (isAutomaticTheme) {
      // Use system theme to determine color
      final systemBrightness =
          WidgetsBinding.instance.window.platformBrightness;
      fColor =
          systemBrightness == Brightness.dark ? Colors.white : Colors.black;
    } else {
      // Use selected theme
      fColor = selectedTheme == 'Light' ? Colors.black : Colors.white;
    }
    return Drawer(
      backgroundColor: drawerBgColor,
      child: Column(
        children: [
          // Profile Header - FIXED SECTION
          Container(
            height: MediaQuery.of(context).size.height * 0.2,
            padding: EdgeInsets.only(top: 40, left: 20, right: 20, bottom: 20),
            decoration: BoxDecoration(
              color: headerBgColor,
              image: DecorationImage(
                image: AssetImage('assets/drawer.jpg'),
                fit: BoxFit.cover,
                alignment: Alignment.center,
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.4),
                  BlendMode.srcOver, // Try this instead of BlendMode.darken
                ),
              ),
            ),
            child: Row(
              children: [
                // Profile Avatar and Name Column
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Profile Image
                      CachedImageWidget(
                        imageUrl: profileImageUrl,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        borderRadius: BorderRadius.circular(
                          30,
                        ), // Make it circular
                        errorWidget: CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.grey[600],
                          child: const Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 35,
                          ),
                        ),
                      ),
                      SizedBox(height: 7),
                      // Profile Name
                      SizedBox(
                        width: 150,
                        child: Text(
                          _profileDetails?['fullname'] ?? '',
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
                  onTap: () async {
                    Navigator.pop(context);
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LanguageScreen()),
                    );

                    // If language was changed, refresh the home page
                    if (result != null && result != currentLanguage) {
                      print(
                        'Language changed from $currentLanguage to $result',
                      );
                      _loadData(); // Refresh all data
                    }
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
                  onTap: () async {
                    Navigator.pop(context);
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SettingsScreen()),
                    );

                    if (result != null) {
                      // Reload theme settings after returning from settings
                      await _loadThemeSettings();
                      _loadData(); // Refresh all data
                    }
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
                _buildDrawerItem(
                  Icons.info_outline,
                  'About this App',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AboutApp()),
                    );
                  },
                ),
                Divider(color: Colors.white, thickness: 1),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        textAlign: TextAlign.center,
                        'A Vision by Johnson Shan',

                        style: TextStyle(color: fColor),
                      ),
                      Text(
                        textAlign: TextAlign.center,
                        'Designed & Developed by JS Christian Productions ',
                        style: TextStyle(color: fColor),
                      ),
                      Text(
                        textAlign: TextAlign.center,
                        ' www.therockofpraise.org ',
                        style: TextStyle(color: Colors.lightBlue),
                      ),
                      Text(
                        textAlign: TextAlign.center,
                        '© 2025 The Rock of Praise. All rights reserved.',
                        style: TextStyle(color: fColor),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
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
    Color fColor;

    if (isAutomaticTheme) {
      // Use system theme to determine color
      final systemBrightness =
          WidgetsBinding.instance.window.platformBrightness;
      fColor =
          systemBrightness == Brightness.dark ? Colors.white : Colors.black;
    } else {
      // Use selected theme
      fColor = selectedTheme == 'Light' ? Colors.black : Colors.white;
    }

    return ListTile(
      leading: Icon(icon, color: fColor, size: 24),
      trailing: isPremium ? Icon(Icons.lock, color: fColor, size: 20) : null,
      title: Text(
        title,
        style: TextStyle(
          color: fColor,
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
    print('artist details ${artist.image}');
    return SizedBox(
      width: 110,
      child: Column(
        children: [
          CachedImageWidget(
            imageUrl: artist.image,
            width: 110,
            height: 110,
            fit: BoxFit.cover,
            borderRadius: BorderRadius.circular(12),
            placeholder: Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white54),
                ),
              ),
            ),
            errorWidget: Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.person, color: Colors.white54, size: 40),
            ),
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
          CachedImageWidget(
            imageUrl: album.image,
            width: 110,
            height: 110,
            fit: BoxFit.cover,
            borderRadius: BorderRadius.circular(12),
            placeholder: Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white54),
                ),
              ),
            ),
            errorWidget: Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.album, color: Colors.white54, size: 40),
            ),
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
