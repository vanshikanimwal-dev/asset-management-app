// // // import 'package:flutter/material.dart';
// // // import 'dart:async'; // For Timer
// // // import 'dart:ui'; // For ImageFilter.blur
// // // import 'package:flutter/services.dart'; // REQUIRED: Import for MethodChannel
// // // import 'package:http/http.dart' as http; // Already added for API call
// // // import 'package:ferrero_asset_management/widgets/styled_button.dart';
// // // import 'package:ferrero_asset_management/widgets/otp_input_field.dart';
// // // import 'package:ferrero_asset_management/screens/completion/completion_page.dart';
// // // import 'dart:math'; // For OTP generation
// // // //use DataProvider to put all the assets details in one place to use while sending in the uploads request
// // // import 'package:provider/provider.dart';
// // // import 'package:ferrero_asset_management/provider/data_provider.dart';
// // // import 'package:ferrero_asset_management/services/asset_upload_service.dart';
// // // import 'package:logging/logging.dart';
// // // import 'package:ferrero_asset_management/screens/auth/global_auth_token.dart' as globals;
// // //
// // // class ConsentAndOtpVerificationPage extends StatefulWidget {
// // //   final String outletOwnerNumber;
// // //   final String outletName;
// // //   final String username;
// // //   final Map<String, String?> capturedImages; // Captured image paths from AssetCapturePage
// // //   final String? capturedLocation; // Captured location from AssetCapturePage
// // //   static final Logger log = Logger('ConsentAndOtpVerificationPage');
// // //
// // //   const ConsentAndOtpVerificationPage({
// // //     super.key,
// // //     required this.outletOwnerNumber,
// // //     required this.outletName,
// // //     required this.username,
// // //     required this.capturedImages,
// // //     this.capturedLocation,
// // //   });
// // //
// // //   @override
// // //   State<ConsentAndOtpVerificationPage> createState() => _ConsentAndOtpVerificationPageState();
// // // }
// // //
// // // class _ConsentAndOtpVerificationPageState extends State<ConsentAndOtpVerificationPage> {
// // //   final TextEditingController _otpController = TextEditingController();
// // //   bool _isOtpSent = false;
// // //   bool _hasAgreed = false;
// // //   Timer? _timer;
// // //   int _start = 120; // 2 minutes
// // //   bool _canResendOtp = false;
// // //
// // //   // Store the generated OTP here for client-side verification
// // //   String _generatedOtp = '';
// // //
// // //   // Define the MethodChannel here. Ensure the name matches the one in MainActivity.kt
// // //   static const platform = MethodChannel('com.ferrero.asset_management/sms');
// // //
// // //   @override
// // //   void dispose() {
// // //     _otpController.dispose();
// // //     _timer?.cancel();
// // //     super.dispose();
// // //   }
// // //
// // //   void _startTimer() {
// // //     _canResendOtp = false;
// // //     _start = 120;
// // //     const oneSec = Duration(seconds: 1);
// // //     _timer = Timer.periodic(
// // //       oneSec,
// // //           (Timer timer) {
// // //         if (_start == 0) {
// // //           setState(() {
// // //             timer.cancel();
// // //             _canResendOtp = true;
// // //           });
// // //         } else {
// // //           setState(() {
// // //             _start--;
// // //           });
// // //         }
// // //       },
// // //     );
// // //   }
// // //
// // //   String _formatTimer() {
// // //     int minutes = _start ~/ 60;
// // //     int seconds = _start % 60;
// // //     return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
// // //   }
// // //
// // //   // Function to generate a random OTP
// // //   String _generateRandomOtp() {
// // //     Random random = Random();
// // //     String otp = '';
// // //     for (int i = 0; i < 6; i++) { // 6-digit OTP
// // //       otp += random.nextInt(10).toString();
// // //     }
// // //     return otp;
// // //   }
// // //
// // //   // MODIFIED: _sendOtp now only sends the OTP
// // //   Future<void> _sendOtp() async {
// // //     String phoneNumber = "+91${widget.outletOwnerNumber}";
// // //
// // //     _generatedOtp = _generateRandomOtp();
// // //     // Reverted: Only send the OTP in the initial SMS
// // //     String message = 'Your Ferrero verification code is: $_generatedOtp';
// // //
// // //     try {
// // //       final bool result = await platform.invokeMethod(
// // //         'sendSms',
// // //         <String, dynamic>{
// // //           'phoneNumber': phoneNumber,
// // //           'message': message,
// // //         },
// // //       );
// // //
// // //       if (result) {
// // //         setState(() {
// // //           _isOtpSent = true;
// // //           _canResendOtp = false;
// // //         });
// // //         _startTimer();
// // //         _showDialog('OTP Sent', 'OTP sent successfully for confirmation!');
// // //         print('Native SMS sent to $phoneNumber with OTP: $_generatedOtp');
// // //       } else {
// // //         _showDialog('SMS Sending Failed', 'Failed to send OTP via native code. Check permissions/log.');
// // //         print('Native SMS sending failed to $phoneNumber');
// // //       }
// // //     } on PlatformException catch (e) {
// // //       _showDialog('Error', 'Failed to send OTP: ${e.message}');
// // //       print("Failed to send SMS via platform channel: '${e.message}'.");
// // //     } catch (e) {
// // //       _showDialog('Error', 'An unexpected error occurred: ${e.toString()}');
// // //       print('An unexpected error occurred during SMS sending: ${e.toString()}');
// // //     }
// // //   }
// // //
// // //   // MODIFIED: _verifyOtp now sends the link SMS after successful verification
// // //   Future<void> _verifyOtp() async {
// // //     String enteredOtp = _otpController.text.trim();
// // //
// // //     if (enteredOtp.isEmpty) {
// // //       _showDialog('OTP Required', 'Please enter the OTP.');
// // //       return;
// // //     }
// // //     if (_start == 0 && _isOtpSent) {
// // //       _showDialog('OTP Expired', 'OTP expired. Please resend OTP.');
// // //       return;
// // //     }
// // //
// // //     // --- CRITICAL CHANGE: Show loading dialog IMMEDIATELY ---
// // //     // This ensures the UI doesn't freeze while operations are in progress.
// // //     _showLoadingDialog();
// // //
// // //     if (enteredOtp == _generatedOtp) {
// // //       // --- CRITICAL CHANGE: Only cancel the timer if OTP is correct ---
// // //       _timer?.cancel();
// // //
// // //       final dataProvider = Provider.of<DataProvider>(context, listen: false);
// // //
// // //       // --- Data Saving to DataProvider ---
// // //       if (widget.capturedImages.isNotEmpty) {
// // //         dataProvider.addImages(widget.capturedImages);
// // //       } else {
// // //         ConsentAndOtpVerificationPage.log.info('No captured images to add to DataProvider.');
// // //       }
// // //
// // //       if (widget.capturedLocation != null && widget.capturedLocation!.isNotEmpty) {
// // //         dataProvider.setLocation(widget.capturedLocation);
// // //       } else {
// // //         ConsentAndOtpVerificationPage.log.info('No captured location to add to DataProvider.');
// // //       }
// // //
// // //       if (widget.username.isNotEmpty) {
// // //         dataProvider.setUsername(widget.username);
// // //       }
// // //
// // //       dataProvider.finalizeAllUpdates();
// // //
// // //       // Call AssetUploadService ---
// // //       ConsentAndOtpVerificationPage.log.info("Calling AssetUploadService to upload data...");
// // //       AssetUploadService uploadService = AssetUploadService();
// // //       Map<String, dynamic> uploadResult;
// // //
// // //       try {
// // //         uploadResult = await uploadService.uploadDataWithJsonAndImages(
// // //           dataProvider: dataProvider,
// // //           bearerToken: globals.authToken,
// // //         );
// // //
// // //         ConsentAndOtpVerificationPage.log.info(
// // //             'Asset Upload Result: ${uploadResult['success'] ? "SUCCESS" : "FAILURE"} - ${uploadResult['message']}');
// // //
// // //         if (!uploadResult['success']) {
// // //           // Dismiss loading dialog and show an error if upload fails
// // //           if (mounted && Navigator.of(context).canPop()) {
// // //             Navigator.of(context).pop(); // Dismiss loading dialog
// // //           }
// // //           _showDialog('Upload Failed', uploadResult['message'] ?? 'Data upload failed. Please try again.');
// // //           return; // Stop further execution if upload failed
// // //         }
// // //
// // //       } catch (e, s) {
// // //         ConsentAndOtpVerificationPage.log.severe("Exception calling AssetUploadService from _verifyOtp", e, s);
// // //         // Dismiss loading dialog on exception
// // //         if (mounted && Navigator.of(context).canPop()) {
// // //           Navigator.of(context).pop();
// // //         }
// // //         _showDialog('Error', 'An unexpected error occurred during data submission: ${e.toString()}. Please try again.');
// // //         return; // Stop further execution on exception
// // //       }
// // //
// // //       // --- Execute Link SMS and API Call in Parallel ---
// // //       String phoneNumberForLinkSms = "+91${widget.outletOwnerNumber}";
// // //       String linkSmsMessage = 'consent form-https://sarsatiya.store/XJAAM-0.0.1-SNAPSHOT/getvendordata/6499630664';
// // //
// // //       String vendorNumber = widget.outletOwnerNumber;
// // //       if (vendorNumber.startsWith('+91')) {
// // //         vendorNumber = vendorNumber.substring(3);
// // //       } else if (vendorNumber.length > 10) {
// // //         if (vendorNumber.startsWith('0')) {
// // //           vendorNumber = vendorNumber.substring(1);
// // //         }
// // //       }
// // //       final String apiUrl = 'https://sarsatiya.store/XJAAM-0.0.1-SNAPSHOT/getvendordata/$vendorNumber';
// // //
// // //       // Create Futures for both operations
// // //       Future<bool> sendLinkSmsFuture = (() async {
// // //         ConsentAndOtpVerificationPage.log.info('Attempting to send link SMS to: $phoneNumberForLinkSms');
// // //         try {
// // //           final bool resultLinkSms = await platform.invokeMethod(
// // //             'sendSms',
// // //             <String, dynamic>{
// // //               'phoneNumber': phoneNumberForLinkSms,
// // //               'message': linkSmsMessage,
// // //             },
// // //           );
// // //           if (resultLinkSms) {
// // //             ConsentAndOtpVerificationPage.log.info('Link SMS sent successfully after OTP verification to $phoneNumberForLinkSms');
// // //           } else {
// // //             ConsentAndOtpVerificationPage.log.warning('Link SMS sending failed after OTP verification to $phoneNumberForLinkSms');
// // //           }
// // //           return resultLinkSms;
// // //         } on PlatformException catch (e, s) {
// // //           ConsentAndOtpVerificationPage.log.severe("Failed to send link SMS via platform channel after verification", e, s);
// // //           return false;
// // //         } catch (e, s) {
// // //           ConsentAndOtpVerificationPage.log.severe('An unexpected error occurred during link SMS sending', e, s);
// // //           return false;
// // //         }
// // //       })();
// // //
// // //       Future<void> makeApiCallFuture = (() async {
// // //         ConsentAndOtpVerificationPage.log.info('Attempting to send GET request to: $apiUrl (Backend)');
// // //         try {
// // //           final response = await http.get(Uri.parse(apiUrl));
// // //           if (response.statusCode == 200) {
// // //             ConsentAndOtpVerificationPage.log.info('API call to $apiUrl successful. Response: ${response.body}');
// // //           } else {
// // //             ConsentAndOtpVerificationPage.log.warning('API call to $apiUrl failed with status: ${response.statusCode}, Body: ${response.body}');
// // //           }
// // //         } catch (e, s) {
// // //           ConsentAndOtpVerificationPage.log.severe('Error making API call to $apiUrl', e, s);
// // //         }
// // //       })();
// // //
// // //       // Wait for both futures to complete
// // //       await Future.wait([
// // //         sendLinkSmsFuture,
// // //         makeApiCallFuture,
// // //       ]);
// // //
// // //       // Dismiss the loading dialog once all operations are complete
// // //       if (mounted && Navigator.of(context).canPop()) {
// // //         Navigator.of(context).pop(); // Dismiss loading dialog
// // //       }
// // //
// // //       // Show final success pop-up. The navigation will happen when 'OK' is pressed.
// // //       _showDialog(
// // //         'Success',
// // //         'Consent form sent!',
// // //         onOkPressed: () {
// // //           // Dismiss success dialog
// // //           if (mounted && Navigator.of(context).canPop()) {
// // //             Navigator.of(context).pop();
// // //           }
// // //
// // //           Navigator.push( // Navigate to CompletionPage
// // //             context,
// // //             MaterialPageRoute(
// // //               builder: (context) => CompletionPage(
// // //                 outletName: widget.outletName,
// // //                 username: widget.username,
// // //               ),
// // //             ),
// // //           );
// // //         },
// // //       );
// // //
// // //     } else {
// // //       // --- CRITICAL CHANGE: Dismiss loading dialog if OTP is invalid ---
// // //       if (mounted && Navigator.of(context).canPop()) {
// // //         Navigator.of(context).pop(); // Dismiss loading dialog
// // //       }
// // //       _showDialog('Invalid OTP', 'Invalid OTP. Please try again.');
// // //     }
// // //     ConsentAndOtpVerificationPage.log.info('Attempted OTP verification with: $enteredOtp (Generated: $_generatedOtp)');
// // //   }
// // //
// // //   void _onAgreePressed() {
// // //     setState(() {
// // //       _hasAgreed = true;
// // //     });
// // //     // This will trigger the UI to show the OTP field and start the timer
// // //     _sendOtp(); // This will now send only the OTP
// // //   }
// // //
// // //   // MODIFIED: _showDialog now accepts an optional onOkPressed callback
// // //   void _showDialog(String title, String message, {VoidCallback? onOkPressed}) {
// // //     showDialog(
// // //       context: context,
// // //       barrierDismissible: false, // Prevents user from dismissing by tapping outside
// // //       builder: (BuildContext context) {
// // //         return AlertDialog(
// // //           title: Text(title),
// // //           content: Text(message),
// // //           actions: <Widget>[
// // //             TextButton(
// // //               child: const Text('OK'),
// // //               onPressed: () {
// // //                 // This pop ensures the current dialog is dismissed before the next action (navigation)
// // //                 Navigator.of(context).pop(); // Dismiss THIS dialog
// // //                 if (onOkPressed != null) {
// // //                   onOkPressed(); // Execute the provided callback (which includes navigation)
// // //                 }
// // //               },
// // //             ),
// // //           ],
// // //         );
// // //       },
// // //     );
// // //   }
// // //
// // //   // NEW: Function to show a loading dialog
// // //   void _showLoadingDialog() {
// // //     showDialog(
// // //       context: context,
// // //       barrierDismissible: false, // User must wait
// // //       builder: (BuildContext context) {
// // //         return const AlertDialog(
// // //           content: Row(
// // //             mainAxisSize: MainAxisSize.min, // Added to prevent excessive width
// // //             children: [
// // //               CircularProgressIndicator(),
// // //               SizedBox(width: 20), // Spacing between indicator and text
// // //               Text("Processing..."), // User-friendly text
// // //             ],
// // //           ),
// // //         );
// // //       },
// // //     );
// // //   }
// // //
// // //
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       backgroundColor: const Color(0xFFFAF6EF),
// // //       body: SingleChildScrollView(
// // //         child: Padding(
// // //           padding: const EdgeInsets.all(20.0),
// // //           child: Column(
// // //             crossAxisAlignment: CrossAxisAlignment.start,
// // //             children: [
// // //               Padding(
// // //                 padding: const EdgeInsets.only(top: 30.0, bottom: 20.0),
// // //                 child: GestureDetector(
// // //                   onTap: () => Navigator.pop(context),
// // //                   child: const Row(
// // //                     mainAxisSize: MainAxisSize.min,
// // //                     children: [
// // //                       Icon(Icons.arrow_back_ios, color: Colors.brown, size: 20),
// // //                       Text('Back', style: TextStyle(fontSize: 18, color: Colors.brown)),
// // //                     ],
// // //                   ),
// // //                 ),
// // //               ),
// // //               const SizedBox(height: 15),
// // //               ClipRect(
// // //                 child: BackdropFilter(
// // //                   filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
// // //                   child: Container(
// // //                     height: 1.0,
// // //                     decoration: BoxDecoration(
// // //                       color: Colors.brown.withOpacity(0.2),
// // //                       boxShadow: [
// // //                         BoxShadow(
// // //                           color: Colors.black.withOpacity(0.1),
// // //                           blurRadius: 5.0,
// // //                           offset: const Offset(0, 3),
// // //                         ),
// // //                       ],
// // //                     ),
// // //                   ),
// // //                 ),
// // //               ),
// // //               const SizedBox(height: 20),
// // //               Container(
// // //                 padding: const EdgeInsets.all(15.0),
// // //                 decoration: BoxDecoration(
// // //                   image: const DecorationImage(
// // //                     image: AssetImage('assets/rect1.png'), // Use AppAssets.rect1
// // //                     fit: BoxFit.cover,
// // //                     repeat: ImageRepeat.repeat,
// // //                     colorFilter: ColorFilter.mode(Colors.black38, BlendMode.darken),
// // //                   ),
// // //                   borderRadius: BorderRadius.circular(15),
// // //                   boxShadow: [
// // //                     BoxShadow(
// // //                       color: Colors.black.withOpacity(0.1),
// // //                       blurRadius: 10,
// // //                       spreadRadius: 2,
// // //                       offset: const Offset(0, 5),
// // //                     ),
// // //                   ],
// // //                 ),
// // //                 child: const Column(
// // //                   crossAxisAlignment: CrossAxisAlignment.start,
// // //                   children: [
// // //                     Text(
// // //                       'Consent Statement',
// // //                       style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
// // //                     ),
// // //                     SizedBox(height: 15),
// // //                     SizedBox(
// // //                       height: 200,
// // //                       child: SingleChildScrollView(
// // //                         child: Text(
// // //                           'I hereby give my full consent to Ferrero to collect, use, and store my information for the purpose of asset verification and audit. '
// // //                               'This includes location data, photos of assets, and personal identification details as required for the verification process.\n\n'
// // //                               'I understand that my participation is voluntary and that I may withdraw my consent at any time without any consequences. All data collected will be kept confidential and used solely for the stated purpose.\n\n'
// // //                               'By agreeing below, I acknowledge that I have read and understood this consent statement.',
// // //                           style: TextStyle(fontSize: 16, color: Colors.white70, height: 1.5),
// // //                         ),
// // //                       ),
// // //                     ),
// // //                   ],
// // //                 ),
// // //               ),
// // //               const SizedBox(height: 20),
// // //               Center(
// // //                 child: styledButton(
// // //                   text: ' Agree',
// // //                   onPressed: _hasAgreed ? null : _onAgreePressed,
// // //                   buttonColor: _hasAgreed ? Colors.grey : Colors.green.shade700,
// // //                   width: 150,
// // //                 ),
// // //               ),
// // //               const SizedBox(height: 30),
// // //               if (_hasAgreed) // This shows the OTP input only after _hasAgreed is true
// // //                 Column(
// // //                   crossAxisAlignment: CrossAxisAlignment.start,
// // //                   children: [
// // //                     Text(
// // //                       'Sending OTP to: ${widget.outletOwnerNumber}',
// // //                       style: const TextStyle(fontSize: 16, color: Colors.brown, fontWeight: FontWeight.bold),
// // //                     ),
// // //                     const SizedBox(height: 10),
// // //                     OtpInputField(
// // //                       controller: _otpController,
// // //                       labelText: 'Enter OTP:',
// // //                       hintText: 'Enter 6-digit OTP',
// // //                       keyboardType: TextInputType.number,
// // //                       buttonText: 'Verify OTP',
// // //                       onButtonPressed: _verifyOtp,
// // //                       showTimer: _isOtpSent && _start > 0,
// // //                       timerText: _formatTimer(),
// // //                       onResendPressed: _canResendOtp ? _sendOtp : null, // Pass resend function
// // //                       canResend: _canResendOtp, // Pass canResend state
// // //                     ),
// // //                   ],
// // //                 ),
// // //               const SizedBox(height: 30),
// // //             ],
// // //           ),
// // //         ),
// // //       ),
// // //     );
// // //   }
// // // }
// // // import 'package:flutter/material.dart';
// // // import 'dart:async'; // For Timer
// // // import 'dart:ui'; // For ImageFilter.blur
// // // import 'package:flutter/services.dart'; // REQUIRED: Import for MethodChannel
// // // import 'package:http/http.dart' as http; // Already added for API call
// // // import 'package:ferrero_asset_management/widgets/styled_button.dart';
// // // import 'package:ferrero_asset_management/widgets/otp_input_field.dart';
// // // import 'package:ferrero_asset_management/screens/completion/completion_page.dart';
// // // import 'dart:math'; // For OTP generation
// // // import 'package:provider/provider.dart';
// // // import 'package:ferrero_asset_management/provider/data_provider.dart';
// // // import 'package:ferrero_asset_management/services/asset_upload_service.dart';
// // // import 'package:logging/logging.dart';
// // // import 'package:ferrero_asset_management/screens/auth/global_auth_token.dart' as globals;
// // // import 'package:ferrero_asset_management/services/student_service.dart';
// // // import 'package:ferrero_asset_management/models/student_sitting.dart'; // <--- CRITICAL: ADDED THIS IMPORT
// // //
// // // class ConsentAndOtpVerificationPage extends StatefulWidget {
// // //   final String outletOwnerNumber;
// // //   final String outletName;
// // //   final String username;
// // //   final Map<String, String?> capturedImages; // Captured image paths from AssetCapturePage
// // //   final String? capturedLocation; // Captured location from AssetCapturePage
// // //   static final Logger log = Logger('ConsentAndOtpVerificationPage');
// // //
// // //   const ConsentAndOtpVerificationPage({
// // //     super.key,
// // //     required this.outletOwnerNumber,
// // //     required this.outletName,
// // //     required this.username,
// // //     required this.capturedImages,
// // //     this.capturedLocation,
// // //   });
// // //
// // //   @override
// // //   State<ConsentAndOtpVerificationPage> createState() => _ConsentAndOtpVerificationPageState();
// // // }
// // //
// // // class _ConsentAndOtpVerificationPageState extends State<ConsentAndOtpVerificationPage> {
// // //   final TextEditingController _otpController = TextEditingController();
// // //   bool _isOtpSent = false;
// // //   bool _hasAgreed = false;
// // //   Timer? _timer;
// // //   int _start = 120; // 2 minutes
// // //   bool _canResendOtp = false;
// // //
// // //   String _generatedOtp = ''; // Store the generated OTP here for client-side verification
// // //
// // //   static const platform = MethodChannel('com.ferrero.asset_management/sms');
// // //
// // //   final StudentService _studentService = StudentService();
// // //
// // //   @override
// // //   void dispose() {
// // //     _otpController.dispose();
// // //     _timer?.cancel();
// // //     super.dispose();
// // //   }
// // //
// // //   void _startTimer() {
// // //     _canResendOtp = false;
// // //     _start = 120;
// // //     const oneSec = Duration(seconds: 1);
// // //     _timer = Timer.periodic(
// // //       oneSec,
// // //           (Timer timer) {
// // //         if (_start == 0) {
// // //           setState(() {
// // //             timer.cancel();
// // //             _canResendOtp = true;
// // //           });
// // //         } else {
// // //           setState(() {
// // //             _start--;
// // //           });
// // //         }
// // //       },
// // //     );
// // //   }
// // //
// // //   String _formatTimer() {
// // //     int minutes = _start ~/ 60;
// // //     int seconds = _start % 60;
// // //     return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
// // //   }
// // //
// // //   String _generateRandomOtp() {
// // //     Random random = Random();
// // //     String otp = '';
// // //     for (int i = 0; i < 6; i++) { // 6-digit OTP
// // //       otp += random.nextInt(10).toString();
// // //     }
// // //     return otp;
// // //   }
// // //
// // //   Future<void> _sendOtp() async {
// // //     print('DEBUG: _sendOtp() called. (ConsentAndOtpVerificationPage)'); // <--- DEBUG POINT A
// // //     String phoneNumber = "+91${widget.outletOwnerNumber}";
// // //
// // //     _generatedOtp = _generateRandomOtp();
// // //     String message = 'Your Ferrero verification code is: $_generatedOtp';
// // //
// // //     print('DEBUG: Attempting to send SMS to $phoneNumber with OTP: $_generatedOtp'); // <--- DEBUG POINT B
// // //
// // //     try {
// // //       final bool result = await platform.invokeMethod(
// // //         'sendSms',
// // //         <String, dynamic>{
// // //           'phoneNumber': phoneNumber,
// // //           'message': message,
// // //         },
// // //       );
// // //
// // //       if (result) {
// // //         setState(() {
// // //           _isOtpSent = true;
// // //           _canResendOtp = false;
// // //         });
// // //         _startTimer();
// // //         _showDialog('OTP Sent', 'OTP sent successfully for confirmation!');
// // //         print('DEBUG: Native SMS sent to $phoneNumber with OTP: $_generatedOtp'); // <--- DEBUG POINT C
// // //       } else {
// // //         _showDialog('SMS Sending Failed', 'Failed to send OTP via native code. Check permissions/log.');
// // //         print('DEBUG: Native SMS sending failed to $phoneNumber'); // <--- DEBUG POINT D
// // //       }
// // //     } on PlatformException catch (e) {
// // //       _showDialog('Error', 'Failed to send OTP: ${e.message}');
// // //       print("DEBUG: PlatformException sending SMS: '${e.message}'."); // <--- DEBUG POINT E
// // //     } catch (e) {
// // //       _showDialog('Error', 'An unexpected error occurred: ${e.toString()}');
// // //       print('DEBUG: Unexpected error during SMS sending: ${e.toString()}'); // <--- DEBUG POINT F
// // //     }
// // //   }
// // //
// // //   Future<void> _verifyOtp() async {
// // //     print('DEBUG: _verifyOtp() method started. (ConsentAndOtpVerificationPage)'); // <--- DEBUG POINT 1
// // //     String enteredOtp = _otpController.text.trim();
// // //
// // //     if (enteredOtp.isEmpty) {
// // //       _showDialog('OTP Required', 'Please enter the OTP.');
// // //       print('DEBUG: OTP is empty. Exiting _verifyOtp().'); // <--- DEBUG POINT 2
// // //       return;
// // //     }
// // //     if (_start == 0 && _isOtpSent) {
// // //       _showDialog('OTP Expired', 'OTP expired. Please resend OTP.');
// // //       print('DEBUG: OTP expired. Exiting _verifyOtp().'); // <--- DEBUG POINT 3
// // //       return;
// // //     }
// // //
// // //     _showLoadingDialog();
// // //     print('DEBUG: Loading dialog shown. (ConsentAndOtpVerificationPage)'); // <--- DEBUG POINT 4
// // //
// // //     if (enteredOtp == _generatedOtp) {
// // //       print('DEBUG: OTP matched. Proceeding with operations. (ConsentAndOtpVerificationPage)'); // <--- DEBUG POINT 5
// // //       _timer?.cancel();
// // //
// // //       // --- Fetch Student Data Immediately After OTP Verification ---
// // //       ConsentAndOtpVerificationPage.log.info('OTP Verified. Attempting to fetch all students sitting data NOW.');
// // //       try {
// // //         print('DEBUG: Calling _studentService.fetchAllStudentsSitting()...'); // <--- DEBUG POINT 6
// // //
// // //         // Check if authToken is available before making the call
// // //         if (globals.authToken == null || globals.authToken!.isEmpty) {
// // //           print('DEBUG: WARNING: globals.authToken is null or empty. Cannot fetch student data.'); // <--- DEBUG POINT 6.1
// // //           ConsentAndOtpVerificationPage.log.warning('globals.authToken is null or empty. Cannot fetch student data without authorization.');
// // //           // Optionally, handle this error more gracefully (e.g., show a specific dialog)
// // //         } else {
// // //           // MODIFIED: Pass the bearerToken from globals.authToken
// // //           List<StudentSitting> studentsData = await _studentService.fetchAllStudentsSitting(
// // //             bearerToken: globals.authToken!, // Pass the token here
// // //           );
// // //           print('DEBUG: _studentService.fetchAllStudentsSitting() completed. Fetched ${studentsData.length} items.'); // <--- DEBUG POINT 7
// // //           ConsentAndOtpVerificationPage.log.info('Student data fetch completed after OTP verification. Count: ${studentsData.length}');
// // //         }
// // //       } catch (e, s) {
// // //         print('DEBUG: ERROR: Exception during student data fetch: $e'); // <--- DEBUG POINT 8
// // //         ConsentAndOtpVerificationPage.log.severe('Error fetching all students sitting data immediately after OTP verification: $e', e, s);
// // //       }
// // //       print('DEBUG: Student data fetch section complete. (ConsentAndOtpVerificationPage)'); // <--- DEBUG POINT 9
// // //
// // //       // --- Continue with existing DataProvider and AssetUploadService calls ---
// // //       final dataProvider = Provider.of<DataProvider>(context, listen: false);
// // //
// // //       if (widget.capturedImages.isNotEmpty) {
// // //         dataProvider.addImages(widget.capturedImages);
// // //       } else {
// // //         ConsentAndOtpVerificationPage.log.info('No captured images to add to DataProvider.');
// // //       }
// // //
// // //       if (widget.capturedLocation != null && widget.capturedLocation!.isNotEmpty) {
// // //         dataProvider.setLocation(widget.capturedLocation);
// // //       } else {
// // //         ConsentAndOtpVerificationPage.log.info('No captured location to add to DataProvider.');
// // //       }
// // //
// // //       if (widget.username.isNotEmpty) {
// // //         dataProvider.setUsername(widget.username);
// // //       }
// // //
// // //       dataProvider.finalizeAllUpdates();
// // //
// // //       // Call AssetUploadService ---
// // //       ConsentAndOtpVerificationPage.log.info("Calling AssetUploadService to upload data...");
// // //       AssetUploadService uploadService = AssetUploadService();
// // //       Map<String, dynamic> uploadResult;
// // //
// // //       try {
// // //         uploadResult = await uploadService.uploadDataWithJsonAndImages(
// // //           dataProvider: dataProvider,
// // //           bearerToken: globals.authToken,
// // //         );
// // //
// // //         ConsentAndOtpVerificationPage.log.info(
// // //             'Asset Upload Result: ${uploadResult['success'] ? "SUCCESS" : "FAILURE"} - ${uploadResult['message']}');
// // //
// // //         if (!uploadResult['success']) {
// // //           if (mounted && Navigator.of(context).canPop()) {
// // //             Navigator.of(context).pop();
// // //           }
// // //           _showDialog('Upload Failed', uploadResult['message'] ?? 'Data upload failed. Please try again.');
// // //           print('DEBUG: Upload Failed: ${uploadResult['message']}'); // <--- DEBUG POINT 10
// // //           return;
// // //         }
// // //
// // //       } catch (e, s) {
// // //         ConsentAndOtpVerificationPage.log.severe("Exception calling AssetUploadService from _verifyOtp", e, s);
// // //         if (mounted && Navigator.of(context).canPop()) {
// // //           Navigator.of(context).pop();
// // //         }
// // //         _showDialog('Error', 'An unexpected error occurred during data submission: ${e.toString()}. Please try again.');
// // //         print('DEBUG: Exception during AssetUploadService: $e'); // <--- DEBUG POINT 11
// // //         return;
// // //       }
// // //
// // //       // --- Execute Link SMS and Vendor API Call in Parallel ---
// // //       String phoneNumberForLinkSms = "+91${widget.outletOwnerNumber}";
// // //       String linkSmsMessage = 'consent form-https://sarsatiya.store/XJAAM-0.0.1-SNAPSHOT/getvendordata/6499630664';
// // //
// // //       String vendorNumber = widget.outletOwnerNumber;
// // //       if (vendorNumber.startsWith('+91')) {
// // //         vendorNumber = vendorNumber.substring(3);
// // //       } else if (vendorNumber.length > 10) {
// // //         if (vendorNumber.startsWith('0')) {
// // //           vendorNumber = vendorNumber.substring(1);
// // //         }
// // //       }
// // //       final String vendorApiUrl = 'https://sarsatiya.store/XJAAM-0.0.1-SNAPSHOT/getvendordata/$vendorNumber';
// // //
// // //       List<Future<void>> parallelOperations = [
// // //         (() async {
// // //           print('DEBUG: Attempting to send link SMS.'); // <--- DEBUG POINT 12
// // //           try {
// // //             final bool resultLinkSms = await platform.invokeMethod(
// // //               'sendSms',
// // //               <String, dynamic>{
// // //                 'phoneNumber': phoneNumberForLinkSms,
// // //                 'message': linkSmsMessage,
// // //               },
// // //             );
// // //             if (resultLinkSms) {
// // //               ConsentAndOtpVerificationPage.log.info('Link SMS sent successfully after OTP verification to $phoneNumberForLinkSms');
// // //               print('DEBUG: Link SMS sent successfully.'); // <--- DEBUG POINT 13
// // //             } else {
// // //               ConsentAndOtpVerificationPage.log.warning('Link SMS sending failed after OTP verification to $phoneNumberForLinkSms');
// // //               print('DEBUG: Link SMS sending failed.'); // <--- DEBUG POINT 14
// // //             }
// // //           } on PlatformException catch (e, s) {
// // //             ConsentAndOtpVerificationPage.log.severe("Failed to send link SMS via platform channel after verification", e, s);
// // //             print('DEBUG: PlatformException during link SMS: $e'); // <--- DEBUG POINT 15
// // //           } catch (e, s) {
// // //             ConsentAndOtpVerificationPage.log.severe('An unexpected error occurred during link SMS sending', e, s);
// // //             print('DEBUG: Unexpected error during link SMS: $e'); // <--- DEBUG POINT 16
// // //           }
// // //         })(),
// // //
// // //         (() async {
// // //           print('DEBUG: Attempting to send GET request to Vendor API.'); // <--- DEBUG POINT 17
// // //           try {
// // //             final response = await http.get(Uri.parse(vendorApiUrl));
// // //             if (response.statusCode == 200) {
// // //               ConsentAndOtpVerificationPage.log.info('API call to $vendorApiUrl successful. Response: ${response.body}');
// // //               print('DEBUG: Vendor API call successful. Status: 200'); // <--- DEBUG POINT 18
// // //             } else {
// // //               ConsentAndOtpVerificationPage.log.warning('API call to $vendorApiUrl failed with status: ${response.statusCode}, Body: ${response.body}');
// // //               print('DEBUG: Vendor API call failed. Status: ${response.statusCode}'); // <--- DEBUG POINT 19
// // //             }
// // //           } catch (e, s) {
// // //             ConsentAndOtpVerificationPage.log.severe('Error making API call to $vendorApiUrl', e, s);
// // //             print('DEBUG: Error making Vendor API call: $e'); // <--- DEBUG POINT 20
// // //           }
// // //         })(),
// // //       ];
// // //
// // //       await Future.wait(parallelOperations);
// // //       print('DEBUG: All parallel operations (SMS, Vendor API) completed.'); // <--- DEBUG POINT 21
// // //
// // //       if (mounted && Navigator.of(context).canPop()) {
// // //         Navigator.of(context).pop(); // Dismiss loading dialog
// // //         print('DEBUG: Loading dialog dismissed (after all ops).'); // <--- DEBUG POINT 22
// // //       }
// // //
// // //       _showDialog(
// // //         'Success',
// // //         'Consent form sent!',
// // //         onOkPressed: () {
// // //           print('DEBUG: Success dialog OK pressed.'); // <--- DEBUG POINT 23
// // //           if (mounted && Navigator.of(context).canPop()) {
// // //             Navigator.of(context).pop();
// // //           }
// // //
// // //           Navigator.push(
// // //             context,
// // //             MaterialPageRoute(
// // //               builder: (context) => CompletionPage(
// // //                 outletName: widget.outletName,
// // //                 username: widget.username,
// // //               ),
// // //             ),
// // //           );
// // //         },
// // //       );
// // //
// // //     } else {
// // //       if (mounted && Navigator.of(context).canPop()) {
// // //         Navigator.of(context).pop(); // Dismiss loading dialog
// // //         print('DEBUG: Loading dialog dismissed (invalid OTP).'); // <--- DEBUG POINT 24
// // //       }
// // //       _showDialog('Invalid OTP', 'Invalid OTP. Please try again.');
// // //       print('DEBUG: OTP did NOT match. Showing invalid OTP dialog.'); // <--- DEBUG POINT 25
// // //     }
// // //     print('DEBUG: _verifyOtp() method finished.'); // <--- DEBUG POINT 26
// // //     ConsentAndOtpVerificationPage.log.info('Attempted OTP verification with: $enteredOtp (Generated: $_generatedOtp)');
// // //   }
// // //
// // //   void _onAgreePressed() {
// // //     print('DEBUG: _onAgreePressed() called. (ConsentAndOtpVerificationPage)'); // <--- DEBUG POINT G
// // //     setState(() {
// // //       _hasAgreed = true;
// // //     });
// // //     _sendOtp();
// // //   }
// // //
// // //   void _showDialog(String title, String message, {VoidCallback? onOkPressed}) {
// // //     showDialog(
// // //       context: context,
// // //       barrierDismissible: false,
// // //       builder: (BuildContext context) {
// // //         return AlertDialog(
// // //           title: Text(title),
// // //           content: Text(message),
// // //           actions: <Widget>[
// // //             TextButton(
// // //               child: const Text('OK'),
// // //               onPressed: () {
// // //                 Navigator.of(context).pop();
// // //                 if (onOkPressed != null) {
// // //                   onOkPressed();
// // //                 }
// // //               },
// // //             ),
// // //           ],
// // //         );
// // //       },
// // //     );
// // //     print('DEBUG: Dialog "$title" shown. (ConsentAndOtpVerificationPage)'); // <--- DEBUG POINT H
// // //   }
// // //
// // //   void _showLoadingDialog() {
// // //     showDialog(
// // //       context: context,
// // //       barrierDismissible: false,
// // //       builder: (BuildContext context) {
// // //         return const AlertDialog(
// // //           content: Row(
// // //             mainAxisSize: MainAxisSize.min,
// // //             children: [
// // //               CircularProgressIndicator(),
// // //               SizedBox(width: 20),
// // //               Text("Processing..."),
// // //             ],
// // //           ),
// // //         );
// // //       },
// // //     );
// // //     print('DEBUG: Loading dialog initiated. (ConsentAndOtpVerificationPage)'); // <--- DEBUG POINT I
// // //   }
// // //
// // //
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     print('DEBUG: ConsentAndOtpVerificationPage build() called.'); // <--- DEBUG POINT J
// // //     return Scaffold(
// // //       backgroundColor: const Color(0xFFFAF6EF),
// // //       body: SingleChildScrollView(
// // //         child: Padding(
// // //           padding: const EdgeInsets.all(20.0),
// // //           child: Column(
// // //             crossAxisAlignment: CrossAxisAlignment.start,
// // //             children: [
// // //               Padding(
// // //                 padding: const EdgeInsets.only(top: 30.0, bottom: 20.0),
// // //                 child: GestureDetector(
// // //                   onTap: () {
// // //                     print('DEBUG: Back button pressed. (ConsentAndOtpVerificationPage)'); // <--- DEBUG POINT K
// // //                     Navigator.pop(context);
// // //                   },
// // //                   child: const Row(
// // //                     mainAxisSize: MainAxisSize.min,
// // //                     children: [
// // //                       Icon(Icons.arrow_back_ios, color: Colors.brown, size: 20),
// // //                       Text('Back', style: TextStyle(fontSize: 18, color: Colors.brown)),
// // //                     ],
// // //                   ),
// // //                 ),
// // //               ),
// // //               const SizedBox(height: 15),
// // //               ClipRect(
// // //                 child: BackdropFilter(
// // //                   filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
// // //                   child: Container(
// // //                     height: 1.0,
// // //                     decoration: BoxDecoration(
// // //                       color: Colors.brown.withOpacity(0.2),
// // //                       boxShadow: [
// // //                         BoxShadow(
// // //                           color: Colors.black.withOpacity(0.1),
// // //                           blurRadius: 5.0,
// // //                           offset: const Offset(0, 3),
// // //                         ),
// // //                       ],
// // //                     ),
// // //                   ),
// // //                 ),
// // //               ),
// // //               const SizedBox(height: 20),
// // //               Container(
// // //                 padding: const EdgeInsets.all(15.0),
// // //                 decoration: BoxDecoration(
// // //                   image: const DecorationImage(
// // //                     image: AssetImage('assets/rect1.png'),
// // //                     fit: BoxFit.cover,
// // //                     repeat: ImageRepeat.repeat,
// // //                     colorFilter: ColorFilter.mode(Colors.black38, BlendMode.darken),
// // //                   ),
// // //                   borderRadius: BorderRadius.circular(15),
// // //                   boxShadow: [
// // //                     BoxShadow(
// // //                       color: Colors.black.withOpacity(0.1),
// // //                       blurRadius: 10,
// // //                       spreadRadius: 2,
// // //                       offset: const Offset(0, 5),
// // //                     ),
// // //                   ],
// // //                 ),
// // //                 child: const Column(
// // //                   crossAxisAlignment: CrossAxisAlignment.start,
// // //                   children: [
// // //                     Text(
// // //                       'Consent Statement',
// // //                       style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
// // //                     ),
// // //                     SizedBox(height: 15),
// // //                     SizedBox(
// // //                       height: 200,
// // //                       child: SingleChildScrollView(
// // //                         child: Text(
// // //                           'I hereby give my full consent to Ferrero to collect, use, and store my information for the purpose of asset verification and audit. '
// // //                               'This includes location data, photos of assets, and personal identification details as required for the verification process.\n\n'
// // //                               'I understand that my participation is voluntary and that I may withdraw my consent at any time without any consequences. All data collected will be kept confidential and used solely for the stated purpose.\n\n'
// // //                               'By agreeing below, I acknowledge that I have read and understood this consent statement.',
// // //                           style: TextStyle(fontSize: 16, color: Colors.white70, height: 1.5),
// // //                         ),
// // //                       ),
// // //                     ),
// // //                   ],
// // //                 ),
// // //               ),
// // //               const SizedBox(height: 20),
// // //               Center(
// // //                 child: styledButton(
// // //                   text: ' Agree',
// // //                   onPressed: _hasAgreed ? null : _onAgreePressed,
// // //                   buttonColor: _hasAgreed ? Colors.grey : Colors.green.shade700,
// // //                   width: 150,
// // //                 ),
// // //               ),
// // //               const SizedBox(height: 30),
// // //               if (_hasAgreed)
// // //                 Column(
// // //                   crossAxisAlignment: CrossAxisAlignment.start,
// // //                   children: [
// // //                     Text(
// // //                       'Sending OTP to: ${widget.outletOwnerNumber}',
// // //                       style: const TextStyle(fontSize: 16, color: Colors.brown, fontWeight: FontWeight.bold),
// // //                     ),
// // //                     const SizedBox(height: 10),
// // //                     // --- TEMPORARY: Display generated OTP for debugging (REMOVE IN PRODUCTION!) ---
// // //                     Text(
// // //                       'DEBUG OTP: $_generatedOtp',
// // //                       style: const TextStyle(fontSize: 14, color: Colors.red, fontWeight: FontWeight.bold),
// // //                     ),
// // //                     const SizedBox(height: 10),
// // //                     // --- END TEMPORARY ---
// // //                     OtpInputField(
// // //                       controller: _otpController,
// // //                       labelText: 'Enter OTP:',
// // //                       hintText: 'Enter 6-digit OTP',
// // //                       keyboardType: TextInputType.number,
// // //                       buttonText: 'Verify OTP',
// // //                       onButtonPressed: _verifyOtp,
// // //                       showTimer: _isOtpSent && _start > 0,
// // //                       timerText: _formatTimer(),
// // //                       onResendPressed: _canResendOtp ? _sendOtp : null,
// // //                       canResend: _canResendOtp,
// // //                     ),
// // //                   ],
// // //                 ),
// // //               const SizedBox(height: 30),
// // //             ],
// // //           ),
// // //         ),
// // //       ),
// // //     );
// // //   }
// // // }

