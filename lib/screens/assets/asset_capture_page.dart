import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io'; // Required for File class (if displaying images from path)
import 'dart:async';
import 'dart:ui'; // For ImageFilter.blur

import 'package:ferrero_asset_management/widgets/styled_button.dart';
import 'package:ferrero_asset_management/widgets/photo_capture_grid_item.dart';
import 'package:ferrero_asset_management/widgets/location_grid_item.dart';
import 'package:ferrero_asset_management/screens/consent/consent_and_otp_verification_page.dart';

class AssetCapturePage extends StatefulWidget {
  final String outletName;
  final String outletOwnerNumber;
  final String username;
  final Map<String, String?> capturedImages; // Now expecting resolved paths
  final String? capturedLocation;

  const AssetCapturePage({
    super.key,
    required this.outletName,
    required this.outletOwnerNumber,
    required this.username,
    this.capturedImages = const {},
    this.capturedLocation,
  });

  @override
  State<AssetCapturePage> createState() => _AssetCapturePageState();
}

class _AssetCapturePageState extends State<AssetCapturePage> {
  Position? _currentPosition;
  String _locationMessage = 'Tap to get location';
  bool _isLocationFetching = false;

  final ImagePicker _picker = ImagePicker();

  final Map<String, String?> _resolvedImagePaths = {
    'outlet_exteriors_photo': null,
    'asset_pics': null,
    'outlet_owner_ids_pics': null,
    'outlet_owner_pic': null,
    'serial_no_pic': null,
  };

  bool get _allPhotosCaptured {
    bool allImagesCaptured = _resolvedImagePaths.values.every((path) => path != null);
    bool locationCaptured = _currentPosition != null;
    return allImagesCaptured && locationCaptured;
  }

  @override
  void initState() {
    super.initState();
    widget.capturedImages.forEach((key, path) {
      if (path != null) {
        _resolvedImagePaths[key] = path;
      }
    });

    if (widget.capturedLocation != null && widget.capturedLocation!.startsWith('Lat:')) {
      final parts = widget.capturedLocation!.split(', ');
      if (parts.length == 2) {
        final lat = double.tryParse(parts[0].replaceFirst('Lat: ', ''));
        final lng = double.tryParse(parts[1].replaceFirst('Lng: ', ''));
        if (lat != null && lng != null) {
          _currentPosition = Position(
            latitude: lat,
            longitude: lng,
            timestamp: DateTime.now(),
            accuracy: 0.0,
            altitude: 0.0,
            heading: 0.0,
            speed: 0.0,
            speedAccuracy: 0.0,
            altitudeAccuracy: 0.0,
            headingAccuracy: 0.0,
          );
          _locationMessage = 'Location already captured!';
        }
      }
    }
  }

  Future<void> _requestLocationPermission() async {
    setState(() {
      _isLocationFetching = true;
      _locationMessage = 'Checking permissions...';
      _currentPosition = null;
    });

    LocationPermission permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.denied) {
      _showSnackBar('Location permission was denied. Please grant access to capture location.', isError: true);
      setState(() {
        _isLocationFetching = false;
        _locationMessage = 'Location permission denied.';
      });
      return;
    }

