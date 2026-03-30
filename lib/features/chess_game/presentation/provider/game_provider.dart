import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;

class GameProvider extends ChangeNotifier {
  // Khởi tạo đối tượng Chess()
  final chess.Chess _game = chess.Chess();

  // Getters để UI truy cập dữ liệu
  chess.Chess get game => _game;
  String get fen => _game.fen;
  bool get isGameOver => _game.game_over;

  /// Thực hiện nước đi từ ô [from] đến ô [to]
  /// Trả về true nếu nước đi hợp lệ và thành công
  bool makeMove(String from, String to) {
    // Thư viện chess.move nhận vào một Map hoặc chuỗi SAN
    // Ở đây chúng ta dùng Map để kiểm soát chi tiết from/to
    final bool success = _game.move({
      'from': from,
      'to': to,
      'promotion': 'q', // Mặc định phong cấp lên Hậu (Queen) nếu có thể
    });

    if (success) {
      // Thông báo cho UI vẽ lại bàn cờ
      notifyListeners();
    } else {
      debugPrint('Nước đi không hợp lệ: $from -> $to');
    }

    return success;
  }

  /// Khởi động lại trò chơi
  void resetGame() {
    _game.reset();
    notifyListeners();
  }
}
