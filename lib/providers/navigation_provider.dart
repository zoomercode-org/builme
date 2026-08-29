import 'package:flutter_riverpod/flutter_riverpod.dart';

final isAiDrawerOpenProvider = StateProvider<bool>((ref) => false);
final globalSearchQueryProvider = StateProvider<String>((ref) => '');
