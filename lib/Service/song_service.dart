import 'package:lyrics/Service/base_api.dart';

class SongModel {
  final int? id;
  final String songname;
  final String? lyricsSi;
  final String? lyricsEn;
  final String? lyricsTa;
  final int artistId;
  final int? albumId;
  final int? duration;
  final int? trackNumber;
  final String? artistName;
  final String? artistImage;
  final String? albumName;
  final String? image;
  final String? albumImage;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  SongModel({
    this.id,
    required this.songname,
    this.lyricsSi,
    this.lyricsEn,
    this.lyricsTa,
    required this.artistId,
    this.albumId,
    this.duration,
    this.trackNumber,
    this.artistName,
    this.artistImage,
    this.albumName,
    this.albumImage,
    this.createdAt,
    this.image,
    this.updatedAt,
  });

  factory SongModel.fromJson(Map<String, dynamic> json) {
    return SongModel(
      id: json['id'],
      songname: json['songname'] ?? '',
      lyricsSi: json['lyrics_si'],
      lyricsEn: json['lyrics_en'],
      lyricsTa: json['lyrics_ta'],
      artistId: json['artist_id'] ?? 0,
      albumId: json['album_id'],
      duration: json['duration'],
      trackNumber: json['track_number'],
      artistName: json['artist_name'],
      artistImage: json['artist_image'],
      albumName: json['album_name'],
      albumImage: json['album_image'],
      image: json['image'],
      createdAt:
          json['created_at'] != null
              ? DateTime.parse(json['created_at'])
              : null,
      updatedAt:
          json['updated_at'] != null
              ? DateTime.parse(json['updated_at'])
              : null,
    );
  }

  Map<String, dynamic> toCreateJson() {
    return {
      'songname': songname,
      'lyrics_si': lyricsSi,
      'lyrics_en': lyricsEn,
      'lyrics_ta': lyricsTa,
      'artist_id': artistId,
      'album_id': albumId,
      'duration': duration,
      'track_number': trackNumber,
      'image': image,
    };
  }

  // Get formatted duration
  String get formattedDuration {
    if (duration == null) return '--:--';
    final minutes = duration! ~/ 60;
    final seconds = duration! % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  // Check if lyrics exist for a language
  bool hasLyrics(String language) {
    switch (language.toLowerCase()) {
      case 'si':
        return lyricsSi != null && lyricsSi!.isNotEmpty;
      case 'en':
        return lyricsEn != null && lyricsEn!.isNotEmpty;
      case 'ta':
        return lyricsTa != null && lyricsTa!.isNotEmpty;
      default:
        return false;
    }
  }

  // Get lyrics by language
  String? getLyrics(String language) {
    switch (language.toLowerCase()) {
      case 'si':
        return lyricsSi;
      case 'en':
        return lyricsEn;
      case 'ta':
        return lyricsTa;
      default:
        return null;
    }
  }
}

class LyricsModel {
  final int id;
  final String songname;
  final String language;
  final String lyrics;
  final String artistName;
  final String? albumName;

  LyricsModel({
    required this.id,
    required this.songname,
    required this.language,
    required this.lyrics,
    required this.artistName,
    this.albumName,
  });

  factory LyricsModel.fromJson(Map<String, dynamic> json) {
    return LyricsModel(
      id: json['id'],
      songname: json['songname'] ?? '',
      language: json['language'] ?? '',
      lyrics: json['lyrics'] ?? '',
      artistName: json['artist_name'] ?? '',
      albumName: json['album_name'],
    );
  }
}

class SongService {
  final BaseApiService _apiService;

  SongService({BaseApiService? apiService})
    : _apiService = apiService ?? BaseApiService();

