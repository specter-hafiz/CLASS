import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:logger/logger.dart';

class NetworkConnectivity {
  final logger = Logger();
  NetworkConnectivity() {
    logger.i('NetworkConnectivity initialized');
  }

  final Connectivity _connectivity = Connectivity();

  /// Checks the current connectivity status
  Future<bool> get isConnected async {
    final result = await _connectivity.checkConnectivity();
    return !result.contains(ConnectivityResult.none);
  }

  /// Provides a stream to listen to connectivity changes
  Stream<bool> get onConnectivityChanged async* {
    yield* _connectivity.onConnectivityChanged.map(
      (List<ConnectivityResult> results) =>
          results.any((result) => result != ConnectivityResult.none),
    );
  }
}
