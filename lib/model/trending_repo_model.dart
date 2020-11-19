import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class TrendingRepoModel {
  final int articles;
  final String name;
  final charts.Color barolor;

  TrendingRepoModel({
    @required this.articles,
    @required this.name,
    @required this.barolor,
  });
}
