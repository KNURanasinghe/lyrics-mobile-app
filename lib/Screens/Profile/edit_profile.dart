import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lyrics/widgets/main_background.dart';
import 'package:lyrics/widgets/profile_section_container.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  final TextEditingController _nameController = TextEditingController(
    text: 'Tharindu Nipun',
  );
  final TextEditingController _emailController = TextEditingController(
    text: 'tharindunipun@gmail.com',
  );
  final TextEditingController _countryController = TextEditingController(
    text: 'Sri Lanka',
  );
  final TextEditingController _phoneController = TextEditingController(
    text: '+9476 666 6666',
  );
  final TextEditingController _dobController = TextEditingController(
    text: '12-09-2002',
  );
  final TextEditingController _genderController = TextEditingController(
    text: 'Male',
  );
  final TextEditingController _languageController = TextEditingController(
    text: 'English',
  );
  final TextEditingController _bioController = TextEditingController();

  List<String> selectedInterests = [
    'Worship',
    'Gospel',
    'Hymns',
    'Contemporary',
    'Instrumental',
    'Choir',
    'Praise & Worship',
    'Kids Songs',
    'Devotional',
    'Tamil Songs',
    'English Songs',
    'Sinhala Songs',
  ];

  // Available interests that can be added
  List<String> availableInterests = [
    'Worship',
    'Gospel',
    'Hymns',
    'Contemporary',
    'Instrumental',
    'Choir',
    'Praise & Worship',
    'Kids Songs',
    'Devotional',
    'Tamil Songs',
    'English Songs',
    'Sinhala Songs',
    'Classical',
    'Rock',
    'Jazz',
    'Blues',
    'Country',
    'Pop',
    'Folk',
    'Spiritual',
    'Meditation',
    'Christian Rock',
    'Acoustic',
    'Orchestra',
  ];

  void _saveProfile() {
    if (_nameController.text.isEmpty) {
      _showSnackBar('Name is required');
      return;
    }

    if (_emailController.text.isEmpty) {
      _showSnackBar('Email is required');
      return;
    }

    Map<String, dynamic> profileData = {
      'name': _nameController.text,
      'email': _emailController.text,
      'country': _countryController.text,
      'phone': _phoneController.text,
      'dateOfBirth': _dobController.text,
      'gender': _genderController.text,
      'language': _languageController.text,
      'interests': selectedInterests,
      'bio': _bioController.text,
      'profileImage': _selectedImage?.path, // Include image path
    };

    _showSnackBar('Profile saved successfully!');
    Navigator.of(context).pop();
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor:
            message.contains('successfully') ? Colors.green : Colors.red,
        duration: Duration(seconds: 2),
      ),
    );
  }

  // Image picker functionality
  Future<void> _showImageSourceDialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFF313439),
          title: Text(
            'Select Image Source',
            style: TextStyle(color: Colors.white),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.camera_alt, color: Colors.white),
                title: Text('Camera', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_library, color: Colors.white),
                title: Text('Gallery', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
              if (_selectedImage != null)
                ListTile(
                  leading: Icon(Icons.delete, color: Colors.red),
                  title: Text(
                    'Remove Photo',
                    style: TextStyle(color: Colors.red),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _removeImage();
                  },
                ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel', style: TextStyle(color: Colors.grey[400])),
            ),
          ],
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 80,
      );

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
      }
    } catch (e) {
      _showSnackBar('Error picking image: $e');
    }
  }

  void _removeImage() {
    setState(() {
      _selectedImage = null;
    });
  }

  // Date picker for date of birth
  Future<void> _selectDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: Colors.blue,
              onPrimary: Colors.white,
              surface: Color(0xFF313439),
              onSurface: Colors.white,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: Colors.blue),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      String formattedDate =
          "${pickedDate.day.toString().padLeft(2, '0')}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.year}";
      _dobController.text = formattedDate;
    }
  }

  // Show interests selection dialog
  void _showInterestsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Color(0xFF313439),
              title: Text(
                'Select Interests',
                style: TextStyle(color: Colors.white),
              ),
              content: SizedBox(
                width: double.maxFinite,
                height: 400,
                child: ListView(
                  children:
                      availableInterests.map((interest) {
                        bool isSelected = selectedInterests.contains(interest);
                        return CheckboxListTile(
                          title: Text(
                            interest,
                            style: TextStyle(color: Colors.white),
                          ),
                          value: isSelected,
                          onChanged: (bool? value) {
                            setState(() {
                              if (value == true) {
                                if (!selectedInterests.contains(interest)) {
                                  selectedInterests.add(interest);
                                }
                              } else {
                                selectedInterests.remove(interest);
                              }
                            });
                            // Update the main widget state
                            this.setState(() {});
                          },
                          activeColor: Colors.blue,
                          checkColor: Colors.white,
                        );
                      }).toList(),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Done', style: TextStyle(color: Colors.blue)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Show bio editing dialog
  void _showBioDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFF313439),
          title: Text('Edit Bio', style: TextStyle(color: Colors.white)),
          content: SizedBox(
            width: double.maxFinite,
            child: TextField(
              controller: _bioController,
              maxLines: 5,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Tell us about yourself...',
                hintStyle: TextStyle(color: Colors.grey[400]),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[600]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[600]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel', style: TextStyle(color: Colors.grey[400])),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {});
              },
              child: Text('Save', style: TextStyle(color: Colors.blue)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Profile',
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
        actions: [
          IconButton(
            icon: Icon(Icons.check, color: Colors.white, size: 24),
            onPressed: () {
              _saveProfile();
            },
          ),
        ],
      ),
      backgroundColor: Color(0xFF313439),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),

            // Profile Photo Section
            Column(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 45,
                      backgroundImage:
                          _selectedImage != null
                              ? FileImage(_selectedImage!)
                              : AssetImage('assets/profile_image.png')
                                  as ImageProvider,
                      backgroundColor: Colors.grey[300],
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: _showImageSourceDialog,
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.7),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                GestureDetector(
                  onTap: _showImageSourceDialog,
                  child: Text(
                    _selectedImage != null ? 'Change Photo' : 'Add Photo',
                    style: TextStyle(color: Colors.grey[400], fontSize: 14),
                  ),
                ),
              ],
            ),
            SizedBox(height: 40),

            // About You Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'About You',
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 20),

                  _buildEditableField('Name', _nameController, true),
                  _buildEditableField('Email', _emailController, true),
                  _buildEditableField('Country', _countryController, true),
                  _buildEditableField('Phone no.', _phoneController, true),
                  _buildDateField('Date of Birth', _dobController),
                  _buildEditableField('Gender', _genderController, true),
                  _buildEditableField(
                    'Preferred Language',
                    _languageController,
                    true,
                  ),
                  _buildEditableField(
                    'Account Type',
                    TextEditingController(text: 'Pro'),
                    false,
                  ),
                  _buildInterestsSection(),
                  _buildBioSection(),
                ],
              ),
            ),

            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildEditableField(
    String label,
    TextEditingController controller,
    bool isEditable,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
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
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Flexible(
                  child: TextFormField(
                    controller: controller,
                    enabled: isEditable,
                    style: TextStyle(color: Colors.grey[300], fontSize: 16),
                    textAlign: TextAlign.right,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
                if (isEditable) ...[
                  SizedBox(width: 8),
                  Icon(Icons.edit, color: Colors.grey[400], size: 16),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateField(String label, TextEditingController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
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
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Flexible(
                  child: GestureDetector(
                    onTap: _selectDate,
                    child: AbsorbPointer(
                      child: TextFormField(
                        controller: controller,
                        style: TextStyle(color: Colors.grey[300], fontSize: 16),
                        textAlign: TextAlign.right,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Icon(Icons.calendar_today, color: Colors.grey[400], size: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInterestsSection() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Interests',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              GestureDetector(
                onTap: _showInterestsDialog,
                child: Icon(Icons.edit, color: Colors.grey[400], size: 16),
              ),
            ],
          ),
          SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children:
                selectedInterests
                    .map((interest) => _buildInterestChip(interest))
                    .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildInterestChip(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey[600],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(text, style: TextStyle(color: Colors.white, fontSize: 12)),
          SizedBox(width: 4),
          GestureDetector(
            onTap: () {
              setState(() {
                selectedInterests.remove(text);
              });
            },
            child: Icon(Icons.close, size: 14, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildBioSection() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12),
      child: GestureDetector(
        onTap: _showBioDialog,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Bio',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            Row(
              children: [
                Text(
                  _bioController.text.isEmpty ? 'Add a bio' : 'Edit bio',
                  style: TextStyle(color: Colors.grey[400], fontSize: 16),
                ),
                SizedBox(width: 8),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.grey[400],
                  size: 16,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _countryController.dispose();
    _phoneController.dispose();
    _dobController.dispose();
    _genderController.dispose();
    _languageController.dispose();
    _bioController.dispose();
    super.dispose();
  }
}
