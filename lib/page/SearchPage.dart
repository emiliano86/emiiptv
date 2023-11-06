import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:m3u_nullsafe/m3u_nullsafe.dart';

import '../service/network.dart';
import 'Link_page.dart';
import 'lettore_video.dart';

class SearchPage extends StatefulWidget {
  SearchPage({super.key,  required this.grup,});

  List<M3uGenericEntry> grup;




  @override
  State<SearchPage> createState() => _SearchPageState();
}
class _SearchPageState extends State<SearchPage> {
  TextEditingController searchTextEditController=TextEditingController();




  @override
  void initState() {

    super.initState();

  }
  _runFilter(keyword){
    List<M3uGenericEntry> search=[];
    if(keyword.isEmpty){
      setState(() {
        search=widget.grup;
      });

    }else{
      search=widget.grup
          .where((element) => element.title.toLowerCase().contains(keyword.toLowerCase())).toList();
      setState(() {
        widget.grup=search;
      });
    }


  }



  @override
  Widget build(BuildContext context) {

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








    return Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,

        ),
        body:Column(
          children: [
            TextField(

              autofocus: true,
              onChanged:(value)=>setState(() {
                value=searchTextEditController.text;
                _runFilter(value);
              }),
              onEditingComplete: _runFilter(searchTextEditController.text),


              textInputAction: TextInputAction.next,
              onSubmitted: (e){
                _runFilter(e);
              },

              controller:searchTextEditController,
              decoration: InputDecoration(
                  labelText: "Search...",
                  filled: true,
                  fillColor: Colors.white38,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))

              ),
            ),
            Container(
              height: 420,
              child:Column(

                children: [

                  Expanded(
                    child:  ListView.builder(
                        itemCount:widget.grup.length,
                        itemBuilder: (context,index){

                          final String publicUrl = supabase
                              .storage
                              .from('film')
                              .getPublicUrl('${grupVod[index].title}.jpg');

                          return Row(
                            children: [
                              if(widget.grup!=serie&&widget.grup!=tvChannel)Expanded(
                                child: InkWell(
                                  hoverColor: Colors.transparent,
                                  focusColor: Colors.yellowAccent,
                                  onTap:() {

                                    Navigator.push(context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                LettoreVideoPage(
                                                    widget.grup[index]
                                                        .link,widget.grup)));

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
                              Expanded(
                                child: ElevatedButton(onPressed: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) => LettoreVideoPage(widget.grup[index].link,widget.grup)));
                                },


                                    child: ListTile(
                                      title: Text(widget.grup[index].title,
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






          ],
        )
    );












  }
}