import 'package:lyrics/Service/base_api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:lyrics/Service/language_service.dart';

class AlbumModel {
  final int? id;
  final String name; // Changed to non-nullable
  final String? image;
  final int artistId; // Changed to non-nullable
  final String? artistName;
  final String? artistImage;
  final String? releaseDate;
  final String? description;
  final int? songCount;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  AlbumModel({
    this.id,
    required this.name,
    this.image,
    required this.artistId,
    this.artistName,
    this.artistImage,
    this.releaseDate,
    this.description,
    this.songCount,
    this.createdAt,
    this.updatedAt,
  });

  factory AlbumModel.fromJson(Map<String, dynamic> json) {
    return AlbumModel(
      id: json['id'],
      name: json['name'] ?? 'Unknown Album', // Provide default value
      image: json['image'],
      artistId: json['artist_id'] ?? 0, // Provide default value
      artistName: json['artist_name'],
      artistImage: json['artist_image'],
      releaseDate: json['release_date'],
      description: json['description'],
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

  Map<String, dynamic> toCreateJson() {
    return {
      'name': name,
      'image': image,
      'artist_id': artistId,
      'release_date': releaseDate,
      'description': description,
    };
  }
}

class AlbumService {
  final BaseApiService _apiService;
  static const String _baseUrl = 'http://145.223.21.62:3100/api';

  AlbumService({BaseApiService? apiService})
    : _apiService = apiService ?? BaseApiService();

  // Get all albums
  Future<Map<String, dynamic>> getAllAlbums() async {
    try {
      final language = await LanguageService.getLanguage();
      print('language selected in ablbum $language');
      final result = await _apiService.get('/language/$language');

      if (result['success']) {
        final List<dynamic> albumsData = result['data']['data'] ?? [];
        print('Albums Data: $albumsData');

        // Add type checking before parsing
        final List<AlbumModel> albums =
            albumsData.map((item) {
              if (item is AlbumModel) {
                return item; // Already an AlbumModel, no need to parse
              } else if (item is Map<String, dynamic>) {
                return AlbumModel.fromJson(item); // Parse from JSON
              } else {
                throw Exception('Invalid album data type: ${item.runtimeType}');
              }
            }).toList();

        return {
          'success': true,
          'albums': albums,
          'message': 'Albums fetched successfully',
        };
      } else {
        return {
          'success': false,
          'message': result['message'] ?? 'Failed to fetch albums',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred: ${e.toString()}',
      };
    }
  }

  Future<Map<String, dynamic>> getAlbumsByLanguage(String language) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/albums/language/$language'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          final List<dynamic> albumsData = data['data'] ?? [];
          final List<AlbumModel> albums =
              albumsData.map((json) => AlbumModel.fromJson(json)).toList();

          return {
            'success': true,
            'albums': albums,
            'language': data['language'],
            'languageDisplayName': data['languageDisplayName'],
          };
        } else {
          return {
            'success': false,
            'message': data['error'] ?? 'Failed to fetch albums by language',
          };
        }
      } else {
        return {
          'success': false,
          'message': 'Failed to load data: ${response.statusCode}',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred: ${e.toString()}',
      };
    }
  }

  // Get album by ID
  Future<Map<String, dynamic>> getAlbumById(int id) async {
    try {
      final result = await _apiService.get('/albums/$id');

      if (result['success']) {
        final AlbumModel album = AlbumModel.fromJson(result['data']['data']);

        return {
          'success': true,
          'album': album,
          'message': 'Album fetched successfully',
        };
      } else {
        return {
          'success': false,
          'message': result['message'] ?? 'Album not found',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred: ${e.toString()}',
      };
    }
  }

  // Create album
  Future<Map<String, dynamic>> createAlbum(AlbumModel album) async {
    try {
      final result = await _apiService.post('/albums', album.toCreateJson());

      if (result['success']) {
        final AlbumModel createdAlbum = AlbumModel.fromJson(
          result['data']['data'],
        );

        return {
          'success': true,
          'album': createdAlbum,
          'message': result['data']['message'] ?? 'Album created successfully',
        };
      } else {
        return {
          'success': false,
          'message': result['message'] ?? 'Failed to create album',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred: ${e.toString()}',
      };
    }
  }

  // Update album
  Future<Map<String, dynamic>> updateAlbum(int id, AlbumModel album) async {
    try {
      final result = await _apiService.put('/albums/$id', album.toCreateJson());

      if (result['success']) {
        final AlbumModel updatedAlbum = AlbumModel.fromJson(
          result['data']['data'],
        );

        return {
          'success': true,
          'album': updatedAlbum,
          'message': result['data']['message'] ?? 'Album updated successfully',
        };
      } else {
        return {
          'success': false,
          'message': result['message'] ?? 'Failed to update album',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred: ${e.toString()}',
      };
    }
  }

  // Delete album
  Future<Map<String, dynamic>> deleteAlbum(int id) async {
    try {
      final result = await _apiService.delete('/albums/$id');

      if (result['success']) {
        return {
          'success': true,
          'message': result['data']['message'] ?? 'Album deleted successfully',
        };
      } else {
        return {
          'success': false,
          'message': result['message'] ?? 'Failed to delete album',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred: ${e.toString()}',
      };
    }
  }

  // Get album's songs
  Future<Map<String, dynamic>> getAlbumSongs(int albumId) async {
    try {
      final result = await _apiService.get('/albums/$albumId/songs');

      if (result['success']) {
        final List<dynamic> songsData = result['data']['data'] ?? [];

        return {
          'success': true,
          'songs': songsData,
          'message': 'Album songs fetched successfully',
        };
      } else {
        return {
          'success': false,
          'message': result['message'] ?? 'Failed to fetch album songs',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred: ${e.toString()}',
      };
    }
  }

  Future<Map<String, dynamic>> getLatestAlbums() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/albums/latest'),
        headers: {'Content-Type': 'application/json'},
      );
      print('latest album re ${response.statusCode}');
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<AlbumModel> albums =
            (data['data'] as List)
                .map((album) => AlbumModel.fromJson(album))
                .toList();
        return {'success': true, 'albums': albums};
      } else {
        return {'success': false, 'message': 'Failed to load latest albums'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  // Search albums
  Future<Map<String, dynamic>> searchAlbums(String query) async {
    try {
      final result = await _apiService.get('/albums/search/$query');

      if (result['success']) {
        final List<dynamic> albumsData = result['data']['data'] ?? [];
        final List<AlbumModel> albums =
            albumsData.map((json) => AlbumModel.fromJson(json)).toList();

        return {
          'success': true,
          'albums': albums,
          'message': 'Albums search completed successfully',
        };
      } else {
        return {
          'success': false,
          'message': result['message'] ?? 'Search failed',
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
