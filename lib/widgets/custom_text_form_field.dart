import 'package:flutter/material.dart';
// import 'package:ferrero_app/utils/constants.dart'; // Uncomment if you use AppAssets

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final FocusNode focusNode;
  final ValueNotifier<bool> isFocusedNotifier;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final bool obscureText;

  const CustomTextFormField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.hintText,
    required this.focusNode,
    required this.isFocusedNotifier,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            text: labelText,
            style: const TextStyle(fontSize: 18, color: Colors.brown),
            children: const [TextSpan(text: ' *', style: TextStyle(fontSize: 18, color: Colors.red))],
          ),
        ),
        const SizedBox(height: 8),
        ValueListenableBuilder<bool>(
          valueListenable: isFocusedNotifier,
          builder: (context, isFocused, child) {
            return Container(
              height: 50,
              decoration: BoxDecoration(
                image: const DecorationImage(
                  image: AssetImage('assets/rect1.png'), // Use AppAssets.rect1 if you uncommented the import
                  fit: BoxFit.cover,
                  repeat: ImageRepeat.repeat,
                ),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: isFocused ? Colors.amber.withOpacity(0.5) : Colors.brown.withOpacity(0.2),
                    blurRadius: isFocused ? 8 : 3,
                    spreadRadius: isFocused ? 2 : 0,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: TextFormField(
                controller: controller,
                focusNode: focusNode,
                keyboardType: keyboardType,
                obscureText: obscureText,
                style: const TextStyle(color: Colors.white, fontSize: 16),
                decoration: InputDecoration(
                  hintText: hintText,
                  hintStyle: const TextStyle(color: Colors.white70),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                ),
                validator: validator,
              ),
            );
          },
        ),
      ],
    );
  }
}
