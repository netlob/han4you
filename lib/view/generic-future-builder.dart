import 'package:flutter/material.dart';

typedef void ErrorCallback(Exception exception);
typedef Widget DataBuilder<T>(T data);

class GenericFutureBuilder<T> extends StatelessWidget {
  final Future<T> future;
  final DataBuilder<T> builder;

  const GenericFutureBuilder({
    Key key,
    @required this.future,
    @required this.builder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: future,
      builder: (context, snapshot) {
        if(snapshot.connectionState != ConnectionState.done) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasData) {
          return builder(snapshot.data);
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(snapshot.error.toString()),
          );
        }

        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
