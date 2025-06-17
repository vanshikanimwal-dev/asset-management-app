import 'package:flutter/material.dart';
import 'package:ferrero_asset_management/widgets/styled_button.dart';
import 'package:ferrero_asset_management/screens/auth/login_page.dart';
import 'package:ferrero_asset_management/screens/shops/search_page.dart';
// import 'package:ferrero_app/utils/constants.dart'; // Uncomment if you use AppAssets, AppColors

class HomePage extends StatelessWidget {
  final String username;

  const HomePage({super.key, required this.username});

  String _capitalizeFirstLetter(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBF4EF), // Use AppColors.lightBackground
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/homescreen.png', fit: BoxFit.cover), // Use AppAssets.homeScreen
          ),
          Column(
            children: [
              Container(
                height: 80,
                padding: const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/rect1.png'), // Use AppAssets.rect1
                    fit: BoxFit.cover,
                    repeat: ImageRepeat.repeat,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    PopupMenuButton<String>(
                      icon: const Icon(Icons.menu, color: Colors.white, size: 30),
                      offset: const Offset(0, 50),
                      color: Colors.brown[700], // Use AppColors.primaryBrown.shade700
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      onSelected: (value) {
                        if (value == 'logout') {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => const LoginPage()),
                                (Route<dynamic> route) => false,
                          );
                        }
                      },
                      itemBuilder: (BuildContext context) => [
                        const PopupMenuItem<String>(
                          value: 'logout',
                          child: Text(
                            'Logout',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                    // MODIFICATION START: Replace Column with Row for logo and text
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end, // Align contents to the right
                      crossAxisAlignment: CrossAxisAlignment.center, // Vertically center items in the row
                      children: [
                        // Add your logo here
                        Image.asset(
                          'assets/logo.png', // Assuming your logo is in assets/logo.png
                          height: 40, // Adjust height as needed
                          width: 40,  // Adjust width as needed
                        ),
                        const SizedBox(width: 8), // Space between logo and text
                        RichText(
                          text: TextSpan(
                            children: [
                              const TextSpan(
                                text: 'Welcome ',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              TextSpan(
                                text: _capitalizeFirstLetter(username),
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    // MODIFICATION END
                  ],
                ),
              ),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 50),
                      styledButton(
                        text: 'Installed Assets',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SearchPage(username: username),
                            ),
                          );
                        },
                        width: 200,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}