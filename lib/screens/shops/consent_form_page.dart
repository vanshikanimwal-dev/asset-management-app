// import 'package:flutter/material.dart';
// import 'dart:ui'; // For ImageFilter.blur
// import 'package:ferrero_asset_management/widgets/styled_button.dart';
// import 'package:ferrero_asset_management/widgets/custom_text_form_field.dart';
// import 'package:ferrero_asset_management/screens/assets/asset_capture_page.dart'; // Corrected import path
// import 'package:ferrero_asset_management/services/api_service.dart'; // Import ApiService
// import 'package:ferrero_asset_management/models/shop_model.dart'; // Import Shop model
//
// //use DataProvider to put all the assets details in one place to use while sending in the uploads request
// import 'package:provider/provider.dart';
// import 'package:ferrero_asset_management/provider/data_provider.dart';
//
//
// class ConsentFormPage extends StatefulWidget {
//   final String outletName; // Now directly receiving outletName
//   final String username;
//
//   const ConsentFormPage({
//     super.key,
//     required this.outletName, // Updated parameter name
//     required this.username,
//   });
//
//   @override
//   State<ConsentFormPage> createState() => _ConsentFormPageState();
// }
//
// class _ConsentFormPageState extends State<ConsentFormPage> {
//   final _formKey = GlobalKey<FormState>();
//
//   // Existing controllers
//   final TextEditingController _outletUniqueCodeController = TextEditingController();
//   final TextEditingController _outletAddressController = TextEditingController();
//   final TextEditingController _VCTypeController = TextEditingController();
//   final TextEditingController _serialNumberController = TextEditingController();
//   final TextEditingController _outletOwnerNameController = TextEditingController();
//   final TextEditingController _outletOwnerNumberController = TextEditingController();
//
//   // NEW: Controllers for State and Postal Code
//   final TextEditingController _stateController = TextEditingController();
//   final TextEditingController _postalCodeController = TextEditingController();
//
//
//   // Existing FocusNodes
//   final FocusNode _outletUniqueCodeFocus = FocusNode();
//   final FocusNode _outletAddressFocus = FocusNode();
//   final FocusNode _VCTypeFocus = FocusNode();
//   final FocusNode _serialNumberFocus = FocusNode();
//   final FocusNode _outletOwnerNameFocus = FocusNode();
//   final FocusNode _outletOwnerNumberFocus = FocusNode();
//
//   // NEW: FocusNodes for State and Postal Code
//   final FocusNode _stateFocus = FocusNode();
//   final FocusNode _postalCodeFocus = FocusNode();
//
//
//   // Existing ValueNotifiers
//   final ValueNotifier<bool> _outletUniqueCodeFocused = ValueNotifier<bool>(false);
//   final ValueNotifier<bool> _outletAddressFocused = ValueNotifier<bool>(false);
//   final ValueNotifier<bool> _VCTypeFocused = ValueNotifier<bool>(false);
//   final ValueNotifier<bool> _serialNumberFocused = ValueNotifier<bool>(false);
//   final ValueNotifier<bool> _outletOwnerNameFocused = ValueNotifier<bool>(false);
//   final ValueNotifier<bool> _outletOwnerNumberFocused = ValueNotifier<bool>(false);
//
//   // NEW: ValueNotifiers for State and Postal Code
//   final ValueNotifier<bool> _stateFocused = ValueNotifier<bool>(false);
//   final ValueNotifier<bool> _postalCodeFocused = ValueNotifier<bool>(false);
//
//   late Future<Shop?> _shopDetailsFuture;
//   //late DataProvider dataProvider; // Declare your provider instance variable
//
//   @override
//   void initState() {
//     super.initState();
//     // Initialize DataProvider
//     //_dataProvider = Provider.of<DataProvider>(context, listen: false);
//
//     // Add listeners for existing focus nodes
//     _outletUniqueCodeFocus.addListener(() => _outletUniqueCodeFocused.value = _outletUniqueCodeFocus.hasFocus);
//     _outletAddressFocus.addListener(() => _outletAddressFocused.value = _outletAddressFocus.hasFocus);
//     _VCTypeFocus.addListener(() => _VCTypeFocused.value = _VCTypeFocus.hasFocus);
//     _serialNumberFocus.addListener(() => _serialNumberFocused.value = _serialNumberFocus.hasFocus);
//     _outletOwnerNameFocus.addListener(() => _outletOwnerNameFocused.value = _outletOwnerNameFocus.hasFocus);
//     _outletOwnerNumberFocus.addListener(() => _outletOwnerNumberFocused.value = _outletOwnerNumberFocus.hasFocus);
//
//     // NEW: Add listeners for new focus nodes
//     _stateFocus.addListener(() => _stateFocused.value = _stateFocus.hasFocus);
//     _postalCodeFocus.addListener(() => _postalCodeFocused.value = _postalCodeFocus.hasFocus);
//
//     // Fetch shop details and populate controllers
//     _shopDetailsFuture = ApiService.fetchShopDetails(widget.outletName);
//     _shopDetailsFuture.then((shop) {
//       if (shop != null) {
//         WidgetsBinding.instance.addPostFrameCallback((_) {
//           if (mounted) { // Check if the widget is still in the tree
//             setState(() {
//               _outletUniqueCodeController.text = shop.uoc;
//               _outletAddressController.text = shop.address;
//               _VCTypeController.text = shop.vcType;
//               _serialNumberController.text = shop.vcSerialNo.toString(); // Ensure conversion if not string
//               _outletOwnerNameController.text = shop.contactPerson;
//               _outletOwnerNumberController.text = shop.mobileNumber.toString(); // Ensure conversion if not string
//               _stateController.text = shop.state;
//               _postalCodeController.text = shop.postalCode.toString(); // Ensure conversion if not string
//             });
//           }
//         });
//       } else {
//         if (mounted) {
//           _showDialog('Shop Not Found', 'Details for ${widget.outletName} could not be fetched.');
//         }
//       }
//     }).catchError((error) {
//       if (mounted) {
//         _showDialog('Error', 'Failed to load shop details: $error');
//       }
//     });
//   }
//
//   @override
//   void dispose() {
//     // Dispose existing controllers
//     _outletUniqueCodeController.dispose();
//     _outletAddressController.dispose();
//     _VCTypeController.dispose();
//     _serialNumberController.dispose();
//     _outletOwnerNameController.dispose();
//     _outletOwnerNumberController.dispose();
//     _stateController.dispose();
//     _postalCodeController.dispose();
//
//     // Dispose existing focus nodes
//     _outletUniqueCodeFocus.dispose();
//     _outletAddressFocus.dispose();
//     _VCTypeFocus.dispose();
//     _serialNumberFocus.dispose();
//     _outletOwnerNameFocus.dispose();
//     _outletOwnerNumberFocus.dispose();
//     _stateFocus.dispose();
//     _postalCodeFocus.dispose();
//
//     // Dispose existing value notifiers
//     _outletUniqueCodeFocused.dispose();
//     _outletAddressFocused.dispose();
//     _VCTypeFocused.dispose();
//     _serialNumberFocused.dispose();
//     _outletOwnerNameFocused.dispose();
//     _outletOwnerNumberFocused.dispose();
//     _stateFocused.dispose();
//     _postalCodeFocused.dispose();
//
//     super.dispose();
//   }
//
//   void _initiateEAgreement() {
//     if (_formKey.currentState!.validate()) {
//       final dataProvider = Provider.of<DataProvider>(context, listen: false);
//       // Print for debugging
//       print('Form Data to be submitted/updated:');
//       print('UOC: ${_outletUniqueCodeController.text}');
//       print('OUTLET_NAME: ${widget.outletName}');
//       print('Address: ${_outletAddressController.text}');
//       print('VC Type: ${_VCTypeController.text}');
//       print('VC Serial No: ${_serialNumberController.text}');
//       print('Contact_Person: ${_outletOwnerNameController.text}');
//       print('Mobile Number: ${_outletOwnerNumberController.text}');
//       print('State: ${_stateController.text}');
//       print('Postal Code: ${_postalCodeController.text}');
//
//       dataProvider.updateString('UOC', _outletUniqueCodeController.text);
//       dataProvider.updateString('OUTLET_NAME', widget.outletName);
//       dataProvider.updateString('Address', _outletAddressController.text);
//       dataProvider.updateString('VC Type', _VCTypeController.text);
//       dataProvider.updateString('VC Serial No', _serialNumberController.text);
//       dataProvider.updateString('Contact_Person', _outletOwnerNameController.text);
//       dataProvider.updateString('Mobile Number', _outletOwnerNumberController.text);
//       dataProvider.updateString('State', _stateController.text);
//       dataProvider.updateString('Postal Code', _postalCodeController.text);
//
//       // Navigate to the next page
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => AssetCapturePage(
//             outletName: widget.outletName,
//             outletOwnerNumber: _outletOwnerNumberController.text, // Pass the actual number
//             username: widget.username,
//             // These might be initialized differently or passed if needed from here
//             capturedImages: const {},
//             capturedLocation: null,
//           ),
//         ),
//       );
//     } else {
//       if (mounted) {
//         _showDialog('Validation Error', 'Please fill all required fields correctly.');
//       }
//     }
//   }
//
//   void _showDialog(String title, String message) {
//     if (!mounted) return; // Ensure widget is still mounted
//     showDialog(
//       context: context,
//       builder: (BuildContext Context) { // Use a different context name for the dialog
//         return AlertDialog(
//           title: Text(title),
//           content: Text(message),
//           actions: <Widget>[
//             TextButton(
//               child: const Text('OK'),
//               onPressed: () {
//                 Navigator.of(Context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFFAF6EF), // Example background color
//       body: FutureBuilder<Shop?>(
//         future: _shopDetailsFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator(color: Colors.brown));
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else if (!snapshot.hasData || snapshot.data == null) {
//             // This case might be hit if fetchShopDetails returns null (shop not found)
//             // The .then block in initState also calls _showDialog for this.
//             // You might want a more specific UI here or rely on the dialog.
//             return const Center(child: Text('Shop details could not be loaded.'));
//           } else {
//             // Data is loaded, display the form
//             return SingleChildScrollView(
//               child: Padding(
//                 padding: const EdgeInsets.all(20.0),
//                 child: Form(
//                   key: _formKey,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.only(top: 30.0, bottom: 20.0), // Adjust top padding for status bar
//                         child: GestureDetector(
//                           onTap: () => Navigator.pop(context),
//                           child: const Row(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               Icon(Icons.arrow_back_ios, color: Colors.brown, size: 20),
//                               Text('Back', style: TextStyle(fontSize: 18, color: Colors.brown)),
//                             ],
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 15),
//                       ClipRRect( // Use ClipRRect for rounded corners if desired on the container
//                         borderRadius: BorderRadius.circular(12.0),
//                         child: BackdropFilter(
//                           filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
//                           child: Container( // This container is blurred if there's content behind it
//                             // Add some padding or content inside this container if it's meant to hold something
//                             // Or remove if it's just for a blur effect on a line
//                             height: 1.0, // If it's just a line, make it visible
//                             decoration: BoxDecoration(
//                               color: Colors.grey.withOpacity(0.1), // Example color for the blurred area
//                               // borderRadius: BorderRadius.circular(12.0), // Match ClipRRect
//                             ),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 20),
//                       // Outlet Name display (Styled as per your description)
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text.rich(
//                             TextSpan(
//                               text: 'OUTLET_NAME: ',
//                               style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.brown),
//                               children: const [TextSpan(text: '*', style: TextStyle(fontSize: 18, color: Colors.red))],
//                             ),
//                           ),
//                           const SizedBox(height: 8),
//                           Container(
//                             height: 50,
//                             padding: const EdgeInsets.symmetric(horizontal: 15.0),
//                             decoration: BoxDecoration(
//                               color: Colors.brown, // Example color
//                               borderRadius: BorderRadius.circular(8.0),
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: Colors.black.withOpacity(0.1),
//                                   spreadRadius: 1,
//                                   blurRadius: 3,
//                                   offset: const Offset(0, 2),
//                                 ),
//                               ],
//                             ),
//                             child: Row(
//                               children: [
//                                 Image.asset('assets/logo.png', height: 30, width: 30), // Ensure logo.png is in assets
//                                 const SizedBox(width: 10),
//                                 Expanded(
//                                   child: Text(
//                                     widget.outletName,
//                                     style: const TextStyle(color: Colors.white, fontSize: 16),
//                                     overflow: TextOverflow.ellipsis,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 20),
//                       CustomTextFormField(
//                         controller: _outletUniqueCodeController,
//                         labelText: 'UOC:',
//                         hintText: 'Enter unique code...',
//                         focusNode: _outletUniqueCodeFocus,
//                         isFocusedNotifier: _outletUniqueCodeFocused,
//                         validator: (value) => value == null || value.isEmpty ? 'Please enter UOC' : null,
//                       ),
//                       const SizedBox(height: 20),
//                       CustomTextFormField(
//                         controller: _outletAddressController,
//                         labelText: 'Address:',
//                         hintText: 'Enter outlet address...',
//                         focusNode: _outletAddressFocus,
//                         isFocusedNotifier: _outletAddressFocused,
//                         validator: (value) => value == null || value.isEmpty ? 'Please enter Address' : null,
//                       ),
//                       const SizedBox(height: 20),
//                       CustomTextFormField(
//                         controller: _stateController,
//                         labelText: 'State:',
//                         hintText: 'Enter state...',
//                         focusNode: _stateFocus,
//                         isFocusedNotifier: _stateFocused,
//                         validator: (value) => value == null || value.isEmpty ? 'Please enter State' : null,
//                       ),
//                       const SizedBox(height: 20),
//                       CustomTextFormField(
//                         controller: _postalCodeController,
//                         labelText: 'Postal Code:',
//                         hintText: 'Enter postal code...',
//                         keyboardType: TextInputType.number,
//                         focusNode: _postalCodeFocus,
//                         isFocusedNotifier: _postalCodeFocused,
//                         validator: (value) => value == null || value.isEmpty ? 'Please enter Postal Code' : null,
//                       ),
//                       const SizedBox(height: 20),
//                       CustomTextFormField(
//                         controller: _VCTypeController,
//                         labelText: 'VC Type:',
//                         hintText: 'Enter asset type...',
//                         focusNode: _VCTypeFocus,
//                         isFocusedNotifier: _VCTypeFocused,
//                         validator: (value) => value == null || value.isEmpty ? 'Please enter VC Type' : null,
//                       ),
//                       const SizedBox(height: 20),
//                       CustomTextFormField(
//                         controller: _serialNumberController,
//                         labelText: 'VC Serial No:',
//                         hintText: 'Enter serial number...',
//                         focusNode: _serialNumberFocus,
//                         isFocusedNotifier: _serialNumberFocused,
//                         validator: (value) => value == null || value.isEmpty ? 'Please enter VC Serial No' : null,
//                       ),
//                       const SizedBox(height: 20),
//                       CustomTextFormField(
//                         controller: _outletOwnerNameController,
//                         labelText: 'Contact Person:',
//                         hintText: 'Enter owner\'s name...',
//                         focusNode: _outletOwnerNameFocus,
//                         isFocusedNotifier: _outletOwnerNameFocused,
//                         validator: (value) => value == null || value.isEmpty ? 'Please enter Contact Person' : null,
//                       ),
//                       const SizedBox(height: 20),
//                       CustomTextFormField(
//                         controller: _outletOwnerNumberController,
//                         labelText: 'Mobile Number:',
//                         hintText: 'Enter owner\'s number...',
//                         keyboardType: TextInputType.phone,
//                         focusNode: _outletOwnerNumberFocus,
//                         isFocusedNotifier: _outletOwnerNumberFocused,
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Please enter mobile number';
//                           }
//                           if (value.length < 10) { // Basic length check
//                             return 'Please enter a valid 10-digit number';
//                           }
//                           // You could add a regex for more specific validation if needed
//                           return null;
//                         },
//                       ),
//                       const SizedBox(height: 30),
//                       Center(
//                         child: styledButton(
//                           text: 'Initiate E-agreement',
//                           onPressed: _initiateEAgreement,
//                         ),
//                       ),
//                       const SizedBox(height: 20), // For some spacing at the bottom
//                     ],
//                   ),
//                 ),
//               ),
//             );
//           }
//         },
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'dart:ui'; // For ImageFilter.blur
import 'package:ferrero_asset_management/widgets/styled_button.dart';
import 'package:ferrero_asset_management/widgets/custom_text_form_field.dart';
import 'package:ferrero_asset_management/screens/assets/asset_capture_page.dart'; // Corrected import path
// REMOVED: import 'package:ferrero_asset_management/services/api_service.dart'; // Import ApiService
import 'package:ferrero_asset_management/models/shop_model.dart'; // Import Shop model

//use DataProvider to put all the assets details in one place to use while sending in the uploads request
import 'package:provider/provider.dart';
import 'package:ferrero_asset_management/provider/data_provider.dart';
import 'package:ferrero_asset_management/services/app_api_service.dart'; // ADDED: Import AppApiService


class ConsentFormPage extends StatefulWidget {
  final String outletName; // Now directly receiving outletName
  final String username;

  const ConsentFormPage({
    super.key,
    required this.outletName, // Updated parameter name
    required this.username,
  });

  @override
  State<ConsentFormPage> createState() => _ConsentFormPageState();
}

class _ConsentFormPageState extends State<ConsentFormPage> {
  final _formKey = GlobalKey<FormState>();

  // Existing controllers
  final TextEditingController _outletUniqueCodeController = TextEditingController();
  final TextEditingController _outletAddressController = TextEditingController();
  final TextEditingController _VCTypeController = TextEditingController();
  final TextEditingController _serialNumberController = TextEditingController();
  final TextEditingController _outletOwnerNameController = TextEditingController();
  final TextEditingController _outletOwnerNumberController = TextEditingController();

  // NEW: Controllers for State and Postal Code
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _postalCodeController = TextEditingController();


  // Existing FocusNodes
  final FocusNode _outletUniqueCodeFocus = FocusNode();
  final FocusNode _outletAddressFocus = FocusNode();
  final FocusNode _VCTypeFocus = FocusNode();
  final FocusNode _serialNumberFocus = FocusNode();
  final FocusNode _outletOwnerNameFocus = FocusNode();
  final FocusNode _outletOwnerNumberFocus = FocusNode();

  // NEW: FocusNodes for State and Postal Code
  final FocusNode _stateFocus = FocusNode();
  final FocusNode _postalCodeFocus = FocusNode();


  // Existing ValueNotifiers
  final ValueNotifier<bool> _outletUniqueCodeFocused = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _outletAddressFocused = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _VCTypeFocused = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _serialNumberFocused = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _outletOwnerNameFocused = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _outletOwnerNumberFocused = ValueNotifier<bool>(false);

  // NEW: ValueNotifiers for State and Postal Code
  final ValueNotifier<bool> _stateFocused = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _postalCodeFocused = ValueNotifier<bool>(false);

  late Future<Shop?> _shopDetailsFuture;
  //late DataProvider dataProvider; // Declare your provider instance variable

  @override
  void initState() {
    super.initState();
    // Initialize DataProvider
    //_dataProvider = Provider.of<DataProvider>(context, listen: false);

    // Add listeners for existing focus nodes
    _outletUniqueCodeFocus.addListener(() => _outletUniqueCodeFocused.value = _outletUniqueCodeFocus.hasFocus);
    _outletAddressFocus.addListener(() => _outletAddressFocused.value = _outletAddressFocus.hasFocus);
    _VCTypeFocus.addListener(() => _VCTypeFocused.value = _VCTypeFocus.hasFocus);
    _serialNumberFocus.addListener(() => _serialNumberFocused.value = _serialNumberFocus.hasFocus);
    _outletOwnerNameFocus.addListener(() => _outletOwnerNameFocused.value = _outletOwnerNameFocus.hasFocus);
    _outletOwnerNumberFocus.addListener(() => _outletOwnerNumberFocused.value = _outletOwnerNumberFocus.hasFocus);

    // NEW: Add listeners for new focus nodes
    _stateFocus.addListener(() => _stateFocused.value = _stateFocus.hasFocus);
    _postalCodeFocus.addListener(() => _postalCodeFocused.value = _postalCodeFocus.hasFocus);

    // Fetch shop details and populate controllers
    // MODIFIED: Use AppApiService().fetchShopDetails
    _shopDetailsFuture = AppApiService().fetchShopDetails(widget.outletName);
    _shopDetailsFuture.then((shop) {
      if (shop != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) { // Check if the widget is still in the tree
            setState(() {
              _outletUniqueCodeController.text = shop.uoc;
              _outletAddressController.text = shop.address;
              _VCTypeController.text = shop.vcType;
              _serialNumberController.text = shop.vcSerialNo.toString(); // Ensure conversion if not string
              _outletOwnerNameController.text = shop.contactPerson;
              _outletOwnerNumberController.text = shop.mobileNumber.toString(); // Ensure conversion if not string
              _stateController.text = shop.state;
              _postalCodeController.text = shop.postalCode.toString(); // Ensure conversion if not string
            });
          }
        });
      } else {
        if (mounted) {
          _showDialog('Shop Not Found', 'Details for ${widget.outletName} could not be fetched.');
        }
      }
    }).catchError((error) {
      if (mounted) {
        _showDialog('Error', 'Failed to load shop details: $error');
      }
    });
  }

  @override
  void dispose() {
    // Dispose existing controllers
    _outletUniqueCodeController.dispose();
    _outletAddressController.dispose();
    _VCTypeController.dispose();
    _serialNumberController.dispose();
    _outletOwnerNameController.dispose();
    _outletOwnerNumberController.dispose();
    _stateController.dispose();
    _postalCodeController.dispose();

    // Dispose existing focus nodes
    _outletUniqueCodeFocus.dispose();
    _outletAddressFocus.dispose();
    _VCTypeFocus.dispose();
    _serialNumberFocus.dispose();
    _outletOwnerNameFocus.dispose();
    _outletOwnerNumberFocus.dispose();
    _stateFocus.dispose();
    _postalCodeFocus.dispose();

    // Dispose existing value notifiers
    _outletUniqueCodeFocused.dispose();
    _outletAddressFocused.dispose();
    _VCTypeFocused.dispose();
    _serialNumberFocused.dispose();
    _outletOwnerNameFocused.dispose();
    _outletOwnerNumberFocused.dispose();
    _stateFocused.dispose();
    _postalCodeFocused.dispose();

    super.dispose();
  }

  void _initiateEAgreement() {
    if (_formKey.currentState!.validate()) {
      final dataProvider = Provider.of<DataProvider>(context, listen: false);
      // Print for debugging
      print('Form Data to be submitted/updated:');
      print('UOC: ${_outletUniqueCodeController.text}');
      print('OUTLET_NAME: ${widget.outletName}');
      print('Address: ${_outletAddressController.text}');
      print('VC Type: ${_VCTypeController.text}');
      print('VC Serial No: ${_serialNumberController.text}');
      print('Contact_Person: ${_outletOwnerNameController.text}');
      print('Mobile Number: ${_outletOwnerNumberController.text}');
      print('State: ${_stateController.text}');
      print('Postal Code: ${_postalCodeController.text}');

      dataProvider.updateString('UOC', _outletUniqueCodeController.text);
      dataProvider.updateString('OUTLET_NAME', widget.outletName);
      dataProvider.updateString('Address', _outletAddressController.text);
      dataProvider.updateString('VC Type', _VCTypeController.text);
      dataProvider.updateString('VC Serial No', _serialNumberController.text);
      dataProvider.updateString('Contact_Person', _outletOwnerNameController.text);
      dataProvider.updateString('Mobile Number', _outletOwnerNumberController.text);
      dataProvider.updateString('State', _stateController.text);
      dataProvider.updateString('Postal Code', _postalCodeController.text);

      // Navigate to the next page
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AssetCapturePage(
            outletName: widget.outletName,
            outletOwnerNumber: _outletOwnerNumberController.text, // Pass the actual number
            username: widget.username,
            // These might be initialized differently or passed if needed from here
            capturedImages: const {},
            capturedLocation: null,
          ),
        ),
      );
    } else {
      if (mounted) {
        _showDialog('Validation Error', 'Please fill all required fields correctly.');
      }
    }
  }

  void _showDialog(String title, String message) {
    if (!mounted) return; // Ensure widget is still mounted
    showDialog(
      context: context,
      builder: (BuildContext Context) { // Use a different context name for the dialog
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(Context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF6EF), // Example background color
      body: FutureBuilder<Shop?>(
        future: _shopDetailsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.brown));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            // This case might be hit if fetchShopDetails returns null (shop not found)
            // The .then block in initState also calls _showDialog for this.
            // You might want a more specific UI here or rely on the dialog.
            return const Center(child: Text('Shop details could not be loaded.'));
          } else {
            // Data is loaded, display the form
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 30.0, bottom: 20.0), // Adjust top padding for status bar
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
                      ClipRRect( // Use ClipRRect for rounded corners if desired on the container
                        borderRadius: BorderRadius.circular(12.0),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                          child: Container( // This container is blurred if there's content behind it
                            // Add some padding or content inside this container if it's meant to hold something
                            // Or remove if it's just for a blur effect on a line
                            height: 1.0, // If it's just a line, make it visible
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.1), // Example color for the blurred area
                              // borderRadius: BorderRadius.circular(12.0), // Match ClipRRect
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Outlet Name display (Styled as per your description)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text.rich(
                            TextSpan(
                              text: 'OUTLET_NAME: ',
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.brown),
                              children: const [TextSpan(text: '*', style: TextStyle(fontSize: 18, color: Colors.red))],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            height: 50,
                            padding: const EdgeInsets.symmetric(horizontal: 15.0),
                            decoration: BoxDecoration(
                              color: Colors.brown, // Example color
                              borderRadius: BorderRadius.circular(8.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  spreadRadius: 1,
                                  blurRadius: 3,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Image.asset('assets/logo.png', height: 30, width: 30), // Ensure logo.png is in assets
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    widget.outletName,
                                    style: const TextStyle(color: Colors.white, fontSize: 16),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      CustomTextFormField(
                        controller: _outletUniqueCodeController,
                        labelText: 'UOC:',
                        hintText: 'Enter unique code...',
                        focusNode: _outletUniqueCodeFocus,
                        isFocusedNotifier: _outletUniqueCodeFocused,
                        validator: (value) => value == null || value.isEmpty ? 'Please enter UOC' : null,
                      ),
                      const SizedBox(height: 20),
                      CustomTextFormField(
                        controller: _outletAddressController,
                        labelText: 'Address:',
                        hintText: 'Enter outlet address...',
                        focusNode: _outletAddressFocus,
                        isFocusedNotifier: _outletAddressFocused,
                        validator: (value) => value == null || value.isEmpty ? 'Please enter Address' : null,
                      ),
                      const SizedBox(height: 20),
                      CustomTextFormField(
                        controller: _stateController,
                        labelText: 'State:',
                        hintText: 'Enter state...',
                        focusNode: _stateFocus,
                        isFocusedNotifier: _stateFocused,
                        validator: (value) => value == null || value.isEmpty ? 'Please enter State' : null,
                      ),
                      const SizedBox(height: 20),
                      CustomTextFormField(
                        controller: _postalCodeController,
                        labelText: 'Postal Code:',
                        hintText: 'Enter postal code...',
                        keyboardType: TextInputType.number,
                        focusNode: _postalCodeFocus,
                        isFocusedNotifier: _postalCodeFocused,
                        validator: (value) => value == null || value.isEmpty ? 'Please enter Postal Code' : null,
                      ),
                      const SizedBox(height: 20),
                      CustomTextFormField(
                        controller: _VCTypeController,
                        labelText: 'VC Type:',
                        hintText: 'Enter asset type...',
                        focusNode: _VCTypeFocus,
                        isFocusedNotifier: _VCTypeFocused,
                        validator: (value) => value == null || value.isEmpty ? 'Please enter VC Type' : null,
                      ),
                      const SizedBox(height: 20),
                      CustomTextFormField(
                        controller: _serialNumberController,
                        labelText: 'VC Serial No:',
                        hintText: 'Enter serial number...',
                        focusNode: _serialNumberFocus,
                        isFocusedNotifier: _serialNumberFocused,
                        validator: (value) => value == null || value.isEmpty ? 'Please enter VC Serial No' : null,
                      ),
                      const SizedBox(height: 20),
                      CustomTextFormField(
                        controller: _outletOwnerNameController,
                        labelText: 'Contact Person:',
                        hintText: 'Enter owner\'s name...',
                        focusNode: _outletOwnerNameFocus,
                        isFocusedNotifier: _outletOwnerNameFocused,
                        validator: (value) => value == null || value.isEmpty ? 'Please enter Contact Person' : null,
                      ),
                      const SizedBox(height: 20),
                      CustomTextFormField(
                        controller: _outletOwnerNumberController,
                        labelText: 'Mobile Number:',
                        hintText: 'Enter owner\'s number...',
                        keyboardType: TextInputType.phone,
                        focusNode: _outletOwnerNumberFocus,
                        isFocusedNotifier: _outletOwnerNumberFocused,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter mobile number';
                          }
                          if (value.length < 10) { // Basic length check
                            return 'Please enter a valid 10-digit number';
                          }
                          // You could add a regex for more specific validation if needed
                          return null;
                        },
                      ),
                      const SizedBox(height: 30),
                      Center(
                        child: styledButton(
                          text: 'Initiate E-agreement',
                          onPressed: _initiateEAgreement,
                        ),
                      ),
                      const SizedBox(height: 20), // For some spacing at the bottom
                    ],
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}