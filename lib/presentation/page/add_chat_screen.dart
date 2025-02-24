import 'package:chatterly/application/search_animation/search_animation_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddChatScreen extends StatelessWidget {
  const AddChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: BlocBuilder<SearchAnimationBloc, SearchAnimationState>(
            builder: (context, state) {
              return AnimatedCrossFade(
                duration: Duration(milliseconds: 300),
                crossFadeState: state is SearchActive
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                firstChild: Text(
                  'Add Chat',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                secondChild: TextField(
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    border: InputBorder.none,
                  ),
                ),
              );
            },
          ),
          actions: [
            BlocBuilder<SearchAnimationBloc, SearchAnimationState>(
              builder: (context, state) {
                return IconButton(
                  icon:
                      Icon(state is SearchActive ? Icons.close : Icons.search),
                  onPressed: () {
                    context
                        .read<SearchAnimationBloc>()
                        .add(ToggleSearchAnimationEvent());
                  },
                );
              },
            ),
          ],
        ),
        // body: Center(
        //   child: Text('search user to start chat'),
        // ),
        body: ListView(
          padding: EdgeInsets.symmetric(vertical: 10),
          children: [
            ListTile(
              title: Text(
                'User 1',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                'This is user 1',
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
              leading: CircleAvatar(
                child: Text('C1'),
              ),
            ),
            SizedBox(
              height: 5,
            ),
          ],
        ),
      ),
    );
  }
}
