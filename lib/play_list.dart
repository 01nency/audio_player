import 'package:assets_audio_player/assets_audio_player.dart';

class Playable {
  final String playlistName;
  final String image;
  final int id;

  Playable({required this.id, required this.playlistName, required this.image});

}
List<Playable> playmusic = [
  Playable(
    id: 1,
    playlistName: 'Party',
    image: "assets/party.jpg",
  ),
  Playable(
    id: 2,
    playlistName: 'Peace',
    image: "assets/meditation.jpg",
  ),
  Playable(
    id: 3,
    playlistName: 'Flutter Time',
    image: "assets/colors.jpg",
  ),
  Playable(
    id: 4,
    playlistName: 'Romance',
    image: "assets/love.jpg",
  ),
];