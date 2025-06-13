import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import '../models/score.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  static Database? _database;

  factory DatabaseService() => _instance;

  DatabaseService._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    // Obtém o diretório de documentos
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "ipv4_game.db");

    // Verifica se o banco de dados já existe
    bool exists = await databaseExists(path);

    if (!exists) {
      // Copia da pasta assets
      try {
        ByteData data =
            await rootBundle.load(join("assets", "database", "ipv4_game.db"));
        List<int> bytes =
            data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
        await File(path).writeAsBytes(bytes, flush: true);
      } catch (e) {
        print("Error copying database: $e");
      }
    }

    // Abre o banco de dados
    return await openDatabase(
      path,
      version: 1,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Tabela para o score atual
    await db.execute('''
      CREATE TABLE current_score(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        value INTEGER NOT NULL,
        timestamp TEXT NOT NULL
      )
    ''');

    // Tabela para o ranking (top 5)
    await db.execute('''
      CREATE TABLE ranking(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        value INTEGER NOT NULL,
        timestamp TEXT NOT NULL
      )
    ''');

    // Inicializa o score atual com 0
    await db.insert('current_score', {
      'value': 0,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  // Atualiza o score atual
  Future<void> updateCurrentScore(int newScore) async {
    final db = await database;
    await db.update(
      'current_score',
      {
        'value': newScore,
        'timestamp': DateTime.now().toIso8601String(),
      },
      where: 'id = 1',
    );
  }

  // Obtém o score atual
  Future<Score?> getCurrentScore() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('current_score');

    if (maps.isEmpty) return null;

    return Score.fromMap(maps.first);
  }

  // Adiciona um novo score ao ranking
  Future<void> addToRanking(Score score) async {
    final db = await database;

    // Insere o novo score
    await db.insert('ranking', score.toMap());

    // Obtém todos os scores ordenados
    final List<Map<String, dynamic>> allScores = await db.query(
      'ranking',
      orderBy: 'value DESC',
    );

    // Se houver mais de 5 scores, remove os piores
    if (allScores.length > 5) {
      final idsToDelete =
          allScores.skip(5).map((score) => score['id'] as int).toList();

      for (var id in idsToDelete) {
        await db.delete(
          'ranking',
          where: 'id = ?',
          whereArgs: [id],
        );
      }
    }
  }

  // Obtém o top 5 scores
  Future<List<Score>> getTopScores() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'ranking',
      orderBy: 'value DESC',
      limit: 5,
    );

    return List.generate(maps.length, (i) => Score.fromMap(maps[i]));
  }

  // Reseta o score atual para 0
  Future<void> resetCurrentScore() async {
    final db = await database;
    await db.update(
      'current_score',
      {
        'value': 0,
        'timestamp': DateTime.now().toIso8601String(),
      },
      where: 'id = 1',
    );
  }
}
