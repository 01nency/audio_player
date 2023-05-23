import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:carousel_indicator/carousel_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:play_audio/play_list.dart';
import 'package:play_audio/songs.dart';
import 'package:assets_audio_player/src/playable.dart';
import 'package:play_audio/songscreen.dart';
import 'constants.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin{
  final player = AssetsAudioPlayer();
  int currentPos = 0;
  bool isPlaying = true;
  late final AnimationController _animationController =
  AnimationController(vsync: this, duration: Duration(seconds: 3));
  @override
  void initState() {
    openPlayer();
    player.isPlaying.listen((event) {
      if (mounted) {
        setState(() {
          isPlaying = event;
        });
      }
    });
    super.initState();
  }

  void openPlayer() async {
    await player.open(Playlist(audios: songs),
        autoStart: false, showNotification: true, loopMode: LoopMode.playlist);
  }
  int _selectedIndex = 0;
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: normalcolor,
      appBar: AppBar(
        title: Text(
          'Discover',
          style: Theme.of(context)
              .textTheme
              .headline4!
              .copyWith(fontWeight: FontWeight.bold, color: color1),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Icon(
              Icons.account_circle,
              color: color1,
              size: 30,
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Container(
            height: size.height * 0.72,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [_buildNavigationRail(), _buildPlaylistAndSongs(size)],
            ),
          ),
          _buildCurrentPlayingSong(size),
        ],
      ),
    );
  }

  Widget _buildCurrentPlayingSong(Size size) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            CupertinoPageRoute(
                fullscreenDialog: true,
                builder: (context) => SongScreen(
                  player: player,
                ),),);
      },
      child: Container(
        height: size.height * 0.100,
        padding: EdgeInsets.symmetric(horizontal: 40.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            Color(0xff0968B0),
            Color(0xFFFF0000),
          ]),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(50.0),
                topRight: Radius.circular(50.0),),),
        child: Row(
          children: [
            CircleAvatar(
                radius: 25,
                backgroundColor: Colors.grey,
                backgroundImage: AssetImage(
                    player.getCurrentAudioImage?.path ?? ''),),
            SizedBox(
              width: 10.0,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                player.getCurrentAudioTitle,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15),
                ),
                Container(
                  width: size.width * 0.40,
                  child: Text(
                    player.getCurrentAudioArtist,maxLines: 1,overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                )
              ],
            ),
            Expanded(
              child: Container(),
            ),
            Icon(
              Icons.favorite_border,
              color: Colors.white,
            ),
            SizedBox(width: 10.0),
            Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                  borderRadius: BorderRadiusDirectional.circular(10.0),
                  color: Colors.white),
              child:  Center(
                child: IconButton(
                  onPressed: () async {
                    await player.playOrPause();
                  },
                  padding: EdgeInsets.zero,
                  icon: isPlaying
                      ? const Icon(
                    Icons.pause_circle_outline_outlined,
                    color: color1,
                  )
                      : const Icon(
                    Icons.play_circle_outline,
                    color: color1,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationRail() {
    return NavigationRail(
      minWidth: 56.0,
      selectedIndex: _selectedIndex,
      onDestinationSelected: (int index) {
        setState(() {
          _selectedIndex = index;
        });
      },
      groupAlignment: -0.1,
      labelType: NavigationRailLabelType.all,
      selectedLabelTextStyle:
      TextStyle(color: color1, fontWeight: FontWeight.bold),
      unselectedLabelTextStyle:
      TextStyle(color: LightColor, fontWeight: FontWeight.bold),
      leading: Column(
        children: [
          Icon(
            Icons.playlist_play,
            color: color1,
          ),
          SizedBox(height: 5.0),
          RotatedBox(
            quarterTurns: -1,
            child: Text(
              'Your playlists',
              style:
              TextStyle(color: color1, fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
      destinations: [
        NavigationRailDestination(
          icon: SizedBox.shrink(),
          label: RotatedBox(
            quarterTurns: -1,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Recent'),
            ),
          ),
        ),
        NavigationRailDestination(
          icon: SizedBox.shrink(),
          label: RotatedBox(
            quarterTurns: -1,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Like'),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildPlaylistAndSongs(Size size) {
    return Column(
      children: [
        Column(
          children: [
            Container(
              height: 0.26 * size.height,
              width: size.width * 0.8,
              child: CarouselSlider.builder(
                options: CarouselOptions(
                    enlargeCenterPage: true,
                  onPageChanged: (index, reason) {
                    setState(() {
                      currentPos = index;
                    });
                  }
                ),
                itemCount: playmusic.length,
                itemBuilder: (context, index , realIndex) => _buildPlaylistItem(
                    image: playmusic[index].image,
                    title: playmusic[index].playlistName,
                ),
              ),
            ),
            CarouselIndicator(
              color: color1,
              activeColor: Colors.red,
              count: playmusic.length,
              index: currentPos,
            ),
            SizedBox(height: 20,)
          ],
        ),
        Container(
          height: 0.41 * size.height,
          width: size.width * 0.8,
          child: ListView.builder(
            itemCount: songs.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(top: 10),
                child: ListTile(
                  title: Text(
                    songs[index].metas.title!,
                    style: TextStyle(color: color1),
                  ),
                  subtitle: Text(
                    songs[index].metas.artist!,
                    style: TextStyle(color: color2),
                  ),
                  leading: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                        image: DecorationImage(image: AssetImage(songs[index].metas.image!.path), fit: BoxFit.fill),
                        borderRadius: BorderRadius.circular(10.0)),
                  ),
                  onTap: () async {
                    await player.playlistPlayAtIndex(index);
                    setState(() {
                      player.getCurrentAudioImage;
                      player.getCurrentAudioTitle;
                    });
                  },
                ),
              );
            },
          ),
        )
      ],
    );
  }

  Widget _buildPlaylistItem({required String title, required String image}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
      width: 220,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: Colors.orange,
          image: DecorationImage(image: AssetImage(image), fit: BoxFit.fill)),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                title,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
            ),
            Expanded(child: Container(height: 0)),
            Container(
              height: 30,
              width: 30,
              margin: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.white),
              child: Icon(
                Icons.play_circle_outline,
                color: color1,
              ),
            )
          ],
        ),
      ),
    );
  }
}