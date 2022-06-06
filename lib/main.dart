import 'package:flutter/material.dart';
import 'package:tweet_list/database.dart';
import 'package:tweet_list/emoji_list.dart';
import 'package:tweet_list/model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Tweet> tweetsDB = [];
  int indexTweet = -1;
  int count = 0;

  createTweets() async {
    for (var i = 0; i < listTweets.length; i++) {
      await DBTweets().insertTweet(listTweets[i]);
    }

    tweetsDB = await DBTweets().getAllTweets();

    for(var i = 0; i < tweetsDB.length; i++){
      if(tweetsDB[i].emoji.isNotEmpty) count += 1;
    }
    print(tweetsDB);
    setState(() {});
  }

  @override
  initState() {
    super.initState();
    createTweets();
  }

  @override
  dispose() {
    super.dispose();
    DBTweets().close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Tweet - Emoji"),
        actions: [
          Icon(Icons.touch_app),
          Center(child: Text('$count',
            style: TextStyle(fontSize: MediaQuery.of(context).textScaleFactor * 25.0),)),
          SizedBox(width: 10.0,)
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                itemCount: tweetsDB.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () async{
                      if(indexTweet !=-1) await DBTweets().updateTweet(tweetsDB[indexTweet]);
                      print(indexTweet);
                      indexTweet = index;
                      setState(() {});
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height / 9.5,
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Card(
                        color: Colors.grey.shade400,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                                flex: 4,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        tweetsDB[index].text,
                                        style: TextStyle(
                                            fontSize: MediaQuery.of(context)
                                                    .textScaleFactor *
                                                15.0),
                                      )),
                                )),
                            Expanded(
                              flex: 2,
                              child: Container(
                                color: Colors.deepPurple.shade300,
                                padding: EdgeInsets.symmetric(horizontal: 3.0),
                                child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: tweetsDB[index].emoji.length,
                                    itemBuilder: (context, ind) {
                                      return Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            tweetsDB[index].emoji[ind],
                                            style: TextStyle(
                                                fontSize: MediaQuery.of(context)
                                                        .textScaleFactor *
                                                    16.0),
                                          ));
                                    }),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                })),
      ),
      bottomSheet: indexTweet != -1 ? BottomAppBar(
        color: Colors.deepPurple.shade50,
        child: Container(
          height: MediaQuery.of(context).size.height * 0.35,
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                    flex: 1,
                    child: ElevatedButton(
                      onPressed: () async{
                        DBTweets().updateTweet(tweetsDB[indexTweet]);
                        indexTweet = -1;
                        setState((){});
                      },
                      style: ElevatedButton.styleFrom(
                          primary: Colors.deepPurple,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          )),
                      child: Text("Готово"),
                    )),
                Expanded(
                  flex: 7,
                  child: Center(
                    child: Wrap(
                      children: [
                        for (var i = 0; i < emoji.length; i++)
                          InkWell(
                            onTap: () {
                              if (tweetsDB[indexTweet].emoji.contains(emoji[i])) {
                                tweetsDB[indexTweet].emoji.remove(emoji[i]);
                                if(tweetsDB[indexTweet].emoji.isEmpty) count -= 1;
                              } else {
                                tweetsDB[indexTweet].emoji.add(emoji[i]);
                                if(tweetsDB[indexTweet].emoji.length == 1) count += 1;
                              }
                              setState(() {});
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: indexTweet != -1 &&
                                          tweetsDB[indexTweet]
                                              .emoji
                                              .contains(emoji[i])
                                      ? Colors.deepPurple.shade300.withOpacity(0.5)
                                      : null),
                              margin: EdgeInsets.all(2.0),
                              padding: EdgeInsets.all(7.0),
                              child: Text(
                                emoji[i],
                                style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).textScaleFactor *
                                            28.0),
                              ),
                            ),
                          )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ) : null,
    );
  }
}
