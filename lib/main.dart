import 'package:flutter/material.dart';
import 'services/db_service.dart';
import 'screens/home_screen.dart';

void main() async {
  // Necessário para usar plugins nativos antes de runApp
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa a base de dados
  final dbService = DatabaseService();
  await dbService.database; // Isto vai criar a base de dados se não existir

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IPv4 Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
