import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import for MethodChannel
import 'package:ferrero_asset_management/widgets/styled_button.dart';
import 'package:ferrero_asset_management/screens/home/home_page.dart';

//better to pass through DataProvider class
import 'package:ferrero_asset_management/screens/auth/global_auth_token.dart' as globals;

//good to use for passing auth token to all the screen where needed
//import 'package:provider/provider.dart';
//import 'package:ferrero_asset_management/provider/data_provider.dart';

// import 'package:ferrero_app/utils/constants.dart'; // Uncomment if you use AppAssets, AppColors

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _userIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;
  bool _obscurePassword = true;

  // Define the MethodChannel, ensuring the name matches the native side
  static const MethodChannel _authChannel = MethodChannel('com.example.ferrero_asset_management/auth');


  void _login() async {
    // Clear any previous error message and show loading
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final String username = _userIdController.text.trim();
    final String password = _passwordController.text.trim();

    // Basic client-side validation
    if (username.isEmpty || password.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter both User ID and Password.';
        _isLoading = false; // Stop loading if validation fails
      });
      return; // Stop the login process
    }

    try {
      // Invoke the native method to request the auth token
      // Pass the username and password from the text controllers
      final String? authToken = await _authChannel.invokeMethod(
        'requestAuthToken',
        {'username': username, 'password': password}, // Pass arguments as a Map
      );

      // Check if a token was successfully received
      if (authToken != null && authToken.isNotEmpty) {
        // Authentication Successful!
        // You would typically store this token securely here
        // (e.g., using a package like flutter_secure_storage)
        print('Authentication Successful! Token: $authToken');

        globals.authToken = authToken;  //better to pass through DataProvider class

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login Successful!')),
        );

        // Clear the text fields after successful login
        _userIdController.clear();
        _passwordController.clear();

        // Navigate to the HomePage on success, passing the username
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage(
            username: username,
          )),
        );

      } else {
        // This case indicates that the native side returned null or an empty string,
        // which should ideally be handled as an error from the native side via PlatformException.
        // However, this fallback ensures a message is displayed if the native side doesn't throw.
        setState(() {
          _errorMessage = 'Authentication failed: No token received.';
        });
      }
    } on PlatformException catch (e) {
      // Handle errors specifically from the native platform (e.g., network issues, server errors)
      print("Failed to get auth token: '${e.code}': '${e.message}'. Details: ${e.details}");
      setState(() {
        _errorMessage = 'Login failed: ${e.message ?? "Unknown authentication error"}';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login Failed: ${e.message ?? "Authentication Error"}')),
      );
    } catch (e) {
      // Catch any other unexpected Dart-side errors
      print("An unexpected error occurred during login: $e");
      setState(() {
        _errorMessage = 'An unexpected error occurred: $e';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An unexpected error occurred.')),
      );
    } finally {
      // Always stop the loading indicator regardless of success or failure
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _userIdController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //use data provider to pass auth token to all screen where needed
    //final dataProvider = Provider.of<DataProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: const Color(0xFFFBF4EF), // Use AppColors.lightBackground
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/homescreen.png', fit: BoxFit.cover), // Use AppAssets.homeScreen
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/logo.png', height: 150, width: 150), // Use AppAssets.logo
                  const SizedBox(height: 30),
                  const Text(
                    'Ferrero Asset Management App',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF3E2723), // Use AppColors.darkBrown
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  // User ID TextField
                  Container(
                    margin: const EdgeInsets.only(bottom: 20.0),
                    decoration: BoxDecoration(
                      image: const DecorationImage(
                        image: AssetImage('assets/rect1.png'), // Use AppAssets.rect1
                        fit: BoxFit.cover,
                        repeat: ImageRepeat.repeat,
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: TextField(
                      controller: _userIdController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Enter your user id',
                        hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                        border: InputBorder.none,
                        prefixIcon: const Icon(Icons.person, color: Colors.white70),
                      ),
                      keyboardType: TextInputType.text,
                    ),
                  ),
                  // Password TextField
                  Container(
                    margin: const EdgeInsets.only(bottom: 40.0),
                    decoration: BoxDecoration(
                      image: const DecorationImage(
                        image: AssetImage('assets/rect1.png'), // Use AppAssets.rect1
                        fit: BoxFit.cover,
                        repeat: ImageRepeat.repeat,
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: TextField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Enter your password',
                        hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                        border: InputBorder.none,
                        prefixIcon: const Icon(Icons.lock, color: Colors.white70),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword ? Icons.visibility_off : Icons.visibility,
                            color: Colors.white70,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
                      keyboardType: TextInputType.text,
                    ),
                  ),
                  // Error message display
                  if (_errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Text(
                        _errorMessage!,
                        style: const TextStyle(color: Colors.redAccent, fontSize: 14), // Use AppColors.redAccent
                        textAlign: TextAlign.center, // Center the error message
                      ),
                    ),
                  // Login button or CircularProgressIndicator
                  _isLoading
                      ? const CircularProgressIndicator(color: Color(0xFF5D4037)) // Consider defining this color in AppColors
                      : styledButton(text: 'Login', onPressed: _login),
                  const SizedBox(height: 50),
                  // Copyright text
                  const Text(
                    '© Ferrero 2022. All rights reserved.',
                    style: TextStyle(fontSize: 12, color: Colors.black),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}