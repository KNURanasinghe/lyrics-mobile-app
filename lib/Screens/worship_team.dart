import 'package:flutter/material.dart';
import 'package:lyrics/Models/artist_model.dart';
import 'package:lyrics/OfflineService/connectivity_manager.dart';
import 'package:lyrics/OfflineService/offline_groupe_service.dart';
import 'package:lyrics/Screens/DrawerScreens/premium_screen.dart';
import 'package:lyrics/Service/language_service.dart';
import 'package:lyrics/Screens/music_player.dart';
import 'package:lyrics/Service/user_service.dart';
import 'package:lyrics/widgets/cached_image_widget.dart';
import 'package:lyrics/widgets/main_background.dart';

class WorshipTeam extends StatefulWidget {
  const WorshipTeam({super.key});

  @override
  State<WorshipTeam> createState() => _WorshipTeamState();
}

class _WorshipTeamState extends State<WorshipTeam> {
  final OfflineGroupSongService _groupSongService = OfflineGroupSongService();
  final TextEditingController _searchController = TextEditingController();
  final ConnectivityManager _connectivityManager = ConnectivityManager();

  List<GroupSongModel> allGroupSongs = [];
  List<GroupSongModel> filteredGroupSongs = [];
  bool isLoading = true;
  String? errorMessage;
  String? currentLanguage;
  String? languageDisplayName;

  @override
  void initState() {
    super.initState();
    _loadAllGroupSongs();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _groupSongService.dispose();
    super.dispose();
  }

  Future<void> _loadAllGroupSongs() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      // Get the current language
      final lang = await LanguageService.getLanguage();
      final langcode = LanguageService.getLanguageCode(lang);

