import 'package:audio_waveforms/audio_waveforms.dart';

/// Manages audio playback across the chat application.
///
/// Ensures only one voice message is playing at a time and provides
/// utilities for controlling audio playback state.
class AudioManager {
  AudioManager._();

  static final AudioManager _instance = AudioManager._();

  /// Gets the singleton instance of AudioManager.
  static AudioManager get instance => _instance;

  /// Holds the currently playing voice message controller (if any).
  ///
  /// Used to ensure only one voice note is playing/active across the chat,
  /// and to allow stopping playback when starting a recording.
  PlayerController? _currentlyPlayingController;

  /// Gets the currently playing controller, if any.
  PlayerController? get currentlyPlayingController =>
      _currentlyPlayingController;

  /// Starts playing audio with the given controller.
  ///
  /// If another audio is already playing, it will be paused and reset
  /// to the start position before starting the new audio.
  ///
  /// [controller] - The PlayerController to start playing.
  void startPlaying(PlayerController controller) {
    final previousController = _currentlyPlayingController;

    /// If another audio is already playing, stop it first.
    if (previousController != null &&
        !identical(previousController, controller)) {
      previousController.pausePlayer();

      /// Ensure it is reset to start position for next play.
      previousController.seekTo(0);
    }

    _currentlyPlayingController = controller;
    controller.startPlayer();
    controller.setFinishMode(finishMode: FinishMode.pause);
  }

  /// Pauses the currently playing audio.
  ///
  /// [controller] - The PlayerController to pause.
  void pausePlaying(PlayerController controller) {
    controller.pausePlayer();
    if (identical(_currentlyPlayingController, controller)) {
      _currentlyPlayingController = null;
    }
  }

  /// Stops all audio playback.
  ///
  /// This is useful when starting a recording or when needing to
  /// ensure no audio is playing.
  void stopAllPlayback() {
    final controller = _currentlyPlayingController;
    if (controller != null) {
      controller.pausePlayer();
      _currentlyPlayingController = null;
    }
  }

  /// Clears the currently playing controller reference.
  ///
  /// Should be called when a controller is disposed to prevent
  /// holding references to disposed controllers.
  ///
  /// [controller] - The PlayerController being disposed.
  void clearController(PlayerController controller) {
    if (identical(_currentlyPlayingController, controller)) {
      _currentlyPlayingController = null;
    }
  }

  /// Checks if the given controller is currently playing.
  ///
  /// [controller] - The PlayerController to check.
  /// Returns true if the controller is the currently playing one.
  bool isCurrentlyPlaying(PlayerController controller) {
    return identical(_currentlyPlayingController, controller);
  }
}
