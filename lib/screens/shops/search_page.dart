// // import 'package:flutter/material.dart';
// // import 'dart:ui'; // For ImageFilter.blur
// // // import 'package:ferrero_asset_management/data/static_shop_data.dart'; // Import static shop data (will be replaced)
// // import 'package:ferrero_asset_management/screens/shops/consent_form_page.dart'; // Import ConsentFormPage
// // // import 'package:ferrero_app/services/api_service.dart'; // Will be used later
// // // import 'package:ferrero_app/models/shop_model.dart'; // Will be used later
// //
// // class SearchPage extends StatefulWidget {
// //   final String username;
// //
// //   const SearchPage({super.key, required this.username});
// //
// //   @override
// //   State<SearchPage> createState() => _SearchPageState();
// // }
// //
// // class _SearchPageState extends State<SearchPage> {
// //   final TextEditingController _searchController = TextEditingController();
// //   List<String> _filteredShopNames = []; // Will be List<Shop> later
// //   List<String> _allShopNames = []; // Will be List<Shop> later
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _allShopNames = StaticShopData.allShopNames; // Using static data for now
// //     _filteredShopNames = _allShopNames;
// //     _searchController.addListener(_filterShopNames);
// //   }
// //
// //   @override
// //   void dispose() {
// //     _searchController.removeListener(_filterShopNames);
// //     _searchController.dispose();
// //     super.dispose();
// //   }
// //
// //   void _filterShopNames() {
// //     String query = _searchController.text.toLowerCase();
// //     setState(() {
// //       _filteredShopNames = _allShopNames
// //           .where((name) => name.toLowerCase().contains(query))
// //           .toList();
// //     });
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: const Color(0xFFFAF6EF),
// //       body: Column(
// //         children: [
// //           Padding(
// //             padding: const EdgeInsets.fromLTRB(20.0, 50.0, 20.0, 0.0),
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 GestureDetector(
// //                   onTap: () => Navigator.pop(context),
// //                   child: const Row(
// //                     mainAxisSize: MainAxisSize.min,
// //                     children: [
// //                       Icon(Icons.arrow_back_ios, color: Colors.brown, size: 20),
// //                       Text('Back', style: TextStyle(fontSize: 18, color: Colors.brown)),
// //                     ],
// //                   ),
// //                 ),
// //                 const SizedBox(height: 15),
// //                 ClipRect(
// //                   child: BackdropFilter(
// //                     filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
// //                     child: Container(
// //                       height: 1.0,
// //                       decoration: BoxDecoration(
// //                         color: Colors.brown.withOpacity(0.2),
// //                         boxShadow: [
// //                           BoxShadow(
// //                             color: Colors.black.withOpacity(0.1),
// //                             blurRadius: 5.0,
// //                             offset: const Offset(0, 3),
// //                           ),
// //                         ],
// //                       ),
// //                     ),
// //                   ),
// //                 ),
// //                 const SizedBox(height: 30),
// //                 Container(
// //                   height: 50,
// //                   decoration: BoxDecoration(
// //                     image: const DecorationImage(
// //                       image: AssetImage('assets/rect1.png'),
// //                       fit: BoxFit.cover,
// //                       repeat: ImageRepeat.repeat,
// //                     ),
// //                     borderRadius: BorderRadius.circular(10),
// //                   ),
// //                   child: TextField(
// //                     controller: _searchController,
// //                     style: const TextStyle(color: Colors.white, fontSize: 18),
// //                     decoration: const InputDecoration(
// //                       hintText: 'Search...',
// //                       hintStyle: TextStyle(color: Colors.white70, fontSize: 18),
// //                       border: InputBorder.none,
// //                       contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
// //                       prefixIcon: Icon(Icons.search, color: Colors.white70),
// //                     ),
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //           Expanded(
// //             child: ListView.builder(
// //               padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
// //               itemCount: _filteredShopNames.length,
// //               itemBuilder: (context, index) {
// //                 String shopName = _filteredShopNames[index];
// //                 String? status = StaticShopData.shopStatuses[shopName];
// //                 Color? statusColor;
// //                 switch (status) {
// //                   case 'Not Completed':
// //                     statusColor = Colors.red[700];
// //                     break;
// //                   case 'Completed':
// //                     statusColor = Colors.green[700];
// //                     break;
// //                   case 'Pending':
// //                     statusColor = Colors.orange[700];
// //                     break;
// //                   case 'Reject':
// //                     statusColor = Colors.black;
// //                     break;
// //                   default:
// //                     statusColor = Colors.grey;
// //                 }
// //
// //                 return Padding(
// //                   padding: const EdgeInsets.symmetric(vertical: 8.0),
// //                   child: InkWell(
// //                     onTap: () {
// //                       if (status == 'Completed') {
// //                         return;
// //                       }
// //                       Navigator.push(
// //                         context,
// //                         MaterialPageRoute(
// //                           builder: (context) => ConsentFormPage(
// //                             initialShopName: shopName,
// //                             allShopNames: StaticShopData.allShopNames,
// //                             username: widget.username,
// //                           ),
// //                         ),
// //                       ).then((_) => setState(() {}));
// //                     },
// //                     child: Container(
// //                       decoration: BoxDecoration(
// //                         color: Colors.white,
// //                         borderRadius: BorderRadius.circular(10),
// //                         boxShadow: [
// //                           BoxShadow(
// //                             color: Colors.grey.withOpacity(0.2),
// //                             spreadRadius: 2,
// //                             blurRadius: 5,
// //                             offset: const Offset(0, 3),
// //                           ),
// //                         ],
// //                       ),
// //                       padding: const EdgeInsets.all(15.0),
// //                       child: Row(
// //                         children: [
// //                           Expanded(
// //                             child: Text(
// //                               '${index + 1}. $shopName',
// //                               style: const TextStyle(
// //                                 fontSize: 20,
// //                                 color: Colors.brown,
// //                                 fontWeight: FontWeight.w500,
// //                               ),
// //                             ),
// //                           ),
// //                           Text(
// //                             status?.toUpperCase() ?? 'UNKNOWN',
// //                             style: TextStyle(
// //                               fontSize: 12,
// //                               fontWeight: FontWeight.bold,
// //                               color: statusColor,
// //                             ),
// //                             textAlign: TextAlign.right,
// //                           ),
// //                         ],
// //                       ),
// //                     ),
// //                   ),
// //                 );
// //               },
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
// import 'package:flutter/material.dart';
// import 'dart:ui'; // For ImageFilter.blur
// // Removed: import 'package:ferrero_asset_management/data/static_shop_data.dart';
// import 'package:ferrero_asset_management/screens/shops/consent_form_page.dart'; // Import ConsentFormPage
// import 'package:ferrero_asset_management/services/api_service.dart'; // Import ApiService
// import 'package:ferrero_asset_management/models/shop_model.dart'; // Import Shop model
//
// class SearchPage extends StatefulWidget {
//   final String username;
//
//   const SearchPage({super.key, required this.username});
//
//   @override
//   State<SearchPage> createState() => _SearchPageState();
// }
//
// class _SearchPageState extends State<SearchPage> {
//   final TextEditingController _searchController = TextEditingController();
//   late Future<List<Shop>> _shopsFuture; // Future to hold fetched shops
//   List<Shop> _allShops = []; // All shops fetched from API
//   List<Shop> _filteredShops = []; // Shops filtered by search query
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchShops(); // Call method to fetch shops
//     _searchController.addListener(_filterShops);
//   }
//
//   @override
//   void dispose() {
//     _searchController.removeListener(_filterShops);
//     _searchController.dispose();
//     super.dispose();
//   }
//
//   Future<void> _fetchShops() async {
//     setState(() {
//       _shopsFuture = ApiService.fetchAllShops();
//     });
//     _shopsFuture.then((shops) {
//       setState(() {
//         _allShops = shops;
//         _filteredShops = shops; // Initially, show all shops
//       });
//     }).catchError((error) {
//       _showDialog('Error', 'Failed to load shops: $error');
//       setState(() {
//         _allShops = []; // Clear shops on error
//         _filteredShops = [];
//       });
//     });
//   }
//
//   void _filterShops() {
//     String query = _searchController.text.toLowerCase();
//     setState(() {
//       _filteredShops = _allShops
//           .where((shop) => shop.outletName.toLowerCase().contains(query))
//           .toList();
//     });
//   }
//
//   void _showDialog(String title, String message) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text(title),
//           content: Text(message),
//           actions: <Widget>[
//             TextButton(
//               child: const Text('OK'),
//               onPressed: () {
//                 Navigator.of(context).pop();
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
//       backgroundColor: const Color(0xFFFAF6EF),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.fromLTRB(20.0, 50.0, 20.0, 0.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 GestureDetector(
//                   onTap: () => Navigator.pop(context),
//                   child: const Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Icon(Icons.arrow_back_ios, color: Colors.brown, size: 20),
//                       Text('Back', style: TextStyle(fontSize: 18, color: Colors.brown)),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 15),
//                 ClipRect(
//                   child: BackdropFilter(
//                     filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
//                     child: Container(
//                       height: 1.0,
//                       decoration: BoxDecoration(
//                         color: Colors.brown.withOpacity(0.2),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.black.withOpacity(0.1),
//                             blurRadius: 5.0,
//                             offset: const Offset(0, 3),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 30),
//                 Container(
//                   height: 50,
//                   decoration: BoxDecoration(
//                     image: const DecorationImage(
//                       image: AssetImage('assets/rect1.png'),
//                       fit: BoxFit.cover,
//                       repeat: ImageRepeat.repeat,
//                     ),
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child: TextField(
//                     controller: _searchController,
//                     style: const TextStyle(color: Colors.white, fontSize: 18),
//                     decoration: const InputDecoration(
//                       hintText: 'Search...',
//                       hintStyle: TextStyle(color: Colors.white70, fontSize: 18),
//                       border: InputBorder.none,
//                       contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//                       prefixIcon: Icon(Icons.search, color: Colors.white70),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Expanded(
//             child: FutureBuilder<List<Shop>>(
//               future: _shopsFuture,
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const Center(child: CircularProgressIndicator());
//                 } else if (snapshot.hasError) {
//                   return Center(child: Text('Error: ${snapshot.error}. Pull to refresh.'));
//                 } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                   return const Center(child: Text('No shops found.'));
//                 } else {
//                   // Display filtered shops from the API data
//                   return RefreshIndicator( // Added for pull-to-refresh
//                     onRefresh: _fetchShops,
//                     child: ListView.builder(
//                       padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
//                       itemCount: _filteredShops.length,
//                       itemBuilder: (context, index) {
//                         final shop = _filteredShops[index]; // Now 'shop' is a Shop object
//                         Color? statusColor;
//                         switch (shop.status) { // Use shop.status
//                           case 'Not Completed':
//                             statusColor = Colors.red[700];
//                             break;
//                           case 'Completed':
//                             statusColor = Colors.green[700];
//                             break;
//                           case 'Pending':
//                             statusColor = Colors.orange[700];
//                             break;
//                           case 'Reject':
//                             statusColor = Colors.black;
//                             break;
//                           default:
//                             statusColor = Colors.grey;
//                         }
//
//                         return Padding(
//                           padding: const EdgeInsets.symmetric(vertical: 8.0),
//                           child: InkWell(
//                             onTap: () {
//                               if (shop.status == 'Completed') { // Use shop.status
//                                 _showDialog('Status', 'Cannot edit shops with Completed status.');
//                                 return;
//                               }
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) => ConsentFormPage(
//                                     outletName: shop.outletName, // Pass the outlet name
//                                     username: widget.username,
//                                   ),
//                                 ),
//                               ).then((_) => setState(() {})); // Refresh list on pop
//                             },
//                             child: Container(
//                               decoration: BoxDecoration(
//                                 color: Colors.white,
//                                 borderRadius: BorderRadius.circular(10),
//                                 boxShadow: [
//                                   BoxShadow(
//                                     color: Colors.grey.withOpacity(0.2),
//                                     spreadRadius: 2,
//                                     blurRadius: 5,
//                                     offset: const Offset(0, 3),
//                                   ),
//                                 ],
//                               ),
//                               padding: const EdgeInsets.all(15.0),
//                               child: Row(
//                                 children: [
//                                   Expanded(
//                                     child: Text(
//                                       '${index + 1}. ${shop.outletName}', // Use shop.outletName
//                                       style: const TextStyle(
//                                         fontSize: 20,
//                                         color: Colors.brown,
//                                         fontWeight: FontWeight.w500,
//                                       ),
//                                     ),
//                                   ),
//                                   Text(
//                                     shop.status.toUpperCase(), // Use shop.status
//                                     style: TextStyle(
//                                       fontSize: 12,
//                                       fontWeight: FontWeight.bold,
//                                       color: statusColor,
//                                     ),
//                                     textAlign: TextAlign.right,
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                   );
//                 }
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'dart:ui'; // For ImageFilter.blur
// // Removed: import 'package:ferrero_asset_management/data/static_shop_data.dart';
// import 'package:ferrero_asset_management/screens/shops/consent_form_page.dart'; // Import ConsentFormPage
// import 'package:ferrero_asset_management/services/api_service.dart'; // Import ApiService
// import 'package:ferrero_asset_management/models/shop_model.dart'; // Import Shop model
//
// class SearchPage extends StatefulWidget {
//   final String username;
//
//   const SearchPage({super.key, required this.username});
//
//   @override
//   State<SearchPage> createState() => _SearchPageState();
// }
//
// class _SearchPageState extends State<SearchPage> {
//   final TextEditingController _searchController = TextEditingController();
//   late Future<List<Shop>> _shopsFuture; // Future to hold fetched shops
//   List<Shop> _allShops = []; // All shops fetched from API
//   List<Shop> _filteredShops = []; // Shops filtered by search query
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchShops(); // Call method to fetch shops
//     _searchController.addListener(_filterShops);
//   }
//
//   @override
//   void dispose() {
//     _searchController.removeListener(_filterShops);
//     _searchController.dispose();
//     super.dispose();
//   }
//
//   Future<void> _fetchShops() async {
//     setState(() {
//       _shopsFuture = ApiService.fetchAllShops();
//     });
//     _shopsFuture.then((shops) {
//       setState(() {
//         _allShops = shops;
//         _filteredShops = shops; // Initially, show all shops
//       });
//     }).catchError((error) {
//       _showDialog('Error', 'Failed to load shops: $error');
//       setState(() {
//         _allShops = []; // Clear shops on error
//         _filteredShops = [];
//       });
//     });
//   }
//
//   void _filterShops() {
//     String query = _searchController.text.toLowerCase();
//     setState(() {
//       _filteredShops = _allShops
//           .where((shop) => shop.outletName.toLowerCase().contains(query))
//           .toList();
//     });
//   }
//
//   void _showDialog(String title, String message) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text(title),
//           content: Text(message),
//           actions: <Widget>[
//             TextButton(
//               child: const Text('OK'),
//               onPressed: () {
//                 Navigator.of(context).pop();
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
//       backgroundColor: const Color(0xFFFAF6EF),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.fromLTRB(20.0, 50.0, 20.0, 0.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 GestureDetector(
//                   onTap: () => Navigator.pop(context),
//                   child: const Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Icon(Icons.arrow_back_ios, color: Colors.brown, size: 20),
//                       Text('Back', style: TextStyle(fontSize: 18, color: Colors.brown)),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 15),
//                 ClipRect(
//                   child: BackdropFilter(
//                     filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
//                     child: Container(
//                       height: 1.0,
//                       decoration: BoxDecoration(
//                         color: Colors.brown.withOpacity(0.2),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.black.withOpacity(0.1),
//                             blurRadius: 5.0,
//                             offset: const Offset(0, 3),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 30),
//                 Container(
//                   height: 50,
//                   decoration: BoxDecoration(
//                     image: const DecorationImage(
//                       image: AssetImage('assets/rect1.png'),
//                       fit: BoxFit.cover,
//                       repeat: ImageRepeat.repeat,
//                     ),
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child: TextField(
//                     controller: _searchController,
//                     style: const TextStyle(color: Colors.white, fontSize: 18),
//                     decoration: const InputDecoration(
//                       hintText: 'Search...',
//                       hintStyle: TextStyle(color: Colors.white70, fontSize: 18),
//                       border: InputBorder.none,
//                       contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//                       prefixIcon: Icon(Icons.search, color: Colors.white70),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Expanded(
//             child: FutureBuilder<List<Shop>>(
//               future: _shopsFuture,
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const Center(child: CircularProgressIndicator());
//                 } else if (snapshot.hasError) {
//                   return Center(child: Text('Error: ${snapshot.error}. Pull to refresh.'));
//                 } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                   return const Center(child: Text('No shops found.'));
//                 } else {
//                   // Display filtered shops from the API data
//                   return RefreshIndicator( // Added for pull-to-refresh
//                     onRefresh: _fetchShops,
//                     child: ListView.builder(
//                       padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
//                       itemCount: _filteredShops.length,
//                       itemBuilder: (context, index) {
//                         final shop = _filteredShops[index]; // Now 'shop' is a Shop object
//                         Color? statusColor;
//                         switch (shop.status.toLowerCase()) { // Convert to lowercase for robust matching
//                           case 'completed':
//                             statusColor = Colors.green[700];
//                             break;
//                           case 'in progress':
//                           case 'pending': // Assuming 'in progress' also covers 'Pending'
//                             statusColor = Colors.orange[700];
//                             break;
//                           case 'open': // New status
//                             statusColor = Colors.blue[700];
//                             break;
//                           case 'not completed': // Existing status
//                             statusColor = Colors.red[700];
//                             break;
//                           case 'reject':
//                             statusColor = Colors.black;
//                             break;
//                           default:
//                             statusColor = Colors.grey; // Default for unhandled statuses
//                         }
//
//                         return Padding(
//                           padding: const EdgeInsets.symmetric(vertical: 8.0),
//                           child: InkWell(
//                             onTap: () {
//                               if (shop.status == 'Completed') { // Use shop.status
//                                 _showDialog('Status', 'Cannot edit shops with Completed status.');
//                                 return;
//                               }
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) => ConsentFormPage(
//                                     outletName: shop.outletName, // Pass the outlet name
//                                     username: widget.username,
//                                   ),
//                                 ),
//                               ).then((_) => setState(() {})); // Refresh list on pop
//                             },
//                             child: Container(
//                               decoration: BoxDecoration(
//                                 color: Colors.white,
//                                 borderRadius: BorderRadius.circular(10),
//                                 boxShadow: [
//                                   BoxShadow(
//                                     color: Colors.grey.withOpacity(0.2),
//                                     spreadRadius: 2,
//                                     blurRadius: 5,
//                                     offset: const Offset(0, 3),
//                                   ),
//                                 ],
//                               ),
//                               // --- MODIFICATION: Make box bigger with increased padding ---
//                               padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 15.0),
//                               child: Column( // Use Column to stack elements vertically
//                                 crossAxisAlignment: CrossAxisAlignment.start, // Align contents to the left
//                                 children: [
//                                   Row( // Row for Outlet Name and Status on the same line
//                                     children: [
//                                       Expanded(
//                                         child: Text(
//                                           '${index + 1}. ${shop.outletName}', // Outlet Name
//                                           style: const TextStyle(
//                                             fontSize: 20, // Keep larger for main name
//                                             color: Colors.brown,
//                                             fontWeight: FontWeight.w500,
//                                           ),
//                                           overflow: TextOverflow.ellipsis, // Handle long names
//                                           maxLines: 1, // Ensure it stays on one line
//                                         ),
//                                       ),
//                                       Text(
//                                         shop.status.toUpperCase(), // Status, will be right-aligned by Expanded
//                                         style: TextStyle(
//                                           fontSize: 14, // Slightly larger status font
//                                           fontWeight: FontWeight.bold,
//                                           color: statusColor,
//                                         ),
//                                         textAlign: TextAlign.right,
//                                       ),
//                                     ],
//                                   ),
//                                   const SizedBox(height: 4), // Small space between first row and UOC
//                                   // --- NEW: Display UOC in smaller font ---
//                                   Text(
//                                     'UOC: ${shop.uoc}', // Display UOC
//                                     style: const TextStyle(
//                                       fontSize: 14, // Smaller font size for UOC
//                                       color: Colors.grey,
//                                       fontWeight: FontWeight.normal,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                   );
//                 }
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }



// import 'package:flutter/material.dart';
// import 'dart:ui'; // For ImageFilter.blur
// // Removed: import 'package:ferrero_asset_management/data/static_shop_data.dart';
// import 'package:ferrero_asset_management/screens/shops/consent_form_page.dart'; // Import ConsentFormPage
// import 'package:ferrero_asset_management/services/api_service.dart'; // Import ApiService
// import 'package:ferrero_asset_management/models/shop_model.dart'; // Import Shop model
//
// class SearchPage extends StatefulWidget {
//   final String username;
//
//   const SearchPage({super.key, required this.username});
//
//   @override
//   State<SearchPage> createState() => _SearchPageState();
// }
//
// class _SearchPageState extends State<SearchPage> {
//   final TextEditingController _searchController = TextEditingController();
//   late Future<List<Shop>> _shopsFuture; // Future to hold fetched shops
//   List<Shop> _allShops = []; // All shops fetched from API
//   List<Shop> _filteredShops = []; // Shops filtered by search query
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchShops(); // Call method to fetch shops
//     _searchController.addListener(_filterShops);
//   }
//
//   @override
//   void dispose() {
//     _searchController.removeListener(_filterShops);
//     _searchController.dispose();
//     super.dispose();
//   }
//
//   Future<void> _fetchShops() async {
//     setState(() {
//       _shopsFuture = ApiService.fetchAllShops();
//     });
//     _shopsFuture.then((shops) {
//       setState(() {
//         _allShops = shops;
//         _filteredShops = shops; // Initially, show all shops
//       });
//     }).catchError((error) {
//       _showDialog('Error', 'Failed to load shops: $error');
//       setState(() {
//         _allShops = []; // Clear shops on error
//         _filteredShops = [];
//       });
//     });
//   }
//
//   void _filterShops() {
//     String query = _searchController.text.toLowerCase();
//     setState(() {
//       _filteredShops = _allShops
//           .where((shop) => shop.outletName.toLowerCase().contains(query))
//           .toList();
//     });
//   }
//
//   void _showDialog(String title, String message) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text(title),
//           content: Text(message),
//           actions: <Widget>[
//             TextButton(
//               child: const Text('OK'),
//               onPressed: () {
//                 Navigator.of(context).pop();
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
//       backgroundColor: const Color(0xFFFAF6EF),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.fromLTRB(20.0, 50.0, 20.0, 0.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 GestureDetector(
//                   onTap: () => Navigator.pop(context),
//                   child: const Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Icon(Icons.arrow_back_ios, color: Colors.brown, size: 20),
//                       Text('Back', style: TextStyle(fontSize: 18, color: Colors.brown)),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 15),
//                 ClipRect(
//                   child: BackdropFilter(
//                     filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
//                     child: Container(
//                       height: 1.0,
//                       decoration: BoxDecoration(
//                         color: Colors.brown.withOpacity(0.2),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.black.withOpacity(0.1),
//                             blurRadius: 5.0,
//                             offset: const Offset(0, 3),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 30),
//                 Container(
//                   height: 50,
//                   decoration: BoxDecoration(
//                     image: const DecorationImage(
//                       image: AssetImage('assets/rect1.png'),
//                       fit: BoxFit.cover,
//                       repeat: ImageRepeat.repeat,
//                     ),
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child: TextField(
//                     controller: _searchController,
//                     style: const TextStyle(color: Colors.white, fontSize: 18),
//                     decoration: const InputDecoration(
//                       hintText: 'Search...',
//                       hintStyle: TextStyle(color: Colors.white70, fontSize: 18),
//                       border: InputBorder.none,
//                       contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//                       prefixIcon: Icon(Icons.search, color: Colors.white70),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Expanded(
//             child: FutureBuilder<List<Shop>>(
//               future: _shopsFuture,
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const Center(child: CircularProgressIndicator());
//                 } else if (snapshot.hasError) {
//                   return Center(child: Text('Error: ${snapshot.error}. Pull to refresh.'));
//                 } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                   return const Center(child: Text('No shops found.'));
//                 } else {
//                   // Display filtered shops from the API data
//                   return RefreshIndicator( // Added for pull-to-refresh
//                     onRefresh: _fetchShops,
//                     child: ListView.builder(
//                       padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
//                       itemCount: _filteredShops.length,
//                       itemBuilder: (context, index) {
//                         final shop = _filteredShops[index]; // Now 'shop' is a Shop object
//                         Color? statusColor;
//                         switch (shop.status.toLowerCase()) { // Convert to lowercase for robust matching
//                           case 'completed':
//                             statusColor = Colors.green[700];
//                             break;
//                           case 'in progress':
//                           case 'pending': // Assuming 'in progress' also covers 'Pending'
//                             statusColor = Colors.orange[700];
//                             break;
//                           case 'open': // New status
//                             statusColor = Colors.blue[700];
//                             break;
//                           case 'not completed': // Existing status
//                             statusColor = Colors.red[700];
//                             break;
//                           case 'reject':
//                             statusColor = Colors.black;
//                             break;
//                           default:
//                             statusColor = Colors.grey; // Default for unhandled statuses
//                         }
//
//                         return Padding(
//                           padding: const EdgeInsets.symmetric(vertical: 8.0),
//                           child: InkWell(
//                             onTap: () {
//                               if (shop.status == 'Completed') { // Use shop.status
//                                 _showDialog('Status', 'Cannot edit shops with Completed status.');
//                                 return;
//                               }
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) => ConsentFormPage(
//                                     outletName: shop.outletName, // Pass the outlet name
//                                     username: widget.username,
//                                   ),
//                                 ),
//                               ).then((_) => setState(() {})); // Refresh list on pop
//                             },
//                             child: Container(
//                               decoration: BoxDecoration(
//                                 color: Colors.white,
//                                 borderRadius: BorderRadius.circular(10),
//                                 boxShadow: [
//                                   BoxShadow(
//                                     color: Colors.grey.withOpacity(0.2),
//                                     spreadRadius: 2,
//                                     blurRadius: 5,
//                                     offset: const Offset(0, 3),
//                                   ),
//                                 ],
//                               ),
//                               // --- MODIFICATION: Make box smaller by reducing padding ---
//                               padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0), // Reduced from 20.0 to 12.0
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Row(
//                                     children: [
//                                       Expanded(
//                                         child: Text(
//                                           '${index + 1}. ${shop.outletName}',
//                                           style: const TextStyle(
//                                             fontSize: 18, // Slightly reduced font size for outlet name
//                                             color: Colors.brown,
//                                             fontWeight: FontWeight.w500,
//                                           ),
//                                           overflow: TextOverflow.ellipsis,
//                                           maxLines: 1,
//                                         ),
//                                       ),
//                                       Text(
//                                         shop.status.toUpperCase(),
//                                         style: TextStyle(
//                                           fontSize: 10, // Reduced status font size from 14 to 12
//                                           fontWeight: FontWeight.bold,
//                                           color: statusColor,
//                                         ),
//                                         textAlign: TextAlign.right,
//                                       ),
//                                     ],
//                                   ),
//                                   const SizedBox(height: 4),
//                                   Text(
//                                     'UOC: ${shop.uoc}',
//                                     style: const TextStyle(
//                                       fontSize: 12,
//                                       color: Colors.grey,
//                                       fontWeight: FontWeight.normal,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                   );
//                 }
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'dart:ui'; // For ImageFilter.blur
// Removed: import 'package:ferrero_asset_management/data/static_shop_data.dart';
import 'package:ferrero_asset_management/screens/shops/consent_form_page.dart'; // Import ConsentFormPage
// REMOVED: import 'package:ferrero_asset_management/services/api_service.dart'; // Import ApiService
import 'package:ferrero_asset_management/models/shop_model.dart'; // Import Shop model
import 'package:ferrero_asset_management/services/app_api_service.dart'; // ADDED: Import AppApiService

class SearchPage extends StatefulWidget {
  final String username;

  const SearchPage({super.key, required this.username});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  late Future<List<Shop>> _shopsFuture; // Future to hold fetched shops
  List<Shop> _allShops = []; // All shops fetched from API
  List<Shop> _filteredShops = []; // Shops filtered by search query

  @override
  void initState() {
    super.initState();
    _fetchShops(); // Call method to fetch shops
    _searchController.addListener(_filterShops);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterShops);
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchShops() async {
    setState(() {
      // MODIFIED: Use AppApiService().fetchAllShops()
      _shopsFuture = AppApiService().fetchAllShops();
    });
    _shopsFuture.then((shops) {
      setState(() {
        _allShops = shops;
        _filteredShops = shops; // Initially, show all shops
      });
    }).catchError((error) {
      _showDialog('Error', 'Failed to load shops: $error');
      setState(() {
        _allShops = []; // Clear shops on error
        _filteredShops = [];
      });
    });
  }

  void _filterShops() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _filteredShops = _allShops
          .where((shop) => shop.outletName.toLowerCase().contains(query))
          .toList();
    });
  }

  void _showDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
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
      backgroundColor: const Color(0xFFFAF6EF),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 50.0, 20.0, 0.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.arrow_back_ios, color: Colors.brown, size: 20),
                      Text('Back', style: TextStyle(fontSize: 18, color: Colors.brown)),
                    ],
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
                const SizedBox(height: 30),
                Container(
                  height: 50,
                  decoration: BoxDecoration(
                    image: const DecorationImage(
                      image: AssetImage('assets/rect1.png'),
                      fit: BoxFit.cover,
                      repeat: ImageRepeat.repeat,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextField(
                    controller: _searchController,
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                    decoration: const InputDecoration(
                      hintText: 'Search...',
                      hintStyle: TextStyle(color: Colors.white70, fontSize: 18),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      prefixIcon: Icon(Icons.search, color: Colors.white70),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Shop>>(
              future: _shopsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}. Pull to refresh.'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No shops found.'));
                } else {
                  // Display filtered shops from the API data
                  return RefreshIndicator( // Added for pull-to-refresh
                    onRefresh: _fetchShops,
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                      itemCount: _filteredShops.length,
                      itemBuilder: (context, index) {
                        final shop = _filteredShops[index]; // Now 'shop' is a Shop object
                        Color? statusColor;
                        switch (shop.status.toLowerCase()) { // Convert to lowercase for robust matching
                          case 'completed':
                            statusColor = Colors.green[700];
                            break;
                          case 'in progress':
                          case 'pending': // Assuming 'in progress' also covers 'Pending'
                            statusColor = Colors.orange[700];
                            break;
                          case 'open': // New status
                            statusColor = Colors.blue[700];
                            break;
                          case 'not completed': // Existing status
                            statusColor = Colors.red[700];
                            break;
                          case 'reject':
                            statusColor = Colors.black;
                            break;
                          default:
                            statusColor = Colors.grey; // Default for unhandled statuses
                        }

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: InkWell(
                            onTap: () {
                              // MODIFIED: Robust check for 'completed' status to prevent editing
                              if (shop.status.toLowerCase() == 'completed') {
                                _showDialog('Status', 'Cannot edit shops with Completed status.');
                                return;
                              }
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ConsentFormPage(
                                    outletName: shop.outletName, // Pass the outlet name
                                    username: widget.username,
                                  ),
                                ),
                              ).then((_) => setState(() {})); // Refresh list on pop
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              // --- MODIFICATION: Make box smaller by reducing padding ---
                              padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0), // Reduced from 20.0 to 12.0
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          '${index + 1}. ${shop.outletName}',
                                          style: const TextStyle(
                                            fontSize: 18, // Slightly reduced font size for outlet name
                                            color: Colors.brown,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      ),
                                      Text(
                                        shop.status.toUpperCase(),
                                        style: TextStyle(
                                          fontSize: 10, // Reduced status font size from 14 to 12
                                          fontWeight: FontWeight.bold,
                                          color: statusColor,
                                        ),
                                        textAlign: TextAlign.right,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'UOC: ${shop.uoc}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}