import 'package:flutter/material.dart';
import 'dart:async'; // For Timer
import 'dart:ui'; // For ImageFilter.blur
import 'package:flutter/services.dart'; // Required for PlatformException
import 'package:http/http.dart' as http; // Still used for direct vendor API call
import 'package:ferrero_asset_management/widgets/styled_button.dart';
import 'package:ferrero_asset_management/widgets/otp_input_field.dart';
import 'package:ferrero_asset_management/screens/completion/completion_page.dart';
import 'dart:math'; // For OTP generation
import 'package:provider/provider.dart';
import 'package:ferrero_asset_management/provider/data_provider.dart';
import 'package:logging/logging.dart';
import 'package:ferrero_asset_management/screens/auth/global_auth_token.dart' as globals;
import 'package:ferrero_asset_management/models/student_sitting.dart';
import 'package:ferrero_asset_management/services/app_api_service.dart'; // The consolidated AppApiService


class ConsentAndOtpVerificationPage extends StatefulWidget {
  final String outletOwnerNumber;
  final String outletName;
  final String username;
  final Map<String, String?> capturedImages; // Captured image paths from AssetCapturePage
  final String? capturedLocation; // Captured location from AssetCapturePage
  static final Logger log = Logger('ConsentAndOtpVerificationPage');

