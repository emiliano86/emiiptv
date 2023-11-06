import 'dart:ffi';

import 'package:emiiptv/page/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


import 'package:supabase_flutter/supabase_flutter.dart';

import '../main.dart';
import '../service/network.dart';
import 'home_page.dart';

final supabase=Supabase.instance.client;
class LinkPage extends StatefulWidget {





  @override
  State<LinkPage> createState() => _LinkState();
}

class _LinkState extends State<LinkPage> {
  TextEditingController nomelinkTextEditController = TextEditingController();
  TextEditingController linkurlTextEditController = TextEditingController();
  List link=[];
  String _macAddress = '';
  late FocusNode myFocusNode;
  late FocusNode my1FocusNode;



  @override
  void initState() {
    myFocusNode=FocusNode();
    my1FocusNode=FocusNode();
    initPlatformState();
    super.initState();

  }
  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    myFocusNode.dispose();
    my1FocusNode.dispose();

    super.dispose();
  }
  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String macAddress;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      //macAddress =
      //await GetMac.macAddress;
    } on PlatformException {
      macAddress = 'Failed to get mac address.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {

      //_macAddress = macAddress;
    });
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      barrierColor: Colors.transparent,
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(

          elevation: 10,

          title: const Text('Carica Url'),

          content:Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children:  [

              TextField(
                scrollController: ScrollController(keepScrollOffset: true,),
                scrollPadding: const EdgeInsets.all(20),
                scrollPhysics: const ScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                textInputAction: TextInputAction.next,
                autofocus: true,
                focusNode: myFocusNode,

                controller: nomelinkTextEditController,

                onSubmitted: (e){
                  setState(() {

                  });
                },
                decoration: InputDecoration(
                  labelText: "nome iptv",
                  filled: true,
                  fillColor: Colors.white38,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),

                ),
              ),



              const SizedBox(height: 20,),


              TextField(

                autofocus: true,
                focusNode: my1FocusNode,
                textInputAction: TextInputAction.next,
                onSubmitted: (e){
                  setState(() {


                  });
                },

                controller: linkurlTextEditController,
                decoration: InputDecoration(
                    labelText: "Link...",
                    filled: true,
                    fillColor: Colors.white38,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))

                ),
              ),



            ],
          ),

          actions: [
            Column(
              children: [
                ElevatedButton(onPressed: ()async{
                  await supabase.from("TvLink").insert({"nome":nomelinkTextEditController.text,"link":linkurlTextEditController.text,"mac":Pref.sharedPreferences?.getString("Token")});
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MyHomePage(title: "${nomelinkTextEditController.text} link TV", nome: nomelinkTextEditController.text)));
                } ,
                    child: Text("Save")),
              ],
            )
          ],

        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Video Demo',
      home: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const Text("Link Setting"),
        ),
        body:  Padding(
            padding: const EdgeInsets.all(50),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height:200,
                    child: FutureBuilder(
                        future: supabase.from("TvLink").select("nome").eq("mac",Pref.sharedPreferences?.getString("Token")),
                        builder: (context ,snapshot){



                          if(snapshot.hasData){
                            link= snapshot.data;
                            return Container(
                              height: 700,
                              child: Column(
                                children: [
                                  const Text("I miei Link Iptv ",style: TextStyle(fontSize: 40,fontWeight: FontWeight.bold,color: Colors.white)),
                                  const SizedBox(height: 20,),
                                  //Text("My Mac Adress: ${_macAddress}",style: const TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.white),),
                                  const SizedBox(height: 50,),
                                  Expanded(

                                      child:ListView.builder(
                                          itemCount: link.length,
                                          itemBuilder: (context,index){

                                            return Column(
                                              children:[

                                                ElevatedButton(onPressed: (){

                                                  Navigator.push(context,
                                                    MaterialPageRoute(builder: (context) => MyHomePage(title: "${link[index]["nome"]} Link", nome: link[index]["nome"])));}
                                                    ,style: ElevatedButton.styleFrom(
                                                      foregroundColor: Colors.yellowAccent, backgroundColor: Colors.blueGrey,
                                                      elevation: 6.0,
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(20.0),
                                                      ),
                                                      shadowColor: Colors.yellow[200],
                                                    ),
                                                    child:ListTile(
                                                      title: Text("${link[index]["nome"]} Link",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                                                      trailing: IconButton(onPressed: () async{
                                                        await supabase.from("TvLink").delete().eq("nome",link[index]["nome"]);

                                                      },icon: const Icon(Icons.delete),),

                                                    )



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
                          return const Center(
                            child:  CircularProgressIndicator(),
                          );
                        }

                    ),
                  ),
                  SizedBox(height: 100,),
                  TextButton(onPressed: ()=>_showMyDialog(), child:const Text("+ Carica il tuo Url",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),)),

                ],
              ),
            )
        ),
      ),
    );
  }

}