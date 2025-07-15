import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String selectedTheme = 'Dark'; // Light, Dark, or Automatic
  bool isAutomaticTheme = false;
  bool isBoldText = false;
  double brightness = 0.6; // 0.0 to 1.0
  bool notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1E3A5F),
      appBar: AppBar(
        backgroundColor: Color(0xFF1E3A5F),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Settings',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1E3A5F), Color(0xFF0F1B2E)],
          ),
        ),
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 25, vertical: 16),
          children: [
            // Theme Selection Card
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Color(0xFFD9D9D9).withOpacity(0.9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  // Phone mockups
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Light theme phone
                      _buildPhoneMockup(
                        isLight: true,
                        isSelected: selectedTheme == 'Light',
                      ),
                      // Dark theme phone
                      _buildPhoneMockup(
                        isLight: false,
                        isSelected: selectedTheme == 'Dark',
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  // Theme options
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Light option
                      Column(
                        children: [
                          Text(
                            'Light',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 8),
                          Radio<String>(
                            value: 'Light',
                            groupValue: isAutomaticTheme ? null : selectedTheme,
                            onChanged:
                                isAutomaticTheme
                                    ? null
                                    : (value) {
                                      setState(() {
                                        selectedTheme = value!;
                                      });
                                    },
                            activeColor: Colors.blue,
                          ),
                        ],
                      ),
                      // Dark option
                      Column(
                        children: [
                          Text(
                            'Dark',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 8),
                          Radio<String>(
                            value: 'Dark',
                            groupValue: isAutomaticTheme ? null : selectedTheme,
                            onChanged:
                                isAutomaticTheme
                                    ? null
                                    : (value) {
                                      setState(() {
                                        selectedTheme = value!;
                                      });
                                    },
                            activeColor: Colors.blue,
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  // Automatic toggle
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Automatic',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Switch(
                        value: isAutomaticTheme,
                        onChanged: (value) {
                          setState(() {
                            isAutomaticTheme = value;
                          });
                        },
                        activeColor: Colors.white,
                        activeTrackColor: Colors.blue,
                        inactiveThumbColor: Colors.white,
                        inactiveTrackColor: Colors.grey.shade400,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 24),

            // Lyrics Section Header
            Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: Text(
                'Lyrics',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            // Text Size Card
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              margin: EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Color(0xFFD9D9D9).withOpacity(0.9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Text Size',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.grey.shade600,
                        size: 18,
                      ),
                    ],
                  ),
                  Divider(
                    color: Colors.grey.shade400,
                    thickness: 1,
                    height: 24,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Bold Text',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Switch(
                        value: isBoldText,
                        onChanged: (value) {
                          setState(() {
                            isBoldText = value;
                          });
                        },
                        activeColor: Colors.white,
                        activeTrackColor: Colors.blue,
                        inactiveThumbColor: Colors.white,
                        inactiveTrackColor: Colors.grey.shade400,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Brightness Card
            Container(
              padding: EdgeInsets.all(20),
              margin: EdgeInsets.only(bottom: 24),
              decoration: BoxDecoration(
                color: Color(0xFFD9D9D9).withOpacity(0.9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Brightness',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 16),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: Colors.blue,
                      inactiveTrackColor: Colors.grey.shade300,
                      thumbColor: Colors.blue,
                      overlayColor: Colors.blue.withOpacity(0.2),
                      trackHeight: 4,
                      thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8),
                    ),
                    child: Slider(
                      value: brightness,
                      onChanged: (value) {
                        setState(() {
                          brightness = value;
                        });
                      },
                      min: 0.0,
                      max: 1.0,
                    ),
                  ),
                ],
              ),
            ),

            // Notifications Card
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.notifications,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Notifications',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Get updates about new songs and features',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: notificationsEnabled,
                    onChanged: (value) {
                      setState(() {
                        notificationsEnabled = value;
                      });
                    },
                    activeColor: Colors.white,
                    activeTrackColor: Colors.blue,
                    inactiveThumbColor: Colors.white,
                    inactiveTrackColor: Colors.grey.shade600,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhoneMockup({required bool isLight, required bool isSelected}) {
    return Container(
      width: 60,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(12),
        border: isSelected ? Border.all(color: Colors.blue, width: 2) : null,
      ),
      child: Container(
        margin: EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: isLight ? Colors.white : Colors.black,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            // Status bar
            Container(
              height: 8,
              margin: EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: isLight ? Colors.grey.shade300 : Colors.grey.shade700,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Content area
            Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: isLight ? Colors.grey.shade200 : Colors.grey.shade800,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            SizedBox(height: 4),
          ],
        ),
      ),
    );
  }
}
