import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:play_audio/songs.dart';
import 'constants.dart';

class SongScreen extends StatefulWidget {
  const SongScreen({required this.player});
  final AssetsAudioPlayer player;
  @override
  State<SongScreen> createState() => _SongScreenState();
}

class _SongScreenState extends State<SongScreen> with TickerProviderStateMixin{
  AudioPlayer advplayer = AudioPlayer();
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  bool isPlaying = true;
  @override
  void initState() {
    // TODO: implement initState
    widget.player.isPlaying.listen((event) {
      if (mounted) {
        setState(() {
          isPlaying = event;
        });
      }
    });
    widget.player.onReadyToPlay.listen((newDuration) {
      if (mounted) {
        setState(() {
          duration = newDuration?.duration ?? Duration.zero;
        });
      }
    });
    widget.player.currentPosition.listen((newPosition) {
      if (mounted) {
        setState(() {
          position = newPosition;
        });
      }
    });
    super.initState();
  }
  void seekToSecond(int second) {
    Duration newDuration = Duration(seconds: second);
  }
  @override
    Widget build(BuildContext context) {
      Size size = MediaQuery
          .of(context)
          .size;
      return Scaffold(
        backgroundColor: color2,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          centerTitle: true,
          leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(
                Icons.keyboard_arrow_down,
                size: 30,
                color: Colors.white,
              )),
          title: Text(
            'Now Playing',
            style: TextStyle(
                fontSize: 15.0,
                color: Colors.white,
                fontWeight: FontWeight.w800),
          ),
          actions: [
            Icon(
              Icons.more_horiz,
              color: Colors.white,
            ),
            SizedBox(width: 10.0,)
          ],
        ),
        body: Container(
          decoration: BoxDecoration(
            color: normalcolor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(35.0),
              topRight: Radius.circular(35.0),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
                height: size.height * 0.5,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  image: DecorationImage(
                    image: AssetImage(widget.player.getCurrentAudioImage?.path ?? ''),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  children: [
                    Text(
                      widget.player.getCurrentAudioTitle,
                      style: TextStyle(
                          color: color1,
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold),
                    ),
                    Expanded(
                      child: Container(),
                    ),
                    Icon(
                      Icons.favorite,
                      color: favcolor,
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  widget.player.getCurrentAudioArtist,
                  style: TextStyle(
                      color: LightColor,
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                margin: EdgeInsetsDirectional.only(top: 10.0),
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                width: double.infinity,
                child: Slider(
                  value: position.inSeconds.toDouble(),
                  max: duration.inSeconds.toDouble(),
                  onChanged: (double value) {  setState(() {
                    seekToSecond(value.toInt());
                    value = value;
                  });},)
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  children: [
                    Text(
                    durationFormat(position),
                      style: TextStyle(
                          color: LightColor,
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold),
                    ),
                    Expanded(
                      child: Container(),
                    ),
                    Text(
                        durationFormat(duration - position),
                      style: TextStyle(
                          color: LightColor,
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10.0),
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(
                      Icons.playlist_add,
                      color: LightColor,
                      size: 0.09 * size.width,
                    ),
                    IconButton(
                      onPressed: () async {
                        await widget.player.previous();
                      },
                      icon: Icon(
                        Icons.skip_previous_rounded,
                        size: 0.12 * size.width,
                        color: color1,
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        await widget.player.playOrPause();
                      },
                      padding: EdgeInsets.zero,
                      icon: isPlaying
                          ?  Icon(
                        Icons.pause_circle_outline_outlined,
                        size: 0.18 * size.width,
                        color: color1,
                      )
                          : Icon(
                        Icons.play_circle_outline,
                        size: 0.18 * size.width,
                        color: color1,
                      ),
                    ),
                    IconButton(
                        onPressed: () async {
                          await widget.player.next();
                        },
                        icon:  Icon(
                          Icons.skip_next_rounded,
                          size: 0.12 * size.width,
                          color: color1,
                        ),
                    ),
                    Icon(
                      Icons.swap_horiz,
                      color: LightColor,
                      size: 0.09 * size.width,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
}

