import 'dart:convert'; // Required for JSON encoding/decoding
import 'dart:io';     // Required for File operations (image upload)
import 'package:http/http.dart' as http; // Required for HTTP requests
import 'package:logging/logging.dart';   // Required for logging
import 'package:path/path.dart' as p;     // Required for path manipulation (image upload)

// Required because these models and provider classes are used within the service logic
import 'package:ferrero_asset_management/provider/data_provider.dart';
import 'package:ferrero_asset_management/models/shop_model.dart';
import 'package:ferrero_asset_management/models/student_sitting.dart';

import 'package:flutter/services.dart'; // Required for MethodChannel (SMS functionality)


/// A consolidated API and platform service for the Ferrero Asset Management application.
/// This class follows the Singleton pattern to ensure only one instance
/// is used throughout the application, managing various API calls
/// (HTTP requests) and platform-specific functionalities (like SMS).
class AppApiService {
  // --- Singleton Setup ---
  static final AppApiService _instance = AppApiService._internal();
  factory AppApiService() {
    return _instance;
  }
  AppApiService._internal();
  // --- End Singleton Setup ---

  // Logger for this consolidated service
  static final Logger _log = Logger('AppApiService');

  // --- API Base URLs and Paths ---
  // Base URL for your Apps Script Web App (for Shop data)
  static const String _googleAppsScriptBaseUrl = "https://script.google.com/macros/s/AKfycby1EebDOltRckL9qxyKXC_tBP5XoHiOfscjwIaPhiG3YAUrch_ljGAefyVUU5peLT05/exec";

  // Base URL for your Asset Upload API
  static const String _assetUploadBaseUrl = 'https://sarsatiya.store';
  static const String _assetUploadPath = '/XJAAM-0.0.1-SNAPSHOT/uploadproducts';

  // API URL for StudentSitting data
  static const String _studentsApiUrl = 'https://sarsatiya.store/XJAAM-0.0.1-SNAPSHOT/getallstudentsitting';

  // --- Method Channel for SMS ---
  // Must match the name on the native side (MainActivity.kt/AppDelegate.swift)
  static const MethodChannel _smsMethodChannel = MethodChannel('com.ferrero.asset_management/sms');

  // --- Shop API Methods (from ApiService) ---
  /// Fetches a list of all shops from the Google Apps Script API.
  ///
  /// Throws an [Exception] if the API call fails or returns an unexpected structure.
  Future<List<Shop>> fetchAllShops() async {
    _log.info('Fetching all shops from: $_googleAppsScriptBaseUrl');
    try {
      final response = await http.get(Uri.parse(_googleAppsScriptBaseUrl));

      if (response.statusCode == 200) {
        List<dynamic> jsonList = json.decode(response.body);
        if (jsonList is! List) {
          _log.severe('API returned a non-list structure for all shops. Body: ${response.body}');
          throw Exception('API returned a non-list structure. Check Apps Script output.');
        }
        _log.info('Successfully fetched ${jsonList.length} shops.');
        return jsonList.map((json) => Shop.fromJson(json)).toList();
      } else {
        _log.warning('Failed to load all shops. Status: ${response.statusCode}, Body: ${response.body}');
        throw Exception('Failed to load shops: ${response.statusCode} - ${response.body}');
      }
    } catch (e, stackTrace) {
      _log.severe('Failed to connect to API for all shops: $e', e, stackTrace);
      throw Exception('Failed to connect to API: $e');
    }
  }

