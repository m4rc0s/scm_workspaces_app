import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/sse.dart';


final notificationProvider = StreamProvider<String>((ref) async* {
  final notificationChannel = Sse.connect(
    uri: Uri.parse('http://localhost:3333/scm-events'),
    closeOnError: true,
    withCredentials: false,
  );

  // Parse the value received and emit a Message instance
  await for (final value in notificationChannel.stream) {
    yield value.toString();
  }
}

);