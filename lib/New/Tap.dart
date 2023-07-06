import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter/material.dart';
import 'package:memory_game/New/TimeUpNew.dart';
import 'package:memory_game/New/rememberscreen.dart';
import 'package:memory_game/New/utils.dart';
import 'package:memory_game/model/Audio.dart';
import 'package:memory_game/model/user_model.dart';
import 'package:memory_game/services/helpers.dart';

import '../model/User_model.dart';
import 'WinScreen.dart';
import 'exit_dialog.dart';

class TapScreen extends StatefulWidget {
  final GameDataModel? dataList;
  final int currentIndex;
  final List<String> emptyList;
  TapScreen({required this.dataList, required this.currentIndex,required this.emptyList,});
  @override
  State<StatefulWidget> createState() => MyApp(dataList!,currentIndex,emptyList);

}

class MyApp extends State<TapScreen> with WidgetsBindingObserver{
  final GameDataModel dataList;
  AudioService audioService=AudioService();
   int currentIndex;
  List<String> emptyList;
  MyApp(this.dataList, this.currentIndex, this.emptyList);
  late FlutterSoundPlayer soundPlayer;
  PlayerState audioPlayerState = PlayerState.isStopped;

  int length=0;
  int abovelistlength=0;
  bool isChangeImage=false;
  bool isTab=false;
  bool showListView = true;
  String textContent = 'Hello, Flutter!';
  bool showWinDialog = false;
  bool showTextView = false;
  double _progress = 1.0;
  late Timer _timer;
  late bool _isTimerRunning=false;

