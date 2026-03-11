import '../models/quiz_item.dart';

class QuizData {
  static const List<QuizItem> items = [
    QuizItem(
      id: 'q_1',
      question: 'Where did we first meet?',
      hindiQuestion: 'Hum pehli baar kahaan mile thhe?',
      options: ['Coffee Shop', 'Through Friends', 'Online/App', 'Work/School'],
      hindiOptions: [
        'Coffee Shop',
        'Friends ke through',
        'Online/App',
        'Work/School',
      ],
    ),
    QuizItem(
      id: 'q_2',
      question: 'What is my favorite movie genre?',
      hindiQuestion: 'Mera favorite movie genre kaun sa hai?',
      options: ['Action', 'Rom-Com', 'Horror', 'Sci-Fi'],
      hindiOptions: ['Action', 'Rom-Com', 'Horror', 'Sci-Fi'],
    ),
    QuizItem(
      id: 'q_3',
      question: 'Who said "I love you" first?',
      hindiQuestion: '"I love you" pehle kisne bola thha?',
      options: ['Me', 'You', 'We said it together', 'Not yet!'],
      hindiOptions: ['Maine', 'Aapne', 'Humne saath mein', 'Abhi tak nahi!'],
    ),
    QuizItem(
      id: 'q_4',
      question: 'What is my dream vacation destination?',
      hindiQuestion: 'Meri dream vacation destination kaun si hai?',
      options: ['Paris', 'Maldives', 'Tokyo', 'New York'],
      hindiOptions: ['Paris', 'Maldives', 'Tokyo', 'New York'],
    ),
    QuizItem(
      id: 'q_5',
      question: 'What is my go-to comfort food?',
      hindiQuestion: 'Mera favorite comfort food kya hai?',
      options: ['Pizza', 'Ice Cream', 'Tacos', 'Sushi'],
      hindiOptions: ['Pizza', 'Ice Cream', 'Tacos', 'Sushi'],
    ),
  ];
}