      // Load group songs by language
      final result = await _groupSongService.getGroupSongsByLanguage(langcode);

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
          allGroupSongs = loadedGroupSongs;
          filteredGroupSongs = List.from(allGroupSongs);
          currentLanguage = result['language'];
          languageDisplayName = result['languageDisplayName'];
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = result['message'] ?? 'Failed to load worship songs';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error loading worship songs: ${e.toString()}';
        isLoading = false;
      });
    }
  }

  void _filterGroupSongs(String query) {
    setState(() {
      if (query.trim().isEmpty) {
        filteredGroupSongs = List.from(allGroupSongs);
      } else {
        filteredGroupSongs =
            allGroupSongs
                .where(
                  (groupSong) =>
                      groupSong.songName.toLowerCase().contains(
                        query.toLowerCase(),
                      ) ||
                      groupSong.artists.any(
                        (artist) => artist.name.toLowerCase().contains(
                          query.toLowerCase(),
                        ),
                      ),
                )
                .toList();
      }
    });
  }

  void _showPremiumDialog({
    bool isOffline = false,
    String feature = 'this content',
  }) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[900],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: Colors.amber.withOpacity(0.3), width: 1),
          ),
          title: Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  isOffline ? Icons.wifi_off : Icons.star,
                  color: Colors.amber,
                  size: 24,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  isOffline ? 'Offline Access Restricted' : 'Premium Required',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Main message
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.amber.withOpacity(0.1),
                        Colors.orange.withOpacity(0.1),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.amber.withOpacity(0.3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (isOffline) ...[
                        Row(
                          children: [
                            Icon(
                              Icons.wifi_off,
                              color: Colors.orange,
                              size: 20,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'You are currently offline',
                              style: TextStyle(
                                color: Colors.orange,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                        Text(
                          'To access $feature while offline, you need a Premium subscription.',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                            height: 1.4,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Connect to the internet and upgrade to Premium for full offline access.',
                          style: TextStyle(color: Colors.white60, fontSize: 14),
                        ),
                      ] else ...[
                        Text(
                          'Access to $feature requires a Premium subscription.',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                SizedBox(height: 20),

                // Premium features list
                Text(
                  'Premium Features Include:',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 12),

                ...premiumFeatures.map(
                  (feature) => _buildPremiumFeatureItem(feature),
                ),

                SizedBox(height: 16),

                // Special offline benefits
                if (isOffline) ...[
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.blue.withOpacity(0.3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.offline_bolt,
                              color: Colors.blue,
                              size: 16,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Offline Benefits',
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text(
                          '• Access all content without internet\n• Auto-sync when connection returns\n• Seamless offline experience',
                          style: TextStyle(color: Colors.white70, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          actions: [
            // Maybe Later button
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(foregroundColor: Colors.white70),
              child: Text(
                isOffline ? 'Use Online Only' : 'Maybe Later',
                style: TextStyle(fontSize: 14),
              ),
            ),

            // Connect to Internet button (only for offline)
            if (isOffline) ...[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _showConnectivityInstructions();
                },
                style: TextButton.styleFrom(foregroundColor: Colors.blue),
                child: Text(
                  'Connect to Internet',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ),
            ],

            // Buy Now / Upgrade button
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _navigateToPremiumUpgrade();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
                foregroundColor: Colors.black,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.upgrade, size: 18),
                  SizedBox(width: 8),
                  Text(
                    isOffline ? 'Get Premium' : 'Buy Now',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  // Premium features list
  final List<String> premiumFeatures = [
    'Unlimited offline access',
    'Download songs & albums',
    'No advertisements',
    'High quality audio',
    'Exclusive premium content',
    'Priority customer support',
  ];

  Widget _buildPremiumFeatureItem(String feature) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: Colors.amber,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              feature,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Navigate to premium upgrade screen
  void _navigateToPremiumUpgrade() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PremiumScreen()),
    );
  }

  // Show connectivity instructions
  void _showConnectivityInstructions() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[900],
          title: Row(
            children: [
              Icon(Icons.wifi, color: Colors.blue, size: 24),
              SizedBox(width: 12),
              Text(
                'Connect to Internet',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'To upgrade to Premium and enable offline features:',
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
              SizedBox(height: 16),
              _buildConnectivityStep('1', 'Connect to Wi-Fi or mobile data'),
              _buildConnectivityStep('2', 'Tap "Get Premium" to upgrade'),
              _buildConnectivityStep('3', 'Enjoy unlimited offline access'),
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue, size: 16),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Premium subscription requires internet connection for initial setup.',
                        style: TextStyle(color: Colors.blue, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Got it', style: TextStyle(color: Colors.blue)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildConnectivityStep(String step, String description) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                step,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              description,
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToGroupSong(GroupSongModel groupSong) async {
    final isConnected = await _connectivityManager.isConnected();
    final isPremiumStr = await UserService.getIsPremium();
    final isPremium = isPremiumStr == '1';

    // Check for offline + non-premium
    if (!isConnected && !isPremium) {
      _showPremiumDialog(isOffline: true, feature: 'artist content');
      return;
    }

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

  Widget _buildGroupSongCard(GroupSongModel groupSong) {
    return GestureDetector(
      onTap: () => _navigateToGroupSong(groupSong),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Group Song Image
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.all(8),
                child: CachedImageWidget(
                  imageUrl: groupSong.image,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                  borderRadius: BorderRadius.circular(8),
                  placeholder: Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: SizedBox(
                        width: 30,
                        height: 30,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white54,
                          ),
                        ),
                      ),
                    ),
                  ),
                  errorWidget: Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.group,
                      color: Colors.white54,
                      size: 40,
                    ),
                  ),
                ),
              ),
            ),

            // Group Song Info
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      groupSong.songName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      groupSong.artists.isNotEmpty
                          ? '${groupSong.artists.length} Artists'
                          : 'Unknown Artists',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MainBAckgound(
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Worship Teams',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    if (languageDisplayName != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          languageDisplayName!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                  ],
                ),
              ),

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
                      hintText: 'Search worship songs or artists...',
                      hintStyle: TextStyle(color: Colors.white70, fontSize: 14),
                      prefixIcon: Icon(Icons.search, color: Colors.white54),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 15,
                      ),
                    ),
                    onChanged: _filterGroupSongs,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Group Songs Count
              if (!isLoading)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    children: [
                      Text(
                        '${filteredGroupSongs.length} Worship Songs',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 15),

              // Content Area
              Expanded(child: _buildContent()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
            SizedBox(height: 16),
            Text(
              'Loading worship songs...',
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
          ],
        ),
      );
    }

    if (errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 64),
            const SizedBox(height: 16),
            Text(
              errorMessage!,
              style: const TextStyle(color: Colors.white, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadAllGroupSongs,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white.withOpacity(0.2),
                foregroundColor: Colors.white,
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (filteredGroupSongs.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _searchController.text.isNotEmpty
                  ? Icons.search_off
                  : Icons.group_outlined,
              color: Colors.white54,
              size: 64,
            ),
            const SizedBox(height: 16),
            Text(
              _searchController.text.isNotEmpty
                  ? 'No worship songs found for "${_searchController.text}"'
                  : 'No worship songs available',
              style: const TextStyle(color: Colors.white70, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            if (_searchController.text.isNotEmpty) ...[
              const SizedBox(height: 8),
              TextButton(
                onPressed: () {
                  _searchController.clear();
                  _filterGroupSongs('');
                },
                child: const Text(
                  'Clear search',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadAllGroupSongs,
      color: Colors.white,
      backgroundColor: Colors.black54,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: GridView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.8, // Adjust this to make cards taller/shorter
          ),
          itemCount: filteredGroupSongs.length,
          itemBuilder: (context, index) {
            return _buildGroupSongCard(filteredGroupSongs[index]);
          },
        ),
      ),
    );
  }
}
