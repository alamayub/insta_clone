import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final TextEditingController _searchController = TextEditingController();
  bool _isShowUsers = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextFormField(
          controller: _searchController,
          decoration: InputDecoration(
            labelText: 'Search...',
          ),
          onFieldSubmitted: (String text) {
            print(text);
            setState(() => _isShowUsers = true);
          },
        ),
      ),
      body: _isShowUsers ? FutureBuilder(
        future: FirebaseFirestore.instance.collection('users').where('username', isGreaterThanOrEqualTo: _searchController.text).get(),
        builder: (context, snapshot) {
          if(!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
            shrinkWrap: true,
            itemCount: (snapshot.data! as dynamic).docs.length,
            itemBuilder: (context, index) => ListTile(
              leading: CircleAvatar(backgroundImage: NetworkImage((snapshot.data! as dynamic).docs[index]['imgUrl'])),
              title: Text('${(snapshot.data! as dynamic).docs[index]['username']}'),
            )
          );
        },
      ) : FutureBuilder(
        future: FirebaseFirestore.instance.collection('posts').get(),
        builder: (context, snapshot) {
          if(!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator()
            );
          }
          return StaggeredGridView.countBuilder(
            crossAxisCount: 3,
            itemCount: (snapshot.data! as dynamic).docs.length,
            itemBuilder: (context, index) => Image.network(
              (snapshot.data! as dynamic).docs[index]['postUrl'],
              fit: BoxFit.cover,
            ),
            staggeredTileBuilder: (index) => StaggeredTile.count((index % 7 == 0) ? 2 : 1, (index % 7 == 0) ? 2 : 1),
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          );
        }
      ),
    );
  }
}
