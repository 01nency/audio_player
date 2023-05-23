import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';

List<Audio> songs = [
  Audio('assets/music/ambarse toda.mp3',
      metas: Metas(
          title: 'Ambar se Toda',
          image: MetasImage.asset("assets/ambar.jpg"),
          artist: 'Raag Patel')),
  Audio('assets/music/apna bana le.mp3',
      metas: Metas(
          title: 'Apna Banale Piya',
          image: MetasImage.asset("assets/apna.jpg"),
          artist: 'Arijit Singh and \nsachin-jigar'),
  ),
  Audio('assets/music/chitta.mp3',
      metas: Metas(
          title: 'Chitta',
          image: MetasImage.asset("assets/chitta.jpg"),
          artist: 'Manan Bhardwaj')),
  Audio('assets/music/de tali.mp3',
      metas: Metas(
          title: 'De Taali',
          image: MetasImage.asset("assets/tali.jpg"),
          artist: 'Armaan Malik, Shashwat Singh and Yo Yo Honey Singh')),
  Audio('assets/music/heer ranjhah.mp3',
      metas: Metas(
          title: 'Heer Ranjhah',
          image: MetasImage.asset("assets/ranjhah.jpg"),
          artist: 'Rajat Nagpal, Rana Sotal, and Rito Riba')),
  Audio('assets/music/tujhse naraz.mp3',
      metas: Metas(
          title: 'Tujhse Naraz Nahi Dil',
          image: MetasImage.asset("assets/naraz.jpg"),
          artist: 'Pallak Ranka')),
];
String durationFormat(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, '0');
  String twoDigitsMinutes = twoDigits(duration.inMinutes.remainder(60));
  String twoDigitsSeconds = twoDigits(duration.inSeconds.remainder(60));
  return '$twoDigitsMinutes:$twoDigitsSeconds';
}

Future<PaletteGenerator> getImageColor(AssetsAudioPlayer player) async {
  var paletteGenerator = await PaletteGenerator.fromImageProvider(
      AssetImage(player.getCurrentAudioImage?.path ?? ''));
  return paletteGenerator;
}
