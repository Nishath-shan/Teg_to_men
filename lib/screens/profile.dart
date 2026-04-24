import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import '../data/app_state.dart';
import '../widgets/app_bottom_nav.dart';
import '../theme.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Future<void> pickImageFromGallery() async {
    final picker = ImagePicker();
    final XFile? picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() {
        AppState.imagePath = picked.path;
      });
    }
  }

  void copyText(String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$label copied'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  InputDecoration inputStyle(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: context.inputFillColor,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFF1450F0), width: 1.5),
      ),
    );
  }

  void showEditProfileDialog() {
    final nameController = TextEditingController(
      text: AppState.userName == 'User' ? '' : AppState.userName,
    );
    final emailController = TextEditingController(text: AppState.email);
    final phoneController = TextEditingController(text: AppState.phone);

    showDialog(
      context: context,
      builder: (_) {
        return Dialog(
          backgroundColor: context.bgColor,
          insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          child: AnimatedPadding(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 20,
              bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Edit Profile',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: context.textColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: pickImageFromGallery,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1450F0),
                        foregroundColor: Colors.white,
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      child: const Text(
                        'Change Image',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  TextField(
                    controller: nameController,
                    cursorColor: const Color(0xFF1450F0),
                    decoration: inputStyle('Enter your name'),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: emailController,
                    cursorColor: const Color(0xFF1450F0),
                    decoration: inputStyle('Enter your email'),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: phoneController,
                    cursorColor: const Color(0xFF1450F0),
                    decoration: inputStyle('Enter your phone'),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 52,
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFF1450F0),
                              side: const BorderSide(color: Color(0xFF1450F0)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                            ),
                            child: const Text(
                              'Cancel',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: SizedBox(
                          height: 52,
                          child: ElevatedButton(
                            onPressed: () async {
                              setState(() {
                                AppState.userName = nameController.text.trim().isEmpty
                                    ? 'User'
                                    : nameController.text.trim();
                                AppState.email = emailController.text.trim();
                                AppState.phone = phoneController.text.trim();
                              });
                              await AppState.saveState();
                              if (context.mounted) Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1450F0),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                            ),
                            child: const Text(
                              'Save',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void showLanguageDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: context.bgColor,
        title: const Text('Select Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('English'),
              onTap: () {
                setState(() {
                  AppState.language = 'English';
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Tamil'),
              onTap: () {
                setState(() {
                  AppState.language = 'Tamil';
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Sinhala'),
              onTap: () {
                setState(() {
                  AppState.language = 'Sinhala';
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void showContactDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: context.bgColor,
        title: Text('Contact'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('076 792 6070'),
              trailing: const Icon(Icons.copy, size: 20),
              onTap: () => copyText('076 792 6070', 'Phone number'),
            ),
            ListTile(
              title: const Text('070 123 4567'),
              trailing: const Icon(Icons.copy, size: 20),
              onTap: () => copyText('070 123 4567', 'Phone number'),
            ),
          ],
        ),
      ),
    );
  }

  void showShareAppDialog() {
    const appLink =
        'https://play.google.com/store/apps/details?id=com.example.tagtomen';

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: context.bgColor,
        title: const Text('Share App'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              appLink,
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                copyText(appLink, 'App link');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1450F0),
                foregroundColor: Colors.white,
              ),
              child: const Text('Copy Link'),
            ),
          ],
        ),
      ),
    );
  }

  void showHelpCenterDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: context.bgColor,
        title: Text('Help Center'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('FAQ', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 6),
              Text('• How to place an order'),
              Text('• How to add items to cart'),
              Text('• How to edit profile'),
              Text('• How to change address'),
              SizedBox(height: 14),
              Text('Support', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 6),
              Text('Email: support@tagtomen.com'),
              Text('Phone: 076 792 6070'),
              SizedBox(height: 14),
              Text('About', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 6),
              Text('This app helps users shop men’s fashion items easily.'),
            ],
          ),
        ),
      ),
    );
  }

  Widget menuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Widget? trailing,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: const Color(0xFF1450F0)),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: context.textColor,
          ),
        ),
        trailing: trailing ?? const Icon(Icons.chevron_right),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final imageProvider = AppState.imagePath.isNotEmpty
        ? FileImage(File(AppState.imagePath))
        : null;

    return Scaffold(
      backgroundColor: context.bgColor,
      bottomNavigationBar: const AppBottomNav(currentIndex: 3),
      appBar: AppBar(
        backgroundColor: context.bgColor,
        foregroundColor: context.textColor,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Profile',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 210,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(26),
                image: imageProvider != null
                    ? DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      )
                    : null,
                color: context.highlightBgColor,
              ),
              child: Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(26),
                  color: context.cardColor.withOpacity(0.70),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      width: 108,
                      height: 128,
                      decoration: BoxDecoration(
                        color: context.cardColor,
                        borderRadius: BorderRadius.circular(18),
                        image: imageProvider != null
                            ? DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      child: imageProvider == null
                          ? const Icon(
                              Icons.person,
                              size: 54,
                              color: Color(0xFF1450F0),
                            )
                          : null,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () => copyText(AppState.userName, 'Name'),
                              child: Text(
                                AppState.userName,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: context.textColor,
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            GestureDetector(
                              onTap: () => copyText(
                                AppState.phone.isEmpty ? 'No phone added' : AppState.phone,
                                'Phone number',
                              ),
                              child: Text(
                                AppState.phone.isEmpty ? 'No phone added' : AppState.phone,
                                style: TextStyle(
                                  color: context.iconColor,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            SizedBox(
                              height: 40,
                              child: ElevatedButton(
                                onPressed: showEditProfileDialog,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF1450F0),
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                                child: const Text(
                                  'Edit Profile',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 18),
            ValueListenableBuilder<ThemeMode>(
              valueListenable: themeNotifier,
              builder: (context, currentMode, _) {
                final isDark = currentMode == ThemeMode.dark;
                return menuItem(
                  icon: Icons.dark_mode_outlined,
                  title: 'Dark Mode',
                  onTap: () {
                    themeNotifier.value =
                        isDark ? ThemeMode.light : ThemeMode.dark;
                  },
                  trailing: Switch(
                    value: isDark,
                    onChanged: (val) {
                      themeNotifier.value =
                          val ? ThemeMode.dark : ThemeMode.light;
                    },
                    activeColor: const Color(0xFF1450F0),
                  ),
                );
              },
            ),
            menuItem(
              icon: Icons.language_outlined,
              title: 'Language (${AppState.language})',
              onTap: showLanguageDialog,
            ),
            menuItem(
              icon: Icons.call_outlined,
              title: 'Contact',
              onTap: showContactDialog,
            ),
            menuItem(
              icon: Icons.share_outlined,
              title: 'Share App',
              onTap: showShareAppDialog,
            ),
            menuItem(
              icon: Icons.help_outline,
              title: 'Help Center',
              onTap: showHelpCenterDialog,
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () async {
                  await AppState.resetUserData();
                  if (!context.mounted) return;
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/',
                    (route) => false,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1450F0),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                child: const Text(
                  'Sign Out',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}