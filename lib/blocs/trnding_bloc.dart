import 'dart:async';
import 'dart:convert';
import 'package:git_repo/model/trending_repo_model.dart';
import 'package:git_repo/utils/connectivity_util.dart';
import 'package:git_repo/utils/network_util.dart';
import 'package:git_repo/utils/prefs_util.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:charts_flutter/flutter.dart' as charts;

class TrendingBloc {
  static final TrendingBloc _accountBloc = TrendingBloc._();
  factory TrendingBloc() => _accountBloc;
  TrendingBloc._() {
    _connectivityUtil = ConnectivityUtil();
  }

  Timer autoRefreshTimer;
  ConnectivityUtil _connectivityUtil = ConnectivityUtil();
  NetworkUtil _networkUtil = NetworkUtil();
  PrefsUtil _prefsUtil = PrefsUtil();

  List<String> headlinesList = [];
  List<TrendingRepoModel> interestdata = [];
  bool isActive = true;
  int page = 1;

  TextEditingController searchController = TextEditingController();
  TextEditingController searchEverythingController = TextEditingController();

  final _searchData = BehaviorSubject<String>();
  final _searchEverythingData = BehaviorSubject<String>();
  BehaviorSubject<List<String>> _headlines =
      BehaviorSubject<List<String>>.seeded([]);
  BehaviorSubject<List<TrendingRepoModel>> _interestData =
      BehaviorSubject<List<TrendingRepoModel>>.seeded([]);
  BehaviorSubject<bool> _isAutoRefreshEnabled =
      BehaviorSubject<bool>.seeded(false);

  Stream<String> get searchData => _searchData.stream;
  String get searchDataValue => _searchData.value;
  Function(String) get updateSearchData => _searchData.sink.add;
  Stream<String> get searchEverythingData => _searchEverythingData.stream;
  Function(String) get updateSearchEverythingData =>
      _searchEverythingData.sink.add;
  Stream<List<String>> get headlines => _headlines.stream;
  Function(List<String>) get updateHeadlines => _headlines.sink.add;
  Stream<List<TrendingRepoModel>> get interestData => _interestData.stream;
  List<TrendingRepoModel> get interestDataValue => _interestData.value;
  Function(List<TrendingRepoModel>) get updateInterestData =>
      _interestData.sink.add;
  Stream<bool> get isAutoRefreshEnabled => _isAutoRefreshEnabled.stream;
  Function(bool) get updateIsAutoRefreshEnabled =>
      _isAutoRefreshEnabled.sink.add;

  void dispose() {
    _searchEverythingData.close();
    _searchData.close();
    _headlines.close();
    _interestData.close();
    _isAutoRefreshEnabled.close();
  }

  Future<bool> clearAll() async {
    return true;
  }

  void init(BuildContext context) async {
    ConnectivityUtil().init(context);
    loadTraendingRepoFromApi();
    Map<String, dynamic> prefsValues = await _prefsUtil.init();
    headlinesList = prefsValues['headlines'];
    interestdata = prefsValues['interestOverTime'];
    updateHeadlines(headlinesList);
    updateInterestData(interestdata);
  }

  Future loadTraendingRepoFromApi() async {
    if (_connectivityUtil.isConnectionActive && isActive) {
      try {
        http.Response response = await _networkUtil.loadTrendingRepo();
        print(response.statusCode);
        print(response.body);
        if (response.statusCode == 200) {
        } else {
          SnackBar(content: Text(response.body.toString()));
        }
      } catch (ex) {}
    } else {
      SnackBar(content: Text('Network not available.'));
    }
  }
}
