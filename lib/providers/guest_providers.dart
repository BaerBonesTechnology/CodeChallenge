
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_d_list/impl/guest_repository_impl.dart';
import 'package:the_d_list/repo/guest_repository.dart';

final guestListProvider = Provider<GuestRepository>(
    (ref){
      return GuestRepositoryImpl();
    }
);