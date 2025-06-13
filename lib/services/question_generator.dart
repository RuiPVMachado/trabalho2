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
    // Gera uma máscara de sub-rede aleatória entre /25 e /28
    final maskBits = _random.nextInt(4) + 25; // 25, 26, 27 ou 28
    final subnetMask = _calculateSubnetMask(maskBits);
    final numSubnets =
        pow(2, maskBits - 24).toInt(); // Número de sub-redes possíveis

    String question =
        'Quantas sub-redes podem ser criadas com a máscara $subnetMask para a rede $ip?';
    String correctAnswer = numSubnets.toString();

    // Gera opções incorretas
    final options = [
      (numSubnets ~/ 2).toString(),
      (numSubnets * 2).toString(),
      (numSubnets + 2).toString(),
      correctAnswer
    ];
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
    // Gera uma máscara de superrede aleatória entre /16 e /20
    final maskBits = _random.nextInt(5) + 16; // 16, 17, 18, 19 ou 20
    final supernetMask = _calculateSubnetMask(maskBits);
    final numHosts = pow(2, 32 - maskBits).toInt(); // Número de hosts possíveis

    String question =
        'Quantos endereços IP podem ser endereçados com a máscara $supernetMask para a rede $ip?';
    String correctAnswer = numHosts.toString();

    // Gera opções incorretas
    final options = [
      (numHosts ~/ 2).toString(),
      (numHosts * 2).toString(),
      (numHosts ~/ 4).toString(),
      correctAnswer
    ];
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

  String _calculateSubnetMask(int bits) {
    if (bits < 0 || bits > 32) throw Exception('Invalid mask bits');

    final fullMask = ('1' * bits).padRight(32, '0');
    return _binaryToIP(fullMask);
  }
}
