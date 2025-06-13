import 'dart:math';
import '../models/question.dart';

class QuestionGenerator {
  final Random _random = Random();

  Question generateQuestion(int difficulty) {
    switch (difficulty) {
      case 1:
        return _generateLevel1Question();
      case 2:
        return _generateLevel2Question();
      case 3:
        return _generateLevel3Question();
      default:
        throw Exception('Invalid difficulty level');
    }
  }

  Question _generateLevel1Question() {
    // Gera um IP aleatório
    final ip = _generateRandomIP();
    final mask =
        _random.nextInt(3) == 0 ? 8 : (_random.nextInt(2) == 0 ? 16 : 24);

    // Decide se pergunta sobre Network ID ou Broadcast
    final isNetworkID = _random.nextBool();

    String question;
    String correctAnswer;

    if (isNetworkID) {
      question = 'Qual é o Network ID do endereço $ip/$mask?';
      correctAnswer = _calculateNetworkID(ip, mask);
    } else {
      question = 'Qual é o endereço de Broadcast do endereço $ip/$mask?';
      correctAnswer = _calculateBroadcast(ip, mask);
    }

    // Gera opções incorretas
    final options = _generateWrongOptions(correctAnswer);
    options.add(correctAnswer);
    options.shuffle();

    return Question(
      question: question,
      options: options,
      correctAnswer: correctAnswer,
      difficulty: 1,
    );
  }

  Question _generateLevel2Question() {
    // Gera um IP aleatório
    final ip = _generateRandomIP();
    final subnetMask = '255.255.255.192'; // /26

    String question =
        'Quantas sub-redes podem ser criadas com a máscara $subnetMask?';
    String correctAnswer = '4';

    // Gera opções incorretas
    final options = ['2', '6', '8', '4'];
    options.shuffle();

    return Question(
      question: question,
      options: options,
      correctAnswer: correctAnswer,
      difficulty: 2,
    );
  }

  Question _generateLevel3Question() {
    // Gera um IP aleatório
    final ip = _generateRandomIP();
    final supernetMask = '255.255.248.0'; // /21

    String question =
        'Quantos endereços IP podem ser endereçados com a máscara $supernetMask?';
    String correctAnswer = '2048';

    // Gera opções incorretas
    final options = ['1024', '4096', '512', '2048'];
    options.shuffle();

    return Question(
      question: question,
      options: options,
      correctAnswer: correctAnswer,
      difficulty: 3,
    );
  }

  String _generateRandomIP() {
    return '${_random.nextInt(256)}.${_random.nextInt(256)}.${_random.nextInt(256)}.${_random.nextInt(256)}';
  }

  String _calculateNetworkID(String ip, int mask) {
    final parts = ip.split('.').map(int.parse).toList();
    final binary =
        parts.map((e) => e.toRadixString(2).padLeft(8, '0')).join('');
    final networkPart = binary.substring(0, mask).padRight(32, '0');

    return _binaryToIP(networkPart);
  }

  String _calculateBroadcast(String ip, int mask) {
    final parts = ip.split('.').map(int.parse).toList();
    final binary =
        parts.map((e) => e.toRadixString(2).padLeft(8, '0')).join('');
    final broadcastPart = binary.substring(0, mask).padRight(32, '1');

    return _binaryToIP(broadcastPart);
  }

  String _binaryToIP(String binary) {
    final octets = <String>[];
    for (var i = 0; i < 4; i++) {
      final octet = binary.substring(i * 8, (i + 1) * 8);
      octets.add(int.parse(octet, radix: 2).toString());
    }
    return octets.join('.');
  }

  List<String> _generateWrongOptions(String correctAnswer) {
    final options = <String>[];
    final correctParts = correctAnswer.split('.').map(int.parse).toList();

    while (options.length < 3) {
      final wrongIP = correctParts.map((part) {
        final variation = _random.nextInt(3) - 1; // -1, 0, or 1
        return ((part + variation) % 256).toString();
      }).join('.');

      if (wrongIP != correctAnswer && !options.contains(wrongIP)) {
        options.add(wrongIP);
      }
    }

    return options;
  }
}
