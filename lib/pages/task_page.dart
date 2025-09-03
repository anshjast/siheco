import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/course.dart';
import '../widgets/reward_dialog.dart';

class TaskPage extends StatefulWidget {
  final Course course;
  final VoidCallback onTaskComplete;

  const TaskPage({
    super.key,
    required this.course,
    required this.onTaskComplete,
  });

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  File? _imageFile;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  void _submitTask() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => RewardDialog(
        title: widget.course.badgeName,
        xp: widget.course.xp,
        coins: widget.course.coins,
        // --- THE FIX IS HERE ---
        // We now pass the correct 'badgeAsset' parameter with the image path.
        badgeAsset: widget.course.badgeAsset,
      ),
    ).then((_) {
      widget.onTaskComplete();
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    const taskInstructions =
        "1. Find two containers for your home.\n2. Label one 'Wet Waste' and the other 'Dry Waste'.\n3. Put all your waste into the correct bin for 24 hours.";
    const submissionRequirement =
        "To complete this challenge and earn your rewards, upload a photo of your two labeled bins.";

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.course.title),
        backgroundColor: const Color(0xFF56ab2f),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(taskInstructions, style: TextStyle(fontSize: 16, color: Colors.black87), textAlign: TextAlign.center),
            const SizedBox(height: 16),
            const Text(submissionRequirement, style: TextStyle(fontSize: 14, color: Colors.grey, fontStyle: FontStyle.italic), textAlign: TextAlign.center),
            const SizedBox(height: 20),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: _imageFile == null
                    ? Center(child: Text('Press the button below to take a photo', style: TextStyle(color: Colors.grey[600])))
                    : ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Image.file(_imageFile!, fit: BoxFit.cover),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.camera_alt),
              label: const Text('Take Photo', style: TextStyle(fontSize: 18)),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: Colors.green,
              ),
              onPressed: _pickImage,
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: _imageFile != null ? Colors.blueAccent : Colors.grey,
              ),
              onPressed: _imageFile != null ? _submitTask : null,
              child: const Text('Submit Challenge', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}

