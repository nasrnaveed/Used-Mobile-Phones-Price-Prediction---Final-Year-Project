import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class Condition extends StatefulWidget {
  const Condition({super.key});

  @override
  State<Condition> createState() => _ConditionState();
}

class _ConditionState extends State<Condition> {
  File? _backImage;
  File? _frontOnImage;
  File? _frontOffImage;
  String? _predictionBack;
  String? _predictionFrontOn;
  String? _predictionFrontOff;
  String? _overallCondition;
  bool _loadingBack = false;
  bool _loadingFrontOn = false;
  bool _loadingFrontOff = false;
  int backPoints = 0;
  int frontOnPoints = 0;
  int frontOffPoints = 0;
  int overallPoints = 0;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImageFromGalleryBack() async {
    final image = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (image != null) {
        _backImage = File(image.path);
      }
    });
  }

  Future<void> _pickImageFromCameraBack() async {
    final image = await _picker.pickImage(source: ImageSource.camera);
    setState(() {
      if (image != null) {
        _backImage = File(image.path);
      }
    });
  }

  Future<void> _uploadImageBack() async {
    if (_backImage == null) return;

    setState(() {
      _loadingBack = true;
    });

    final uri = Uri.parse('http://192.168.171.136:5000/predictBack');
    final request = http.MultipartRequest('POST', uri);
    request.files
        .add(await http.MultipartFile.fromPath('file', _backImage!.path));

    final response = await request.send();
    if (response.statusCode == 200) {
      final responseData = await response.stream.bytesToString();
      final result = json.decode(responseData);
      String temp;
      setState(() {
        temp = result['predicted_class'].toString();
        switch (temp) {
          case '0':
            _predictionBack = 'Average';
            backPoints = 2;
            break;
          case '1':
            _predictionBack = 'Bad';
            backPoints = 1;
            break;
          case '2':
            _predictionBack = 'Good';
            backPoints = 3;
            break;
        }
      });
    } else {
      setState(() {
        _predictionBack = 'Error: ${response.reasonPhrase}';
      });
    }

    setState(() {
      _loadingBack = false;
    });
  }

  Future<void> _pickImageFromGalleryFrontOn() async {
    final image = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (image != null) {
        _frontOnImage = File(image.path);
      }
    });
  }

  Future<void> _pickImageFromCameraFrontOn() async {
    final image = await _picker.pickImage(source: ImageSource.camera);
    setState(() {
      if (image != null) {
        _frontOnImage = File(image.path);
      }
    });
  }

  Future<void> _uploadImageFrontOn() async {
    if (_frontOnImage == null) return;

    setState(() {
      _loadingFrontOn = true;
    });

    final uri = Uri.parse('http://192.168.171.136:5000/predictFrontOn');
    final request = http.MultipartRequest('POST', uri);
    request.files
        .add(await http.MultipartFile.fromPath('file', _frontOnImage!.path));

    final response = await request.send();
    if (response.statusCode == 200) {
      final responseData = await response.stream.bytesToString();
      final result = json.decode(responseData);
      String temp;
      setState(() {
        temp = result['predicted_class'].toString();
        switch (temp) {
          case '0':
            _predictionFrontOn = 'Average';
            frontOnPoints = 2;
            break;
          case '1':
            _predictionFrontOn = 'Bad';
            frontOnPoints = 1;
            break;
          case '2':
            _predictionFrontOn = 'Good';
            frontOnPoints = 3;
            break;
        }
      });
    } else {
      setState(() {
        _predictionFrontOn = 'Error: ${response.reasonPhrase}';
      });
    }

    setState(() {
      _loadingFrontOn = false;
    });
  }

  Future<void> _pickImageFromGalleryFrontOff() async {
    final image = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (image != null) {
        _frontOffImage = File(image.path);
      }
    });
  }

  Future<void> _pickImageFromCameraFrontOff() async {
    final image = await _picker.pickImage(source: ImageSource.camera);
    setState(() {
      if (image != null) {
        _frontOffImage = File(image.path);
      }
    });
  }

  Future<void> _uploadImageFrontOff() async {
    if (_frontOffImage == null) return;

    setState(() {
      _loadingFrontOff = true;
    });

    final uri = Uri.parse('http://192.168.171.136:5000/predictFrontOff');
    final request = http.MultipartRequest('POST', uri);
    request.files
        .add(await http.MultipartFile.fromPath('file', _frontOffImage!.path));

    final response = await request.send();
    if (response.statusCode == 200) {
      final responseData = await response.stream.bytesToString();
      final result = json.decode(responseData);
      String temp;
      setState(() {
        temp = result['predicted_class'].toString();
        switch (temp) {
          case '0':
            _predictionFrontOff = 'Average';
            frontOffPoints = 2;
            break;
          case '1':
            _predictionFrontOff = 'Bad';
            frontOffPoints = 1;
            break;
          case '2':
            _predictionFrontOff = 'Good';
            frontOffPoints = 3;
            break;
        }
      });
    } else {
      setState(() {
        _predictionFrontOff = 'Error: ${response.reasonPhrase}';
      });
    }

    setState(() {
      _loadingFrontOff = false;
    });
  }

  Future<void> _getOverallCondition() async {
    setState(() {
      if (_predictionBack!.isNotEmpty &&
          _predictionFrontOff!.isNotEmpty &&
          _predictionFrontOn!.isNotEmpty) {
        overallPoints = backPoints + frontOnPoints + frontOffPoints;
        if (overallPoints >= 8) {
          _overallCondition = 'Good';
        } else if (overallPoints >= 5) {
          _overallCondition = 'Average';
        } else if (overallPoints < 5) {
          _overallCondition = 'Bad';
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Condition"),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0),
            child: Column(
              children: [
                const Text(
                  "Please take pictures without screen protectors and back covers for better condition analysis.",
                  style: TextStyle(color: Colors.red),
                ),
                const SizedBox(height: 20),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Front Side with Screen On",
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: _pickImageFromGalleryFrontOn,
                      child: const Text("Pick From Gallery"),
                    ),
                    ElevatedButton(
                      onPressed: _pickImageFromCameraFrontOn,
                      child: const Text("Capture A Picture"),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        onPressed: (_frontOnImage != null)
                            ? _uploadImageFrontOn
                            : null,
                        child: const Text("Get Condition")),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_loadingFrontOn) const CircularProgressIndicator(),
                    if (_predictionFrontOn != null) Text(_predictionFrontOn!),
                  ],
                ),
                const SizedBox(
                  height: 10.0,
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Front Side with Screen Off",
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: _pickImageFromGalleryFrontOff,
                      child: const Text("Pick From Gallery"),
                    ),
                    ElevatedButton(
                      onPressed: _pickImageFromCameraFrontOff,
                      child: const Text("Capture A Picture"),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        onPressed: (_frontOffImage != null)
                            ? _uploadImageFrontOff
                            : null,
                        child: const Text("Get Condition")),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_loadingFrontOff) const CircularProgressIndicator(),
                    if (_predictionFrontOff != null) Text(_predictionFrontOff!),
                  ],
                ),
                const SizedBox(
                  height: 10.0,
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Back Side",
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: _pickImageFromGalleryBack,
                      child: const Text("Pick From Gallery"),
                    ),
                    ElevatedButton(
                      onPressed: _pickImageFromCameraBack,
                      child: const Text("Capture A Picture"),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        onPressed:
                            (_backImage != null) ? _uploadImageBack : null,
                        child: const Text("Get Condition")),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_loadingBack) const CircularProgressIndicator(),
                    if (_predictionBack != null) Text(_predictionBack!),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: Column(
                    children: [
                      ElevatedButton(
                          onPressed: (_frontOffImage != null &&
                                  _frontOnImage != null &&
                                  _backImage != null)
                              ? _getOverallCondition
                              : null,
                          child: const Text(
                            "Get Overall Condition",
                          )),
                      if (_overallCondition != null)
                        Text("Overall Condition is : ${_overallCondition!}"),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
