import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../firebase_auth_services.dart';

class AuthWidgetBuilder extends StatelessWidget {
  const AuthWidgetBuilder({Key? key, required this.builder}) : super(key: key);
  final Widget Function(
      BuildContext context, AsyncSnapshot<LoggedInUser?> isLoggedIn) builder;

  @override
  Widget build(BuildContext context) {
    final authService =
        Provider.of<FirebaseAuthService>(context, listen: false);
    return StreamBuilder<LoggedInUser?>(
        stream: authService.onAuthStateChanged,
        builder: (context, snapshot) {
          final user = snapshot.data;

          if (user != null) {
            return MultiProvider(providers: [
              Provider<LoggedInUser>.value(value: user),
            ], child: builder(context, snapshot));
          }
          return builder(context, snapshot);
        });
  }
}
