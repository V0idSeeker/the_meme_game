import 'dart:async';
import 'dart:convert';
import 'meme.dart';
import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:parallax_rain/parallax_rain.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.indigo,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage();
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int score=0;
  String verdic="Wrong" ;
  Color verdict_color=Colors.green;
  bool verdict_visibility=false , meme_loading=true;
  late ConfettiController _confettiController;
  bool button_disable=false;
  List<meme> meme_stack=[]; // stack of new memes
  //losing message
  void openDialog(BuildContext context,String d) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(d),
          content: Text("Score is :${score.toString()}"),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  meme_loading=true;
                  meme_stack.clear();
                  button_disable=false;
                  Navigator.pop(context);

                });
              },
              child: Text('Play again ?'),
            ),
          ],
        );
      },
    );
  }

  Widget widget_mode(Widget t) //confetis
  {
        return ConfettiWidget(confettiController: _confettiController,
        blastDirectionality :BlastDirectionality.explosive ,
        emissionFrequency:0.1,
        colors: [Colors.pink,Colors.purple,Colors.green,Colors.orange],
            child:t );


  }


//meme generator
  Future<List<meme>> get_lists()  async {
   if(!meme_loading) return meme_stack;
    if(meme_stack.isEmpty)
  { score=0;
    meme a=meme();
    meme b=meme();
    meme c=meme();
    await a.init(context);
    await b.init(context);
    await c.init(context);
    await a.showdata();
    meme_stack.add(a);
    meme_stack.add(b);
    meme_stack.add(c);
    await Timer(Duration(microseconds: 50),(){});
    return meme_stack;
  }
   else{
     await meme_stack.removeAt(0);
     await meme_stack[0].showdata();
     meme a=meme();
     await a.init(context);
     meme_stack.add(a);
     button_disable=true;
     await Timer(Duration(milliseconds: 50),(){});
     button_disable=false;
     return meme_stack;
   }



  }
  void tester(bool dir) //testing the value
  {
    if((meme_stack[0].upvotes<meme_stack[1].upvotes)==dir)
    {setState(() {
      score=score+1;
      verdic="Correct";
      verdict_color=Colors.green;
      verdict_visibility=true;
      button_disable=true;

      _confettiController.play();
      _confettiController.duration=Duration(seconds: 1);
       Timer(Duration(milliseconds: 300), () {
         button_disable=false;

           verdict_visibility=false;
      });

      //_confettiController.stop();
    });
    }else{
      setState(() {
        meme_loading=false;
        button_disable=false;


      verdic="Wrong";
      verdict_color=Colors.red.shade800;
      verdict_visibility=true;
      Timer(Duration(seconds: 1), ()
      {
        openDialog(context, "Score");
      }
      );
      });
    }
  }
  
  void pressedHigher(){
    tester(true);
  }
  void pressedLower(){
tester(false);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _confettiController=ConfettiController();


  }


  //getting a meme
  @override
  Widget build(BuildContext context)  {

    return Scaffold(

      body: Container(
        color: Colors.tealAccent,
        child: Center(
          child:Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FutureBuilder(future: get_lists(),builder: (context , snapshot)
                { if(meme_stack.length<1) {

                  return Center(child:CircularProgressIndicator());
                }else{
                List<meme> dat=meme_stack;
                  return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children:[dat[0].meme_display,
                    Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width/6,
                      height: MediaQuery.of(context).size.height,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                         mainAxisAlignment: MainAxisAlignment.center,

                        children: [
                          Text("Score : $score" ,style:TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
                          TextButton(onPressed:(){ if(button_disable) null; else pressedHigher();}, child: Container(
                            color: Colors.red,
                            child: Text("Cooler",style:TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
                          )),
                          TextButton(onPressed: (){ if(button_disable) null; else pressedLower();}, child: Container(
                            color: Colors.blue,
                            child: Text("Lamer",style:TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
                          )),

                          Visibility(
                            visible:verdict_visibility,
                            child: widget_mode(Container(
                            color: verdict_color,
                              child: Text(verdic ,style:TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),

                            )),
                          ),



                        ],
                      ),
                    ),
                        dat[1].meme_display
                      ]

                  );};
                },)
            ],
          )
        ),
      )
    );
  }
}
