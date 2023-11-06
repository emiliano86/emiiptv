import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../service/network.dart';
import 'SearchPage.dart';
import 'lettore_video.dart';
late VideoPlayerController _controllers;
class TvChannelPage extends StatefulWidget {
  const TvChannelPage({super.key,  required this.nome});
  final nome;



  @override
  State<TvChannelPage> createState() => _TvChannelPageState();
}
class _TvChannelPageState extends State<TvChannelPage> {
  String url="https://th.bing.com/th/id/OIP.F-Ndh1bj5I8KtGNK0pgJggHaEO?w=293&h=180&c=7&r=0&o=5&dpr=1.3&pid=1.7";
  String uri="";



  @override
  void initState() {
_initController(uri);
_startVideoPlayer(uri);

    super.initState();

  }
  void _initController(link){
    _controllers=VideoPlayerController.networkUrl(Uri.parse(link),


    )


      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(()
        {

        });
        _controllers.play();

      });
  }
  Future<void> _startVideoPlayer(link)async {
    if(_controllers==null){
      _initController(link);
    }else{
      final oldController=_controllers;
      WidgetsBinding.instance.addPostFrameCallback((_)async {
        await oldController.dispose();
        _initController(link);
      });

    }

  }





  @override
  Widget build(BuildContext context) {
    TextEditingController searchTextEditController = TextEditingController();
    final focus = FocusNode();
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
          return TextStyle(fontSize: 40,color: Colors.black);
        }
        return TextStyle(fontSize: 20,color: Colors.black);
      }),
    );

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







    return Scaffold(
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,

        ),
        body:Padding(
          padding: const EdgeInsets.all(30),
          child: FutureBuilder(
            future: fetchtvChannel(widget.nome),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if(snapshot.hasData){
                tvChannel=snapshot.data;
                return Container(
                  height: 700,
                  child:Column(

                    children: [
                      Expanded(child:Container(
                        width: 700,
                        height: 750,
                        child: AspectRatio(
                            aspectRatio: 16 / 9,
                            child:VideoPlayer(
                             _controllers
                            )
                        ),),
                      ),
                      IconButton(
                          focusColor: Colors.cyan,
                          hoverColor: Colors.red,
                          color: Colors.white,
                          onPressed: ()=> Navigator.push(context,
                              MaterialPageRoute(builder: (context) => SearchPage(grup: tvChannel,))),
                          icon: const Icon(Icons.search_rounded)),
                      Expanded(
                        child:  ListView.builder(
                            itemCount: tvChannel.length,
                            itemBuilder: (context,index){


                              return Row(
                                children: [
                                  Expanded(
                                    child: InkWell(
                                      focusColor:Colors.tealAccent,
                                      onFocusChange: (hasfocus){
                                        if(hasfocus){
    uri= tvChannel[index].link;
    _controllers.dispose();
    _controllers=VideoPlayerController.networkUrl(Uri.parse(uri),


    )


    ..initialize().then((_) {
    // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
    setState(()
    {

    });
    _controllers.play();

    });


                                          print(uri);
                                        }
                                      },
                                      onTap:() {
                                         _controllers.dispose();
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    LettoreVideoPage(
                                                        uri,tvChannel)));

                                      },
                                      child: Container(
                                        height: 100,
                                        decoration: BoxDecoration(image: DecorationImage(
                                          image: Logo(tvChannel[index].title),
                                        )),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10,),
                                  Expanded(
                                    child: ElevatedButton(
                                        onFocusChange: (hasfocus){
                                          if(hasfocus){
                                            uri= tvChannel[index].link;
                                            _controllers.dispose();
                                            _controllers=VideoPlayerController.networkUrl(Uri.parse(uri),


                                            )


                                              ..initialize().then((_) {
                                                // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
                                                setState(()
                                                {

                                                });
                                                _controllers.play();

                                              });

                                          }
                                        },

                                        onPressed: () {
                                          _controllers.dispose();
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) => LettoreVideoPage(uri,tvChannel)));
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
                                  const SizedBox(height: 50,),
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
        )
    );












  }
  @override
  void dispose() {
    _controllers.dispose();
    super.dispose();
  }
}