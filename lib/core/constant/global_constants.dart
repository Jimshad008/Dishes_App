

import 'package:flutter_riverpod/flutter_riverpod.dart';

double width=0.0;
double height=0.0;
String? finalEmail;
final randomIndexProvider=StateProvider((ref) => 0);
final wishlistItems=StateProvider<List<String>>((ref) => []);