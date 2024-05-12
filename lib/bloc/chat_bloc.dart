import 'package:flutter_bloc/flutter_bloc.dart';

// Define the event for the ChatBloc
abstract class ChatEvent {}

class ChatMessageSent extends ChatEvent {
  final String message;

  ChatMessageSent(this.message);
}

class ChatMessageReceived extends ChatEvent {
  final String message;

  ChatMessageReceived(this.message);
}

class ChatBloc extends Bloc<ChatEvent, List<String>> {
  ChatBloc() : super([]);

  @override
  Stream<List<String>> mapEventToState(ChatEvent event) async* {
    if (event is ChatMessageSent) {
      yield [...state, event.message];
    } else if (event is ChatMessageReceived) {
      yield [...state, event.message];
    }
  }
}

