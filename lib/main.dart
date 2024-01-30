import 'package:digital_agenda/pages/components/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'pages/karsılama/hosgeldiniz_sayfasi.dart';

Future<void> main() async {
  runApp(const DijitalAjandaApp());
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('tr_TR', null);
}

class DijitalAjandaApp extends StatelessWidget {
  const DijitalAjandaApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dijital Ajanda',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          appBarTheme: const AppBarTheme(
            backgroundColor: ColorUtility.menuBarColor,
            toolbarHeight: 50,
          )),
      home: const HosgeldinizSayfasi(),
    );
  }
}
