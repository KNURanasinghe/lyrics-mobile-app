import 'package:flutter/material.dart';
import 'package:lyrics/widgets/main_background.dart';

class PremiumScreen extends StatelessWidget {
  const PremiumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MainBAckgound(
        child: SafeArea(
          child: Column(
            children: [
              // App Bar
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                        size: 20,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ),

              // Main Content
              Expanded(
                child: Center(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    padding: EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Crown Icon
                        SizedBox(
                          width: 80,
                          height: 80,
                          child: Image.asset(
                            'assets/Crown.png',
                            width: 145,
                            fit: BoxFit.cover,
                          ),
                        ),

                        SizedBox(height: 14),

                        // Upgrade Text with PRO Badge
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'UPGRADE',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                letterSpacing: 1.0,
                              ),
                            ),
                            SizedBox(width: 12),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.orange[400],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'PRO',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 32),

                        // Price
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              '\$2.99',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2C5F7C),
                              ),
                            ),
                            SizedBox(width: 8),
                            Text(
                              'for 1 month',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 32),

                        // Features List
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            _buildFeatureItem('Stay on top of the news'),
                            SizedBox(height: 8),
                            _buildFeatureItem('Personalized recommendations'),
                            SizedBox(height: 8),
                            _buildFeatureItem('Ad free experience'),
                            SizedBox(height: 8),
                            _buildFeatureItem(
                              'Topics of interest selected by you',
                            ),
                          ],
                        ),

                        SizedBox(height: 40),

                        // Upgrade Button
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: () {
                              // Handle upgrade action
                              _showUpgradeDialog(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFFB71C1C),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(28),
                              ),
                            ),
                            child: Text(
                              'Upgrade Premium \$4.00',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureItem(String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Container(
        //   width: 6,
        //   height: 6,
        //   decoration: BoxDecoration(
        //     color: Colors.grey[400],
        //     shape: BoxShape.circle,
        //   ),
        // ),
        // SizedBox(width: 12),
        Text(
          text,

          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Color(0xFF5C5C5C),

            height: 1.4,
          ),
        ),
      ],
    );
  }

  void _showUpgradeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFF313439),
          title: Text(
            'Upgrade to Premium',
            style: TextStyle(color: Colors.white),
          ),
          content: Text(
            'Are you sure you want to upgrade to Premium for \$4.00?',
            style: TextStyle(color: Colors.white),
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
                // Handle actual upgrade logic here
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Premium upgrade initiated!'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: Text('Upgrade', style: TextStyle(color: Colors.blue)),
            ),
          ],
        );
      },
    );
  }
}
