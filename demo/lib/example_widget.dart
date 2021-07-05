import 'package:flutter/widgets.dart';

abstract class ExampleStatelessWidget extends StatelessWidget {
  Widget buildChild(int value) {
    return Container(child: Center(child: Text('Child $value')));
  }
}