  const ConsentAndOtpVerificationPage({
    super.key,
    required this.outletOwnerNumber,
    required this.outletName,
    required this.username,
    required this.capturedImages,
    this.capturedLocation,
  });

  @override
  State<ConsentAndOtpVerificationPage> createState() => _ConsentAndOtpVerificationPageState();
}

class _ConsentAndOtpVerificationPageState extends State<ConsentAndOtpVerificationPage> {
  final TextEditingController _otpController = TextEditingController();
  bool _isOtpSent = false;
  bool _hasAgreed = false;
  Timer? _timer;
  int _start = 120; // 2 minutes
  bool _canResendOtp = false;

  String _generatedOtp = ''; // Store the generated OTP here for client-side verification

  @override
  void dispose() {
    _otpController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _canResendOtp = false;
    _start = 120;
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
          (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
            _canResendOtp = true;
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  String _formatTimer() {
    int minutes = _start ~/ 60;
    int seconds = _start % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  String _generateRandomOtp() {
    Random random = Random();
    String otp = '';
    for (int i = 0; i < 6; i++) { // 6-digit OTP
      otp += random.nextInt(10).toString();
    }
    return otp;
  }

  Future<void> _sendOtp() async {
    print('DEBUG: _sendOtp() called. (ConsentAndOtpVerificationPage)');
    String phoneNumber = "+91${widget.outletOwnerNumber}";

    _generatedOtp = _generateRandomOtp();
    String message = 'Your Ferrero verification code is: $_generatedOtp';

    // REMOVED: print('DEBUG: Attempting to send SMS to $phoneNumber with OTP: $_generatedOtp');

    try {
      final bool result = await AppApiService().sendSms(
        phoneNumber,
        message,
      );

      if (result) {
        setState(() {
          _isOtpSent = true;
          _canResendOtp = false;
        });
        _startTimer();
        _showDialog('OTP Sent', 'OTP sent successfully for confirmation!');
        // REMOVED: print('DEBUG: Native SMS sent to $phoneNumber with OTP: $_generatedOtp');
      } else {
        _showDialog('SMS Sending Failed', 'Failed to send OTP via native code. Check permissions/log.');
        print('DEBUG: Native SMS sending failed to $phoneNumber');
      }
    } on PlatformException catch (e) {
      _showDialog('Error', 'Failed to send OTP: ${e.message}');
      print("DEBUG: PlatformException sending SMS: '${e.message}'.");
    } catch (e) {
      _showDialog('Error', 'An unexpected error occurred: ${e.toString()}');
      print('DEBUG: Unexpected error during SMS sending: ${e.toString()}');
    }
  }

  Future<void> _verifyOtp() async {
    print('DEBUG: _verifyOtp() method started. (ConsentAndOtpVerificationPage)');
    String enteredOtp = _otpController.text.trim();

    if (enteredOtp.isEmpty) {
      _showDialog('OTP Required', 'Please enter the OTP.');
      print('DEBUG: OTP is empty. Exiting _verifyOtp().');
      return;
    }
    if (_start == 0 && _isOtpSent) {
      _showDialog('OTP Expired', 'OTP expired. Please resend OTP.');
      print('DEBUG: OTP expired. Exiting _verifyOtp().');
      return;
    }

    _showLoadingDialog();
    print('DEBUG: Loading dialog shown. (ConsentAndOtpVerificationPage)');

    if (enteredOtp == _generatedOtp) {
      print('DEBUG: OTP matched. Proceeding with operations. (ConsentAndOtpVerificationPage)');
      _timer?.cancel();

      // --- Fetch Student Data Immediately After OTP Verification ---
      ConsentAndOtpVerificationPage.log.info('OTP Verified. Attempting to fetch all students sitting data NOW.');
      try {
        print('DEBUG: Calling AppApiService().fetchAllStudentsSitting()...');

        if (globals.authToken == null || globals.authToken!.isEmpty) {
          print('DEBUG: WARNING: globals.authToken is null or empty. Cannot fetch student data.');
          ConsentAndOtpVerificationPage.log.warning('globals.authToken is null or empty. Cannot fetch student data without authorization.');
        } else {
          List<StudentSitting> studentsData = await AppApiService().fetchAllStudentsSitting(
            bearerToken: globals.authToken!,
          );
          print('DEBUG: AppApiService().fetchAllStudentsSitting() completed. Fetched ${studentsData.length} items.');
          ConsentAndOtpVerificationPage.log.info('Student data fetch completed after OTP verification. Count: ${studentsData.length}');

          if (studentsData.isNotEmpty) {
            print('DEBUG: Student Data Details:');
            for (var student in studentsData) {
              print('  - Student: ${student.toString()}');
            }
          } else {
            print('DEBUG: No student data found.');
          }
        }
      } catch (e, s) {
        print('DEBUG: ERROR: Exception during student data fetch: $e');
        ConsentAndOtpVerificationPage.log.severe('Error fetching all students sitting data immediately after OTP verification: $e', e, s);
      }
      print('DEBUG: Student data fetch section complete. (ConsentAndOtpVerificationPage)');

      // --- Continue with existing DataProvider and AssetUploadService calls ---
      final dataProvider = Provider.of<DataProvider>(context, listen: false);

      if (widget.capturedImages.isNotEmpty) {
        dataProvider.addImages(widget.capturedImages);
      } else {
        ConsentAndOtpVerificationPage.log.info('No captured images to add to DataProvider.');
      }

      if (widget.capturedLocation != null && widget.capturedLocation!.isNotEmpty) {
        dataProvider.setLocation(widget.capturedLocation);
      } else {
        ConsentAndOtpVerificationPage.log.info('No captured location to add to DataProvider.');
      }

      if (widget.username.isNotEmpty) {
        dataProvider.setUsername(widget.username);
      }

      dataProvider.finalizeAllUpdates();

      ConsentAndOtpVerificationPage.log.info("Calling AppApiService to upload data...");
      Map<String, dynamic> uploadResult;

      try {
        uploadResult = await AppApiService().uploadDataWithJsonAndImages(
          dataProvider: dataProvider,
          bearerToken: globals.authToken,
        );

        ConsentAndOtpVerificationPage.log.info(
            'Asset Upload Result: ${uploadResult['success'] ? "SUCCESS" : "FAILURE"} - ${uploadResult['message']}');

        if (!uploadResult['success']) {
          if (mounted && Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          }
          _showDialog('Upload Failed', uploadResult['message'] ?? 'Data upload failed. Please try again.');
          print('DEBUG: Upload Failed: ${uploadResult['message']}');
          return;
        }

      } catch (e, s) {
        ConsentAndOtpVerificationPage.log.severe("Exception calling AppApiService.uploadDataWithJsonAndImages from _verifyOtp", e, s);
        if (mounted && Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        }
        _showDialog('Error', 'An unexpected error occurred during data submission: ${e.toString()}. Please try again.');
        print('DEBUG: Exception during AppApiService.uploadDataWithJsonAndImages: $e');
        return;
      }

      // --- Execute Link SMS and Vendor API Call in Parallel ---
      String phoneNumberForLinkSms = "+91${widget.outletOwnerNumber}";
      String linkSmsMessage = 'consent form-https://sarsatiya.store/XJAAM-0.0.1-SNAPSHOT/getvendordata/6499630664';

      String vendorNumber = widget.outletOwnerNumber;
      if (vendorNumber.startsWith('+91')) {
        vendorNumber = vendorNumber.substring(3);
      } else if (vendorNumber.length > 10) {
        if (vendorNumber.startsWith('0')) {
          vendorNumber = vendorNumber.substring(1);
        }
      }
      final String vendorApiUrl = 'https://sarsatiya.store/XJAAM-0.0.1-SNAPSHOT/getvendordata/$vendorNumber';

      List<Future<void>> parallelOperations = [
        (() async {
          print('DEBUG: Attempting to send link SMS.');
          try {
            final bool resultLinkSms = await AppApiService().sendSms(
              phoneNumberForLinkSms,
              linkSmsMessage,
            );
            if (resultLinkSms) {
              ConsentAndOtpVerificationPage.log.info('Link SMS sent successfully after OTP verification to $phoneNumberForLinkSms');
              print('DEBUG: Link SMS sent successfully.');
            } else {
              ConsentAndOtpVerificationPage.log.warning('Link SMS sending failed after OTP verification to $phoneNumberForLinkSms');
              print('DEBUG: Link SMS sending failed.');
            }
          } on PlatformException catch (e, s) {
            ConsentAndOtpVerificationPage.log.severe("Failed to send link SMS via platform channel after verification", e, s);
            print('DEBUG: PlatformException during link SMS: $e');
          } catch (e, s) {
            ConsentAndOtpVerificationPage.log.severe('An unexpected error occurred during link SMS sending', e, s);
            print('DEBUG: Unexpected error during link SMS: $e');
          }
        })(),

        (() async {
          print('DEBUG: Attempting to send GET request to Vendor API.');
          try {
            final response = await http.get(Uri.parse(vendorApiUrl));
            if (response.statusCode == 200) {
              ConsentAndOtpVerificationPage.log.info('API call to $vendorApiUrl successful. Response: ${response.body}');
              print('DEBUG: Vendor API call successful. Status: 200');
            } else {
              ConsentAndOtpVerificationPage.log.warning('API call to $vendorApiUrl failed with status: ${response.statusCode}, Body: ${response.body}');
              print('DEBUG: Vendor API call failed. Status: ${response.statusCode}');
            }
          } catch (e, s) {
            ConsentAndOtpVerificationPage.log.severe('Error making API call to $vendorApiUrl', e, s);
            print('DEBUG: Error making Vendor API call: $e');
          }
        })(),
      ];

      await Future.wait(parallelOperations);
      print('DEBUG: All parallel operations (SMS, Vendor API) completed.');

      if (mounted && Navigator.of(context).canPop()) {
        Navigator.of(context).pop(); // Dismiss loading dialog
        print('DEBUG: Loading dialog dismissed (after all ops).');
      }

      _showDialog(
        'Success',
        'Consent form sent!',
        onOkPressed: () {
          print('DEBUG: Success dialog OK pressed.');
          if (mounted && Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          }

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CompletionPage(
                outletName: widget.outletName,
                username: widget.username,
              ),
            ),
          );
        },
      );

    } else {
      if (mounted && Navigator.of(context).canPop()) {
        Navigator.of(context).pop(); // Dismiss loading dialog
        print('DEBUG: Loading dialog dismissed (invalid OTP).');
      }
      _showDialog('Invalid OTP', 'Invalid OTP. Please try again.');
      print('DEBUG: OTP did NOT match. Showing invalid OTP dialog.');
    }
    print('DEBUG: _verifyOtp() method finished.');
    ConsentAndOtpVerificationPage.log.info('Attempted OTP verification with: $enteredOtp (Generated: $_generatedOtp)');
  }

  void _onAgreePressed() {
    print('DEBUG: _onAgreePressed() called. (ConsentAndOtpVerificationPage)');
    setState(() {
      _hasAgreed = true;
    });
    _sendOtp();
  }

  void _showDialog(String title, String message, {VoidCallback? onOkPressed}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                if (onOkPressed != null) {
                  onOkPressed();
                }
              },
            ),
          ],
        );
      },
    );
    print('DEBUG: Dialog "$title" shown. (ConsentAndOtpVerificationPage)');
  }

  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const AlertDialog(
          content: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Text("Processing..."),
            ],
          ),
        );
      },
    );
    print('DEBUG: Loading dialog initiated. (ConsentAndOtpVerificationPage)');
  }


  @override
  Widget build(BuildContext context) {
    print('DEBUG: ConsentAndOtpVerificationPage build() called.');
    return Scaffold(
      backgroundColor: const Color(0xFFFAF6EF),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 30.0, bottom: 20.0),
                child: GestureDetector(
                  onTap: () {
                    print('DEBUG: Back button pressed. (ConsentAndOtpVerificationPage)');
                    Navigator.pop(context);
                  },
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.arrow_back_ios, color: Colors.brown, size: 20),
                      Text('Back', style: TextStyle(fontSize: 18, color: Colors.brown)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 15),
              ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                  child: Container(
                    height: 1.0,
                    decoration: BoxDecoration(
                      color: Colors.brown.withOpacity(0.2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 5.0,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                  image: const DecorationImage(
                    image: AssetImage('assets/rect1.png'),
                    fit: BoxFit.cover,
                    repeat: ImageRepeat.repeat,
                    colorFilter: ColorFilter.mode(Colors.black38, BlendMode.darken),
                  ),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 2,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Consent Statement',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    SizedBox(height: 15),
                    SizedBox(
                      height: 200,
                      child: SingleChildScrollView(
                        child: Text(
                          'I hereby give my full consent to Ferrero to collect, use, and store my information for the purpose of asset verification and audit. '
                              'This includes location data, photos of assets, and personal identification details as required for the verification process.\n\n'
                              'I understand that my participation is voluntary and that I may withdraw my consent at any time without any consequences. All data collected will be kept confidential and used solely for the stated purpose.\n\n'
                              'By agreeing below, I acknowledge that I have read and understood this consent statement.',
                          style: TextStyle(fontSize: 16, color: Colors.white70, height: 1.5),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: styledButton(
                  text: ' Agree',
                  onPressed: _hasAgreed ? null : _onAgreePressed,
                  buttonColor: _hasAgreed ? Colors.grey : Colors.green.shade700,
                  width: 150,
                ),
              ),
              const SizedBox(height: 30),
              if (_hasAgreed)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sending OTP to: ${widget.outletOwnerNumber}',
                      style: const TextStyle(fontSize: 16, color: Colors.brown, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    // REMOVED: TEMPORARY: Display generated OTP for debugging (REMOVE IN PRODUCTION!)
                    // REMOVED: Text(
                    // REMOVED:   'DEBUG OTP: $_generatedOtp',
                    // REMOVED:   style: const TextStyle(fontSize: 14, color: Colors.red, fontWeight: FontWeight.bold),
                    // REMOVED: ),
                    // REMOVED: const SizedBox(height: 10),
                    // REMOVED: END TEMPORARY
                    OtpInputField(
                      controller: _otpController,
                      labelText: 'Enter OTP:',
                      hintText: 'Enter 6-digit OTP',
                      keyboardType: TextInputType.number,
                      buttonText: 'Verify OTP',
                      onButtonPressed: _verifyOtp,
                      showTimer: _isOtpSent && _start > 0,
                      timerText: _formatTimer(),
                      onResendPressed: _canResendOtp ? _sendOtp : null,
                      canResend: _canResendOtp,
                    ),
                  ],
                ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}