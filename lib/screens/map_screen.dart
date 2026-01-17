import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../widgets/custom_app_bar.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'DR.DRIVE', showSOS: true),
      body: Column(
        children: [
          // Page Title
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            color: primaryColor.withOpacity(0.1),
            child: const Text(
              'Traffic Map',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          // Map Container
          Expanded(
            child: Container(
              decoration: kCardDecoration.copyWith(
                borderRadius: BorderRadius.zero,
              ),
              child: const Center(child: Text('Interactive Traffic Map')),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: primaryColor,
        child: const Icon(Icons.info, color: Colors.white),
      ),
    );
  }
}
