import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import '../services/location_service.dart';
import 'photo_preview_screen.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _controller;
  List<CameraDescription>? cameras;
  bool _isCameraReady = false;
  final LocationService _locationService = LocationService();

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      cameras = await availableCameras();
      if (cameras != null && cameras!.isNotEmpty) {
        _controller = CameraController(cameras![0], ResolutionPreset.high);

        await _controller!.initialize();
        if (mounted) {
          setState(() {
            _isCameraReady = true;
          });
        }
      }
    } catch (e) {
      print('Error initializing camera: $e');
      _showErrorDialog('Failed to initialize camera');
    }
  }

  Future<void> _takePicture() async {
    if (!_isCameraReady || _controller == null) return;

    try {
      final image = await _controller!.takePicture();

      if (mounted) {
        final location = await _locationService.getCurrentLocation();

        if (location == null) {
          _showErrorDialog(
            'Unable to get location. Please enable location services.',
          );
          return;
        }

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PhotoPreviewScreen(
              imagePath: image.path,
              latitude: location.latitude,
              longitude: location.longitude,
            ),
          ),
        );
      }
    } catch (e) {
      print('Error taking picture: $e');
      _showErrorDialog('Failed to take picture');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Camera'),
        backgroundColor: const Color(0xFFc94b4b),
      ),
      body: _isCameraReady && _controller != null
          ? Stack(
              children: [
                CameraPreview(_controller!),
                Positioned(
                  bottom: 30,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: FloatingActionButton(
                      onPressed: _takePicture,
                      backgroundColor: const Color(0xFFc94b4b),
                      child: const Icon(Icons.camera_alt),
                    ),
                  ),
                ),
              ],
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
