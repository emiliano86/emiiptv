import 'package:emiiptv/page/serie.dart';
import 'package:emiiptv/page/tv_channel.dart';
import 'package:emiiptv/page/vod_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:m3u_nullsafe/m3u_nullsafe.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../service/network.dart';
import 'Link_page.dart';
import 'SearchPage.dart';
import 'lettore_video.dart';

TextEditingController searchTextEditController = TextEditingController();
late YoutubePlayerController _controller;
bool onTap=false;
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title,required this.nome,});


  final String title;
  final String nome;


  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  List<M3uGenericEntry> tv=[];
  List grup=[];
  late PlayerState _playerState;
  late YoutubeMetaData _videoMetaData;
  double _volume = 100;
  bool _muted = false;
  bool _isPlayerReady = false;
  List grupChannel=[];
  String urlLogo="";
  String urlyoutube="y1ZGQuUMUX4";
  String url="https://th.bing.com/th/id/OIP.F-Ndh1bj5I8KtGNK0pgJggHaEO?w=293&h=180&c=7&r=0&o=5&dpr=1.3&pid=1.7";
  @override
  void initState() {

    _controller = YoutubePlayerController(
      initialVideoId: urlyoutube,
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
    super.initState();

  }
  void listener() {
    if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
      setState(() {
        _playerState = _controller.value.playerState;
        _videoMetaData = _controller.metadata;
      });
    }
  }

  Logo(nome){

    if(nome.toString().contains("Rai 1")){

      url="https://www.andreapernici.com/wp-content/uploads/2010/02/logo-rai.jpg";

    }
    else if(nome.toString().contains("Canale 5")){

      url="https://www.sologossip.it/wp-content/uploads/2020/04/Screenshot_903.jpg";

    }
    else if(nome.toString().contains("Italia 1")){

      url="https://th.bing.com/th/id/OIP.boWcPaiKGC7XrfIWH3AJjQHaD4?w=320&h=180&c=7&r=0&o=5&dpr=1.3&pid=1.7";

    }
    else if(nome.toString().contains("Rete 4")){

      url="https://th.bing.com/th/id/OIP.Ut_C-97M9EETvcu5WjgagwHaDT?w=317&h=156&c=7&r=0&o=5&dpr=1.3&pid=1.7";

    }
    else if(nome.toString().contains("Sky")){

      url="https://th.bing.com/th/id/OIP.ORMrSJeK-UmHaNPzgPO6cgHaFO?w=248&h=180&c=7&r=0&o=5&dpr=1.3&pid=1.7";

    }


    return NetworkImage(url);
  }
  Future<void> _showtvChannel() async {
    return showDialog<void>(
      barrierColor: Colors.transparent,
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          shadowColor: const Color.fromARGB(10, 115, 20, 50),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          backgroundColor: Colors.black,
          elevation: 10,
          alignment: Alignment.center,

          title: const Text('TvLive',style: TextStyle(color: Colors.white),),

          content:Container(

            decoration: BoxDecoration(border:Border(top: BorderSide.none),borderRadius:BorderRadius.circular(10),  color: Colors.transparent,),
            width: 500,
              height: 800,
              child:Column(


                children: [

                 Expanded(
                   flex: 1,
                     child: Row(
                   children: [
                     IconButton(
                       focusColor: Colors.cyan,
                       hoverColor: Colors.red,
                       color: Colors.white,
                       onPressed: ()=>Navigator.pop(context),
                       icon: const Icon(Icons.backspace),),
                     IconButton(
                         focusColor: Colors.cyan,
                         hoverColor: Colors.red,
                         color: Colors.white,
                         onPressed: ()=> Navigator.push(context,
                             MaterialPageRoute(builder: (context) => SearchPage(grup: tvChannel,))),
                         icon: const Icon(Icons.search_rounded)),
                   ],
                 )
                 ),
                  Expanded(
                    flex: 2,
                    child:  ListView.builder(
                        itemCount: tvChannel.length,
                        itemBuilder: (context,index){


                          return Row(
                            children: [
                              Expanded(
                                child: InkWell(
                                  focusColor:Colors.tealAccent,


                                  onTap:() {

                                    Navigator.push(context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                LettoreVideoPage(
                                                    tvChannel[index].link,tvChannel)));

                                  },
                                  child: Container(
                                    height: 50,
                                    decoration: BoxDecoration(image: DecorationImage(
                                      image: Logo(tvChannel[index].title),
                                    )),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10,),
                              Expanded(
                                child: ElevatedButton(


                                    onPressed: () {

                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) => LettoreVideoPage(tvChannel[index].link,tvChannel)));
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
                                      title: Text(tvChannel[index].title,
                                        style: const TextStyle(fontSize: 20,
                                            fontWeight: FontWeight.bold),),




                                    )


                                ),
                              ),
                              const SizedBox(height: 100,),
                            ],
                          );

                        }











                    ),
                  ),
                ],
              ),
            ),
          );




      },
    );
  }
  Future<void> _showVodChannel() async {
    return showDialog<void>(
      barrierColor: Colors.transparent,
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          shadowColor: const Color.fromARGB(10, 115, 20, 50),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          backgroundColor: Colors.black,
          elevation: 10,
          alignment: Alignment.center,

          title: const Text('VodLive',style: TextStyle(color: Colors.white),),

          content:Container(

            decoration: BoxDecoration(border:Border(top: BorderSide.none),borderRadius:BorderRadius.circular(10),  color: Colors.transparent,),
            width: 500,
            height: 800,
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

                Row(
                  children: [
                    IconButton(
                        focusColor: Colors.cyan,
                        hoverColor: Colors.red,
                        color: Colors.white,
                        onPressed: ()=>Navigator.pop(context),
                        icon: const Icon(Icons.backspace)),
                    IconButton(
                        focusColor: Colors.cyan,
                        hoverColor: Colors.red,
                        color: Colors.white,
                        onPressed: ()=>Navigator.push(context,
                            MaterialPageRoute(builder: (context) => SearchPage(grup: grupVod,))),
                        icon: const Icon(Icons.search_rounded)),
                  ],
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: grupVod.length,
                      itemBuilder: (context,indext){
                        var nome=grupVod[indext].title.replaceAll(RegExp(r'[^a-zA-Z]'), "");









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
                                                  grupVod[indext]
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
                                                    grupVod[indext]
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
                                    title: Text(grupVod[indext].title,
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
          ),
        );




      },
    );
  }
  Future<void> _showSerieChannel() async {
    return showDialog<void>(
      barrierColor: Colors.transparent,
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          shadowColor: const Color.fromARGB(10, 115, 20, 50),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          backgroundColor: Colors.black,
          elevation: 10,
          alignment: Alignment.center,

          title: const Text('SerieTv',style: TextStyle(color: Colors.white),),

          content:Container(

            decoration: BoxDecoration(border:Border(top: BorderSide.none),borderRadius:BorderRadius.circular(10),  color: Colors.transparent,),
            width: 500,
            height: 800,
            child:Column(

              children: [
                Row(
                  children: [
                    IconButton(
                        focusColor: Colors.cyan,
                        hoverColor: Colors.red,
                        color: Colors.white,
                        onPressed: ()=>Navigator.pop(context),
                        icon: const Icon(Icons.backspace)),
                    IconButton(
                        focusColor: Colors.cyan,
                        hoverColor: Colors.red,
                        color: Colors.white,
                        onPressed: ()=>Navigator.push(context,
                            MaterialPageRoute(builder: (context) => SearchPage(grup: serie,))),
                        icon: const Icon(Icons.search_rounded)),
                  ],
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: serie.length,
                      itemBuilder: (context,index){


                        return Column(
                          children: [

                            ElevatedButton(onPressed: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) => LettoreVideoPage(serie[index].link,serie)));
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
                                  title: Text(serie[index].title,
                                    style: const TextStyle(fontSize: 20,
                                        fontWeight: FontWeight.bold),),
                                  leading: const Text("Serie",
                                    style: TextStyle(fontSize: 20,
                                        fontWeight: FontWeight.bold),),



                                )


                            ),
                            const SizedBox(height: 20,),
                          ],
                        );

                      }











                  ),
                ),
              ],
            ),
          ),
        );




      },
    );
  }



  @override
  Widget build(BuildContext context) {









    return Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,

        ),
        body:Container(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.all(30),
              child:Row(

                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: FutureBuilder(
                        future: fetchtvChannel(widget.nome),
                        builder: (context,snapshot){
                          if(snapshot.hasData) {
                            tvChannel = snapshot.data;
                            return ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.yellowAccent, backgroundColor: Colors.transparent,
                                  elevation: 6.0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),

                                ),
                                onPressed:(){
                                  fetchGroup(widget.nome);
                                  //Shko(context, TvChannelPage(nome: widget.nome));
                                  _showtvChannel();
                                   }, child:Container(
                                alignment: AlignmentDirectional.center,
                                width: 150,
                                height: 150,
                                decoration: const BoxDecoration(color: Colors.transparent,borderRadius: BorderRadius.all(Radius.circular(20))),
                                child: Center(

                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset("assets/tv.svg"),
                                      const SizedBox(height: 10,),
                                      const Text(
                                        "TvLive", style: TextStyle(fontSize: 20,
                                          fontWeight: FontWeight.bold),),
                                      const SizedBox(width: 20,),
                                      Text(
                                        "${tvChannel.length}", style: const TextStyle(fontSize: 20,
                                          fontWeight: FontWeight.bold),),

                                    ],
                                  ),
                                )
                            ));
                          }
                          return const Center(
                            child: CircularProgressIndicator(color: Colors.red,),
                          );
                        }
                    ),
                  ),
                  const SizedBox(width: 20,),
                  Expanded(
                    child:FutureBuilder(
                        future: fetchVod(widget.nome),
                        builder: (context,snapshot){
                          if(snapshot.hasData) {
                            grupVod = snapshot.data;
                            return ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.yellowAccent, backgroundColor: Colors.transparent,
                                  elevation: 6.0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),

                                ),
                                onPressed:()=>_showVodChannel(), child:Container(
                                alignment: AlignmentDirectional.center,
                                width: 150,
                                height: 150,
                                decoration: const BoxDecoration(color: Colors.transparent,borderRadius: BorderRadius.all(Radius.circular(20))),
                                child: Center(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset("assets/movie.svg"),
                                      const SizedBox(height: 10,),
                                      const Text(
                                        "Film", style: TextStyle(fontSize: 20,
                                          fontWeight: FontWeight.bold),),
                                      const SizedBox(height: 20,),
                                      Text(
                                        "${grupVod.length}", style: const TextStyle(fontSize: 20,
                                          fontWeight: FontWeight.bold),),

                                    ],
                                  ),
                                )
                            ));
                          }
                          return const Center(
                            child: CircularProgressIndicator(color: Colors.red,),
                          );
                        }
                    ),
                  ),
                  const SizedBox(width: 20,),
                  Expanded(
                    child: FutureBuilder(
                        future: fetchSerie(widget.nome),
                        builder: (context,snapshot){
                          if(snapshot.hasData) {
                            serie = snapshot.data;
                            return ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.yellowAccent, backgroundColor: Colors.transparent,
                                  disabledBackgroundColor: Colors.yellow[200],
                                  elevation: 6.0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),

                                ),
                                onPressed:()=>_showSerieChannel(), child:Container(
                                alignment: AlignmentDirectional.center,
                                width: 150,
                                height: 150,
                                decoration: const BoxDecoration(color: Colors.transparent,borderRadius: BorderRadius.all(Radius.circular(20))),
                                child: Center(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset("assets/popcorn.svg"),
                                      const SizedBox(height: 10,),
                                      const Text(
                                        "Serie Tv", style: TextStyle(fontSize: 20,
                                          fontWeight: FontWeight.bold),),
                                      const SizedBox(height: 20,),
                                      Text(
                                        "${serie.length}", style: const TextStyle(fontSize: 20,
                                          fontWeight: FontWeight.bold),),

                                    ],
                                  ),
                                )
                            ));
                          }
                          return const Center(
                            child: CircularProgressIndicator(color: Colors.red,),
                          );
                        }
                    ),
                  ),


                ],
              ),
            )
        )

    );






  }
}