    if (permission == LocationPermission.deniedForever) {
      _showSnackBar('Location permission is permanently denied. Please enable from app settings.', isError: true);
      setState(() {
        _isLocationFetching = false;
        _locationMessage = 'Location permission permanently denied.';
      });
      await Geolocator.openAppSettings();
      return;
    }

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showSnackBar('Location services are disabled. Please enable them to capture location.', isError: true);
      setState(() {
        _isLocationFetching = false;
        _locationMessage = 'Location services are disabled.';
      });
      await Geolocator.openLocationSettings();
      return;
    }

    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );
      setState(() {
        _currentPosition = position;
        _locationMessage = 'Location captured!';
      });
      // Removed success SnackBar for location capture
    } on TimeoutException {
      setState(() {
        _locationMessage = 'Failed to get location: Timeout.';
        _currentPosition = null;
      });
      _showSnackBar('Failed to get location: Timeout. Please try again.', isError: true);
    } catch (e) {
      setState(() {
        _locationMessage = 'Failed to get location: $e';
        _currentPosition = null;
      });
      _showSnackBar('Failed to get location: $e', isError: true);
    } finally {
      setState(() {
        _isLocationFetching = false;
      });
    }
  }

  Future<void> _determinePosition() async {
    await _requestLocationPermission();
  }

  Future<void> _pickImage(String imageType) async {
    try {
      final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
      if (photo != null) {
        final String filePath = photo.path;

        if (File(filePath).existsSync()) {
          setState(() {
            _resolvedImagePaths[imageType] = filePath;
          });
          // Removed success SnackBar for photo capture
          print('DEBUG: Directly using XFile.path for $imageType: $filePath');
        } else {
          _showSnackBar('Captured photo file not found at path: $filePath. Please try again.', isError: true);
          print('ERROR: Captured photo file does not exist at path: $filePath');
        }
      } else {
        // Removed SnackBar for photo capture cancellation, as it's not an error
      }
    } catch (e) {
      _showSnackBar('Error picking photo for $imageType: $e', isError: true);
      print('ERROR: Exception during photo picking for $imageType: $e');
    }
  }

  void _proceedToConsent() {
    if (_allPhotosCaptured) {
      // Removed success SnackBar for proceeding
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ConsentAndOtpVerificationPage(
            outletOwnerNumber: widget.outletOwnerNumber,
            outletName: widget.outletName,
            username: widget.username,
            capturedImages: _resolvedImagePaths.cast<String, String?>(), // Pass the resolved paths
            capturedLocation: _currentPosition != null
                ? 'Lat: ${_currentPosition!.latitude.toStringAsFixed(4)}, Lng: ${_currentPosition!.longitude.toStringAsFixed(4)}'
                : null,
          ),
        ),
      );
    } else {
      _showSnackBar('Please capture all required photos and location before proceeding to consent.', isError: true);
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF6EF),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 30.0, bottom: 20.0),
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
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
                  Text(
                    'Current Outlet: ${widget.outletName}',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.brown),
                  ),
                  const SizedBox(height: 20),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 20.0,
                    mainAxisSpacing: 20.0,
                    children: [
                      PhotoCaptureGridItem(
                        imageType: 'outlet_exteriors_photo',
                        label: 'Outlet Exteriors Photo',
                        pickedFile: _resolvedImagePaths['outlet_exteriors_photo'] != null
                            ? XFile(_resolvedImagePaths['outlet_exteriors_photo']!)
                            : null,
                        onTap: () => _pickImage('outlet_exteriors_photo'),
                      ),
                      PhotoCaptureGridItem(
                        imageType: 'asset_pics',
                        label: 'Asset Photos',
                        pickedFile: _resolvedImagePaths['asset_pics'] != null
                            ? XFile(_resolvedImagePaths['asset_pics']!)
                            : null,
                        onTap: () => _pickImage('asset_pics'),
                      ),
                      PhotoCaptureGridItem(
                        imageType: 'outlet_owner_ids_pics',
                        label: 'Outlet Owner ID\'s Photos',
                        pickedFile: _resolvedImagePaths['outlet_owner_ids_pics'] != null
                            ? XFile(_resolvedImagePaths['outlet_owner_ids_pics']!)
                            : null,
                        onTap: () => _pickImage('outlet_owner_ids_pics'),
                      ),
                      PhotoCaptureGridItem(
                        imageType: 'outlet_owner_pic',
                        label: 'Outlet Owner\'s Photo',
                        pickedFile: _resolvedImagePaths['outlet_owner_pic'] != null
                            ? XFile(_resolvedImagePaths['outlet_owner_pic']!)
                            : null,
                        onTap: () => _pickImage('outlet_owner_pic'),
                      ),
                      PhotoCaptureGridItem(
                        imageType: 'serial_no_pic',
                        label: 'Serial Number Photo',
                        pickedFile: _resolvedImagePaths['serial_no_pic'] != null
                            ? XFile(_resolvedImagePaths['serial_no_pic']!)
                            : null,
                        onTap: () => _pickImage('serial_no_pic'),
                      ),
                      LocationGridItem(
                        isFetching: _isLocationFetching,
                        message: _locationMessage,
                        currentPosition: _currentPosition,
                        onTap: _determinePosition,
                        isLocationCaptured: _currentPosition != null,
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  Center(
                      child: styledButton(
                          text: 'Proceed to Consent',
                          onPressed: _proceedToConsent
                      )
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}