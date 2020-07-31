import 'package:flutter/cupertino.dart';
import 'package:gupshop/widgets/customRaisedButton.dart';

class Categories extends StatefulWidget {
  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  @override
  Widget build(BuildContext context) {
    return CustomRaisedButton(
      onPressed: () async{
        bool _isSelected = await _categorySelectorCheckListDialogBox(context);
        setState(() {
          /// toDo - find why isCategorySelected is null if no category is selected
          isCategorySelected = _isSelected;
          print("isCategorySelected: $isCategorySelected");
        });
      },
      child: Text("Select from category",style: GoogleFonts.openSans()),
    );
  }

  getCategories(BuildContext context){
    return CustomRaisedButton(
      onPressed: () async{
        bool _isSelected = await _categorySelectorCheckListDialogBox(context);
        setState(() {
          /// toDo - find why isCategorySelected is null if no category is selected
          isCategorySelected = _isSelected;
          print("isCategorySelected: $isCategorySelected");
        });
      },
      child: Text("Select from category",style: GoogleFonts.openSans()),
    );
  }

  Future<bool> _categorySelectorCheckListDialogBox(BuildContext context){
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context){
          return AlertDialog(
            content: StatefulBuilder(
              builder: (context, StateSetter setState){
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    CustomRaisedButton(
                      child: CustomText(text: 'back',),
                      onPressed: (){
                        Navigator.of(context).pop(false);
                      },
                    ),
                    /// A RenderFlex overflowed by 299361 pixels on the bottom.
                    /// solution - use Container and constraints
                    Container(//toDo- make the size of the container flexible
                      height: 300,
                      width: 300,
                      child: ListView.builder(
                          itemCount: map.length,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            String categoryName = map.keys.elementAt(index);///getting key in string from index in a map
                            ///RenderFlex children have non-zero flex but incoming height constraints are unbounded.
                            return Container(//container was wrapped with sized box before, but we dont need it because we are using column and  flexible which are giving sizes
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Flexible(
                                    fit: FlexFit.loose,
                                    flex: 1,
                                    child: CheckboxListTile(
                                      title: CustomText(text: categoryName,),
                                      value: map[categoryName] == null ? false : map[categoryName],
                                      //inputs[index],
                                      //controlAffinity: ListTileControlAffinity.leading,
                                      onChanged: (bool val){
                                        setState(() {
                                          map[categoryName] = val; /// setting the new value as selected by user
                                          print("map[categoryName] : ${map[categoryName]}");
                                          print("map in onChanged: $map");
                                          isCategorySelected = categorySelected();
                                          print("isSelected: $isCategorySelected");
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                      ),
                    ),
                    MaterialButton(
                      onPressed: (){
                        // pushCategorySelectedToFirebase();
                        if(categorySelected() == true){
                          Navigator.of(context).pop(true);
                        }
                        else Navigator.of(context).pop(false);
                      },
                      child: categorySelected() ? Text("Save") : null,
                      //child: ifNoCategorySelected() ? Text("Save") : Text("Required"),//flip and show save once and required once
                    ),
                  ],
                );
              },
            ),
          );
        }
    );
  }
}
