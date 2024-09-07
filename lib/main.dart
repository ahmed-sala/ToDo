import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'Provider/app_provider.dart';
import 'Provider/taskProvider.dart';
import 'firebase_options.dart';
import 'home/home_screen.dart';
import 'my_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // FirebaseFirestore.instance.disableNetwork();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (BuildContext context) => AppProvider(),
      ),
      ChangeNotifierProvider(
        create: (BuildContext context) => TaskProvider(),
      ),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  late AppProvider provider;
  late TaskProvider taskProvider;
  @override
  Widget build(BuildContext context) {
    provider = Provider.of(context);
    taskProvider = Provider.of(context);
    return MaterialApp(
      locale: Locale(provider.currentLang),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routes: {
        HomeScreen.routeName: (_) => HomeScreen(),
        // EditTaskScreen.routeName: (_) => EditTaskScreen(),
      },
      initialRoute: HomeScreen.routeName,
      theme: MyTheme.lightTheme,
      themeMode: provider.currentTheme,
      darkTheme: MyTheme.darkTheme,
      debugShowCheckedModeBanner: false,
    );
  }
}
