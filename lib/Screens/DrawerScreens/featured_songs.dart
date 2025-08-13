import 'package:flutter/material.dart';
import 'package:lyrics/Service/favorites_service.dart';
import 'package:lyrics/Service/user_service.dart';
import 'package:lyrics/Screens/music_player.dart';
import 'package:lyrics/widgets/main_background.dart'; // Adjust import path

class FeaturedSongs extends StatefulWidget {
  const FeaturedSongs({super.key});

  @override
  State<FeaturedSongs> createState() => _FeaturedSongsState();
}

class _FeaturedSongsState extends State<FeaturedSongs> {
  List<FavoriteSong> favoriteSongs = [];
  FavoriteStats? stats;
  bool isLoading = true;
  bool isLoadingMore = false;
  String? currentUserId;

  final ScrollController _scrollController = ScrollController();
  final int _pageSize = 20;
  int _currentOffset = 0;
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    _initializeFavorites();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      if (!isLoadingMore && _hasMore) {
        _loadMoreFavorites();
      }
    }
  }

  Future<void> _initializeFavorites() async {
    try {
      currentUserId = await UserService.getUserID();
      if (currentUserId != null) {
        await _loadFavorites();
        await _loadStats();
      }
    } catch (e) {
      print('Error initializing favorites: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _loadFavorites({bool isRefresh = false}) async {
    if (currentUserId == null) return;

    if (isRefresh) {
      setState(() {
        _currentOffset = 0;
        _hasMore = true;
        favoriteSongs.clear();
      });
    }

    setState(() {
      if (isRefresh) {
        isLoading = true;
      } else {
        isLoadingMore = true;
      }
    });

    try {
      final result = await FavoritesService.getFavorites(
        currentUserId!,
        limit: _pageSize,
        offset: _currentOffset,
      );

      if (result['success'] == true) {
        final List<FavoriteSong> newFavorites =
            (result['favorites'] as List)
                .map((favoriteJson) => FavoriteSong.fromJson(favoriteJson))
                .toList();

        setState(() {
          if (isRefresh) {
            favoriteSongs = newFavorites;
          } else {
            favoriteSongs.addAll(newFavorites);
          }

          _currentOffset += _pageSize;
          _hasMore = newFavorites.length == _pageSize;
        });
      } else {
        _showErrorSnackBar(result['message'] ?? 'Failed to load favorites');
      }
    } catch (e) {
      _showErrorSnackBar('Error loading favorites: $e');
    } finally {
      setState(() {
        isLoading = false;
        isLoadingMore = false;
      });
    }
  }

  Future<void> _loadMoreFavorites() async {
    await _loadFavorites();
  }

  Future<void> _loadStats() async {
    if (currentUserId == null) return;

    try {
      final result = await FavoritesService.getFavoriteStats(currentUserId!);
      if (result['success'] == true) {
        setState(() {
          stats = FavoriteStats.fromJson(result);
        });
      }
    } catch (e) {
      print('Error loading stats: $e');
    }
  }

  Future<void> _removeFavorite(FavoriteSong song) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF2A2A2A),
          title: const Text(
            'Remove Favorite',
            style: TextStyle(color: Colors.white),
          ),
          content: Text(
            'Remove "${song.songName}" from favorites?',
            style: const TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.white70),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Remove'),
            ),
          ],
        );
      },
    );

    if (confirm == true && currentUserId != null) {
      try {
        final result = await FavoritesService.removeFromFavorites(
          userId: currentUserId!,
          songId: song.songId,
        );

        if (result['success'] == true) {
          setState(() {
            favoriteSongs.removeWhere((fav) => fav.id == song.id);
          });
          _showSuccessSnackBar('Removed from favorites');
          await _loadStats(); // Refresh stats
        } else {
          _showErrorSnackBar(result['message'] ?? 'Failed to remove favorite');
        }
      } catch (e) {
        _showErrorSnackBar('Error removing favorite: $e');
      }
    }
  }

  void _navigateToMusicPlayer(FavoriteSong song) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => MusicPlayer(
              id: song.id,
              backgroundImage: song.songImage ?? 'assets/Rectangle 29.png',
              song: song.songName,
              artist: song.artistName,
              lyrics: song.getLyrics(
                'en',
              ), // Default to English, you can make this configurable
              language:
                  'en', // You might want to store preferred language in user settings
            ),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }

  Widget _buildStatsCard() {
    if (stats == null) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.purple.withOpacity(0.3),
            Colors.blue.withOpacity(0.3),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.favorite, color: Colors.red, size: 24),
              const SizedBox(width: 8),
              const Text(
                'Your Music Stats',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  'Favorite Songs',
                  stats!.totalFavorites.toString(),
                  Icons.music_note,
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  'Artists',
                  stats!.favoriteArtists.toString(),
                  Icons.person,
                ),
              ),
            ],
          ),
          if (stats!.topArtists.isNotEmpty) ...[
            const SizedBox(height: 16),
            const Text(
              'Top Artists',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children:
                  stats!.topArtists.take(3).map((artist) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${artist.artistName} (${artist.count})',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
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

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white70, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildSongCard(FavoriteSong song) {
    return Card(
      color: Colors.transparent,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: () => _navigateToMusicPlayer(song),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Song image
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child:
                      song.songImage != null && song.songImage!.isNotEmpty
                          ? (song.songImage!.startsWith('http')
                              ? Image.network(
                                song.songImage!,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return _buildDefaultImage();
                                },
                              )
                              : Image.asset(
                                song.songImage!,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return _buildDefaultImage();
                                },
                              ))
                          : _buildDefaultImage(),
                ),
              ),
              const SizedBox(width: 16),
              // Song details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      song.songName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      song.artistName,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        if (song.duration != null) ...[
                          Icon(
                            Icons.access_time,
                            color: Colors.white54,
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            song.formattedDuration,
                            style: const TextStyle(
                              color: Colors.white54,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(width: 16),
                        ],
                        Icon(Icons.favorite, color: Colors.red, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          'Added ${_getRelativeTime(song.createdAt)}',
                          style: const TextStyle(
                            color: Colors.white54,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Actions
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, color: Colors.white70),
                color: const Color(0xFF3A3A3A),
                onSelected: (value) {
                  if (value == 'remove') {
                    _removeFavorite(song);
                  } else if (value == 'play') {
                    _navigateToMusicPlayer(song);
                  }
                },
                itemBuilder:
                    (BuildContext context) => [
                      const PopupMenuItem<String>(
                        value: 'play',
                        child: Row(
                          children: [
                            Icon(
                              Icons.play_arrow,
                              color: Colors.green,
                              size: 18,
                            ),
                            SizedBox(width: 8),
                            Text('Play', style: TextStyle(color: Colors.white)),
                          ],
                        ),
                      ),
                      const PopupMenuItem<String>(
                        value: 'remove',
                        child: Row(
                          children: [
                            Icon(
                              Icons.favorite_border,
                              color: Colors.red,
                              size: 18,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Remove from Favorites',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDefaultImage() {
    return Container(
      color: Colors.grey[700],
      child: const Icon(Icons.music_note, color: Colors.white, size: 30),
    );
  }

  String _getRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutes ago';
    } else {
      return 'Just now';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF173857),
        title: const Text(
          'Featured Songs',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _loadFavorites(isRefresh: true),
          ),
        ],
      ),
      body: MainBAckgound(
        child:
            isLoading
                ? const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                )
                : currentUserId == null
                ? _buildLoginPrompt()
                : favoriteSongs.isEmpty
                ? _buildEmptyState()
                : RefreshIndicator(
                  color: Colors.white,
                  backgroundColor: const Color(0xFF2A2A2A),
                  onRefresh: () => _loadFavorites(isRefresh: true),
                  child: CustomScrollView(
                    controller: _scrollController,
                    slivers: [
                      // Stats card
                      if (stats != null && stats!.totalFavorites > 0)
                        SliverToBoxAdapter(child: _buildStatsCard()),

                      // Songs list
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            if (index < favoriteSongs.length) {
                              return _buildSongCard(favoriteSongs[index]);
                            } else if (isLoadingMore) {
                              return const Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                ),
                              );
                            } else if (!_hasMore && favoriteSongs.isNotEmpty) {
                              return Container(
                                padding: const EdgeInsets.all(16),
                                child: const Center(
                                  child: Text(
                                    'No more songs to load',
                                    style: TextStyle(
                                      color: Colors.white54,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              );
                            }
                            return const SizedBox.shrink();
                          },
                          childCount:
                              favoriteSongs.length +
                              (isLoadingMore ? 1 : 0) +
                              (!_hasMore && favoriteSongs.isNotEmpty ? 1 : 0),
                        ),
                      ),
                    ],
                  ),
                ),
      ),
    );
  }

  Widget _buildLoginPrompt() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.account_circle, size: 80, color: Colors.white54),
          const SizedBox(height: 16),
          const Text(
            'Please Log In',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Log in to view your favorite songs',
            style: TextStyle(color: Colors.white54, fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              // Navigate to login screen
              // Navigator.pushNamed(context, '/login');
            },
            icon: const Icon(Icons.login),
            label: const Text('Log In'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_border, size: 80, color: Colors.white54),
          const SizedBox(height: 16),
          const Text(
            'No Favorite Songs Yet',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Start adding songs to your favorites\nby tapping the heart icon while listening',
            style: TextStyle(color: Colors.white54, fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              // Navigate back or to song browser
              Navigator.pop(context);
            },
            icon: const Icon(Icons.explore),
            label: const Text('Explore Songs'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
}
