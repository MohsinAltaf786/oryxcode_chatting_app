import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:chat_flow/core/theme/colors.dart';
import 'package:chat_flow/presentation/widgets/spacing.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

/// Audio player widget for voice messages and audio files in chat
class AudioPlayerWidget extends StatefulWidget {
  final String audioUrl;
  final bool isIncoming;
  final String? duration;

  const AudioPlayerWidget({
    super.key,
    required this.audioUrl,
    required this.isIncoming,
    this.duration,
  });

  @override
  State<AudioPlayerWidget> createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget>
    with SingleTickerProviderStateMixin {
  late AudioPlayer _audioPlayer;
  bool _isPlaying = false;
  bool _isLoading = false;
  bool _hasError = false;
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;

  late AnimationController _playPauseController;

  bool get _isDark => Theme.of(context).brightness == Brightness.dark;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _playPauseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _setupAudioPlayer();
  }

  Future<void> _setupAudioPlayer() async {
    try {
      _audioPlayer.playerStateStream.listen((state) {
        if (mounted) {
          setState(() {
            _isPlaying = state.playing;
            _isLoading = state.processingState == ProcessingState.loading ||
                state.processingState == ProcessingState.buffering;
          });

          if (state.playing) {
            _playPauseController.forward();
          } else {
            _playPauseController.reverse();
          }

          if (state.processingState == ProcessingState.completed) {
            _audioPlayer.seek(Duration.zero);
            _audioPlayer.pause();
          }
        }
      });

      _audioPlayer.positionStream.listen((position) {
        if (mounted) {
          setState(() {
            _currentPosition = position;
          });
        }
      });

      _audioPlayer.durationStream.listen((duration) {
        if (mounted && duration != null) {
          setState(() {
            _totalDuration = duration;
          });
        }
      });

      await _audioPlayer.setUrl(widget.audioUrl);
    } catch (e) {
      debugPrint('Error setting up audio player: $e');
      if (mounted) {
        setState(() {
          _hasError = true;
        });
      }
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _playPauseController.dispose();
    super.dispose();
  }

  Future<void> _togglePlayPause() async {
    try {
      if (_isPlaying) {
        await _audioPlayer.pause();
      } else {
        await _audioPlayer.play();
      }
    } catch (e) {
      debugPrint('Error toggling play/pause: $e');
      if (mounted) {
        setState(() {
          _hasError = true;
        });
      }
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds.remainder(60);
    return '${twoDigits(minutes)}:${twoDigits(seconds)}';
  }

  @override
  Widget build(BuildContext context) {
    final Color bubbleColor = widget.isIncoming
        ? (_isDark ? AppColors.grey90 : AppColors.grey20)
        : AppColors.primary;
    final Color accentColor =
        widget.isIncoming ? AppColors.primary : Colors.white;
    final Color textColor = widget.isIncoming
        ? (_isDark ? AppColors.light80 : AppColors.darkText)
        : Colors.white;

    if (_hasError) {
      return _buildErrorWidget(bubbleColor, accentColor, textColor);
    }

    return Container(
      width: 260,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bubbleColor,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(18),
          topRight: const Radius.circular(18),
          bottomLeft: Radius.circular(widget.isIncoming ? 4 : 18),
          bottomRight: Radius.circular(widget.isIncoming ? 18 : 4),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildPlayButton(accentColor),
          spacing(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildProgressBar(accentColor),
                spacing(height: 6),
                _buildTimeDisplay(textColor),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayButton(Color accentColor) {
    return GestureDetector(
      onTap: _togglePlayPause,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          gradient: widget.isIncoming
              ? LinearGradient(
                  colors: [accentColor, accentColor.withValues(alpha: 0.8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: widget.isIncoming ? null : Colors.white.withValues(alpha: 0.2),
          shape: BoxShape.circle,
          boxShadow: widget.isIncoming
              ? [
                  BoxShadow(
                    color: accentColor.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: _isLoading
            ? Padding(
                padding: const EdgeInsets.all(12),
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: widget.isIncoming ? Colors.white : Colors.white,
                ),
              )
            : Icon(
                _isPlaying
                    ? TablerIcons.player_pause_filled
                    : TablerIcons.player_play_filled,
                color: widget.isIncoming ? Colors.white : Colors.white,
                size: 22,
              ),
      ),
    );
  }

  Widget _buildProgressBar(Color accentColor) {
    final double progress = _totalDuration.inMilliseconds > 0
        ? _currentPosition.inMilliseconds / _totalDuration.inMilliseconds
        : 0.0;

    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        trackHeight: 4,
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
        overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
        activeTrackColor: accentColor,
        inactiveTrackColor: accentColor.withValues(alpha: 0.3),
        thumbColor: accentColor,
        overlayColor: accentColor.withValues(alpha: 0.2),
      ),
      child: Slider(
        value: progress,
        onChanged: (value) {
          final Duration newPosition = Duration(
            milliseconds: (_totalDuration.inMilliseconds * value).toInt(),
          );
          _audioPlayer.seek(newPosition);
        },
      ),
    );
  }

  Widget _buildTimeDisplay(Color textColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          _formatDuration(_currentPosition),
          style: TextStyle(
            color: textColor.withValues(alpha: 0.7),
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              TablerIcons.microphone,
              size: 12,
              color: textColor.withValues(alpha: 0.5),
            ),
            spacing(width: 4),
            Text(
              _totalDuration.inSeconds > 0
                  ? _formatDuration(_totalDuration)
                  : widget.duration ?? '0:00',
              style: TextStyle(
                color: textColor.withValues(alpha: 0.7),
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildErrorWidget(Color bubbleColor, Color accentColor, Color textColor) {
    return Container(
      width: 260,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: bubbleColor,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(18),
          topRight: const Radius.circular(18),
          bottomLeft: Radius.circular(widget.isIncoming ? 4 : 18),
          bottomRight: Radius.circular(widget.isIncoming ? 18 : 4),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.red.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              TablerIcons.alert_circle,
              color: Colors.red,
              size: 24,
            ),
          ),
          spacing(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Failed to load audio',
                  style: TextStyle(
                    color: textColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                spacing(height: 4),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _hasError = false;
                    });
                    _setupAudioPlayer();
                  },
                  child: Text(
                    'Tap to retry',
                    style: TextStyle(
                      color: accentColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
