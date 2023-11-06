import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../service/network.dart';
import 'SearchPage.dart';
import 'lettore_video.dart';

class SeriePage extends StatefulWidget {
  const SeriePage({super.key, required this.nome  });
  final nome;



  @override
  State<SeriePage> createState() => _SeriePageState();
}
class _SeriePageState extends State<SeriePage> {



  @override
  void initState() {

    super.initState();

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
          return TextStyle(fontSize: 40,color: Colors.black);
        }
        return TextStyle(fontSize: 20,color: Colors.black);
      }),
    );









    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,

      ),
      body:Padding(
        padding: EdgeInsets.all(30),
        child: FutureBuilder(
          future: fetchSerie(widget.nome),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if(snapshot.hasData){
              serie=snapshot.data;
              return Container(
                height: 700,
                child:Column(

                  children: [
                    IconButton(
                      focusColor: Colors.cyan,
                        hoverColor: Colors.red,
                        color: Colors.white,
                        onPressed: ()=>Navigator.push(context,
                            MaterialPageRoute(builder: (context) => SearchPage(grup: serie,))),
                        icon: const Icon(Icons.search_rounded)),
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
}