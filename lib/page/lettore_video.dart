import 'dart:async';


import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

import '../service/network.dart';
import 'Link_page.dart';
bool isVisibile=false;
FocusNode focus =FocusNode();
late VideoPlayerController controller;
bool isPause=false;
bool isKeyPressed(LogicalKeyboardKey key) => RawKeyboard.instance.keysPressed.contains(key);


class LettoreVideoPage extends StatefulWidget {

  final url;
  final grupp;
  LettoreVideoPage(this.url,this.grupp);



  @override
  State<LettoreVideoPage> createState() => _LettoreVideoState();
}

class _LettoreVideoState extends State<LettoreVideoPage> {


   _showProgresVideo() async {
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



          content:Container(

            decoration: BoxDecoration(border:Border(top: BorderSide.none),borderRadius:BorderRadius.circular(10),  color: Colors.transparent,),
            width: 300,
            height: 300,
            child:PageView(
              scrollDirection: Axis.horizontal,
           children: [
             VideoPlayer(controller),

           ],
            )
          ),
        );




      },
    );
  }

  _showMyDialog() async {
    return showDialog<void>(
      barrierColor: Colors.transparent,
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          title: const Text('Vod'),
          content: Container(
            color: Colors.transparent,
            width: 500,
            height: 650,

            child: ListView.builder(
                itemCount: widget.grupp.length,
                itemBuilder: (context,index){
                  var nome=grupVod[index].title.replaceAll(RegExp(r'[^a-zA-Z]'), "");

                  final String publicUrl = supabase
                      .storage
                      .from('film')
                      .getPublicUrl('$nome.jpg');

                  return Row(
                    children: [
                      if(widget.grupp!=serie&&widget.grupp!=tvChannel)Expanded(
                        child: InkWell(
                          hoverColor: Colors.transparent,
                          focusColor: Colors.yellowAccent,
                          onTap:() {

                            Navigator.push(context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        LettoreVideoPage(
                                            widget.grupp[index]
                                                .link,widget.grupp)));

                          },
                          child: Container(
                            height: 100,

                            decoration: BoxDecoration(color: Colors.transparent,image: DecorationImage(
                              image: NetworkImage(publicUrl,
                                scale: 1,
                              ),
                            )),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10,height: 10,),
                      Expanded(
                        child:  ElevatedButton(onPressed: () {

                          Navigator.push(context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      LettoreVideoPage(
                                          widget.grupp[index]
                                              .link,widget.grupp)));

                        },


                            child: ListTile(
                              title: Text(widget.grupp[index].title,
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

        );
      },
    );
  }



  @override
  void initState() {

    controller=VideoPlayerController.networkUrl(Uri.parse( widget.url),


    )


      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(()
        {

        });


        controller.play();
        controller.setLooping(false);



      });





    controller.play();

    Timer(
      const Duration(milliseconds: 100),
          () =>setState(() {
        isVisibile=false;
      }),
    );

    super.initState();



  }


  @override
  Widget build(BuildContext context) {
    return  RawKeyboardListener(
        focusNode: focus,
        autofocus: true,
        onKey: (event){

          if (event.logicalKey==LogicalKeyboardKey.select) {




            controller.pause();


            setState(() {
              isVisibile=true;
            });
















          }



          else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {

            controller.seekTo(Duration(
                seconds: controller.value.position.inSeconds +10));
            setState(() {
              isVisibile=true;
              controller.play();
            });




          }
          else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {

            _showMyDialog();

          }
          else if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {

            controller.seekTo(Duration(
                seconds: controller.value.position.inSeconds -10));
            setState(() {
              isVisibile=true;
              controller.play();
            });

          }


          else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
            controller.play();
            setState(() {
              isVisibile=false;
            });




          }



        },


        child:  GestureDetector(
          onDoubleTap: (){
            if(isVisibile){
              setState(() {
                isVisibile=false;
              });
            }
          },
          onTap: (){
            if(isVisibile==false){
              setState(() {
                isVisibile=true;
              });
            }
          },
          child: Scaffold(


            body: Center(
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: VideoPlayer(

                    controller

                ),
            )
            ),










            floatingActionButton: isVisibile ?Padding(padding: EdgeInsets.all(25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: IconButton(onPressed: (){controller.dispose();Navigator.pop(context);},icon: const Icon(Icons.backspace,color: Colors.deepOrange,),),),
                  const SizedBox(height: 150,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(flex:1,child: IconButton(onPressed: ()=>controller.seekTo(Duration(seconds: controller.value.position.inSeconds -10)), icon: const Icon(Icons.fast_rewind_outlined,color: Colors.white),),),
                      Expanded(flex:1,child: IconButton(onPressed: ()=>controller.value.isPlaying?controller.pause():controller.play(), icon: controller.value.isPlaying?const Icon(Icons.pause,color: Colors.white,):const Icon(Icons.play_arrow,color: Colors.white),),),
                      Expanded(flex:1,child: IconButton(onPressed: ()=>controller.seekTo(Duration(seconds: controller.value.position.inSeconds +10)), icon:const Icon(Icons.fast_forward_outlined,color: Colors.white),),),

                    ],
                  ),
                  const SizedBox(height: 200,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,


                    children: [

                      Expanded(flex:1,child: ValueListenableBuilder(
                        valueListenable: controller, builder: (BuildContext context,VideoPlayerValue value, Widget? child) {

                        return Text("${value.position.inHours.toString()}:${value.position.inMinutes.toString()}:${value.position.inSeconds.remainder(60).toString()}",style: const TextStyle(color: Colors.deepOrange,fontSize: 20,fontWeight: FontWeight.bold),);
                      },


                      )),
                      Expanded(flex: 6,child: VideoProgressIndicator(controller, allowScrubbing: true,
                          colors: const VideoProgressColors(
                              backgroundColor: Color.fromRGBO(250,200,250,5)))),
                      const SizedBox(width: 30,),
                      Expanded(flex:1,child: ValueListenableBuilder(
                        valueListenable: controller, builder: (BuildContext context,VideoPlayerValue value, Widget? child) {

                        return Text("${value.duration.inHours}:${value.duration.inMinutes.remainder(60).toString()}:${value.duration.inSeconds.remainder(60).toString()}",style: const TextStyle(color: Colors.deepOrange,fontSize: 20,fontWeight: FontWeight.bold));
                      },


                      )),
                      Expanded(flex:1,child: IconButton(onPressed: (){controller.dispose();Navigator.pop(context);},icon: const Icon(Icons.fullscreen,color: Colors.deepOrange,size: 37,),)),


                    ],
                  ),


                ],

              )
            ):Container(),


          ),
        ),




    );



  }

  @override
  void dispose() {

    controller.dispose();
    super.dispose();
  }
}