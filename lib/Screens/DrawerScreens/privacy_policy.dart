import 'package:flutter/material.dart';
import 'package:lyrics/widgets/main_background.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Privacy Policy',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: const Color(0xFF1E3A5F), // Dark blue color
        elevation: 0,

        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: MainBAckgound(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSection(
                title: "1. Information We Collect",
                content: [
                  "a. Personal Information:",
                  "",
                  "We may collect limited personal information such as:",
                  "Name (if entered)",
                  "Email address (if account creation or feedback is required)",
                  "",
                  "b. Non-Personal Information:",
                  "",
                  "We may automatically collect certain non-personal information, including:",
                  "Device information (type, OS version)",
                  "Usage data (features used, app crashes)",
                  "IP address and location (approximate)",
                  "",
                  "c. Lyrics Search and Usage Data:",
                  "",
                  "We may log search queries, favorite lyrics, or usage preferences to improve user experience.",
                ],
              ),
              _buildSection(
                title: "2. How We Use Your Information",
                content: [
                  "We use the information to:",
                  "Provide and maintain the app",
                  "Personalize content and recommendations",
                  "Improve app performance and functionality",
                  "Respond to feedback or support requests",
                  "Analyze usage patterns to enhance user experience",
                ],
              ),
              _buildSection(
                title: "3. Sharing of Information",
                content: [
                  "We do not sell your personal information.",
                  "",
                  "We may share limited data with:",
                  "Analytics providers (e.g., Google Analytics for Firebase) to understand app usage",
                  "Service providers (e.g., cloud storage) under strict confidentiality",
                  "Legal authorities if required by law or to protect our rights",
                ],
              ),
              _buildSection(
                title: "4. Third-Party Services",
                content: [
                  "The app may contain links or use features from third-party services (e.g., YouTube previews, ad networks). These services may collect information independently according to their privacy policies.",
                ],
              ),
              _buildSection(
                title: "5. Data Security",
                content: [
                  "We use industry-standard measures to protect your data. However, no method of transmission or storage is 100% secure, and we cannot guarantee absolute security.",
                ],
              ),
              _buildSection(
                title: "6. Children's Privacy",
                content: [
                  "Our app is not intended for children under 13. We do not knowingly collect personal data from children. If we become aware of such data, we will delete it promptly.",
                ],
              ),
              _buildSection(
                title: "7. Your Rights",
                content: [
                  "Depending on your location, you may have rights to:",
                  "Access, update, or delete your data",
                  "Opt out of certain data uses",
                  "Withdraw consent (where applicable)",
                  "",
                  "To exercise these rights, contact us at [your email address].",
                ],
              ),
              _buildSection(
                title: "8. Changes to This Policy",
                content: [
                  "We may update this Privacy Policy from time to time. We will notify you of any significant changes through the app or by updating the date at the top.",
                ],
              ),
              _buildSection(
                title: "9. Contact Us",
                content: [
                  "If you have any questions about this Privacy Policy or your data, please contact:",
                  "",
                  "[Your Company Name]",
                  "Email: [your email address]",
                  "Address: [your postal address]",
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required List<String> content}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          ...content.map(
            (text) => Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                text,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  height: 1.4,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Alternative implementation with better text formatting
class PrivacyPolicyFormatted extends StatelessWidget {
  const PrivacyPolicyFormatted({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Privacy Policy',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: const Color(0xFF1E3A5F),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: MainBAckgound(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildFormattedSection(
                title: "1. Information We Collect",
                subsections: [
                  {
                    "subtitle": "Personal Information:",
                    "content":
                        "We may collect limited personal information such as:\n• Name and email address\n• Device information\n• Usage data and analytics\n• Location data (if required)",
                  },
                  {
                    "subtitle": "",
                    "content":
                        "We do not collect sensitive personal information such as credit card details or certain non-personal information, including:\n• Device information and identifiers\n• Log files and usage data\n• Cookies and tracking technologies",
                  },
                  {
                    "subtitle": "Lyrics Search and Usage Data:",
                    "content":
                        "We may collect information about lyrics you search for, view, or interact with in our app.",
                  },
                ],
              ),
              _buildFormattedSection(
                title: "2. How We Use Your Information",
                subsections: [
                  {
                    "subtitle": "",
                    "content":
                        "We use collected information to:\n• Provide and maintain the app\n• Improve user experience and functionality\n• Send notifications (if enabled)\n• Respond to feedback or support requests\n• Analyze usage patterns to enhance user experience",
                  },
                ],
              ),
              _buildFormattedSection(
                title: "3. Sharing of Information",
                subsections: [
                  {
                    "subtitle": "",
                    "content":
                        "We do not sell personal information.\n\nWe may share limited data with:\n• Analytics providers (e.g., Google Analytics)\n• Cloud service providers for app functionality\n• Service providers (e.g., cloud storage)\n• Legal authorities if required by law\n• Business partners for analytics and improvement purposes",
                  },
                ],
              ),
              _buildFormattedSection(
                title: "4. Third-Party Services",
                subsections: [
                  {
                    "subtitle": "",
                    "content":
                        "This app may contain links to or features from third-party services. You must exercise caution when accessing these services as their information independently according to their privacy policies.\n\nWe are not responsible for third-party practices.",
                  },
                ],
              ),
              _buildFormattedSection(
                title: "5. Data Security",
                subsections: [
                  {
                    "subtitle": "",
                    "content":
                        "We use industry-standard measures to protect your data. However, no method of transmission or storage is 100% secure, and we cannot guarantee absolute security.",
                  },
                ],
              ),
              _buildFormattedSection(
                title: "6. Children's Privacy",
                subsections: [
                  {
                    "subtitle": "",
                    "content":
                        "Our app is not intended for children under 13. We do not knowingly collect personal data from children. If we become aware of such data, we will delete it immediately.",
                  },
                ],
              ),
              _buildFormattedSection(
                title: "7. Your Rights",
                subsections: [
                  {
                    "subtitle": "",
                    "content":
                        "Depending on your location, you may have the right to:\n• Access, update, or delete your data\n• Opt out of certain data collection\n• Request data portability\n\nTo exercise these rights, contact us at [Your Email Address].",
                  },
                ],
              ),
              _buildFormattedSection(
                title: "8. Changes to This Policy",
                subsections: [
                  {
                    "subtitle": "",
                    "content":
                        "We may update this Privacy Policy from time to time. We will notify you of any significant changes through the app or by updating this document.",
                  },
                ],
              ),
              _buildFormattedSection(
                title: "9. Contact Us",
                subsections: [
                  {
                    "subtitle": "",
                    "content":
                        "If you have questions about this Privacy Policy, please contact us at:\n\nEmail: [Your Email Address]\nCompany: [Your Company Name]\nEmail: [Your Email Address]\nAddress: [Your Address]",
                  },
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormattedSection({
    required String title,
    required List<Map<String, String>> subsections,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          ...subsections.map(
            (subsection) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (subsection["subtitle"]!.isNotEmpty) ...[
                  Text(
                    subsection["subtitle"]!,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.95),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 6),
                ],
                Text(
                  subsection["content"]!,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
