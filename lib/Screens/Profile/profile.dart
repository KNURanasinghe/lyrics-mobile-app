import 'package:flutter/material.dart';
import 'package:lyrics/Screens/Profile/edit_profile.dart';
import 'package:lyrics/Service/language_service.dart';
import 'package:lyrics/Service/user_service.dart';
import 'package:lyrics/widgets/main_background.dart';
import 'package:lyrics/widgets/profile_section_container.dart';
import 'package:lyrics/Models/user_model.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final UserService _userService = UserService();
  UserModel? _currentUser;
  Map<String, dynamic>? _profileDetails;
  bool _isLoading = true;
  String? _errorMessage;
  String _preferredLanguage = 'English';

  @override
  void initState() {
    super.initState();
    _loadProfileData();
    _loadPreferredLanguage();
  }

  Future<void> _loadPreferredLanguage() async {
    try {
      final language = await LanguageService.getLanguage();
      setState(() {
        _preferredLanguage = language;
      });
    } catch (e) {
      print('Error loading preferred language: $e');
    }
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
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load profile: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  Future<void> _refreshProfile() async {
    await _loadProfileData();
    await _loadPreferredLanguage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        backgroundColor: Color(0xFF313439),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.white),
            onPressed: _refreshProfile,
          ),
        ],
      ),
      body: MainBAckgound(
        child:
            _isLoading
                ? Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
                : _errorMessage != null
                ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, color: Colors.red, size: 64),
                      SizedBox(height: 16),
                      Text(
                        _errorMessage!,
                        style: TextStyle(color: Colors.white, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _refreshProfile,
                        child: Text('Retry'),
                      ),
                    ],
                  ),
                )
                : SingleChildScrollView(
                  child: Column(
                    children: [
                      // Profile Header Section
                      ProfileSectionContainer(
                        child: Column(
                          children: [
                            // Profile Image
                            CircleAvatar(
                              radius: 45,
                              backgroundImage:
                                  _profileDetails?['profile']['profile_image'] !=
                                          null
                                      ? NetworkImage(
                                        _profileDetails!['profile']['profile_image'],
                                      )
                                      : AssetImage('assets/profile_image.png')
                                          as ImageProvider,
                              backgroundColor: Colors.grey[300],
                            ),
                            SizedBox(height: 16),

                            // Email
                            Text(
                              _currentUser?.email ?? 'No email',
                              style: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(height: 8),

                            // Name
                            Text(
                              _currentUser?.fullname ?? 'No name',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 16),

                            // Edit Profile Button
                            ElevatedButton(
                              onPressed: () async {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditProfile(),
                                  ),
                                );

                                if (result == true) {
                                  _refreshProfile();
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 8,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: Text(
                                'Edit Profile',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 20),

                      // Profile Details Section
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Column(
                          children: [
                            // Phone number
                            _buildProfileRow(
                              'Phone no.',
                              _currentUser?.phonenumber ?? 'Not provided',
                            ),
                            _buildDivider(),

                            // User ID
                            _buildProfileRow(
                              'User ID',
                              _currentUser?.id?.toString() ?? 'N/A',
                            ),
                            _buildDivider(),

                            // Account created date
                            // if (_currentUser?.createdAt != null)
                            //   _buildProfileRow(
                            //     'Member Since',
                            //     _formatDate(_currentUser!.createdAt!),
                            //   ),
                            // if (_currentUser?.createdAt != null) _buildDivider(),

                            // Dynamic fields from profile details
                            _buildProfileRow(
                              'Country',
                              _profileDetails?['profile']['country'] ??
                                  'Sri Lanka',
                            ),
                            _buildDivider(),

                            _buildProfileRow(
                              'Date of Birth',
                              _profileDetails?['profile']['date_of_birth'] !=
                                      null
                                  ? _formatProfileDate(
                                    _profileDetails!['profile']['date_of_birth'],
                                  )
                                  : 'Not provided',
                            ),
                            _buildDivider(),

                            _buildProfileRow(
                              'Gender',
                              _profileDetails?['profile']['gender'] ??
                                  'Not specified',
                            ),
                            _buildDivider(),

                            _buildProfileRow(
                              'Preferred Language',
                              _profileDetails?['profile']['preferred_language'] ??
                                  _preferredLanguage,
                            ),
                            _buildDivider(),

                            _buildProfileRow(
                              'Account Type',
                              _profileDetails?['profile']['account_type'] ??
                                  'Pro',
                            ),
                            _buildDivider(),

                            // Interests
                            _buildInterestsRow(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}';
  }

  String _formatProfileDate(String dateString) {
    try {
      // Parse the ISO date string (e.g., "2025-08-04T00:00:00.000Z")
      DateTime dob = DateTime.parse(dateString);

      // Format for display (DD-MM-YYYY)
      return "${dob.day.toString().padLeft(2, '0')}-"
          "${dob.month.toString().padLeft(2, '0')}-"
          "${dob.year}";
    } catch (e) {
      // Fallback for non-ISO formats or invalid dates
      try {
        final parts = dateString.split('-');
        if (parts.length == 3) {
          // Convert from YYYY-MM-DD to DD-MM-YYYY for display
          return '${parts[2]}-${parts[1]}-${parts[0]}';
        }
        return dateString;
      } catch (e) {
        return dateString;
      }
    }
  }

  Widget _buildProfileRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          Flexible(
            child: Text(
              value,
              style: TextStyle(color: Colors.grey[300], fontSize: 16),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInterestsRow() {
    final interests =
        _profileDetails?['interests'] is List
            ? List<String>.from(_profileDetails!['interests'])
            : <String>[];

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Interests',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (interests.isNotEmpty)
            Flexible(
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children:
                    interests
                        .take(interests.length) // Show max 3 interests
                        .map((interest) => _buildInterestChip(interest))
                        .toList(),
              ),
            )
          else
            Text(
              'No interests',
              style: TextStyle(color: Colors.grey[300], fontSize: 16),
            ),
        ],
      ),
    );
  }

  Widget _buildInterestChip(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[600],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(text, style: TextStyle(color: Colors.white, fontSize: 12)),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 1,
      color: Colors.grey[700],
      margin: EdgeInsets.symmetric(vertical: 4),
    );
  }
}
