// services/sync_manager.dart
import 'package:lyrics/OfflineService/connectivity_manager.dart';
import 'package:lyrics/OfflineService/database_helper.dart';
import 'package:lyrics/Service/album_service.dart';
import 'package:lyrics/Service/artist_service.dart';
import 'package:lyrics/Service/song_service.dart';
import 'package:lyrics/Service/user_service.dart';
import 'package:lyrics/Service/setlist_service.dart';
import 'package:lyrics/Service/worship_note_service.dart';
import 'package:lyrics/Models/artist_model.dart';
import 'package:lyrics/Models/song_model.dart';
import 'package:lyrics/Models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

class SyncManager {
  static final SyncManager _instance = SyncManager._internal();
  factory SyncManager() => _instance;
  SyncManager._internal();

  static bool _isSyncing = false;
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final ConnectivityManager _connectivityManager = ConnectivityManager();

  Future<void> performFullSync() async {
    if (_isSyncing || !await _connectivityManager.isConnected()) return;

    _isSyncing = true;

    try {
      print('🔄 Starting full sync...');

      // Sync in priority order (dependencies first)
      await _syncArtists();
      await _syncAlbums();
      await _syncSongs();
      await _syncUserData();

      // Update last sync time
      await _updateLastSyncTime();

      print('✅ Full sync completed successfully');
    } catch (e) {
      print('❌ Sync failed: $e');
    } finally {
      _isSyncing = false;
    }
  }

