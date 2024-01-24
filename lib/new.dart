import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:simple_waveform_progressbar/simple_waveform_progressbar.dart';

class AudioPlayerScreen extends StatefulWidget {
  const AudioPlayerScreen({super.key});

  @override
  _AudioPlayerScreenState createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends State<AudioPlayerScreen> {
  AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  double _sliderValue = 0.0;
  Duration _duration = const Duration();
  Duration _position = const Duration();
  bool _isSliderChanging = false;
  late StreamController<Duration> _positionController;
  late Timer _timer;

  @override
  void initState() {
    super.initState();

    _audioPlayer.onDurationChanged.listen((Duration duration) {
      setState(() {
        _duration = duration;
      });
    });

    // Initialize StreamController
    _positionController = StreamController<Duration>();

    // Set up a timer to update the position periodically
    _timer = Timer.periodic(const Duration(milliseconds: 100), (_) {
      if (!_isSliderChanging) {
        _audioPlayer.getCurrentPosition().then((position) {
          _positionController.add(position!); // Add position to the stream
        });
      }
    });

    // Listen to the stream for position updates
    _positionController.stream.listen((position) {
      setState(() {
        _position = position;
        _sliderValue = _position.inMilliseconds / _duration.inMilliseconds;
      });
    });
  }

  @override
  void dispose() {
    _positionController.close();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Audio Player App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 0,
              child: SizedBox(
                height: 100,
                child: WaveformProgressbar(
                  color: Colors.grey,
                  progressColor: Colors.red,
                  progress: _sliderValue,
                  onTap: (progress) {
                    _sliderValue = progress;
                    if (!_isSliderChanging) {
                      _setPosition();
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              '${_position.inMinutes.remainder(60).toString().padLeft(2, '0')}:'
              '${_position.inSeconds.remainder(60).toString().padLeft(2, '0')} / '
              '${_duration.inMinutes.remainder(60).toString().padLeft(2, '0')}:'
              '${_duration.inSeconds.remainder(60).toString().padLeft(2, '0')}',
            ),
            const SizedBox(height: 20),
            Text(
              'Slider Value: ${(_sliderValue * 100).toStringAsFixed(2)}%', // Display slider value
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _isPlaying ? _pause() : _play();
              },
              child: Text(_isPlaying ? 'Pause' : 'Play'),
            ),
          ],
        ),
      ),
    );
  }

  void _play() async {
    await _audioPlayer.play(AssetSource("music/song1.mp3"));
    setState(() {
      _isPlaying = true;
    });
  }

  void _pause() {
    _audioPlayer.pause();
    setState(() {
      _isPlaying = false;
    });
  }

  void _setPosition() {
    final newPosition = _sliderValue * _duration.inMilliseconds;
    _audioPlayer.seek(Duration(milliseconds: newPosition.round()));
  }
}
