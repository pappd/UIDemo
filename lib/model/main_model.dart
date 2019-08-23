import 'dart:math';

import 'package:scrolling_ui/model/transaction.dart';

class MainModel {
  double balance = 0;
  final transactions = <Transaction>[];
  final contacts = <String>[
    "Erick Eakins",
    "Laura Leader",
    "Kari Kibler",
    "Sonya Schmeltzer",
    "Alise Ahearn",
    "Tarah Tuggle",
    "Kanesha Kain",
    "Jewel Jacobsen",
    "Graham Gorelick",
    "Rose Rayl",
    "Hertha Hadlock",
    "Cliff Canale",
    "Aura Ashley",
    "Henrietta Hatfield",
    "Tona Thomson",
    "Chas Cooke",
    "Jeffry Jenkins",
    "Adele Almeda",
    "Reatha Rainbolt",
    "Cherilyn Camburn",
  ];

  void transferTo(int index, double amount, [DateTime date]) {
    transactions.add(Transaction(amount,
        name: contacts[index], date: date ?? DateTime.now()));
  }

  void createRandomTransactions([int number = 50]) {
    for (int i = 0; i < number; i++) {
      var random = Random();
      transferTo(
        random.nextInt(contacts.length - 1),
        random.nextDouble() * 500,
        DateTime(2019, 4, 29, 8).add(
          Duration(
            hours: random.nextInt(12),
            days: i,
          ),
        ),
      );
    }
  }

  void topUp(double amount) {
    transactions.add(
      Transaction(amount, date: DateTime.now()),
    );
  }
}
