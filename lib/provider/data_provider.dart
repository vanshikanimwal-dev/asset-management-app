
// lib/provider/data_provider.dart
import 'package:flutter/foundation.dart';

class DataProvider with ChangeNotifier {
  String? _uoc;
  String? _outletNameFromConsentForm;
  String? _address;
  String? _vcType;
  String? _vcSerialNo;
  String? _contactPerson;
  String? _mobileNumberFromConsentForm; // To distinguish from outletOwnerNumber used for OTP
  String? _state;
  String? _postalCode;
  String? _username;

  // --- Asset Capture Data ---
  // This will store the map of image types to their paths directly
  Map<String, String?> _capturedImagesMap = {};
  String? _capturedLocationString;

  // --- Getters for Consent Form Data ---
  String? get uoc => _uoc;
  String? get outletNameFromConsentForm => _outletNameFromConsentForm;
  String? get address => _address;
  String? get vcType => _vcType;
  String? get vcSerialNo => _vcSerialNo;
  String? get contactPerson => _contactPerson;
  String? get mobileNumberFromConsentForm => _mobileNumberFromConsentForm;
  String? get state => _state;
  String? get postalCode => _postalCode;
  String? get username => _username;

  // --- Getters for Asset Capture Data ---
  // Provides an unmodifiable view to prevent external direct modification
  Map<String, String?> get allCapturedImages => Map.unmodifiable(_capturedImagesMap);
  String? get capturedLocation => _capturedLocationString;

  // --- Methods to update data (as seen in ConsentFormPage) ---
  void updateString(String key, String? value) {
    bool changed = false;
    switch (key) {
      case 'UOC':
        if (_uoc != value) { _uoc = value; changed = true; }
        break;
      case 'OUTLET_NAME': // This is the name from the form, potentially editable
        if (_outletNameFromConsentForm != value) { _outletNameFromConsentForm = value; changed = true; }
        break;
      case 'Address':
        if (_address != value) { _address = value; changed = true; }
        break;
      case 'VC Type':
        if (_vcType != value) { _vcType = value; changed = true; }
        break;
      case 'VC Serial No':
        if (_vcSerialNo != value) { _vcSerialNo = value; changed = true; }
        break;
      case 'Contact_Person':
        if (_contactPerson != value) { _contactPerson = value; changed = true; }
        break;
      case 'Mobile Number': // Mobile number from the consent form fields
        if (_mobileNumberFromConsentForm != value) { _mobileNumberFromConsentForm = value; changed = true; }
        break;
      case 'State':
        if (_state != value) { _state = value; changed = true; }
        break;
      case 'Postal Code':
        if (_postalCode != value) { _postalCode = value; changed = true; }
        break;
      case 'USERNAME': // If you pass username to updateString
        if (_username != value) { _username = value; changed = true; }
        break;
      default:
        print("DataProvider: Unknown key for updateString: $key");
    }
    if (changed) {
      notifyListeners(); // Decide if individual updates should notify or if you'll do it in bulk
    }
  }

  // Sets or updates the entire map of captured image paths.
  // If an image type already exists, its path will be updated.
  // If new image types are provided, they will be added.
  void addImages(Map<String, String?> imagePathsMap) { // Changed from addImage to addImages (plural)
    // You might want to merge or replace. Merging is often safer.
    _capturedImagesMap.addAll(imagePathsMap); // Merges new paths, updates existing keys
    print("DataProvider: Updated captured images map. Current map: $_capturedImagesMap");
    // notifyListeners(); // Notify if UI needs to react to this change immediately
  }

  /// Sets or updates the captured location string.
  void setLocation(String? locationString) {
    if (_capturedLocationString != locationString) {
      _capturedLocationString = locationString;
      print("DataProvider: Updated captured location: $_capturedLocationString");
      // notifyListeners(); // Notify if UI needs to react to this change immediately
    }
  }

  /// Sets or updates the username.
  void setUsername(String? newUsername) {
    if (_username != newUsername) {
      _username = newUsername;
      print("DataProvider: Updated username: $_username");
      // notifyListeners();
    }
  }

  // --- Utility Methods ---

  /// Call this after a series of updates if you deferred notifyListeners.
  void finalizeAllUpdates() {
    notifyListeners();
  }

  /// Clears all data in the provider. Useful for starting a new submission.
  void clearAllData() {
    _uoc = null;
    _outletNameFromConsentForm = null;
    _address = null;
    _vcType = null;
    _vcSerialNo = null;
    _contactPerson = null;
    _mobileNumberFromConsentForm = null;
    _state = null;
    _postalCode = null;
    _username = null;

    _capturedImagesMap.clear();
    _capturedLocationString = null;

    print("DataProvider: All data cleared.");
    notifyListeners();
  }

// You can add more specific getters if needed, e.g.:
// String? getOutletExteriorsPhotoPath() => _capturedImagesMap['outlet_exteriors_photo'];
}