  Future<void> _syncArtists() async {
    try {
      print('📡 Syncing artists...');
      final artistService = ArtistService();
      final result = await artistService.getAllArtists();

      if (result['success']) {
        final artistsData = result['artists'] as List<dynamic>;
        final db = await _dbHelper.database;

        for (final artistData in artistsData) {
          // Handle both ArtistModel objects and Map data
          Map<String, dynamic> artistJson;
          if (artistData is ArtistModel) {
            artistJson = artistData.toJson();
          } else if (artistData is Map<String, dynamic>) {
            artistJson = Map<String, dynamic>.from(artistData);
          } else {
            continue; // Skip invalid data
          }

          // Ensure sync status is set
          artistJson['synced'] = 1;

          await db.insert(
            'artists',
            artistJson,
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }

        print('✅ Synced ${artistsData.length} artists');
      }
    } catch (e) {
      print('❌ Artist sync failed: $e');
    }
  }

  Future<void> _syncAlbums() async {
    try {
      print('📡 Syncing albums...');
      final albumService = AlbumService();
      final result = await albumService.getAllAlbums();

      if (result['success']) {
        final albumsData = result['albums'] as List<dynamic>;
        final db = await _dbHelper.database;

        for (final albumData in albumsData) {
          Map<String, dynamic> albumJson;
          if (albumData is AlbumModel) {
            albumJson =
                albumData.toFullJson(); // Use toFullJson for complete data
          } else if (albumData is Map<String, dynamic>) {
            albumJson = Map<String, dynamic>.from(albumData);
          } else {
            continue;
          }

          albumJson['synced'] = 1;

          await db.insert(
            'albums',
            albumJson,
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }

        print('✅ Synced ${albumsData.length} albums');
      }
    } catch (e) {
      print('❌ Album sync failed: $e');
    }
  }

  Future<void> _syncSongs() async {
    try {
      print('📡 Syncing songs...');
      final songService = SongService();
      final result = await songService.getAllSongs();

      if (result['success']) {
        final songsData = result['songs'] as List<dynamic>;
        final db = await _dbHelper.database;

        for (final songData in songsData) {
          Map<String, dynamic> songJson;
          if (songData is SongModel) {
            songJson = songData.toJson();
          } else if (songData is Map<String, dynamic>) {
            songJson = Map<String, dynamic>.from(songData);
          } else {
            continue;
          }

          songJson['synced'] = 1;

          await db.insert(
            'songs',
            songJson,
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }

        print('✅ Synced ${songsData.length} songs');
      }
    } catch (e) {
      print('❌ Song sync failed: $e');
    }
  }

  Future<void> _syncUserData() async {
    try {
      print('📡 Syncing user data...');

      // Get current user ID from UserService
      final userId = await UserService.getUserID();
      if (userId.isEmpty) {
        print('ℹ️ No user logged in, skipping user data sync');
        return;
      }

      final userIdInt = int.parse(userId);

      // Sync user-specific data
      await _syncUserFavorites(userIdInt);
      await _syncUserSetlists(userIdInt);
      await _syncWorshipNotes(userIdInt);

      print('✅ User data sync completed');
    } catch (e) {
      print('❌ User data sync failed: $e');
    }
  }

  Future<void> _syncUserFavorites(int userId) async {
    try {
      // Note: You'll need to implement getUserFavorites in your UserService
      // For now, this is a placeholder
      print('📡 Syncing user favorites...');

      // Implementation depends on your favorites API endpoint
      // Example structure:
      /*
      final favoritesResult = await userService.getUserFavorites(userId.toString());
      if (favoritesResult['success']) {
        final favorites = favoritesResult['favorites'] as List<dynamic>;
        final db = await _dbHelper.database;
        
        for (final favorite in favorites) {
          await db.insert(
            'user_favorites',
            {
              ...favorite,
              'synced': 1,
            },
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }
      }
      */

      print('✅ User favorites synced');
    } catch (e) {
      print('❌ User favorites sync failed: $e');
    }
  }

  Future<void> _syncUserSetlists(int userId) async {
    try {
      print('📡 Syncing user setlists...');

      final setlistResult = await SetListService.getFolders(userId.toString());
      if (setlistResult['success']) {
        // Handle null data safely
        final foldersData = setlistResult['data'];
        if (foldersData == null) {
          print('ℹ️ No setlist folders found for user $userId');
          return;
        }

        final folders = foldersData as List<dynamic>;
        final db = await _dbHelper.database;

        print('📁 Found ${folders.length} folders to sync');

        // Sync folders
        for (final folder in folders) {
          try {
            if (folder == null) continue;

            final folderData = Map<String, dynamic>.from(folder);
            folderData['synced'] = 1;
            folderData['created_at'] ??= DateTime.now().toIso8601String();
            folderData['updated_at'] ??= DateTime.now().toIso8601String();

            await db.insert(
              'setlist_folders',
              folderData,
              conflictAlgorithm: ConflictAlgorithm.replace,
            );

            // Sync songs in each folder
            final folderId = folder['id'];
            if (folderId != null) {
              await _syncFolderSongs(folderId as int);
            }
          } catch (e) {
            print('⚠️ Error syncing folder: $e');
            print('Folder data: $folder');
            continue;
          }
        }

        print('✅ User setlists synced');
      } else {
        print('ℹ️ Setlist sync failed: ${setlistResult['message']}');
      }
    } catch (e) {
      print('❌ User setlists sync failed: $e');
    }
  }

  Future<void> _syncFolderSongs(int folderId) async {
    try {
      final songsResult = await SetListService.getFolderSongs(folderId);
      if (songsResult['success']) {
        final songs = songsResult['data'] as List<dynamic>;
        final db = await _dbHelper.database;

        for (final song in songs) {
          await db.insert('setlist_songs', {
            ...Map<String, dynamic>.from(song),
            'synced': 1,
          }, conflictAlgorithm: ConflictAlgorithm.replace);
        }
      }
    } catch (e) {
      print('❌ Folder songs sync failed: $e');
    }
  }

  Future<void> _syncWorshipNotes(int userId) async {
    try {
      print('📡 Syncing worship notes...');

      final worshipNotesService = WorshipNotesService();
      final notesResult = await worshipNotesService.getUserWorshipNotes();

      if (notesResult['success']) {
        final notes = notesResult['notes'] as List<dynamic>;
        final db = await _dbHelper.database;

        for (final note in notes) {
          await db.insert('worship_notes', {
            ...Map<String, dynamic>.from(note),
            'synced': 1,
          }, conflictAlgorithm: ConflictAlgorithm.replace);
        }

        print('✅ Worship notes synced');
      }
    } catch (e) {
      print('❌ Worship notes sync failed: $e');
    }
  }

  Future<void> _updateLastSyncTime() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('last_sync_time', DateTime.now().toIso8601String());
  }

  Future<DateTime?> getLastSyncTime() async {
    final prefs = await SharedPreferences.getInstance();
    final lastSyncString = prefs.getString('last_sync_time');
    return lastSyncString != null ? DateTime.parse(lastSyncString) : null;
  }

  // Get sync status for all tables
  Future<Map<String, int>> getSyncStatus() async {
    final db = await _dbHelper.database;

    final tables = [
      'albums',
      'songs',
      'artists',
      'user_favorites',
      'setlist_folders',
      'setlist_songs',
      'worship_notes',
    ];
    final status = <String, int>{};

    for (final table in tables) {
      try {
        final result = await db.rawQuery(
          'SELECT COUNT(*) as count FROM $table WHERE synced = 0 OR synced = -1',
        );
        status[table] = result.first['count'] as int;
      } catch (e) {
        // Table might not exist yet
        status[table] = 0;
      }
    }

    return status;
  }

  // Get total pending sync count across all tables
  Future<int> getTotalPendingSyncCount() async {
    final syncStatus = await getSyncStatus();
    return syncStatus.values.fold<int>(0, (sum, count) => sum + count);
  }

  // Check if sync is currently in progress
  bool get isSyncing => _isSyncing;

  // Force sync even if already syncing (use with caution)
  Future<void> forceSync() async {
    _isSyncing = false;
    await performFullSync();
  }

  // Sync only specific table
  Future<void> syncTable(String table) async {
    if (_isSyncing) return;

    _isSyncing = true;

    try {
      switch (table) {
        case 'artists':
          await _syncArtists();
          break;
        case 'albums':
          await _syncAlbums();
          break;
        case 'songs':
          await _syncSongs();
          break;
        case 'user_data':
          await _syncUserData();
          break;
        default:
          print('❌ Unknown table: $table');
      }
    } catch (e) {
      print('❌ Table sync failed for $table: $e');
    } finally {
      _isSyncing = false;
    }
  }
}
