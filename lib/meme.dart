import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
class meme {
   String url="empty" ,discription="";
   late BuildContext context;
  int upvotes=0;
  bool show_info=false;
  Widget meme_display=Container();
  //meme fetching
  Future<List> fetchRandomMeme() async {
    String post_image="",disc="";
    int up;
    bool o;
    do {
      final response = await http.get(
        Uri.parse('https://www.reddit.com/r/meme/random.json'),
      );
      final jsonData = jsonDecode(response.body);
      Map post_info=jsonData[0]['data']['children'][0]['data'];
      o=post_info["over_18"];
      disc=post_info["title"];
      up=post_info["ups"];
      post_image = (post_info["url"])
          .toString();

      print(post_image);
    }while(!post_image.endsWith(".jpg")&&!post_image.endsWith(".png")&&!post_image.contains("imgur.com")&&o);
    if(post_image.contains("imgur.com") &&!post_image.endsWith(".jpg")&&!post_image.endsWith(".png")) {
      post_image = "https://i."+post_image.split("https://")[1]+".jpeg";
    }
    return [post_image,up,disc];
   
  }
  showdata(){
    this.show_info=true;
    widget_creater();
  }
  hidedata()
  {
    this.show_info=false;
    widget_creater();
  }

  Future<void> init(BuildContext context) async{
    List r=await fetchRandomMeme();
    this.context=context;
    this.url=r[0];
    this.upvotes=r[1];
    this.discription=r[2];
    this.show_info=false;
    widget_creater();
  }




 //info displayer
  String info()
  {
    if(!show_info) return "?";
    else return this.upvotes.toString();
  }
  void widget_creater(){
    meme_display=Container(
      width: MediaQuery.of(context).size.width*2/5,
      height: MediaQuery.of(context).size.height*6/7,
      child: Center(
        child: Column(
          children: [
            Container(
                width: MediaQuery.of(context).size.width*2/5,
                color: Colors.yellow,
                alignment: Alignment.center,child:Text(discription ,style: const TextStyle(fontWeight: FontWeight.bold),)),

             Container(color:Colors.white ,child:Image(image: NetworkImage(url ) ,width: MediaQuery.of(context).size.width*2/5,height: MediaQuery.of(context).size.height*4/7,fit: BoxFit.scaleDown)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("upvotes :${info()}", style: TextStyle(fontSize: 30),),


              ],
            )
          ],
        )

      ),
    );

  }


}