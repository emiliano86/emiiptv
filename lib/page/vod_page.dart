


import 'package:emiiptv/models/m3u.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../service/network.dart';
import 'Link_page.dart';
import 'SearchPage.dart';
import 'lettore_video.dart';

late YoutubePlayerController _controller;
class VodPage extends StatefulWidget {
  VodPage({ required this.nome});
  final nome;



  @override
  State<VodPage> createState() => _VodPageState();
}
class _VodPageState extends State<VodPage> {
  late PlayerState _playerState;
  late YoutubeMetaData _videoMetaData;
  double _volume = 100;
  bool _muted = false;
  bool _isPlayerReady = false;


  List grupmovie=[];
 String url="y1ZGQuUMUX4";


  @override
  void initState() {
    super.initState();

    _controller = YoutubePlayerController(
      initialVideoId: url,
      flags: const YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
        disableDragSeek: false,
        loop: true,
        isLive: false,
        forceHD: false,
        enableCaption: true,
      ),
    )..addListener(listener);
    _videoMetaData = const YoutubeMetaData();
    _playerState = PlayerState.unknown;

  }
void listener() {
  if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
    setState(() {
      _playerState = _controller.value.playerState;
      _videoMetaData = _controller.metadata;
    });
  }
}



  @override
  Widget build(BuildContext context) {
    TextEditingController searchTextEditController = TextEditingController();
    final ButtonStyle style=ButtonStyle(
      shadowColor: MaterialStateProperty.resolveWith((states) {
        // If the button is pressed, return green, otherwise blue
        if (states.contains(MaterialState.pressed)) {
          return Colors.green;
        }
        return Colors.blue;
      }),
      backgroundColor: MaterialStateProperty.resolveWith((states) {
        // If the button is pressed, return green, otherwise blue
        if (states.contains(MaterialState.pressed)) {
          return Colors.green;
        }
        return Colors.blue;
      }),
      textStyle: MaterialStateProperty.resolveWith((states) {
        // If the button is pressed, return size 40, otherwise 20
        if (states.contains(MaterialState.pressed)) {
          return const TextStyle(fontSize: 40,color: Colors.black);
        }
        return const TextStyle(fontSize: 20,color: Colors.black);
      }),
    );










    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,

      ),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: FutureBuilder(
          future:fetchVod(widget.nome),

          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {

            if(snapshot.hasData){

              return Container(
                height: 700,
                child:Column(

                  children: [
                    Expanded(child:Container(
                      width: 700,
                    height: 750,
                    child: AspectRatio(
                      aspectRatio: 16 / 9,
                      child:YoutubePlayer(
                        controller: _controller,
                        showVideoProgressIndicator: false,
                        progressIndicatorColor: Colors.blueAccent,
                      )
                    ),),
                ),

                    IconButton(
                        focusColor: Colors.cyan,
                        hoverColor: Colors.red,
                        color: Colors.white,
                        onPressed: ()=>Navigator.push(context,
                            MaterialPageRoute(builder: (context) => SearchPage(grup: grupVod,))),
                        icon: const Icon(Icons.search_rounded)),
                    Expanded(
                      child: ListView.builder(
                          itemCount: grupVod.length,
                          itemBuilder: (context,index){
                            var nome=grupVod[index].title.replaceAll(RegExp(r'[^a-zA-Z]'), "");




                          




                            final String publicUrl = supabase
                                .storage
                                .from('film')
                                .getPublicUrl("$nome.jpg");


                            return Row(
                              children: [
                                Expanded(
                                  child: InkWell(

                                    focusColor:Colors.tealAccent,

                                    onFocusChange: (hasfocus)async{
                                      final trailerurl =await supabase
                                          .from('trailer')
                                          .select('idtrailer')
                                          .eq('nametv', nome);
                                     if(hasfocus) {
                                     url=trailerurl[0]["idtrailer"];
                                       _controller.load(url);

                                         }
                                       },













                                    onTap:() {

                                      Navigator.push(context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  LettoreVideoPage(
                                                      grupVod[index]
                                                          .link,grupVod)));

                                    },
                                    child: Container(
                                      height: 400,
                                      decoration: BoxDecoration(image: DecorationImage(
                                        image: NetworkImage(publicUrl,
                                          scale: 1,
                                        ),
                                      )),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10,),
                                Expanded(
                                  child:  ElevatedButton(

                                      onFocusChange: (hasfocus)async{
                                        final trailerurl =await supabase
                                            .from('trailer')
                                            .select('idtrailer')
                                            .eq('nametv', nome);
                                        if(hasfocus) {
                                          url=trailerurl[0]["idtrailer"];
                                          _controller.load(url);

                                        }
                                      },
                                      onHover: (hashover){
                                        if(hashover){

                                        }
                                      },

                                      onPressed: () {


                                    Navigator.push(context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                LettoreVideoPage(
                                                    grupVod[index]
                                                        .link,grupVod)));

                                  },
                                      style: ElevatedButton.styleFrom(
                                        foregroundColor: Colors.yellowAccent, backgroundColor: Colors.blueGrey,
                                        elevation: 6.0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(20.0),
                                        ),
                                        shadowColor: Colors.yellow[200],
                                      ),

                                      child: ListTile(
                                        title: Text(grupVod[index].title,
                                          style: const TextStyle(fontSize: 20,
                                              fontWeight: FontWeight.bold),),




                                      )


                                  ),
                                ),




                                const SizedBox(height: 20,),
                              ],
                            );


                          }











                      ),
                    ),

                  ],
                ),
              );

            }
            return  const Center(
              child:  CircularProgressIndicator(color: Colors.red,),
            );
          },

        ),
      ),

    );












  }
@override
void dispose() {
  super.dispose();
  _controller.dispose();

}
}