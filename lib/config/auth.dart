import 'package:farel_123/app/models/user.dart';

Map<String, dynamic> authConfig = {
  'guards': {
    'default': {
      'provider': User(),
    }
  }
};
