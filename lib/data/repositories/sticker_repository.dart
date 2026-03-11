import '../models/sticker.dart';

class StickerRepository {
  static const List<Sticker> stickers = [
    Sticker(
      id: 'st_1',
      name: 'Curious Hearts',
      description: 'Completed your first dare.',
      icon: '💕',
      requiredScore: 10,
    ),
    Sticker(
      id: 'st_2',
      name: 'Spicy Duo',
      description: 'Completed 10 spicy dares.',
      icon: '🌶️',
      requiredScore: 100,
    ),
    Sticker(
      id: 'st_3',
      name: 'Kiss Master',
      description: 'Unlocked the power of the first kiss.',
      icon: '💋',
      requiredScore: 250,
    ),
    Sticker(
      id: 'st_4',
      name: 'Silk & Fire',
      description: 'A master of sensory play.',
      icon: '🔥',
      requiredScore: 500,
    ),
    Sticker(
      id: 'st_5',
      name: 'Midnight Lovers',
      description: 'Played after midnight for a week.',
      icon: '🌙',
      requiredScore: 750,
    ),
    Sticker(
      id: 'st_6',
      name: 'Elite Connection',
      description: 'Reached the 1000 point milestone.',
      icon: '👑',
      requiredScore: 1000,
    ),
    Sticker(
      id: 'st_7',
      name: 'Noir Legend',
      description: 'The ultimate intimate partnership.',
      icon: '🍷',
      requiredScore: 2500,
    ),
  ];
}
