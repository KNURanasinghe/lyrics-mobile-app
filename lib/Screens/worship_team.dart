import 'package:flutter/material.dart';
import 'package:lyrics/Models/artist_model.dart';
import 'package:lyrics/OfflineService/offline_groupe_service.dart';
import 'package:lyrics/Service/language_service.dart';
import 'package:lyrics/Screens/music_player.dart';
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
