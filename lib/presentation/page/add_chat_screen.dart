import 'package:chatterly/application/search/search_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddChatScreen extends StatelessWidget {
  final TextEditingController _user = TextEditingController();
  AddChatScreen({super.key});

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
          title: BlocBuilder<SearchBloc, SearchState>(
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
                  controller: _user,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    border: InputBorder.none,
                  ),
                  onSubmitted: (value) =>
                      context.read<SearchBloc>().add(SearchUserEvent(value)),
                ),
              );
            },
          ),
          actions: [
            BlocBuilder<SearchBloc, SearchState>(
              builder: (context, state) {
                return IconButton(
                  icon:
                      Icon(state is SearchActive ? Icons.close : Icons.search),
                  onPressed: () {
                    context.read<SearchBloc>().add(ToggleSearchEvent());
                  },
                );
              },
            ),
          ],
        ),
        body: BlocBuilder<SearchBloc, SearchState>(
          builder: (context, state) {
            if (state is SearchLoading) {
              return CircularProgressIndicator();
            } else if (state is SearchSuccess) {
              return ListView.builder(
                itemCount: state.users.length,
                itemBuilder: (context, index) {
                  final user = state.users[index];

                  return ListTile(
                    title: Text(
                      user.name,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      'This is user 1',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                      ),
                    ),
                    leading: CircleAvatar(
                      child: Text('C1'),
                    ),
                  );
                },
              );
            } else if (state is SearchFailure) {
              return Center(
                  child: Text(
                'User not found',
                style: TextStyle(color: Colors.black),
              ));
            } else {
              return Center(child: Text('Search User to start chat'));
            }
          },
        ),
      ),
    );
  }
}
