import 'package:flutter/material.dart';
import 'package:git_repo/blocs/trnding_bloc.dart';

class TrendingBlocProvider extends InheritedWidget {
  final TrendingBloc _headlinesBloc = TrendingBloc();

  TrendingBlocProvider({Key key, Widget child}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;

  static TrendingBloc getTendingBloc(BuildContext context) =>
      (context.dependOnInheritedWidgetOfExactType<TrendingBlocProvider>())
          ._headlinesBloc;
}
