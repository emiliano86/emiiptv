

import 'package:dio/dio.dart';
import 'package:emiiptv/models/m3u.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:m3u_nullsafe/m3u_nullsafe.dart';
import 'package:tmdb_api/tmdb_api.dart';

import '../page/Link_page.dart';

List grup=[];
List imageTv=[];
List grupChannel=[];
List<M3uGenericEntry> serie=[];
List<M3uGenericEntry> tvChannel=[];
List<M3uGenericEntry> grupVod=[];
List movies=[];
List<M3uGenericEntry>  grupserie=[];


const String apiKey = '60b266eef01306f71f28eb15b2690336';
const apireadacces="eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI2MGIyNjZlZWYwMTMwNmY3MWYyOGViMTViMjY5MDMzNiIsInN1YiI6IjYwODZkOTUwMzNhNTMzMDAyYTAxMmMzOCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.RK83pfyR9f1e3VJeUeohjELVoMoypVr-JgVUeZpDGLg";

Future getChannelinfo() async {
  try {
    TMDB tmdlog=TMDB(ApiKeys(apiKey,apireadacces),
      logConfig: const ConfigLogger(
        showLogs: true,
        showErrorLogs: true,
      ),
    );
    Map movie=await tmdlog.v3.movies.getPopular();
    movies=movie["results"];
    const url = 'https://iptv-org.github.io/api/channels.json';
    final response = await Dio().get(url);

    return response.data;
  } catch (error, stacktrace) {
    throw Exception(
        'Exception accoured: $error with stacktrace: $stacktrace');
  }
}



Future fetchChannels(nome) async {


  try {
    final url=await supabase
        .from("TvLink")
        .select("link")
        .eq("nome",  nome);



    Response response =
    await Dio().get(url[0]["link"]);
//String file=await rootBundle.loadString("assets/tv_channels_emi01.m3u");

    final m3u= await M3uParser.parse(response.data);





    return(m3u);











  } catch (e) {
    print(e);
  }
  return null;

}
Future fetchVod(nome) async {


  try {
    final url=await supabase
        .from("TvLink")
        .select("link")
        .eq("nome",  nome);



    Response response =
    await Dio().get(url[0]["link"]);
    String file=await rootBundle.loadString("assets/tv_channels_emi01.m3u");
    final m3u= await M3uParser.parse(response.data);



    for (var item in m3u.toList()) {
      // final map=m3u.map((e){
      // return {
      // "title": e.title,
      //"link":e.link,
      //"atribute":e.attributes,

      // };
    //}).toList();

      if(item.link.contains("movie")&&item.link.isNotEmpty) {



        grupVod.add(M3uGenericEntry(title: item.title, attributes: item.attributes, link: item.link));


      }
    }

    return(grupVod);













  } catch (e) {
    print(e);
  }
  return null;

}
Future fetchGroup(nome) async {


  try {
    final url=await supabase
        .from("TvLink")
        .select("link")
        .eq("nome",  nome);



    Response response =
    await Dio().get(url[0]["link"]);
    String file=await rootBundle.loadString("assets/tv_channels_emi01.m3u");
    List tv=[];
    tv.add(response.data);
    for(var item in tv.toList()){
      List<TvChannel> channel=[];
      item.forEach((element) {
        channel.add(element.toMap());
      });
      print(channel);
    }
















  } catch (e) {
    print(e);
  }
  return null;

}
Future fetchtvChannel(nome) async {


  try {
    final url=await supabase
        .from("TvLink")
        .select("link")
        .eq("nome",  nome);



    Response response =
    await Dio().get(url[0]["link"]);
    String file=await rootBundle.loadString("assets/tv_channels_emi01.m3u");
    final m3u= await M3uParser.parse(response.data);

    for (var item in m3u.toList()) {
      if(!item.link.contains("series")&&!item.link.contains("movie")&&item.link.isNotEmpty){
        tvChannel.add(M3uGenericEntry(title: item.title, attributes: item.attributes, link: item.link));


      }
    }



    return(tvChannel);











  } catch (e) {
    print(e);
  }
  return null;

}
Future fetchSerie(nome) async {


  try {
    final url=await supabase
        .from("TvLink")
        .select("link")
        .eq("nome",  nome);



    Response response =
    await Dio().get(url[0]["link"]);
    String file=await rootBundle.loadString("assets/tv_channels_emi01.m3u");
    final m3u= await M3uParser.parse(response.data);

    for (var item in m3u.toList()) {

      if( item.link.contains("series")&&item.link.isNotEmpty){

        serie.add(M3uGenericEntry(title: item.title, attributes: item.attributes, link: item.link));


      }
    }



    return(serie);












  } catch (e) {
    print(e);
  }
  return null;

}

Future fetchgrupSerie() async {


  try {

    for(var item in serie.toList()){
      if(item.title.contains(item.title.replaceAll(RegExp(r'[^a-zA-Z ]'), ""))){
        grupserie.add(M3uGenericEntry(title: item.title, attributes: item.attributes, link: item.link));
      }
    }


    return(grupserie);











  } catch (e) {
    print(e);
  }
  return null;
}
void Shko(context,page ){
  Navigator.push(context,
      MaterialPageRoute(builder: (context) => page));
}
