import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/guest.dart';

final StateProvider<List<Guest>> tempGroupListProvider = StateProvider((ref) => []);
final StateProvider<bool> tempReservedProvider = StateProvider((ref) => false);