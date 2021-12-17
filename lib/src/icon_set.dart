import 'package:flutter/material.dart';

class MyIcon {
  const MyIcon({required this.icon, required this.name});

  final IconData icon;
  final String name;
}

class MyIcons {
  static const MyIcon dining = MyIcon(icon: Icons.restaurant_menu, name: '飲食');
  static const MyIcon drink = MyIcon(icon: Icons.coffee, name: '飲料');
  static const MyIcon liquor = MyIcon(icon: Icons.liquor, name: '酒');
  static const MyIcon cloth = MyIcon(icon: Icons.checkroom, name: '服飾');
  static const MyIcon home = MyIcon(icon: Icons.house, name: '居家');
  static const MyIcon bus =
      MyIcon(icon: Icons.directions_bus_filled, name: '公車');
  static const MyIcon train = MyIcon(icon: Icons.train, name: '火車');
  static const MyIcon flight = MyIcon(icon: Icons.flight, name: '飛機');
  static const MyIcon school = MyIcon(icon: Icons.school, name: '教育');
  static const MyIcon pen = MyIcon(icon: Icons.edit, name: '文具');
  static const MyIcon movie = MyIcon(icon: Icons.movie, name: '電影');
  static const MyIcon music = MyIcon(icon: Icons.music_note, name: '音樂');
  static const MyIcon toys = MyIcon(icon: Icons.toys, name: '玩具');
  static const MyIcon map = MyIcon(icon: Icons.map, name: '地圖');
  static const MyIcon shopping = MyIcon(icon: Icons.shopping_cart, name: '購物');
  static const MyIcon sport = MyIcon(icon: Icons.fitness_center, name: '運動');
  static const MyIcon phone = MyIcon(icon: Icons.phone, name: '電話');
  static const MyIcon book = MyIcon(icon: Icons.menu_book, name: '書籍');
  static const MyIcon gift = MyIcon(icon: Icons.redeem, name: '禮物');
  static const MyIcon health = MyIcon(icon: Icons.local_hospital, name: '健康');
  static const MyIcon savings = MyIcon(icon: Icons.savings, name: '儲蓄');
  static const MyIcon bank = MyIcon(icon: Icons.account_balance, name: '銀行');
  static const MyIcon pets = MyIcon(icon: Icons.pets, name: '寵物');
  static const MyIcon paid = MyIcon(icon: Icons.paid, name: '支出');
  static const MyIcon favorite = MyIcon(icon: Icons.favorite, name: '愛心');
  static const MyIcon card = MyIcon(icon: Icons.credit_card, name: '信用卡');
  static const MyIcon star = MyIcon(icon: Icons.star_rate, name: '星星');
  static const MyIcon smile =
      MyIcon(icon: Icons.sentiment_very_satisfied, name: '笑臉');
  static const MyIcon palte = MyIcon(icon: Icons.color_lens, name: '繪畫');
  static const MyIcon landscape = MyIcon(icon: Icons.landscape, name: '風景');
  static const MyIcon face =
      MyIcon(icon: Icons.face_retouching_natural, name: '美容');
  static const MyIcon gas = MyIcon(icon: Icons.local_gas_station, name: '加油');
  static const MyIcon florist = MyIcon(icon: Icons.local_florist, name: '園藝');
  static const MyIcon parking = MyIcon(icon: Icons.local_parking, name: '停車');
  static const MyIcon boat = MyIcon(icon: Icons.directions_boat, name: '船隻');
  static const MyIcon fix = MyIcon(icon: Icons.hardware, name: '維修');
  static const MyIcon computer = MyIcon(icon: Icons.computer, name: '電腦');
  static const MyIcon child = MyIcon(icon: Icons.child_care, name: '育兒');

  static const List<MyIcon> icons = [
    dining,
    drink,
    liquor,
    cloth,
    home,
    bus,
    train,
    flight,
    school,
    pen,
    movie,
    music,
    toys,
    map,
    shopping,
    sport,
    phone,
    book,
    gift,
    health,
    savings,
    bank,
    pets,
    paid,
    favorite,
    card,
    star,
    smile,
    palte,
    landscape,
    face,
    gas,
    florist,
    parking,
    boat,
    fix,
    computer,
    child,
  ];
}