  /// Fetches details for a specific shop by its [outletName] from the Google Apps Script API.
  ///
  /// Returns a [Shop] object if found, otherwise returns `null`.
  /// Throws an [Exception] if the API call fails or returns an unexpected structure.
  Future<Shop?> fetchShopDetails(String outletName) async {
    final uri = Uri.parse('$_googleAppsScriptBaseUrl?outletName=${Uri.encodeComponent(outletName)}');
    _log.info('Fetching shop details for "$outletName" from: $uri');
    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        List<dynamic> jsonList = json.decode(response.body);
        if (jsonList is! List) {
          _log.severe('API for details returned a non-list structure for "$outletName". Body: ${response.body}');
          throw Exception('API for details returned a non-list structure. Check Apps Script output for specific shop.');
        }
        if (jsonList.isNotEmpty) {
          _log.info('Successfully fetched details for "$outletName".');
          return Shop.fromJson(jsonList.first);
        }
        _log.info('Shop details for "$outletName" not found (empty response list).');
        return null;
      } else {
        _log.warning('Failed to load shop details for "$outletName". Status: ${response.statusCode}, Body: ${response.body}');
        throw Exception('Failed to load shop details: ${response.statusCode} - ${response.body}');
      }
    } catch (e, stackTrace) {
      _log.severe('Failed to connect to API for details of "$outletName": $e', e, stackTrace);
      throw Exception('Failed to connect to API for details: $e');
    }
  }

  // --- Asset Upload Methods (from AssetUploadService) ---
  /// Uploads data and images as a multipart request to the asset management backend.
  ///
  /// Requires a [DataProvider] instance containing the data and image paths,
  /// and a [bearerToken] for authorization.
  /// Returns a [Map<String, dynamic>] indicating success/failure and a message.
  Future<Map<String, dynamic>> uploadDataWithJsonAndImages({
    required DataProvider dataProvider,
    required String? bearerToken,
  }) async {
    _log.fine("uploadDataWithJsonAndImages called. Token received: ${bearerToken != null && bearerToken.isNotEmpty ? "Present" : "MISSING/EMPTY"}");

    if (bearerToken == null || bearerToken.isEmpty) {
      _log.severe("Bearer token is null or empty in AppApiService.uploadDataWithJsonAndImages.");
      return {'success': false, 'message': 'Authentication token is missing.'};
    }

    try {
      final Uri uploadUri = Uri.parse('$_assetUploadBaseUrl$_assetUploadPath');
      var request = http.MultipartRequest('POST', uploadUri);

      request.headers['Authorization'] = 'Bearer $bearerToken';

      Map<String, dynamic> jsonData = {
        'uoc': dataProvider.uoc,
        'outlet_name': dataProvider.outletNameFromConsentForm,
        'address': dataProvider.address,
        'vc_type': dataProvider.vcType,
        'vc_serial_no': dataProvider.vcSerialNo,
        'contact_person': dataProvider.contactPerson,
        'mobile_number': dataProvider.mobileNumberFromConsentForm,
        'state': dataProvider.state,
        'postal_code': dataProvider.postalCode,
        'username': dataProvider.username,
      };

      final capturedLocationString = dataProvider.capturedLocation;
      if (capturedLocationString != null && capturedLocationString.isNotEmpty) {
        final parts = capturedLocationString.split(', ');
        if (parts.length == 2) {
          jsonData['latitude'] = parts[0].replaceFirst('Lat: ', '');
          jsonData['longitude'] = parts[1].replaceFirst('Lng: ', '');
        } else {
          jsonData['raw_location_string'] = capturedLocationString;
        }
      }

      final String jsonToLog = JsonEncoder.withIndent('  ').convert(jsonData);

      request.fields['jsonData'] = jsonEncode(jsonData);

      final Map<String, String?> capturedImagePaths = dataProvider.allCapturedImages;
      for (var entry in capturedImagePaths.entries) {
        final String imageTypeKey = entry.key;
        final String? imagePath = entry.value;

        if (imagePath != null && imagePath.isNotEmpty) {
          File imageFile = File(imagePath);
          if (await imageFile.exists()) {
            String fileExtension = p.extension(imageFile.path);
            String desiredFilename = '$imageTypeKey$fileExtension';

            var multipartFile = await http.MultipartFile.fromPath(
              imageTypeKey,
              imagePath,
              filename: desiredFilename,
            );
            request.files.add(multipartFile);
          } else {
            _log.warning('Image file not found for type "$imageTypeKey": $imagePath');
          }
        }
      }

      String fileDetailsLog = 'Files to be uploaded (includes JSON part and images):\n';
      for (var file in request.files) {
        fileDetailsLog += '  - Field: ${file.field}, Filename: ${file.filename}, Length: ${file.length}, ContentType: ${file.contentType}\n';
      }

      _log.info('Uploading data with JSON and Images to $uploadUri...');
      _log.fine('Headers: ${request.headers}');
      _log.fine('JSON data:\n$jsonToLog');
      _log.fine('Image data:\n$fileDetailsLog');

      var response = await request.send();
      final responseBody = await response.stream.bytesToString();

      _log.info('Upload Response Status: ${response.statusCode}');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        _log.fine('Upload Response Body: $responseBody');
        return {'success': true, 'message': 'Data and images uploaded successfully!', 'body': responseBody};
      } else {
        _log.severe('Upload failed. Status: ${response.statusCode}, Body: ${responseBody}');
        return {'success': false, 'message': 'Upload failed. Status: ${response.statusCode}', 'body': responseBody};
      }
    } catch (e, stackTrace) {
      _log.severe('An error occurred during upload', e, stackTrace);
      return {'success': false, 'message': 'An error occurred: ${e.toString()}'};
    }
  }

  // --- SMS Service Methods (from SmsService) ---
  /// Checks if SMS permission is granted on the native platform.
  ///
  /// Returns `true` if permission is granted, `false` otherwise.
  Future<bool> checkSmsPermission() async {
    _log.info('Checking SMS permission via MethodChannel.');
    try {
      final bool hasPermission = await _smsMethodChannel.invokeMethod('checkSmsPermission');
      _log.info('SMS permission status: $hasPermission');
      return hasPermission;
    } on PlatformException catch (e) {
      _log.severe("Failed to check SMS permission: '${e.message}'.", e);
      return false;
    }
  }

  /// Sends an SMS message via the native platform.
  ///
  /// [phoneNumber] The recipient's phone number.
  /// [message] The content of the SMS message.
  /// Returns `true` if the SMS was sent successfully, `false` otherwise.
  Future<bool> sendSms(String phoneNumber, String message) async {
    _log.info('Attempting to send SMS to $phoneNumber via MethodChannel.');
    try {
      final bool success = await _smsMethodChannel.invokeMethod(
        'sendSms',
        <String, dynamic>{
          'phoneNumber': phoneNumber,
          'message': message,
        },
      );
      _log.info('SMS sent success status: $success');
      return success;
    } on PlatformException catch (e) {
      _log.severe("Failed to send SMS to $phoneNumber: '${e.message}'.", e);
      return false;
    }
  }

  // --- Student Service Methods (from StudentService) ---
  /// Fetches a list of all students sitting from the specified API endpoint.
  ///
  /// Requires a [bearerToken] for authorization.
  /// Returns a [List<StudentSitting>] or an empty list if fetching fails.
  Future<List<StudentSitting>> fetchAllStudentsSitting({required String bearerToken}) async {
    _log.info('Attempting to fetch all students sitting from: $_studentsApiUrl');
    try {
      final response = await http.get(
        Uri.parse(_studentsApiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $bearerToken',
        },
      );
      _log.info('Received HTTP response with status code: ${response.statusCode}');

      if (response.statusCode == 200) {
        _log.fine('Raw response body: ${response.body}');
        final List<dynamic> jsonList = jsonDecode(response.body);
        _log.info('JSON decoded. Number of items: ${jsonList.length}');

        final List<StudentSitting> studentsData = jsonList.map((json) {
          try {
            return StudentSitting.fromJson(json as Map<String, dynamic>);
          } catch (e, st) {
            _log.severe('Error parsing a student sitting item: $json', e, st);
            return null;
          }
        }).whereType<StudentSitting>().toList();

        _log.info('Successfully fetched and parsed ${studentsData.length} students sitting.');
        return studentsData;
      } else {
        _log.warning('Failed to fetch students. Status code: ${response.statusCode}, Body: ${response.body}');
        return [];
      }
    } catch (e, stackTrace) {
      _log.severe('Error fetching students: $e', e, stackTrace);
      return [];
    }
  }
}