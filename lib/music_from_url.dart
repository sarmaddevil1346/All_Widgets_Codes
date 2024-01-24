import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class SongFromURL extends StatefulWidget {
  @override
  _SongFromURLState createState() => _SongFromURLState();
}

class _SongFromURLState extends State<SongFromURL> {
  final AudioPlayer audioPlayer = AudioPlayer();

  Future<void> playAudioFromNetwork() async {
    try {
      await audioPlayer.play(UrlSource(
          "https://filesamples.com/samples/audio/mp3/Symphony%20No.6%20(1st%20movement).mp3"));
    } catch (e) {
      print("Error playing audio: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Music Player App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                playAudioFromNetwork();
              },
              child: Text("Play Audio From Network"),
            ),
            ElevatedButton(
              onPressed: () {
                audioPlayer.stop();
              },
              child: Text("Stop"),
            ),
            ElevatedButton(
              onPressed: () {
                audioPlayer.resume();
              },
              child: Text("Resume"),
            ),
            ElevatedButton(
              onPressed: () {
                audioPlayer.pause();
              },
              child: Text("Pause"),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    audioPlayer
        .dispose(); // Dispose the audio player when the widget is disposed
    super.dispose();
  }
}
