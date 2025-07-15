import 'package:flutter/material.dart';
import 'package:lyrics/Screens/Profile/edit_profile.dart';
import 'package:lyrics/widgets/main_background.dart';
import 'package:lyrics/widgets/profile_section_container.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

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
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: MainBAckgound(
        child: Column(
          children: [
            // Profile Header Section
            ProfileSectionContainer(
              child: Column(
                children: [
                  // Profile Image
                  CircleAvatar(
                    radius: 45,
                    backgroundImage: AssetImage(
                      'assets/profile_image.png',
                    ), // Replace with your image path
                    backgroundColor: Colors.grey[300],
                  ),
                  SizedBox(height: 16),

                  // Email
                  Text(
                    'tharindunipun@gmail.com',
                    style: TextStyle(color: Colors.grey[400], fontSize: 14),
                  ),
                  SizedBox(height: 8),

                  // Name
                  Text(
                    'Peter Wilson Johnson Shan',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 16),

                  // Edit Profile Button
                  ElevatedButton(
                    onPressed: () {
                      // Handle edit profile
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => EditProfile()),
                      );
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
                  // Country
                  _buildProfileRow('Country', 'Sri Lanka'),
                  _buildDivider(),

                  // Phone number
                  _buildProfileRow('Phone no.', '+9476 666 6666'),
                  _buildDivider(),

                  // Date of Birth
                  _buildProfileRow('Date of Birth', '12-09-2002'),
                  _buildDivider(),

                  // Gender
                  _buildProfileRow('Gender', 'Male'),
                  _buildDivider(),

                  // Preferred Language
                  _buildProfileRow('Preferred Language', 'English'),
                  _buildDivider(),

                  // Account Type
                  _buildProfileRow('Account Type', 'Pro'),
                  _buildDivider(),

                  // Interests
                  _buildInterestsRow(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
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
          Text(value, style: TextStyle(color: Colors.grey[300], fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildInterestsRow() {
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
          Row(
            children: [
              _buildInterestChip('Worship'),
              SizedBox(width: 8),
              _buildInterestChip('Hymns'),
            ],
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
