import 'package:lyrics/Service/base_api.dart';

class ArtistModel {
  final int? id;
  final String name;
  final String? image;
  final String? bio;
  final int? albumCount;
  final int? songCount;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ArtistModel({
    this.id,
    required this.name,
    this.image,
    this.bio,
    this.albumCount,
    this.songCount,
    this.createdAt,
    this.updatedAt,
  });

  factory ArtistModel.fromJson(Map<String, dynamic> json) {
    return ArtistModel(
      id: json['id'],
      name: json['name'] ?? '',
      image: json['image'],
      bio: json['bio'],
      albumCount: json['album_count'],
      songCount: json['song_count'],
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

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'image': image, 'bio': bio};
  }

  Map<String, dynamic> toCreateJson() {
    return {'name': name, 'image': image, 'bio': bio};
  }
}

class ArtistService {
  final BaseApiService _apiService;

  ArtistService({BaseApiService? apiService})
    : _apiService = apiService ?? BaseApiService();

  // Get all artists
  Future<Map<String, dynamic>> getAllArtists() async {
    try {
      final result = await _apiService.get('/artists');

      if (result['success']) {
        final List<dynamic> artistsData = result['data']['data'] ?? [];
        final List<ArtistModel> artists =
            artistsData.map((json) => ArtistModel.fromJson(json)).toList();

        return {
          'success': true,
          'artists': artists,
          'message': 'Artists fetched successfully',
        };
      } else {
        return {
          'success': false,
          'message': result['message'] ?? 'Failed to fetch artists',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred: ${e.toString()}',
      };
    }
  }

  // Get artist by ID
  Future<Map<String, dynamic>> getArtistById(int id) async {
    try {
      final result = await _apiService.get('/artists/$id');

      if (result['success']) {
        final ArtistModel artist = ArtistModel.fromJson(result['data']['data']);

        return {
          'success': true,
          'artist': artist,
          'message': 'Artist fetched successfully',
        };
      } else {
        return {
          'success': false,
          'message': result['message'] ?? 'Artist not found',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred: ${e.toString()}',
      };
    }
  }

  // Create artist
  Future<Map<String, dynamic>> createArtist(ArtistModel artist) async {
    try {
      final result = await _apiService.post('/artists', artist.toCreateJson());

      if (result['success']) {
        final ArtistModel createdArtist = ArtistModel.fromJson(
          result['data']['data'],
        );

        return {
          'success': true,
          'artist': createdArtist,
          'message': result['data']['message'] ?? 'Artist created successfully',
        };
      } else {
        return {
          'success': false,
          'message': result['message'] ?? 'Failed to create artist',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred: ${e.toString()}',
      };
    }
  }

  // Update artist
  Future<Map<String, dynamic>> updateArtist(int id, ArtistModel artist) async {
    try {
      final result = await _apiService.put(
        '/artists/$id',
        artist.toCreateJson(),
      );

      if (result['success']) {
        final ArtistModel updatedArtist = ArtistModel.fromJson(
          result['data']['data'],
        );

        return {
          'success': true,
          'artist': updatedArtist,
          'message': result['data']['message'] ?? 'Artist updated successfully',
        };
      } else {
        return {
          'success': false,
          'message': result['message'] ?? 'Failed to update artist',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred: ${e.toString()}',
      };
    }
  }

  // Delete artist
  Future<Map<String, dynamic>> deleteArtist(int id) async {
    try {
      final result = await _apiService.delete('/artists/$id');

      if (result['success']) {
        return {
          'success': true,
          'message': result['data']['message'] ?? 'Artist deleted successfully',
        };
      } else {
        return {
          'success': false,
          'message': result['message'] ?? 'Failed to delete artist',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred: ${e.toString()}',
      };
    }
  }

  // Get artist's albums
  Future<Map<String, dynamic>> getArtistAlbums(int artistId) async {
    try {
      final result = await _apiService.get('/artists/$artistId/albums');

      if (result['success']) {
        final List<dynamic> albumsData = result['data']['data'] ?? [];

        return {
          'success': true,
          'albums': albumsData,
          'message': 'Artist albums fetched successfully',
        };
      } else {
        return {
          'success': false,
          'message': result['message'] ?? 'Failed to fetch artist albums',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred: ${e.toString()}',
      };
    }
  }

  // Get artist's songs
  Future<Map<String, dynamic>> getArtistSongs(int artistId) async {
    try {
      final result = await _apiService.get('/artists/$artistId/songs');

      if (result['success']) {
        final List<dynamic> songsData = result['data']['data'] ?? [];
        print('Artist Songs: $songsData');
        return {
          'success': true,
          'songs': songsData,
          'message': 'Artist songs fetched successfully',
        };
      } else {
        return {
          'success': false,
          'message': result['message'] ?? 'Failed to fetch artist songs',
        };
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
}
