import 'package:flutter/material.dart';

class Search extends StatefulWidget {
  const Search({ Key? key }) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {

  TextEditingController _searchQueryController = TextEditingController();
  bool _isSearching = false;
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.grey[700]),
        elevation: 0.0,
        backgroundColor: Colors.white,
        title: Text("Search", style: TextStyle(color: Colors.black),),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),   
              color: Colors.grey[300],
            ),
            child: Padding(
              padding: EdgeInsets.all(5.0),
              child: Material(
                color: Colors.grey[300],
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(Icons.search,color: Colors.grey[700]),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration.collapsed(
                          hintText: ' Search by name',
                        ),
                        controller: _searchQueryController,
                        onChanged: (value) {
                          setState(() {
                            searchQuery = value.toString();
                          });
                          print(searchQuery);
                        },
                      ),
                    ),
                    InkWell(
                      child: Icon(Icons.close, color: Colors.grey[700],),
                      onTap: () {
                        _searchQueryController.clear();
                        setState(() {
                          searchQuery = '';
                        });
                      },
                    )
                  ],
                ),
              ),
            )
          ) ,
        ),
      ),
      body: ListView(
        
      ),
    );
  }  
}