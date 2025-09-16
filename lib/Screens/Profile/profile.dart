import 'package:flutter/material.dart';
import 'package:lyrics/FireBase/auth_service.dart';
import 'package:lyrics/OfflineService/offline_user_service.dart';
import 'package:lyrics/Screens/AuthScreens/login_page.dart';
import 'package:lyrics/Screens/Profile/edit_profile.dart';
import 'package:lyrics/Service/language_service.dart';
import 'package:lyrics/Service/user_service.dart';
import 'package:lyrics/widgets/cached_image_widget.dart';
import 'package:lyrics/widgets/main_background.dart';
import 'package:lyrics/widgets/profile_section_container.dart';
import 'package:lyrics/Models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final OfflineUserService _userService = OfflineUserService();
  UserModel? _currentUser;
  Map<String, dynamic>? _profileDetails;
  bool _isLoading = true;
  String? _errorMessage;
  String _preferredLanguage = 'English';
  String? proemail;
  String? profileImageUrl;
  bool isPremium = false;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
    _loadPreferredLanguage();
    loadPremiumStatus();
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
      // final userResult = await _userService.getCurrentUserProfile();
      // if (!userResult['success']) {
      //   throw Exception(userResult['message'] ?? 'Failed to load user profile');
      // }

      // _currentUser = userResult['user'] as UserModel;
      // print('users results as user model ${_currentUser!.id}');
      final userId = await UserService.getUserID();
      print('user id in profile $userId');
      // Load extended profile details if user exists
      if (userId.isNotEmpty) {
        final profileResult = await _userService.getFullProfile(userId);

        print('profile result in profile ${profileResult['profile']}');
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

  Widget _buildProfileImage() {
    final profileImageUrl = _getProfileValue('profile_image', '');

    if (profileImageUrl.isNotEmpty && profileImageUrl != 'null') {
      return CachedImageWidget(
        imageUrl: profileImageUrl,
        width: 90,
        height: 90,
        fit: BoxFit.cover,
        borderRadius: BorderRadius.circular(45),
        placeholder: Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(45),
          ),
          child: Center(
            child: SizedBox(
              width: 30,
              height: 30,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.grey[600]!),
              ),
            ),
          ),
        ),
        errorWidget: CircleAvatar(
          radius: 45,
          backgroundColor: Colors.grey[300],
          child: Icon(Icons.person, size: 40, color: Colors.grey[600]),
        ),
      );
    }

    return CircleAvatar(
      radius: 45,
      backgroundColor: Colors.grey[300],
      child: Icon(Icons.person, size: 40, color: Colors.grey[600]),
    );
  }

  Future<void> _refreshProfile() async {
    await _loadProfileData();
    await _loadPreferredLanguage();
    await loadPremiumStatus();
  }

  Future<void> emailImage() async {
    proemail = await FireBaseAuthServices.getemailProfileImage();
  }

  // Helper method to safely get profile data
  String _getProfileValue(String key, String defaultValue) {
    if (_profileDetails == null) return defaultValue;

    // Handle nested profile structure
    if (_profileDetails!['profile'] != null &&
        _profileDetails!['profile'][key] != null) {
      return _profileDetails!['profile'][key].toString();
    }

    // Handle direct key access
    if (_profileDetails![key] != null) {
      return _profileDetails![key].toString();
    }
    defaultValue = proemail ?? '';
    return defaultValue;
  }

  Future<void> loadPremiumStatus() async {
    final ispremiun = await UserService.getIsPremium();
    print('premium state is: $ispremiun');
    setState(() {
      isPremium = ispremiun == '1';
    });
  }

  // Helper method to safely get profile image
  ImageProvider _getProfileImage() {
    final profileImageUrl = _getProfileValue('profile_image', '');

    if (profileImageUrl.isNotEmpty && profileImageUrl != 'null') {
      return NetworkImage(profileImageUrl);
    }

    return AssetImage('assets/profile_image.png') as ImageProvider;
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
                            _buildProfileImage(),
                            SizedBox(height: 16),

                            // Email
                            Text(
                              _profileDetails!['email'] ?? 'No email',
                              style: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(height: 8),

                            // Name
                            Text(
                              _profileDetails!['fullname'] ?? 'No name',
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
                            SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () async {
                                final prefs =
                                    await SharedPreferences.getInstance();
                                await prefs.clear();
                                final result = await Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LoginPage(),
                                  ),
                                );

                                if (result == true) {}
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.redAccent,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 4,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text(
                                'LogOut',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
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
                              _profileDetails!['phonenumber'] ?? 'Not provided',
                            ),
                            _buildDivider(),

                            // User ID
                            _buildProfileRow(
                              'User ID',
                              _profileDetails!['id'].toString() ?? 'N/A',
                            ),
                            _buildDivider(),

                            // Dynamic fields from profile details
                            _buildProfileRow(
                              'Country',
                              _getProfileValue('country', 'Not Provided'),
                            ),
                            _buildDivider(),

                            _buildProfileRow(
                              'Date of Birth',
                              _formatProfileDate(
                                _getProfileValue('date_of_birth', ''),
                              ),
                            ),
                            _buildDivider(),

                            _buildProfileRow(
                              'Gender',
                              _getProfileValue('gender', 'Not specified'),
                            ),
                            _buildDivider(),

                            _buildProfileRow(
                              'Preferred Language',
                              _getProfileValue(
                                'preferred_language',
                                _preferredLanguage,
                              ),
                            ),
                            _buildDivider(),

                            _buildProfileRow(
                              'Account Type',
                              isPremium == true ? 'Premium' : 'Free',
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
    if (dateString.isEmpty || dateString == 'null') {
      return 'Not provided';
    }

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
        return 'Not provided';
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
    final interests = _profileDetails?['interests'];
    List<String> interestsList = [];

    if (interests is List) {
      interestsList = List<String>.from(interests);
    }

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
          if (interestsList.isNotEmpty)
            Flexible(
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children:
                    interestsList
                        .take(interestsList.length) // Show all interests
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
