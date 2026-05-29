import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/chat_repository.dart';

final chatRepositoryProvider = Provider<ChatRepository>((ref) => ChatRepository());

final chatHistoryProvider = FutureProvider.family<List<dynamic>, int>(
  (ref, consultationId) async {
    final repo = ref.watch(chatRepositoryProvider);
    return await repo.getChatHistory(consultationId);
  },
);

final sendChatMessageProvider = FutureProvider.family<dynamic, ({int consultationId, String content})>(
  (ref, params) async {
    final repo = ref.watch(chatRepositoryProvider);
    return await repo.sendChatMessage(params.consultationId, params.content);
  },
);