import 'package:flutter/material.dart';
import 'package:halfwaiteradminapp/Model_Classes/ParentCategoryListModel.dart';
import 'package:halfwaiteradminapp/SidebarItems/navigation_bloc.dart';
import 'package:http/http.dart' as http;

class ParentCategoryList extends StatefulWidget with NavigationStates {
  final id,name;

  ParentCategoryList(this.id, this.name);

  @override
  _ParentCategoryListState createState() => _ParentCategoryListState();
}

class _ParentCategoryListState extends State<ParentCategoryList> {
  List<Datum> parentcategoryName = [];
  int _selectedIndex ;


//  _onSelected(int index) {
//    setState(() => _selectedIndex = index);
//    Navigator.push(
//      context,
//      MaterialPageRoute(builder: (context) => SiteTabView(sitesName[index].siteName,sitesName[index].siteId)),
//    );
//  }

  @override
  Widget build(BuildContext context) {

    return Stack(
      children: <Widget>[
        Positioned(
          top: 24.3,
          left: 0,
          right: 0,
          bottom: 0,
          child: getInitialRow(),
        ),
        Positioned(
          top: 145,
          left: 0,
          right: 0,
          bottom: 0,
          child: getCard(context),

        )
      ],
    );
  }

  Widget getInitialRow() {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        height: 122,
        child: Card(
          elevation: 5,
          margin: EdgeInsets.all(0.0),
          color: Colors.white70,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left:50.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width - 160,
                      height: 60,
                      child: Card(
                        child: Center(child: Text('Parent Category List',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16))),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: CircleAvatar(
                        radius: 28,
                        backgroundColor: Colors.deepOrangeAccent,
                        child: IconButton(
                          splashColor: Colors.blue,
                          icon: Icon(
                            Icons.dashboard,
                            size: 28,
                            color: Colors.black,
                          ),
                          tooltip: "DashBoard",
                          onPressed: () {
//                            Navigator.pushReplacement(
//                              context,
//                              MaterialPageRoute(
//                                  builder: (context) =>
//                                      DashBoardManager(widget.id, widget.name)),
//                            );
                          },
                        )),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget getCard(context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        clipBehavior: Clip.antiAlias,
        elevation: 2,
        child: getElementList(),
      ),
    );
  }

  Widget getFirstView(){
    return Container(
        child : FutureBuilder(
            future: _fetchListItem(widget.id),
            builder: (context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return Padding(
                  padding: const EdgeInsets.only(top: 200.0),
                  child: Center(
                      child: Column(
                        children: <Widget>[
                          if (snapshot.error == null) ...[
                            CircularProgressIndicator(),
                          ],
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              snapshot.error == null
                                  ? "Please Wait ..."
                                  : "There Is No Any Menu List",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      )),
                );
              } else {
                return Container(
                    child: ListView.builder(
                        padding: EdgeInsets.only(top: 6),
                        itemCount: parentcategoryName.length,
                        itemBuilder: (BuildContext context, int position) {
                          return getRow(position);
                        }));
              }
            })
    );
  }

  Widget getRow(int index){
    return Card(

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4.0),
        side: BorderSide(color: Colors.white10, width: 1),
      ),
      margin: EdgeInsets.only(top: 4.0, left: 8, right: 8, bottom: 4.0),
      color: _selectedIndex != null && _selectedIndex == index
          ? Colors.lightBlueAccent
          : Colors.white70,
      child: ListTile(
        contentPadding: EdgeInsets.only(left : 10.0,top: 0,bottom: 0,right: 10.0),
        title: Text("${index+1}. "+ parentcategoryName[index].name),
//        subtitle: Text("     "+categoryName[index].parentCat),
        onTap: () {

//          _onSelected(index);
        },
      ),
    );
  }

  _fetchListItem(userId) async {
    String dataURL = "https://www.admin.halfwaiter.com/api/request/parentCategory";
    http.Response response = await http.get(dataURL,headers: {"x-api-key": r"Eprim@Res!"});
    parentcategoryName.clear();
    for (Datum  datum  in parentCategoryListModelFromJson(response.body).data) {

      parentcategoryName.add(datum);
    }
    return parentcategoryName;
  }

  Widget getElementList() {
    return Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: getFirstView()
    );
  }
}