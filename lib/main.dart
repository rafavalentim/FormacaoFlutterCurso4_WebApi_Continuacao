import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'models/journal.dart';
import 'screens/add_journal_screen/add_journal_screen.dart';
import 'screens/home_screen/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Journal',
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.light,
      theme: ThemeData(
        primarySwatch: Colors.grey,
        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: Colors.black,
          titleTextStyle: TextStyle(color: Colors.white),
          actionsIconTheme: IconThemeData(color: Colors.white),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        textTheme: GoogleFonts.bitterTextTheme(),
      ),
      initialRoute: "home",
      routes: {
        "home": (context) => const HomeScreen(),
      },
      onGenerateRoute: (routeSettings) {
        if (routeSettings.name == "add-journal") {
          Map<String, dynamic> map = routeSettings.arguments as Map<String, dynamic>; //Receber parâmetros e enviar para outra tela.
          final Journal journal = map["journal"] as Journal;
          final bool isEditing = map["is_editing"];
          return MaterialPageRoute(
            builder: (context) {
              return AddJournalScreen(journal: journal, isEditing: isEditing,);
            },
          );
        }
        return null;
      },
    );
  }
}