  // Get all songs
  Future<Map<String, dynamic>> getAllSongs() async {
    try {
      final result = await _apiService.get('/songs');

      if (result['success']) {
        final List<dynamic> songsData = result['data']['data'] ?? [];
        final List<SongModel> songs =
            songsData.map((json) => SongModel.fromJson(json)).toList();

        return {
          'success': true,
          'songs': songs,
          'message': 'Songs fetched successfully',
        };
      } else {
        return {
          'success': false,
          'message': result['message'] ?? 'Failed to fetch songs',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred: ${e.toString()}',
      };
    }
  }

  // Get song lyrics by language
  Future<Map<String, dynamic>> getSongLyrics(
    String songTitle,
    String languageCode,
  ) async {
    try {
      final result = await _apiService.get(
        '/songs/lyrics?title=${Uri.encodeComponent(songTitle)}&language=$languageCode',
      );
      print('lyrics ; $result');
      if (result['success']) {
        return {
          'success': true,
          'lyrics': result['data']['lyrics'],
          'message': 'Lyrics fetched successfully',
        };
      } else {
        return {
          'success': false,
          'message': result['message'] ?? 'Lyrics not found',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred: ${e.toString()}',
      };
    }
  }

  // Get random songs
  Future<Map<String, dynamic>> getRandomSongs({int count = 10}) async {
    try {
      if (count > 50) {
        return {'success': false, 'message': 'Maximum 50 songs allowed'};
      }

      final result = await _apiService.get('/songs/random/$count');

      if (result['success']) {
        final List<dynamic> songsData = result['data']['data'] ?? [];
        final List<SongModel> songs =
            songsData.map((json) => SongModel.fromJson(json)).toList();

        return {
          'success': true,
          'songs': songs,
          'message': 'Random songs fetched successfully',
        };
      } else {
        return {
          'success': false,
          'message': result['message'] ?? 'Failed to fetch random songs',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred: ${e.toString()}',
      };
    }
  }

  // Get default random songs (10 songs)
  Future<Map<String, dynamic>> getDefaultRandomSongs() async {
    try {
      final result = await _apiService.get('/songs/random');

      if (result['success']) {
        final List<dynamic> songsData = result['data']['data'] ?? [];
        final List<SongModel> songs =
            songsData.map((json) => SongModel.fromJson(json)).toList();

        return {
          'success': true,
          'songs': songs,
          'message': 'Random songs fetched successfully',
        };
      } else {
        return {
          'success': false,
          'message': result['message'] ?? 'Failed to fetch random songs',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred: ${e.toString()}',
      };
    }
  }

  // Get songs by category
  Future<Map<String, dynamic>> getSongsByCategory(String category) async {
    try {
      final result = await _apiService.get('/songs/category/$category');

      if (result['success']) {
        final List<dynamic> songsData = result['data']['data'] ?? [];
        final List<SongModel> songs =
            songsData.map((json) => SongModel.fromJson(json)).toList();

        return {
          'success': true,
          'songs': songs,
          'message': 'Category songs fetched successfully',
        };
      } else {
        return {
          'success': false,
          'message': result['message'] ?? 'Failed to fetch category songs',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred: ${e.toString()}',
      };
    }
  }

  // Get songs with specific lyrics language available
  Future<Map<String, dynamic>> getSongsWithLyrics(String language) async {
    try {
      final result = await getAllSongs();

      if (result['success']) {
        final List<SongModel> allSongs = result['songs'];
        final List<SongModel> songsWithLyrics =
            allSongs.where((song) => song.hasLyrics(language)).toList();

        return {
          'success': true,
          'songs': songsWithLyrics,
          'message':
              'Songs with ${language.toUpperCase()} lyrics fetched successfully',
        };
      } else {
        return result;
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred: ${e.toString()}',
      };
    }
  }

  // Dispose
  void dispose() {
    _apiService.dispose();
  }

  // Get song by ID
  Future<Map<String, dynamic>> getSongById(int id) async {
    try {
      final result = await _apiService.get('/songs/$id');

      if (result['success']) {
        final SongModel song = SongModel.fromJson(result['data']['data']);

        return {
          'success': true,
          'song': song,
          'message': 'Song fetched successfully',
        };
      } else {
        return {
          'success': false,
          'message': result['message'] ?? 'Song not found',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred: ${e.toString()}',
      };
    }
  }

  // Create song
  Future<Map<String, dynamic>> createSong(SongModel song) async {
    try {
      final result = await _apiService.post('/songs', song.toCreateJson());

      if (result['success']) {
        final SongModel createdSong = SongModel.fromJson(
          result['data']['data'],
        );

        return {
          'success': true,
          'song': createdSong,
          'message': result['data']['message'] ?? 'Song created successfully',
        };
      } else {
        return {
          'success': false,
          'message': result['message'] ?? 'Failed to create song',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred: ${e.toString()}',
      };
    }
  }

  // Update song
  Future<Map<String, dynamic>> updateSong(int id, SongModel song) async {
    try {
      final result = await _apiService.put('/songs/$id', song.toCreateJson());

      if (result['success']) {
        final SongModel updatedSong = SongModel.fromJson(
          result['data']['data'],
        );

        return {
          'success': true,
          'song': updatedSong,
          'message': result['data']['message'] ?? 'Song updated successfully',
        };
      } else {
        return {
          'success': false,
          'message': result['message'] ?? 'Failed to update song',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred: ${e.toString()}',
      };
    }
  }

  // Delete song
  Future<Map<String, dynamic>> deleteSong(int id) async {
    try {
      final result = await _apiService.delete('/songs/$id');

      if (result['success']) {
        return {
          'success': true,
          'message': result['data']['message'] ?? 'Song deleted successfully',
        };
      } else {
        return {
          'success': false,
          'message': result['message'] ?? 'Failed to delete song',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred: ${e.toString()}',
      };
    }
  }

  // Search songs
  Future<Map<String, dynamic>> searchSongs(String query) async {
    try {
      final result = await _apiService.get('/songs/search/$query');

      if (result['success']) {
        final List<dynamic> songsData = result['data']['data'] ?? [];
        final List<SongModel> songs =
            songsData.map((json) => SongModel.fromJson(json)).toList();

        return {
          'success': true,
          'songs': songs,
          'message': 'Songs search completed successfully',
        };
      } else {
        return {
          'success': false,
          'message': result['message'] ?? 'Search failed',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'An error occurred:$e'};
    }
  }
}
