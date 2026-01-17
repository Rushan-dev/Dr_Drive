import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
// import 'package:geolocator/geolocator.dart'; // Commented out for build phase
// import 'package:vibration/vibration.dart'; // Commented out for build phase
import 'dart:async';
import 'dart:math'; // For mock speed generation
import '../widgets/custom_app_bar.dart';

// Development flag - set to true to enable real GPS and vibration
const bool enableRealGpsVibration = false;

class DrivingModeScreen extends StatefulWidget {
  const DrivingModeScreen({super.key});

  @override
  State<DrivingModeScreen> createState() => _DrivingModeScreenState();
}

class _DrivingModeScreenState extends State<DrivingModeScreen> {
  double _currentSpeed = 0.0;
  bool _driveModeEnabled = false;
  double _speedLimit = 60.0; // Default speed limit in km/h
  bool _isVibrating = false;
  bool _isLoading = false;
  // Position? _previousPosition; // Commented out for build phase
  // DateTime? _previousTime; // Commented out for build phase
  // StreamSubscription<Position>? _positionStream; // Commented out for build phase
  Timer? _mockSpeedTimer; // For mock speed simulation

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
  }

  @override
  void dispose() {
    // _positionStream?.cancel(); // Commented out for build phase
    _mockSpeedTimer?.cancel();
    super.dispose();
  }

  Future<void> _checkLocationPermission() async {
    if (enableRealGpsVibration) {
      // Real implementation
      // LocationPermission permission = await Geolocator.checkPermission();
      // if (permission == LocationPermission.denied) {
      //   permission = await Geolocator.requestPermission();
      // }
      // if (permission == LocationPermission.whileInUse ||
      //     permission == LocationPermission.always) {
      //   // Permission granted
      // }
    } else {
      // Mock implementation - simulate permission granted
      await Future.delayed(const Duration(milliseconds: 500));
    }
  }

  void _toggleDriveMode(bool enabled) {
    if (_isLoading) return; // Prevent toggling during loading

    if (enabled) {
      // Immediately update the UI to show enabled state
      setState(() {
        _driveModeEnabled = true;
        _isLoading = true;
      });

      // Start the async process
      _enableDriveMode();
    } else {
      setState(() {
        _driveModeEnabled = false;
      });
      _stopSpeedMonitoring();
      _stopVibration();
    }
  }

  void _enableDriveMode() async {
    try {
      if (enableRealGpsVibration) {
        // Real implementation
        // bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
        // if (!serviceEnabled) {
        //   if (mounted) {
        //     _showLocationServiceDialog();
        //   }
        //   setState(() {
        //     _driveModeEnabled = false;
        //     _isLoading = false;
        //   });
        //   return;
        // }

        // LocationPermission permission = await Geolocator.checkPermission();
        // if (permission == LocationPermission.denied) {
        //   permission = await Geolocator.requestPermission();
        //   if (permission == LocationPermission.denied) {
        //     if (mounted) {
        //       _showPermissionDeniedDialog();
        //     }
        //     setState(() {
        //       _driveModeEnabled = false;
        //       _isLoading = false;
        //     });
        //     return;
        //   }
        // }

        // if (permission == LocationPermission.deniedForever) {
        //   if (mounted) {
        //     _showPermissionDeniedForeverDialog();
        //   }
        //   setState(() {
        //     _driveModeEnabled = false;
        //     _isLoading = false;
        //   });
        //   return;
        // }

        // _startSpeedMonitoring();
      } else {
        // Mock implementation - simulate checking services and permissions
        await Future.delayed(const Duration(seconds: 1));

        // Simulate random success/failure for testing
        final random = Random();
        final success = random.nextBool();

        if (!success) {
          // Simulate location services disabled
          if (mounted) {
            _showLocationServiceDialog();
          }
          setState(() {
            _driveModeEnabled = false;
            _isLoading = false;
          });
          return;
        }

        _startSpeedMonitoring();
      }

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error starting drive mode: $e')),
        );
      }
      setState(() {
        _driveModeEnabled = false;
        _isLoading = false;
      });
    }
  }

  void _startSpeedMonitoring() async {
    if (enableRealGpsVibration) {
      // Real implementation
      // const LocationSettings locationSettings = LocationSettings(
      //   accuracy: LocationAccuracy.high,
      //   distanceFilter: 5, // Update every 5 meters
      // );

      // _positionStream = Geolocator.getPositionStream(
      //   locationSettings: locationSettings,
      // ).listen((Position position) {
      //   _calculateSpeed(position);
      // });
    } else {
      // Mock implementation - simulate speed changes
      _mockSpeedTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
        if (!mounted || !_driveModeEnabled) {
          timer.cancel();
          return;
        }

        // Generate mock speed between 0-80 km/h with some variation
        final random = Random();
        final baseSpeed = _currentSpeed;
        final variation = (random.nextDouble() - 0.5) * 20; // -10 to +10
        final newSpeed = (baseSpeed + variation).clamp(0.0, 80.0);

        setState(() {
          _currentSpeed = newSpeed;
        });

        _checkSpeedLimit(newSpeed);
      });
    }
  }

  void _stopSpeedMonitoring() {
    // _positionStream?.cancel(); // Commented out for build phase
    // _positionStream = null; // Commented out for build phase
    _mockSpeedTimer?.cancel();
    _mockSpeedTimer = null;
    setState(() {
      _currentSpeed = 0.0;
    });
  }

  // void _calculateSpeed(Position currentPosition) { // Commented out for build phase
  //   if (_previousPosition != null && _previousTime != null) {
  //     final distance = Geolocator.distanceBetween(
  //       _previousPosition!.latitude,
  //       _previousPosition!.longitude,
  //       currentPosition.latitude,
  //       currentPosition.longitude,
  //     );

  //     final timeDifference = currentPosition.timestamp.difference(_previousTime!).inSeconds;

  //     if (timeDifference > 0) {
  //       // Calculate speed in km/h
  //       final speed = (distance / 1000) / (timeDifference / 3600);
  //       setState(() {
  //         _currentSpeed = speed;
  //       });

  //       _checkSpeedLimit(speed);
  //     }
  //   }

  //   _previousPosition = currentPosition;
  //   _previousTime = currentPosition.timestamp;
  // }

  void _checkSpeedLimit(double speed) {
    if (_driveModeEnabled && speed > _speedLimit) {
      if (!_isVibrating) {
        _startVibration();
      }
    } else {
      if (_isVibrating) {
        _stopVibration();
      }
    }
  }

  void _startVibration() async {
    if (enableRealGpsVibration) {
      // Real implementation
      // final hasVibrator = await Vibration.hasVibrator();
      // if (hasVibrator) {
      //   setState(() {
      //     _isVibrating = true;
      //   });
      //   Vibration.vibrate(pattern: [500, 500, 500, 500], repeat: 0);
      // }
    } else {
      // Mock implementation - simulate vibration
      setState(() {
        _isVibrating = true;
      });

      // Simulate vibration duration
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted && _isVibrating) {
          setState(() {
            _isVibrating = false;
          });
        }
      });
    }
  }

  void _stopVibration() {
    setState(() {
      _isVibrating = false;
    });

    if (enableRealGpsVibration) {
      // Real implementation
      // Vibration.cancel();
    }
    // Mock implementation doesn't need cleanup
  }

  void _showLocationServiceDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Location Services Disabled'),
          content: const Text(
            'Location services are required for speed monitoring. Please enable location services in your device settings.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                if (enableRealGpsVibration) {
                  // await Geolocator.openLocationSettings();
                } else {
                  // Mock - simulate user enabling location services
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Mock: Location services enabled'),
                    ),
                  );
                }
              },
              child: const Text('Open Settings'),
            ),
          ],
        );
      },
    );
  }

  // void _showPermissionDeniedDialog() { // Commented out for build phase - not used in mock
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: const Text('Location Permission Required'),
  //         content: const Text('Location permission is required for speed monitoring. Please grant location permission.'),
  //         actions: [
  //           TextButton(
  //             onPressed: () => Navigator.of(context).pop(),
  //             child: const Text('Cancel'),
  //           ),
  //           TextButton(
  //             onPressed: () async {
  //               Navigator.of(context).pop();
  //               if (enableRealGpsVibration) {
  //                 await Geolocator.openAppSettings();
  //               } else {
  //                 ScaffoldMessenger.of(context).showSnackBar(
  //                   const SnackBar(content: Text('Mock: Location permission granted')),
  //                 );
  //               }
  //             },
  //             child: const Text('Open Settings'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  // void _showPermissionDeniedForeverDialog() { // Commented out for build phase - not used in mock
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: const Text('Location Permission Required'),
  //         content: const Text('Location permission is permanently denied. Please enable location permission in app settings.'),
  //         actions: [
  //           TextButton(
  //             onPressed: () => Navigator.of(context).pop(),
  //             child: const Text('Cancel'),
  //           ),
  //           TextButton(
  //             onPressed: () async {
  //               Navigator.of(context).pop();
  //               if (enableRealGpsVibration) {
  //                 await Geolocator.openAppSettings();
  //               } else {
  //                 ScaffoldMessenger.of(context).showSnackBar(
  //                   const SnackBar(content: Text('Mock: Location permission granted')),
  //                 );
  //               }
  //             },
  //             child: const Text('Open Settings'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'DR.DRIVE', showSOS: true),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFFE3F2FD), // Light blue
              const Color(0xFFBBDEFB), // Slightly darker light blue
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header with drive mode toggle
              Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Color(0xFF1565C0),
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Text(
                      'Driving Mode',
                      style: TextStyle(
                        color: Color(0xFF1565C0), // Dark blue text
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.settings,
                        color: Color(0xFF1565C0),
                      ),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),

              // Drive mode toggle
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Drive Mode',
                      style: TextStyle(
                        color: Color(0xFF1565C0),
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 16),
                    if (_isLoading)
                      const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Color(0xFF1565C0),
                          ),
                        ),
                      )
                    else
                      Switch(
                        value: _driveModeEnabled,
                        onChanged: _toggleDriveMode,
                        activeThumbColor: const Color(0xFF4CAF50),
                        activeTrackColor: const Color(
                          0xFF4CAF50,
                        ).withValues(alpha: 0.5),
                        inactiveThumbColor: Colors.grey[400],
                        inactiveTrackColor: Colors.grey[300],
                      ),
                  ],
                ),
              ),

              // Speed warning indicator
              if (_isVibrating)
                Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFCDD2), // Light red background
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      color: const Color(0xFFF44336),
                      width: 2,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.vibration,
                        color: Color(0xFFF44336),
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Speed Limit Exceeded!',
                        style: TextStyle(
                          color: Color(0xFFF44336),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

              // Speedometer gauge - now takes full remaining space
              Expanded(
                child: Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: MediaQuery.of(context).size.width * 0.9,
                    child: SfRadialGauge(
                      axes: [
                        RadialAxis(
                          minimum: 0,
                          maximum: 120,
                          ranges: [
                            GaugeRange(
                              startValue: 0,
                              endValue: _speedLimit * 0.8,
                              color: const Color(0xFF4CAF50), // Green for safe
                              startWidth: 12,
                              endWidth: 12,
                            ),
                            GaugeRange(
                              startValue: _speedLimit * 0.8,
                              endValue: _speedLimit,
                              color: const Color(
                                0xFFFFC107,
                              ), // Yellow for caution
                              startWidth: 12,
                              endWidth: 12,
                            ),
                            GaugeRange(
                              startValue: _speedLimit,
                              endValue: 120,
                              color: const Color(0xFFF44336), // Red for danger
                              startWidth: 12,
                              endWidth: 12,
                            ),
                          ],
                          pointers: [
                            NeedlePointer(
                              value: _currentSpeed,
                              needleColor: const Color(
                                0xFF1565C0,
                              ), // Dark blue needle
                              knobStyle: KnobStyle(
                                color: Colors.white,
                                borderColor: const Color(0xFF1565C0),
                                borderWidth: 0.05,
                                knobRadius: 0.08,
                              ),
                            ),
                          ],
                          annotations: [
                            GaugeAnnotation(
                              widget: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    _currentSpeed.toStringAsFixed(0),
                                    style: const TextStyle(
                                      fontSize: 48,
                                      fontWeight: FontWeight.bold,
                                      color: Color(
                                        0xFF1565C0,
                                      ), // Dark blue text
                                    ),
                                  ),
                                  const Text(
                                    'km/h',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Color(
                                        0xFF1565C0,
                                      ), // Dark blue text
                                    ),
                                  ),
                                ],
                              ),
                              angle: 90,
                              positionFactor: 0.5,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Status display at bottom
              Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: _driveModeEnabled
                            ? const Color(0xFFE8F5E8)
                            : const Color(
                                0xFFF5F5F5,
                              ), // Light green or light gray
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: _driveModeEnabled
                              ? const Color(0xFF4CAF50)
                              : Colors.grey[400]!,
                          width: 2,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _driveModeEnabled
                                ? Icons.check_circle
                                : Icons.pause_circle,
                            color: _driveModeEnabled
                                ? const Color(0xFF4CAF50)
                                : Colors.grey[600],
                            size: 24,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _isLoading
                                ? 'Loading...'
                                : _driveModeEnabled
                                ? 'Active'
                                : 'Inactive',
                            style: TextStyle(
                              color: _driveModeEnabled
                                  ? const Color(0xFF4CAF50)
                                  : Colors.grey[600],
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Speed Limit: ${_speedLimit.toStringAsFixed(0)} km/h',
                      style: const TextStyle(
                        color: Color(0xFF1565C0), // Dark blue text
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
