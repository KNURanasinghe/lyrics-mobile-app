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
                title:
                    "𝗣𝗿𝗶𝘃𝗮𝗰𝘆 𝗣𝗼𝗹𝗶𝗰𝘆 – 𝗧𝗵𝗲 𝗥𝗼𝗰𝗸 𝗼𝗳 𝗣𝗿𝗮𝗶𝘀𝗲",
                content: [
                  "𝗘𝗳𝗳𝗲𝗰𝘁𝗶𝘃𝗲 𝗗𝗮𝘁𝗲: 𝗔𝘂𝗴𝘂𝘀𝘁 𝟮𝟬𝟮𝟱",
                  "",

                  "“Sing to the LORD a new song; sing to the LORD, all the earth.” – Psalm 96:1"
                      "The Rock of Praise (“we,” “our,” or “us”) exists to glorify God by helping believers worship through lyrics in English, Sinhala, and Tamil. We respect your privacy, your trust, and the sacred nature of the songs we share. This Privacy Policy explains how we collect, use, and protect your information when you use our mobile application and website (therockofpraise.org).",

                  "⸻"
                      "𝟭. 𝗦𝗼𝗻𝗴 𝗢𝘄𝗻𝗲𝗿𝘀𝗵𝗶𝗽 𝗮𝗻𝗱 𝗜𝗻𝘁𝗲𝗴𝗿𝗶𝘁𝘆\n"
                      "	•	All songs in The Rock of Praise remain the property of their rightful owners and songwriters."
                      "	•	We do not claim ownership of any lyrics and have not changed, distorted, or edited them in any way."
                      "	•	Songs are presented exactly as they were originally written, preserving their meaning and worship intent."
                      "\n⸻"
                      "𝟮. 𝗪𝗵𝗼 𝗖𝗮𝗻 𝗨𝘀𝗲 𝗧𝗵𝗶𝘀 𝗔𝗽𝗽\n"
                      "The Rock of Praise is open to everyone — from young children learning their first worship song to the elderly who have sung His praises for decades. There is no age restriction."
                      "\n⸻"
                      "𝟯. 𝗜𝗻𝗳𝗼𝗿𝗺𝗮𝘁𝗶𝗼𝗻 𝗪𝗲 𝗖𝗼𝗹𝗹𝗲𝗰𝘁\n"
                      "We only collect what is necessary to provide and improve our services:"
                      "	•	Account Information: Name, email address, and payment details when you subscribe to the Pro version."
                      "	•	App Usage Data: Anonymous statistics such as app performance, feature use, and crash reports."
                      "	•	Preferences: Your language settings, saved “My Set List,” worship notes, and other personal worship planning items."
                      "We do not collect sensitive personal information such as religious beliefs, political opinions, or biometric data."
                      "\n⸻"
                      "𝟰. 𝗛𝗼𝘄 𝗪𝗲 𝗨𝘀𝗲 𝗬𝗼𝘂𝗿 𝗜𝗻𝗳𝗼𝗿𝗺𝗮𝘁𝗶𝗼𝗻\n"
                      "Your data is used only to:"
                      "•	Provide and maintain app functionality"
                      "•	Enable Pro features"
                      "•	Improve app performance"
                      "•	Respond to support requests"
                      "	•	Send important service updates (if you have opted in)"
                      "We will never sell or misuse your information."
                      "\n⸻"
                      "𝟱. 𝗣𝗿𝗼 𝗩𝗲𝗿𝘀𝗶𝗼𝗻 𝗙𝗲𝗮𝘁𝘂𝗿𝗲𝘀\n"
                      "The Pro Version is designed to help you worship more effectively and includes:"
                      "•	Offline Access"
                      "	•	Full App Access"
                      "•	My Set List (for worship planning)"
                      "•	How to Prepare Lyrics"
                      "•	Ad-Free Experience"
                      "•	Worship Notes"
                      "\n⸻"
                      "𝟲. 𝗔𝘃𝗮𝗶𝗹𝗮𝗯𝗶𝗹𝗶𝘁𝘆 & 𝗣𝗮𝘆𝗺𝗲𝗻𝘁 𝗣𝗿𝗼𝗰𝗲𝘀𝘀𝗶𝗻𝗴\n"
                      "The Rock of Praise is available for download via:"
                      "	•	Google Play Store"
                      "	•	Apple App Store"
                      "	•	Huawei AppGallery"
                      "Payments for the Pro version are processed securely through PayHere (our official payment gateway). PayHere complies with industry-standard payment security and encryption. We do not store your credit card, debit card, or bank details — all transactions are handled directly through PayHere."
                      "\n⸻"
                      "𝟳. 𝗧𝗵𝗶𝗿𝗱-𝗣𝗮𝗿𝘁𝘆 𝗦𝗲𝗿𝘃𝗶𝗰𝗲𝘀\n"
                      "We may use trusted third-party services for analytics, hosting, and crash reporting. Examples include:"
                      "	•	Google Firebase (analytics & crash reports)"
                      "	•	Website hosting providers"
                      "These services may collect certain non-personal information to function properly and have their own privacy policies."
                      "\n⸻"
                      "𝟴. 𝗗𝗮𝘁𝗮 𝗥𝗲𝘁𝗲𝗻𝘁𝗶𝗼𝗻\n"
                      "We retain your data only as long as necessary to provide our services or comply with legal requirements. You may request deletion of your data at any time by contacting us."
                      "\n⸻"
                      "𝟵. 𝗜𝗻𝘁𝗲𝗿𝗻𝗮𝘁𝗶𝗼𝗻𝗮𝗹 𝗨𝘀𝗲𝗿𝘀\n"
                      "If you access The Rock of Praise from outside Sri Lanka, please note that your information may be processed in other countries where privacy laws may differ."
                      "\n⸻"
                      "𝟭𝟬. 𝗖𝗵𝗶𝗹𝗱𝗿𝗲𝗻’𝘀 𝗣𝗿𝗶𝘃𝗮𝗰𝘆\n"
                      "This app is safe for all ages. Children may use the app with guidance from a parent or guardian. We do not knowingly collect personal information from children without parental consent."
                      "\n⸻"
                      "𝟭𝟭. 𝗦𝗲𝗰𝘂𝗿𝗶𝘁𝘆 𝗼𝗳 𝗬𝗼𝘂𝗿 𝗗𝗮𝘁𝗮\n"
                      "We take reasonable technical and organizational measures to safeguard your information. However, no method of storage or transmission over the Internet is 100% secure."
                      "\n⸻"
                      "𝟭𝟮. 𝗖𝗵𝗮𝗻𝗴𝗲𝘀 𝘁𝗼 𝗧𝗵𝗶𝘀 𝗣𝗼𝗹𝗶𝗰𝘆\n"
                      "We may update this Privacy Policy from time to time. The updated version will be posted in the app and on our website, with the new effective date."
                      "\n⸻"
                      "𝟭𝟯. 𝗖𝗼𝗻𝘁𝗮𝗰𝘁 𝗨𝘀\n"
                      "If you have questions or requests regarding this Privacy Policy:"
                      "\n📧 support@therockofpraise.org"
                      "\n🌐 https://therockofpraise.org"
                      "“\nLet everything that has breath praise the LORD.” – Psalm 150:6",
                ],
              ),
              _buildSection(
                title: "රහස්‍යතා ප්‍රතිපත්තිය – නමස්කාරයේ අග්‍රස්ථානය",
                content: [
                  "බලාත්මක දිනය: 2025 අගෝස්තු",
                  "",

                  "“ස්වාමීන්ට අලුත් ගීතිකාවක් ගීතිකාකරව්;  පොළොවේ සියල්ලෙනි, ස්වාමීන්ට ගීතිකාකරව්.” – ගීතාවලිය 96:1"
                      "නමස්කාරයේ අග්‍රස්ථානය (“අපි,” “අපගේ,” හෝ “අප”) පවතින්නේ ඇදහිලිවන්තයන්ට ඉංග්‍රීසි, සිංහල සහ දෙමළ භාෂාවලින් පද රචනා හරහා නමස්කාර කිරීමට උපකාර කිරීමෙන් දෙවියන් වහන්සේව මහිමයට පත් කිරීමටයි. අපි ඔබේ පෞද්ගලිකත්වය, ඔබේ විශ්වාසය සහ අප බෙදා ගන්නා ගීතවල පරිශුද්ධ ස්වභාවයට ගරු කරමු. ඔබ අපගේ ජංගම යෙදුම සහ වෙබ් අඩවිය (therockofpraise.org) භාවිතා කරන විට අපි ඔබේ තොරතුරු රැස් කරන, භාවිතා කරන සහ ආරක්ෂා කරන ආකාරය මෙම රහස්‍යතා ප්‍රතිපත්තිය පැහැදිලි කරයි."
                      "⸻"
                      "1. ගීතිකා හිමිකාරිත්වය සහ අඛණ්ඩතාව\n"
                      "• නමස්කාරයේ අග්‍රස්ථානය යෙදවුමේ ඇති සියලුම ගීතිකා ඒවායේ නියම හිමිකරුවන්ගේ සහ ගීතිකා රචකයින්ගේ දේපළ ලෙස පවතී."
                      "• අපි කිසිදු පද රචනයක හිමිකාරිත්වය ඉල්ලා නොසිටින අතර ඒවා කිසිදු ආකාරයකින් වෙනස් කර, විකෘති කර හෝ සංස්කරණය කර නොමැත."
                      "• ගීතිකා මුලින් ලියා ඇති ආකාරයටම ඉදිරිපත් කර ඇති අතර, ඒවායේ අර්ථය සහ නමස්කාර අභිප්‍රාය ආරක්ෂා කරයි."
                      "\n⸻"
                      "2. මෙම යෙදුම භාවිතා කළ හැක්කේ කාටද\n"
                      "නමස්කාරයේ අග්‍රස්ථානය යෙදවුම සෑම කෙනෙකුටම විවෘතයි - ඔවුන්ගේ පළමු නමස්කාර ගීතිකා ඉගෙන ගන්නා කුඩා දරුවන්ගේ සිට දශක ගණනාවක් තිස්සේ උන්වහන්සේට ප්‍රශංසා ගීතිකා ගායනා කළ වැඩිහිටියන් දක්වා. වයස් සීමාවක් නොමැත."
                      "\n⸻"
                      "3. අපි රැස් කරන තොරතුරු\n"
                      "අපගේ සේවාවන් සැපයීමට සහ වැඩිදියුණු කිරීමට අවශ්‍ය දේ පමණක් අපි රැස් කරමු:"
                      "• ගිණුම් තොරතුරු: ඔබ Pro අනුවාදයට දායක වන විට නම, විද්‍යුත් තැපැල් ලිපිනය සහ ගෙවීම් විස්තර."
                      "• යෙදුම් භාවිත දත්ත: යෙදුම් කාර්ය සාධනය, විශේෂාංග භාවිතය සහ බිඳ වැටීම් වාර්තා වැනි නිර්නාමික සංඛ්‍යාලේඛන."
                      "• මනාප: ඔබගේ භාෂා සැකසුම්, සුරකින ලද මගේ කට්ටල ලැයිස්තුව, නමස්කාර සටහන් සහ අනෙකුත් පුද්ගලික නමස්කාර සැලසුම් අයිතම."
                      "ආගමික විශ්වාසයන්, දේශපාලන අදහස් හෝ ජෛවමිතික දත්ත වැනි සංවේදී පුද්ගලික තොරතුරු අපි රැස් නොකරමු."
                      "\n⸻"
                      "4. අපි ඔබේ තොරතුරු භාවිතා කරන ආකාරය\n"
                      "ඔබේ දත්ත භාවිතා කරන්නේ:"
                      "• යෙදුම් ක්‍රියාකාරිත්වය සැපයීම සහ නඩත්තු කිරීම"
                      "• Pro විශේෂාංග සක්‍රීය කිරීම"
                      "• යෙදුම් කාර්ය සාධනය වැඩි දියුණු කිරීම"
                      "• සහාය ඉල්ලීම්වලට ප්‍රතිචාර දැක්වීම"
                      "• වැදගත් සේවා යාවත්කාලීන කිරීම් යවන්න (ඔබ තෝරාගෙන තිබේ නම්)"
                      "අපි කිසි විටෙකත් ඔබේ තොරතුරු විකුණන්නේ හෝ අනිසි ලෙස භාවිතා කරන්නේ නැත."
                      "\n⸻"
                      "5. Pro අනුවාදයේ විශේෂාංග\n"
                      "Pro අනුවාදය ඔබට වඩාත් ඵලදායී ලෙස නමස්කාර කිරීමට උපකාර කිරීම සඳහා නිර්මාණය කර ඇති අතර එයට ඇතුළත් වන්නේ:"
                      "• නොබැඳි ප්‍රවේශය"
                      "• සම්පූර්ණ යෙදුම් ප්‍රවේශය"
                      "• මගේ කට්ටල ලැයිස්තුව (නමස්කාර සැලසුම් කිරීම සඳහා)"
                      "• පද රචනා සකස් කරන්නේ කෙසේද"
                      "• දැන්වීම්-රහිත අත්දැකීම"
                      "• නමස්කාර සටහන්"
                      "\n⸻"
                      "6. මෙම යෙදවුම ඔබට ලබා ගත හැකි ආකාරය සහ ගෙවීම් සැකසීම\n"
                      "නමස්කාරයේ අග්‍රස්ථානය යෙදවුම බාගත කිරීම සඳහා ලබා ගත හැකිය:"
                      "• Google Play Store"
                      "• Apple App Store"
                      "• Huawei AppGallery"
                      "Pro අනුවාදය සඳහා ගෙවීම් PayHere (අපගේ නිල ගෙවීම් ද්වාරය) හරහා ආරක්ෂිතව සකසනු ලැබේ. PayHere කර්මාන්ත-සම්මත ගෙවීම් ආරක්ෂාව සහ සංකේතනයට අනුකූල වේ. අපි ඔබේ ක්‍රෙඩිට් කාඩ්පත, හර කාඩ්පත හෝ බැංකු විස්තර ගබඩා නොකරමු - සියලුම ගනුදෙනු PayHere හරහා සෘජුවම හසුරුවනු ලැබේ."
                      "\n⸻"
                      "7. තෙවන පාර්ශවීය සේවා\n"
                      "විශ්ලේෂණ, සත්කාරකත්වය සහ බිඳ වැටීම් වාර්තා කිරීම සඳහා අපට විශ්වාසදායක තෙවන පාර්ශවීය සේවාවන් භාවිතා කළ හැකිය. උදාහරණ අතර:"
                      "• Google Firebase (විශ්ලේෂණ සහ බිඳ වැටීම් වාර්තා)"
                      "• වෙබ් අඩවි සත්කාරක සපයන්නන්"
                      "මෙම සේවාවන් නිසි ලෙස ක්‍රියාත්මක වීමට සහ ඔවුන්ගේම රහස්‍යතා ප්‍රතිපත්ති ඇති කිරීමට ඇතැම් පුද්ගලික නොවන තොරතුරු රැස් කළ හැකිය."
                      "\n⸻"
                      "8. දත්ත රඳවා තබා ගැනීම\n"
                      "අපගේ සේවාවන් සැපයීමට හෝ නීතිමය අවශ්‍යතාවලට අනුකූල වීමට අවශ්‍ය තාක් කල් පමණක් අපි ඔබගේ දත්ත රඳවා ගනිමු. ඔබට ඕනෑම වේලාවක අප හා සම්බන්ධ වීමෙන් ඔබගේ දත්ත මකාදැමීම ඉල්ලා සිටිය හැක."
                      "\n⸻"
                      "9. ජාත්‍යන්තර පරිශීලකයින්\n"
                      "ඔබ ශ්‍රී ලංකාවෙන් පිටත සිට නමස්කාරයේ අග්‍රස්ථානය යෙදවුමට පිවිසෙන්නේ නම්, රහස්‍යතා නීති වෙනස් විය හැකි වෙනත් රටවල ඔබගේ තොරතුරු සැකසිය හැකි බව කරුණාවෙන් සලකන්න."
                      "\n⸻"
                      "10. ළමා රහස්‍යතාව\n"
                      "මෙම යෙදුම සියලුම වයස් කාණ්ඩ සඳහා ආරක්ෂිතයි. දෙමාපියන්ගේ හෝ භාරකරුවෙකුගේ මඟ පෙන්වීම යටතේ දරුවන්ට යෙදුම භාවිතා කළ හැකිය. දෙමාපියන්ගේ අවසරයකින් තොරව අපි දැනුවත්ව දරුවන්ගෙන් පුද්ගලික තොරතුරු රැස් නොකරමු."
                      "\n⸻"
                      "11. ඔබගේ දත්තවල ආරක්ෂාව\n"
                      "ඔබගේ තොරතුරු ආරක්ෂා කිරීම සඳහා අපි සාධාරණ තාක්ෂණික සහ සංවිධානාත්මක පියවර ගනිමු. කෙසේ වෙතත්, අන්තර්ජාලය හරහා ගබඩා කිරීමේ හෝ සම්ප්‍රේෂණය කිරීමේ කිසිදු ක්‍රමයක් 100% ආරක්ෂිත නොවේ."
                      "\n⸻"
                      "12. මෙම ප්‍රතිපත්තියට වෙනස්කම්\n"
                      "අපි මෙම රහස්‍යතා ප්‍රතිපත්තිය වරින් වර යාවත්කාලීන කළ හැකිය. යාවත්කාලීන කරන ලද අනුවාදය නව බලාත්මක වන දිනය සමඟ යෙදුමේ සහ අපගේ වෙබ් අඩවියේ පළ කරනු ලැබේ."
                      "\n⸻"
                      "13. අප අමතන්න\n"
                      "මෙම රහස්‍යතා ප්‍රතිපත්තිය සම්බන්ධයෙන් ඔබට ප්‍රශ්න හෝ ඉල්ලීම් තිබේ නම්:"
                      "\n📧 support@therockofpraise.org"
                      "\n🌐 https://therockofpraise.org"
                      "\n“හුස්ම ඇති සියල්ලෝම ස්වාමීන්ට ප්‍රශංසාකෙරෙත්වා.  ස්වාමීන්ට ප්‍රශංසාකරව්.” – ගීතාවලිය 150:6",
                ],
              ),
              _buildSection(
                title: "தனியுரிமைக் கொள்கை- துதியின் சிகரம் ",
                content: [
                  "நடைமுறைப்படுத்திய தேதி - ஆகஸ்ட் 2025",
                  "",

                  "“கர்த்தருக்காக  புதிய பாடல்களைப் பாடுங்கள்;  பூமி முழுவதும் உள்ள உலக மக்களே, கர்த்தரைப் பாடுங்கள்.– சங்கீதம் 96:1",
                  "விசுவாசிகள் ஆங்கிலம், தமிழ் மற்றும் சிங்களம் போன்ற மொழிகளில் உள்ள பாடல்வரிகள் மூலம் வழிபட உதவுவதற்காகவும்  தேவனை மகிமைப்படுத்துவதற்காகவுமே நாங்கள் இருக்கிறோம்."
                      "நாங்கள் உங்கள் தனியுரிமையை, உங்கள் நம்பிக்கையை மற்றும் நாங்கள் பகிரும் பாடல்களின் புனிதத்தன்மையை மதிக்கிறோம்.  "
                      "இந்த தனியுரிமைக் கொள்கை, நீங்கள் எங்கள் மொபைல் செயலி மற்றும் இணையதளம் (therockofpraise.org) பயன்படுத்தும் போது, உங்கள் தகவல்களை எவ்வாறு சேகரிக்கிறோம், பயன்படுத்துகிறோம் மற்றும் பாதுகாக்கிறோம் என்பதை விளக்குகிறது."
                      "\n\n𝟭. பாடலுக்கான உரிமையும் நேர்மையும்\n"
                      "• துதியின் சிகரத்தில் உள்ள அனைத்து பாடல்களும் அதற்குரிய உரிமையாளர் மற்றும் பாடலாசிரியரின் சொத்தாகவே உள்ளன.  "
                      "\n• நாங்கள் எந்தவொரு பாடல்வரிகளையும் உரிமை கோரவில்லை மற்றும் அவற்றை மாற்றவோ,  சிதைக்கவோ, திருத்தவோ  இல்லை. "
                      "\n• பாடல்கள், தங்களின் உண்மையான அர்த்தத்தையும், வழிபாட்டிற்கான நோக்கத்தையும் பாதுகாக்கும் வகையில், முதலில் எழுதப்பட்டபடியே வழங்கப்படுகின்றன."
                      "\n\n𝟮. இந்தப் பயன்பாட்டை யார் பயன்படுத்தலாம்\n"
                      ""
                      "\n\n𝟯. நாங்கள் சேகரிக்கும் தகவல்கள்\n"
                      "நாங்கள் சேகரிப்பது, நமது சேவைகளை வழங்கவும் மேம்படுத்தவும் தேவையான தகவல்களே:"
                      "- கணக்கு தகவல்: உங்கள் பெயர், மின்னஞ்சல் முகவரி மற்றும் சார்பு(pro) பதிப்புக்கு சந்தா செலுத்தும் போது வழங்கும் கட்டண விபரங்கள்."
                      "- பயன்பாட்டு தரவுகள்: செயலியின் செயல்திறன், பயன்படுத்தப்படும் அம்சங்கள், மற்றும் செயலி முறிவு அறிக்கைகள் போன்ற பெயரிடப்படாத புள்ளிவிவரங்கள்."
                      "- விருப்பங்கள்: உங்கள் மொழி அமைப்புகள்,"
                      "என்னுடைய தொகுப்பு பட்டியலில்"
                      "வழிபாட்டு குறிப்புகள் மற்றும் பிற தனிப்பட்ட வழிபாட்டு திட்டமிடல் பொருட்களை சேமித்தல் ."
                      "முக்கியமாக, உங்களது மத நம்பிக்கைகள், அரசியல் கருத்துகள் அல்லது உயிர்வள தரவுகள் போன்ற அதிக நுணுக்கமான தனிப்பட்ட தகவல்களை நாங்கள் எவ்விதமாகவும் சேகரிக்கவில்லை."
                      "\n\n𝟰. உங்கள் தகவலை நாங்கள் எவ்வாறு பயன்படுத்துகிறோம்\n"
                      "நீங்கள் வழங்கும் தரவுகளை நாங்கள் பயன்படுத்துவது  கீழ்காணும் நோக்கங்களுக்காகவே:"
                      "- செயலியின் செயல்பாட்டை வழங்கவும் பராமரிக்கவும்  "
                      "- சார்பு (pro) அம்சங்களை செயல்படுத்தவும் "
                      "- செயலியின் செயல்திறனை மேம்படுத்தவும் "
                      "- உங்களின் உதவிக் கோரிக்கைகளுக்கு பதிலளிக்கவும் "
                      "- (நீங்கள் ஒப்புக்கொண்டிருந்தால்) முக்கிய சேவை புதுப்பிப்புகளை அனுப்பவும்"
                      "உங்கள் தகவல்களை நாங்கள் எப்போதும் விற்கமாட்டோம் அல்லது தவறாக பயன்படுத்தமாட்டோம்."
                      "\n\n𝟱. சார்பு (pro) பதிப்பு அம்சங்கள்\n"
                      "சார்பு (pro) பதிப்பு உங்களை மேலும் ஆழமான ஆராதனையில் ஈடுபட உதவுவதற்காக வடிவமைக்கப்பட்டுள்ளது. இதில் அடங்கும் அம்சங்கள்:"
                      "- இணையமில்லா அணுகல்  "
                      "- முழு செயலி அணுகல்  "
                      "- என்னுடைய தொகுப்பு பட்டியல்(My Set List) (ஆராதனை திட்டமிடலுக்கானது)  "
                      "- பாடல்வரிகள் தயாரிக்கும் வழிமுறைகள் "
                      "- விளம்பரமில்லாத அனுபவம்"
                      "- ஆராதனை குறிப்பு பதிவுகள்"
                      "\n\n𝟲. கிடைப்பும் மற்றும் கட்டண செயலாக்கமும்\n"
                      "துதியின் சிகரம் செயலி நீங்கள் கீழ்காணும் இடங்களில் பதிவிறக்கம் செய்யக் கிடைக்கும்:"
                      "- Google Play Store "
                      "- Apple App Store "
                      "- Huawei AppGallery"
                      "சார்பு (pro) பதிப்புக்கான கட்டணங்கள் பாதுகாப்பாக PayHere மூலம் செயலாக்கப்படுகின்றன. (இது எங்களின் அதிகாரப்பூர்வ கட்டண வாயிலாகும்). PayHere தொழில்நுட்ப தரநிலைகளுக்கேற்ப பாதுகாப்பு மற்றும் குறியாக்கத்துடன் இயங்குகிறது."
                      "நாங்கள் உங்கள் கடன் அட்டை(credit card), பற்று அட்டை(Debit card) அல்லது வங்கிக் கணக்கு விவரங்களை சேமிக்கவில்லை. அனைத்து பண பரிவர்த்தனைகளும் நேரடியாக PayHere-இல் நடைபெறும்."
                      "\n\n𝟳. மூன்றாம் தரப்பினர் சேவைகள்\n"
                      "நாங்கள் பின்வரும் நம்பத்தகுந்த மூன்றாம் தரப்பு சேவைகளைப் பயன்படுத்தலாம், உதாரணமாக:"
                      "- Google Firebase (பயனர் பகுப்பாய்வு மற்றும் செயலி குறைபாடுகள் அறிக்கைகள்)"
                      "- இணையதள ஹோஸ்டிங் வழங்குநர்கள்"
                      "இவை சரியாக செயல்படுவதற்காக சில தனிப்பட்டதல்லாத தகவல்களை சேகரிக்கலாம். இச் சேவைகளுக்கு தங்களுக்கே உரிய தனியுரிமைக் கொள்கைகள் உள்ளன."
                      "\n\n𝟴. தரவுகளை வைத்திருக்கும் காலம்\n"
                      "நாங்கள் உங்கள் தரவுகளை, எங்கள் சேவைகளை வழங்க தேவையான அளவிற்கு மட்டுமே அல்லது சட்டபூர்வமான கட்டாயங்களை பூர்த்தி செய்ய வேண்டுமெனில் மட்டுமே வைத்திருப்போம்.  "
                      "நீங்கள் விரும்பினால், எப்போது வேண்டுமானாலும் உங்கள் தரவுகளை அழிக்குமாறு எங்களை தொடர்புகொண்டு கேட்டுக்கொள்ளலாம்."
                      "\n\n𝟵. சர்வதேச பயனர்கள்\n"
                      "நீங்கள் இலங்கையை விட வேறொரு நாட்டிலிருந்து துதியின் சிகரம் பயன்பாட்டை அணுகினால், "
                      "உங்கள் தகவல்கள் வேறு நாடுகளில் செயலாக்கப்படலாம் என்பதை கவனத்தில் கொள்ளவும்."
                      "அந்த நாடுகளில் தனியுரிமை சட்டங்கள் வேறுபடலாம்."
                      "\n\n𝟭𝟬. குழந்தைகளின் தனியுரிமை\n"
                      "இந்த பயன்பாடு எல்லா வயதினருக்கும் பாதுகாப்பானது. "
                      "குழந்தைகள் பெற்றோர் அல்லது பாதுகாவலரின் வழிகாட்டுதலுடன் பயன்பாட்டை பயன்படுத்தலாம். "
                      "பெற்றோரின் அனுமதியின்றி குழந்தைகளிடமிருந்து நாங்கள் அறிவதில்லாமல் தனிப்பட்ட தகவலை சேகரிக்கமாட்டோம்."
                      "\n\n𝟭𝟭. உங்கள் தரவின் பாதுகாப்பு\n"
                      "உங்கள் தகவலை பாதுகாப்பதற்காக நாங்கள் நியாயமான தொழில்நுட்ப மற்றும் அமைப்பு நடவடிக்கைகளை எடுக்கிறோம்."
                      "ஆனால், இணையத்தின் மூலம் சேமிப்பும் அல்லது பரிமாற்றமும் 100% பாதுகாப்பானது அல்ல."
                      "\n\n𝟭𝟮. இந்த கொள்கையில் மாற்றங்கள்\n"
                      "நாங்கள் இந்த தனியுரிமை கொள்கையை நேரம் நேரமாக புதுப்பிக்கலாம்."
                      "புதுப்பிக்கப்பட்ட பதிப்பு பயன்பாட்டிலும் எங்கள் வலைத்தளத்திலும்புதிய செயல்திறன் தேதி உடன் பதியப்படும்."
                      "\n\n𝟭𝟯. எங்களை தொடர்பு கொள்ளவும்\n"
                      "இந்த தனியுரிமைக் கொள்கை தொடர்பான கேள்விகள் அல்லது கோரிக்கைகள் இருந்தால்:\n"
                      "📧 support@therockofpraise.org"
                      "\n🌐 https://therockofpraise.org  "
                      "“\nஉயிருள்ள அனைத்தும்  கர்த்தரைத் துதிக்கட்டும்..” – சங்கீதம் 150:6",
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
