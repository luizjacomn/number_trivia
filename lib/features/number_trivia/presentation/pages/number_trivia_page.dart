import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../injection_container.dart';
import '../bloc/bloc.dart';
import '../widgets/loading_widget.dart';
import '../widgets/message_display.dart';
import '../widgets/trivia_controls.dart';
import '../widgets/trivia_display.dart';

class NumberTriviaPage extends StatelessWidget {
  const NumberTriviaPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Number Trivia'),
      ),
      body: SingleChildScrollView(child: _buildBody(context)),
    );
  }

  BlocProvider<NumberTriviaBloc> _buildBody(context) {
    return BlocProvider(
      builder: (_) => sl<NumberTriviaBloc>(),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
                builder: (context, state) {
                  final height = MediaQuery.of(context).size.height;
                  if (state is Empty) {
                    return MessageDisplay(message: 'Start searching ...');
                  }

                  if (state is Loading) {
                    return LoadingWidget();
                  }

                  if (state is Loaded) {
                    return TriviaDisplay(numberTrivia: state.trivia);
                  }

                  if (state is Error) {
                    return MessageDisplay(message: state.message);
                  }

                  return Container(
                    height: height / 3,
                    child: Placeholder(),
                  );
                },
              ),
              const SizedBox(height: 16.0),
              const TriviaControls(),
            ],
          ),
        ),
      ),
    );
  }
}
