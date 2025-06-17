

import 'package:flutter/material.dart';
import 'dart:io'; // Re-import dart:io for File

import 'package:image_picker/image_picker.dart'; // Import XFile

class PhotoCaptureGridItem extends StatelessWidget {
  final String imageType;
  final String label;
  // Reverted back to XFile? pickedFile
  final XFile? pickedFile;
  final VoidCallback onTap;

  const PhotoCaptureGridItem({
    super.key,
    required this.imageType,
    required this.label,
    this.pickedFile, // Changed back to pickedFile
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF0E4D4), // Assuming AppColors.lightOrange
          borderRadius: BorderRadius.circular(15.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // MODIFIED: Use Image.file for XFile
            pickedFile != null
                ? Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  // Use Image.file for XFile
                  child: Image.file(
                    File(pickedFile!.path),
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      // Fallback if image fails to load
                      return const Center(
                        child: Icon(Icons.broken_image, size: 50, color: Colors.red),
                      );
                    },
                  ),
                ),
              ),
            )
                : const Icon(
              Icons.camera_alt,
              size: 50,
              color: Color(0xFF5D4037), // Assuming AppColors.darkBrown
            ),
            const SizedBox(height: 10),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF5D4037), // Assuming AppColors.darkBrown
              ),
            ),
          ],
        ),
      ),
    );
  }
}