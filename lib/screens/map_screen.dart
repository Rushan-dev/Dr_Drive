import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Traffic Map'),
        backgroundColor: primaryColor,
      ),
      body: Container(
        decoration: kCardDecoration.copyWith(
          borderRadius: BorderRadius.zero,
        ),
        child: const Center(
          child: Text('Interactive Traffic Map'),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {}, // Traffic details is now a tab
        child: const Icon(Icons.info),
      ),
    );
  }
}