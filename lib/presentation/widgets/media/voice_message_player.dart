import 'package:chat_flow/core/theme/colors.dart';
import 'package:chat_flow/presentation/widgets/spacing.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

/// Enhanced voice message player with waveform visualization
/// Features:
/// - Waveform visualization
/// - Playback speed control (1x, 1.5x, 2x)
/// - Seek functionality
/// - Duration display
/// - Pause/Resume
class VoiceMessagePlayer extends StatefulWidget {
  final String audioPath;
  final bool isSender;
  final Duration? duration;
  final VoidCallback? onPlaybackComplete;

  const VoiceMessagePlayer({
    super.key,
    required this.audioPath,
    this.isSender = false,
    this.duration,
    this.onPlaybackComplete,
  });

  @override
  State<VoiceMessagePlayer> createState() => _VoiceMessagePlayerState();
}

class _VoiceMessagePlayerState extends State<VoiceMessagePlayer> {
  late AudioPlayer _audioPlayer;
  bool _isPlaying = false;
  bool _isLoading = false;
  double _playbackSpeed = 1.0;
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    _audioPlayer = AudioPlayer();
    
    try {
      setState(() => _isLoading = true);
      
      // Set audio source
      await _audioPlayer.setFilePath(widget.audioPath);
      
      // Get duration
      _totalDuration = _audioPlayer.duration ?? widget.duration ?? Duration.zero;
      
      // Listen to player state
      _audioPlayer.playerStateStream.listen((state) {
        if (mounted) {
          setState(() {
            _isPlaying = state.playing;
          });
          
          if (state.processingState == ProcessingState.completed) {
            setState(() {
              _isPlaying = false;
              _currentPosition = Duration.zero;
            });
            widget.onPlaybackComplete?.call();
          }
        }
      });
      
      // Listen to position
      _audioPlayer.positionStream.listen((position) {
        if (mounted) {
          setState(() {
            _currentPosition = position;
          });
        }
      });
      
      setState(() => _isLoading = false);
    } catch (e) {
      setState(() => _isLoading = false);
      debugPrint('Error initializing audio player: $e');
    }
  }

  void _togglePlayPause() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play();
    }
  }

  void _changeSpeed() {
    setState(() {
      if (_playbackSpeed == 1.0) {
        _playbackSpeed = 1.5;
      } else if (_playbackSpeed == 1.5) {
        _playbackSpeed = 2.0;
      } else {
        _playbackSpeed = 1.0;
      }
    });
    _audioPlayer.setSpeed(_playbackSpeed);
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = widget.isSender 
        ? AppColors.primary.withValues(alpha: 0.1)
        : AppColors.greyText.withValues(alpha: 0.05);
    final iconColor = widget.isSender ? AppColors.primary : AppColors.greyText;

    return Container(
      padding: const .symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: .circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Play/Pause button
          InkWell(
            onTap: _isLoading ? null : _togglePlayPause,
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: iconColor,
                shape: BoxShape.circle,
              ),
              child: _isLoading
                  ? Center(
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      ),
                    )
                  : Icon(
                      _isPlaying ? Icons.pause : Icons.play_arrow,
                      color: Colors.white,
                      size: 20,
                    ),
            ),
          ),
          
          spacing(width: 12),
          
          // Waveform visualization
          Expanded(
            child: GestureDetector(
              onTapDown: (details) {
                if (!_isLoading && _totalDuration.inMilliseconds > 0) {
                  final box = context.findRenderObject() as RenderBox;
                  final localPosition = box.globalToLocal(details.globalPosition);
                  final percentage = (localPosition.dx - 60) / (box.size.width - 120);
                  final newPosition = _totalDuration * percentage.clamp(0.0, 1.0);
                  _audioPlayer.seek(newPosition);
                }
              },
              child: SizedBox(
                height: 36,
                child: CustomPaint(
                  painter: _WaveformPainter(
                    progress: _totalDuration.inMilliseconds > 0
                        ? _currentPosition.inMilliseconds / _totalDuration.inMilliseconds
                        : 0.0,
                    color: iconColor,
                    waveCount: 30,
                  ),
                ),
              ),
            ),
          ),
          
          spacing(width: 12),
          
          // Duration display
          Column(
            crossAxisAlignment: .end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _formatDuration(_isPlaying ? _currentPosition : _totalDuration),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: iconColor,
                ),
              ),
              
              // Speed control
              InkWell(
                onTap: _changeSpeed,
                child: Container(
                  padding: const .symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.1),
                    borderRadius: .circular(8),
                  ),
                  child: Text(
                    '${_playbackSpeed}x',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: iconColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Custom painter for waveform visualization
class _WaveformPainter extends CustomPainter {
  final double progress;
  final Color color;
  final int waveCount;

  _WaveformPainter({
    required this.progress,
    required this.color,
    this.waveCount = 30,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.3)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    final activePaint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    final barWidth = size.width / waveCount;
    final centerY = size.height / 2;

    for (int i = 0; i < waveCount; i++) {
      final x = i * barWidth + barWidth / 2;
      
      // Random height for waveform effect (in real app, use actual audio data)
      final heightFactor = (i % 3 == 0) ? 0.8 : (i % 2 == 0) ? 0.6 : 0.4;
      final barHeight = size.height * heightFactor;
      
      final isActive = (i / waveCount) <= progress;
      
      canvas.drawLine(
        Offset(x, centerY - barHeight / 2),
        Offset(x, centerY + barHeight / 2),
        isActive ? activePaint : paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _WaveformPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
