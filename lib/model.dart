
import 'dart:convert';

class Tweet {
  final int id;
  String text;
  List emoji;

  Tweet ({required this.id, required this.text, required this.emoji });

  Map<String, dynamic> toMap(){
    return {
      'id' : id,
      'text_tweet': text,
      'emoji': emoji.isNotEmpty ? json.encode(emoji) : '',
    };
  }
}

List<Tweet> listTweets = [
  Tweet(id: 0, text: 'Я был здесь!', emoji: []),
  Tweet(id: 1, text: "Osmanthus wine tastes the same as I remember... But where are those who share the memory?", emoji: ['\u{1F60E}','\u{1F602}',]),
  Tweet(id: 2, text: 'Контракт не может определить границы дружбы, не может исчислить её в какой-либо величине...', emoji: []),
  Tweet(id: 3, text: 'Тестовый текст для проерки корректности кода', emoji: []),
  Tweet(id: 4, text: 'Добавить любую эмодзи?', emoji: []),
  Tweet(id: 5, text: '... Если чего-то хочешь по-настоящему, рано или поздно получишь.', emoji: ['\u{1F62D}',]),
];