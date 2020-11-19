import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:git_repo/blocs/trnding_bloc.dart';
import 'package:git_repo/providers/trending_bloc_provider.dart';
import 'package:shimmer/shimmer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: TrendingBlocProvider(
        child: MyHomePageState(),
      ),
    );
  }
}

class MyHomePageState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trending'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert),
            tooltip: 'Sort',
            onPressed: () {},
          )
        ],
      ),
      body: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TrendingBloc trendingBloc = TrendingBlocProvider.getTendingBloc(context);
    trendingBloc.init(context);
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Container(
          child: ShimmerList(),
        ),
      ],
    );
  }

  Widget headlinesListView(TrendingBloc trendingBloc) {
    return StreamBuilder(
        stream: trendingBloc.headlines,
        builder: (BuildContext context, AsyncSnapshot<List<String>> headlines) {
          if (headlines.hasData) {
            return ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: headlines.data.length,
              itemBuilder: (BuildContext context, int index) {
                if (headlines.hasData && headlines.data.length > 0) {
                  return Container(
                    height: 60.0,
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      headlines.data[index],
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 18.0,
                      ),
                    ),
                  );
                } else {
                  return Container();
                }
              },
            );
          } else {
            return Center(
              child: Text('No feed'),
            );
          }
        });
  }
}

class ShimmerList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    int offset = 0;
    int time = 800;

    return SafeArea(
      child: ListView.builder(
        itemCount: 6,
        itemBuilder: (BuildContext context, int index) {
          offset += 5;
          time = 800 + offset;

          print(time);

          return Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Shimmer.fromColors(
                highlightColor: Colors.white,
                baseColor: Colors.grey[300],
                child: ShimmerLayout(),
                period: Duration(milliseconds: time),
              ));
        },
      ),
    );
  }
}

class ShimmerLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double containerWidth = 280;
    double containerHeight = 15;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 7.5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            height: 100,
            width: 100,
            color: Colors.grey,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                height: containerHeight,
                width: containerWidth,
                color: Colors.grey,
              ),
              SizedBox(height: 5),
              Container(
                height: containerHeight,
                width: containerWidth,
                color: Colors.grey,
              ),
              SizedBox(height: 5),
              Container(
                height: containerHeight,
                width: containerWidth * 0.75,
                color: Colors.grey,
              )
            ],
          )
        ],
      ),
    );
  }
}