  void navigateToNextScreen() {
    int currentdata=currentIndex;
    if(currentIndex>=dataList.data!.length-1)
    {
      currentdata=0;
    }
    else{
      currentdata++;
    }
    print(currentdata);


    Future.delayed(Duration(seconds: 5), () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RememberNewScreen(dataList,currentdata,)
        ),
      );
    });
  }
  void navigateToCorrectScreen() {

    Future.delayed(Duration(seconds: 3), () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              TimeUpScreen(currentIndex: currentIndex,dataList: dataList,)
        )
      );
    });

  }


  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      if (_progress > 0) {
        setState(() {
          _progress -= 0.1;
        });
      } else {
        print("Timer End");
        if (questionimage.contains("assets/newUi/tap.png")) {
          // timeUp("Time Up",dataList.length);
        }
        timer.cancel();
        _isTimerRunning = false;
      }
    });
  }

  void stopProgress() {
    _timer.cancel();
    setState(() {
      _isTimerRunning = false;
    });
  }

  void resumeProgress() {
    setState(() {
      _isTimerRunning = true;
    });
    startTimer();
  }

  void toggleTimer() {
    if (_isTimerRunning) {
      stopProgress();
    } else {
      if (_progress > 0.0) {
        _progress -= 0.1;
      }
      resumeProgress();
    }
  }
  @override
  void dispose() {
    soundPlayer.stopPlayer();
    soundPlayer.closeAudioSession();
    _timer.cancel();
    super.dispose();
  }



  @override
  void initState() {
    super.initState();
    startTimer();
    soundPlayer = FlutterSoundPlayer();
    // Wait for 5 seconds and then update the widget tree

  }


  final List<String> questionimage = [
    'assets/newUi/tap.png',
    'assets/newUi/tap.png',
    'assets/newUi/tap.png',
    'assets/newUi/tap.png',
    'assets/newUi/tap.png',

  ];
  final List<String> rowCount = [
    'assets/newUi/innerimage.png',
    'assets/newUi/innerimage.png',
    'assets/newUi/innerimage.png',
    'assets/newUi/innerimage.png',
    'assets/newUi/innerimage.png',
  ];
  final List<String> rowImage = [
    'assets/newUi/fish.png',
    'assets/newUi/plain.png',
    'assets/newUi/bus.png',
    'assets/newUi/car.png',
    'assets/newUi/plain.png',
    'assets/newUi/car.png',


  ];

  final List<String> row2Items = [

    'assets/newUi/innerimage.png',
    'assets/newUi/innerimage.png',
    'assets/newUi/innerimage.png',
    'assets/newUi/innerimage.png',
    'assets/newUi/innerimage.png',
    'assets/newUi/innerimage.png',

    // 'Card A',
    // 'Card B',
  ];

  int count = 0;
  int successCount=0;
  bool showSuccessDialog=false;
  var data=0;
  List<String?> emptyCards = [
    null,
    null,
    null,
    null,
    null,
    null,
    null,
  ];
  List<String?> addCardstoVerify = [
    null,
    null,
    null,
    null,
    null

  ];

  @override
  Widget build(BuildContext context) {
    isTab=ScreenUtilClass().getIsTab(context);
    abovelistlength=dataList!.data![currentIndex].correctAnswer!.split(',').length;
    // row1Items.length=dataList.length;

    return WillPopScope(
      onWillPop: () async {
        return await showDialog(
            context: context,
            builder: (context) => exitDialog());
      },
      child: Scaffold(
        backgroundColor: Color(0xFF6555C0),
        body: SafeArea(
          child: Container(
            padding:isTab?const EdgeInsets.only(left: 30,right: 30,top: 30,bottom: 0):const EdgeInsets.only(left: 10,right: 20,top: 20,bottom: 30),
            child: Column(
              children: [
                Visibility(
                  visible: false,
                  child: Container(
                    padding: isTab ? const EdgeInsets.only(left: 150,right: 150,top: 40) :const EdgeInsets.only(left: 150,right: 150,top: 10,bottom: 10),
                    width: isTab ? 700 :MediaQuery.of(context).size.width,
                    height: isTab ? 50 :30,
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20),)
                    ),
                    alignment: Alignment.center,
                    child: LinearProgressIndicator(
                      value: _progress,
                      minHeight: 30,
                      backgroundColor: const Color(0xFF40309F),
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.pink),
                    ),
                  ),
                ),
                Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 1,
                          child: InkWell(
                            onTap: () {
                              stopProgress();
                              showDialog(
                                  context: context,
                                  builder: (context) => exitDialog()).then((value) => resumeProgress())
                              ;
                            },
                            child: Center(
                              child: Image.asset(
                                'assets/newUi/CancelButton.png',
                                width: isTab?60:40,
                                height:isTab?60:40,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 150,),

                        Padding(
                          padding: isTab?const EdgeInsets.only(top: 100,bottom: 10):const EdgeInsets.only(top: 10,bottom: 10),
                          child: Expanded(
                            flex: 8,
                            child: Container(
                              //Media Query
                              width: isTab ? 700 : 400,
                              height: isTab ? MediaQuery.sizeOf(context).height*0.1:50,
                              alignment: Alignment.center,
                              padding: const EdgeInsets.all(5.0),
                              decoration: const BoxDecoration(
                                color: Color(0xFF7F6AF6),
                                borderRadius: BorderRadius.all(Radius.circular(20),
                                ),
                              ),
                              child: Text(
                                'Tab options you saw in same order.',
                                textAlign: TextAlign.center,
                                style:TextStyle(
                                    fontFamily: 'Grandstander',
                                    fontSize: isTab?30:20,
                                    fontWeight:FontWeight.w800,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 140,),
                        Expanded(
                            flex: 1,
                            child: Container(
                              width: 65,
                              height: isTab?50:40,
                              decoration: const BoxDecoration(
                                color: Color(0xFF7F6AF6),
                                borderRadius: BorderRadius.all(Radius.circular(40),
                                ),
                              ),
                              child:  Center(
                                child: Text('1/10',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontFamily: 'Fredoka-Regular',
                                      fontSize: isTab?25:20,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white)
                                  ,
                                ),
                              ),
                            ))
                      ],
                    ),
                  ],
                ),
                Expanded(
                  child: Container(
                    // width: 1280,
                    // height: 100,
                    alignment: Alignment.center,
                    child: ListView.separated(
                      separatorBuilder: (context, index) {
                        return  SizedBox(width: isTab?50.0:30.0); // Adjust the vertical spacing here
                      },
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount:abovelistlength,
                      itemBuilder: (context, index) {

                        return
                          Container(
                              margin:isTab?const EdgeInsets.only(left: 10, right: 10,top: 10):const EdgeInsets.only(left: 20, right: 20,top: 0),
                              padding: isTab ? const EdgeInsets.only(right: 40):const EdgeInsets.all(0),
                              height:isTab?180:111,
                              width:isTab?180:111,
                              alignment: Alignment.center,
                              decoration:BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(isChangeImage?dataList.data![currentIndex].options![index].isError?'assets/newUi/wrongimage.png':'assets/newUi/correctimage.png':dataList.data![currentIndex].options![index].isCorrect?'assets/newUi/innerimage.png':'assets/newUi/tap.png'),
                                    fit: BoxFit.fitWidth
                                ),
                              ),

                              child: dataList.data![currentIndex].options![index].isCorrect?Center(

                                child: Container(
                                  alignment: Alignment.center,
                                  padding: isTab?const EdgeInsets.only(left:40,right: 10,top:10,bottom: 10):const EdgeInsets.all(30),
                                  // padding: isTab?const EdgeInsets.all(40):EdgeInsets.all(15),
                                  child: ClipRect(
                                    child: Center(
                                      child: Image.asset(emptyCards[index].toString(),
                                        width: isTab?120:106.0,
                                        height:isTab?120:106.0,
                                        fit: BoxFit.fitWidth,
                                      ),
                                    ),
                                  ),
                                ),
                              ):null
                            // child: Container(
                            //   width: 120,
                            //   height: 100,
                            //   child: Center(
                            //     child: Image.asset(row2Items[index]),
                            //   ),
                            // ),
                          );
                      },
                    ),
                  ),
                ),
                showListView ? buildListView() : buildText(),
              ],
            ),
          ),
        ),
      ),
    );

  }




  void timeUp(String title, int length)
  async {

    print('Current data $currentIndex');
    Future.delayed(Duration(seconds: 2), () {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                TimeUpScreen(currentIndex:currentIndex, dataList: dataList,)

        ),
      );
    });
  }
  Widget buildText() {
    _isTimerRunning=true;


    return Expanded(
        child: Container(
          width: 1280,
          height: 300,
          alignment: Alignment.center,
          // decoration: const BoxDecoration(
          //   image: DecorationImage(
          //     image: AssetImage('assets/new-ui/options/bg.png'),
          //     fit: BoxFit.fill,
          //   ),

          child: Center(
            child: GestureDetector(
              onTap: () {
                Future.delayed(
                  Duration.zero,
                      () =>
                      showDialog(
                          context: context,
                          builder: (context) => WinDialog()),
                );
                Timer(const Duration(seconds: 3), () {
                  Navigator.of(context).pop();
                });
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    child: Image.asset(isChangeImage?'assets/newUi/CancelButton.png':
                    'assets/newUi/correct.png',
                      width: 100,
                      height: 100,
                    ),
                  ),
                  SizedBox(height: 16),
                  isChangeImage?Text(
                      'Oops!',
                      textAlign: TextAlign.center,
                      style: SafeGoogleFont(
                        'Grandstander',
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                        height: 0.9975,
                        color: Color(0xffffffff),
                      )
                  ):Text(
                    'ALL DONE',
                    textAlign: TextAlign.center,
                    style: SafeGoogleFont(
                      'Grandstander',
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      height: 0.9975,
                      color: Color(0xffffffff),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));


  }


  Future<void> playAudio(String audioUrl) async {
    await soundPlayer.openAudioSession();
    if(audioUrl.contains("http")) {
      await soundPlayer.startPlayer(
        fromURI: audioUrl,
        codec: Codec.mp3,
      );
    }else{
      await soundPlayer.startPlayer(
        fromDataBuffer: (await rootBundle.load(audioUrl)).buffer.asUint8List(),
      );
    }
    setState(() {
      audioPlayerState = PlayerState.isPlaying;
    });
  }


  Future<void> pauseAudio() async {
    await soundPlayer.pausePlayer();
    setState(() {
      audioPlayerState = PlayerState.isPaused;
    });
  }

  Future<void> stopAudio() async {
    await soundPlayer.stopPlayer();
    setState(() {
      audioPlayerState = PlayerState.isStopped;
    });
  }



  Widget buildListView() {
    length=dataList.data![currentIndex].options!.length;

    // Build your ListView widget here
    return Expanded(
      child: Padding(
        padding:isTab?const EdgeInsets.only(bottom: 100):const EdgeInsets.all(0),
        child: Container(
          width: isTab?1000:MediaQuery.sizeOf(context).width/0.5,
          height: isTab?MediaQuery.sizeOf(context).height*0.22:MediaQuery.sizeOf(context).height,
          alignment: Alignment.center,
          // padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Color(0xff4CDAD4),
            borderRadius: BorderRadius.circular(50),
          ),
          // decoration: const BoxDecoration(
          //   image: DecorationImage(
          //     image: AssetImage('assets/new-ui/options/bg.png'),
          //     fit: BoxFit.fill,
          //   ),

          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: dataList.data![currentIndex].options!.length,
            itemBuilder: (context, index) {

              final dataModel = dataList.data![currentIndex];
              final image = dataModel.options![index];
              return Center(
                child: GestureDetector(
                  onTap: () {
                    stopAudio();
                    playAudio('assets/mp3/Click.mp3');

                    // allCardsReplaced ? null : _replaceCard(index);
                    print(emptyList);

                    print(emptyList[count]);
                    print(image.image);
                    setState(() {
                      if(image.image==emptyList[count])
                      {
                        successCount++;
                      }
                      else
                      {
                        dataList.data![currentIndex].options![count].isError = true;
                      }
                      // dataList[currentIndex].options[count].image = image.image;
                      emptyCards.insert(count, dataList.data![currentIndex].options![index].image);
                      print("emptyCards $emptyCards");
                      dataList.data![currentIndex].options![count].isCorrect = true;
                      count++;
                      // dataList[currentIndex].options.remove(image);


                      // widget.dataList[0].options.forEach((element) {
                      //   dataList[0].options.forEach((element2) {
                      //     if(element.imagePath==element2.imagePath)
                      //     {
                      //       showSuccessDialog=true;
                      //     }

                     //     else{
                      //       showSuccessDialog=false;
                      //     }
                      //   });
                      // });

                    });

                    if (successCount==widget.dataList!.data![currentIndex].correctAnswer!.split(',').length) {

                     stopAudio();
                      playAudio('assets/mp3/Right.mp3');
                      Future.delayed(
                        Duration.zero,
                            () =>
                            showDialog(
                                context: context,
                                builder: (context) => WinDialog()),
                      );
                      Timer(const Duration(seconds: 2), () {
                        Navigator.of(context).pop();
                        setState(() {
                          showListView = false;
                          navigateToNextScreen();
                        });
                      });



                    }
                    else if(widget.dataList!.data![currentIndex].correctAnswer!.split(',').length==count)
                    {
                      stopAudio();
                      playAudio('assets/mp3/Wrong.mp3');
                      isChangeImage=true;
                      showListView = false;
                      navigateToCorrectScreen();

                    }
                    //       else {
                    //
                    //   }
                    // });

                    // setState(() {
                    //   _isFirstImage = !_isFirstImage;
                    //   emptyCards.removeAt(count);
                    //   print("Count $count");
                    //   print("Index $index");
                    //
                    //     emptyCards.insert(count, dataModel.options[index]);
                    //     replaceImage(count);
                    //     row2Items.removeAt(index);
                    //     rowImage.removeAt(index);
                    //     count++;
                    //
                    //   // emptyCards.insert(count, rowImage[index]);
                    //
                    //    print(emptyCards[count]);
                    //    print(dataModel.options[index]);
                    //    print(dataModel.options[index]);
                    //    if(dataModel.options[index]==dataModel.options[index])
                    //      {
                    //        data++;
                    //      }
                    //   print("datacount $data");
                    // });
                    //
                    // if(!row1Items.contains('assets/newUi/tap.png') && dataModel.options[index]==emptyCards[index])
                    //   if(dataModel.options[index]==emptyCards[index] && !row1Items.contains('assets/newUi/tap.png'))
                    //   {
                    //   _isTimerRunning=true;
                    //   stopProgress();
                    //   Future.delayed(
                    //     Duration.zero,
                    //         () => showDialog(
                    //         context: context, builder: (context) => WinDialog()),
                    //   );
                    //   Timer(const Duration(seconds: 2), () {
                    //     Navigator.of(context).pop();
                    //     setState(() {
                    //       showListView = false;
                    //       navigateToNextScreen();
                    //     });
                    //   });
                    //
                    // }
                    // else {
                    //     Future.delayed(
                    //       Duration.zero,
                    //           () => showDialog(
                    //           context: context, builder: (context) => TimeUp(title: '', dataList: dataList, currentIndex: currentIndex)),
                    //     );
                    //     Timer(const Duration(seconds: 2), () {
                    //       Navigator.of(context).pop();
                    //       setState(() {
                    //         showListView = false;
                    //         navigateToNextScreen();
                    //       });
                    //     });
                    // }

                  },
                  child:
                  Container(
                    margin: EdgeInsets.only(left: 25),
                    alignment: Alignment.center,
                    width: isTab?130:100.0,
                    height: isTab?MediaQuery.sizeOf(context).height*0.23:100.0,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/newUi/innerimage.png'),
                      ),
                    ),
                    child: AnimatedContainer(
                      padding: isTab?const EdgeInsets.all(20):EdgeInsets.all(15),
                      duration: const Duration(milliseconds: 500),
                      child: ClipRect(
                        child: Center(
                          child: Image.asset(image.image.toString(),
                            width: isTab?115:106.0,
                            height: isTab?MediaQuery.sizeOf(context).height*.23:106.0,
                          ),
                        ),
                      ),
                    ),
                    // child: Container(
                    //   width: 120,
                    //   height: 100,
                    //   child: Center(
                    //     child: Image.asset(row2Items[index]),
                    //   ),
                    // ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }


}

