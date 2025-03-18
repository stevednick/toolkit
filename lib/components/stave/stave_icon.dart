import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:toolkit/components/stave/stave.dart';
import 'package:toolkit/models/note_data.dart';
import 'package:toolkit/models/player/player.dart';

class StaveImageRenderer {
  final double width;
  final double height;
  final Player player;
  final bool showGhostNotes;
  
  late Stave _stave;
  ui.Image? _cachedImage;

  StaveImageRenderer({
    this.width = 120,
    this.height = 80,
    required this.player,
    this.showGhostNotes = false,
  });

  Future<ui.Image> renderStaveToImage({NoteData? noteData}) async {
    // Return cached image if available and note hasn't changed
    if (_cachedImage != null && noteData == null) {
      return _cachedImage!;
    }

    // Create a picture recorder
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    
    // Create the stave if it doesn't exist
    _stave = Stave(player, height, showGhostNotes: showGhostNotes);
    await _stave.onLoad();

    
    // If a specific note is provided, change to it
    if (noteData != null) {
      await Future.delayed(Duration(seconds: 1), (){});
      _stave.changeNote(noteData, 0.0); // No fade duration for image rendering
    }

    // Set up the paint area
    final rect = Rect.fromLTWH(0, 0, width, height);
    canvas.clipRect(rect);
    
    // Scale the stave to fit our dimensions
    final scale = _stave.positionManager.scaleFactor();
    canvas.scale(scale);

    // Render the stave
    await _stave.onLoad();
    _stave.render(canvas);

    // Create the image
    final picture = recorder.endRecording();
    _cachedImage = await picture.toImage(width.toInt(), height.toInt());
    
    return _cachedImage!;
  }

  // Helper method to create a widget
  Widget buildStaveImage({NoteData? noteData}) {
    return FutureBuilder<ui.Image>(
      future: renderStaveToImage(noteData: noteData),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return RawImage(
            image: snapshot.data,
            width: width,
            height: height,
            fit: BoxFit.contain,
          );
        }
        // Show a placeholder while loading
        return SizedBox(
          width: width,
          height: height,
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }

  // Clean up resources
  void dispose() {
    _cachedImage?.dispose();
    _cachedImage = null;
  }
}