import 'package:diy_website/pages/website_editing_page/properties_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:dotted_border/dotted_border.dart';

class WebsiteEditingPage extends StatefulWidget {
  @override
  State<WebsiteEditingPage> createState() => _WebsiteEditingPageState();
}

class _WebsiteEditingPageState extends State<WebsiteEditingPage> {
  @override
  late double _deviceHeight;

  late double _deviceWidth;

  int _selectedToggleButton = 0;
  bool _isHeaderSelected = false;
  bool _isFooterSelected = false;
  int _selectedContainerIndex = -1;

  List<Widget> _dynamicContainers = [];

  @override
  void initState() {
    super.initState();
    //_dynamicContainers.add(_buildContainer());
    _dynamicContainers.add(_addIconButton());
  }

  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Container(
          height: _deviceHeight,
          width: _deviceWidth * 0.1,
          decoration: BoxDecoration(
            color: Colors.white,
          ),
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Container(
                height: _deviceHeight * 0.1,
                width: _deviceWidth,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 235, 129, 164),
                ),
                child: Padding(
                  padding: EdgeInsets.only(
                      left: _deviceWidth * 0.05, right: _deviceWidth * 0.05),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          _buildToggleButton(0, "Edit"),
                          _buildToggleButton(1, "View"),
                        ],
                      ),
                      Container(
                        height: _deviceHeight * 0.06,
                        width: _deviceWidth * 0.06,
                        child: FloatingActionButton(
                          onPressed: null,
                          child: Text(
                            "Save",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w200),
                          ),
                          backgroundColor: Colors.purple,
                          foregroundColor: Colors.white,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  //editor container
                  Padding(
                    padding: EdgeInsets.only(
                        left: _deviceWidth * 0.015, top: _deviceHeight * 0.023),
                    child: Container(
                      height: _deviceHeight * 0.85,
                      width: _deviceWidth * 0.68,
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            _buildHeaderSection(),
                            _buildDynamicContainersList(),
                            _buildFooterSection(),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: _deviceWidth * 0.015),
                    child: PropertiesSection(
                      selectedContainerIndex: _selectedContainerIndex,
                      dynamicContainers: _dynamicContainers,
                      onDeleteContainer: _deleteContainer,
                      ),
                  )
                ],
              )
            ],
          ),
        )
      ],
    );
  }

  Widget _buildToggleButton(int index, String label) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedToggleButton = index;
        });
      },
      child: Container(
        height: _deviceHeight * 0.06,
        width: _deviceWidth * 0.06,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: _selectedToggleButton == index
              ? Colors.purple
              : Color.fromARGB(255, 65, 63, 63),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w200,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedContainerIndex = 0;
          // _isHeaderSelected = !_isHeaderSelected;
        });
      },
      child: _buildDottedContainer(
        isDynamicContainer: false,
        index: 0,
        isSelected: _selectedContainerIndex == 0,
        child: Center(child: Text("Header")),
      ),
    );
  }

  Widget _buildFooterSection() {
    return GestureDetector(
      onTap: () {
        setState(() {
          //_isFooterSelected = !_isFooterSelected;
          _selectedContainerIndex = 1;
        });
      },
      child: _buildDottedContainer(
        isDynamicContainer: false,
        index: 1,
        isSelected: _selectedContainerIndex == 1,
        child: Center(child: Text("Footer")),
      ),
    );
  }

  //  Widget _buildDynamicContainersList() {
  //   return ListView.builder(
  //     shrinkWrap: true,
  //     itemCount: _dynamicContainers.length,
  //     itemBuilder: (context, index) {
  //       return _dynamicContainers[index];
  //     },
  //   );
  // }

Widget _buildDynamicContainersList() {
  // Find the index of the addButton in _dynamicContainers
  int addButtonIndex = _dynamicContainers.length - 1;

  return ReorderableListView(
    shrinkWrap: true,
    padding: EdgeInsets.all(0.1),
    children: _dynamicContainers
        .asMap()
        .map((index, widget) {
          return MapEntry(
            index,
            KeyedSubtree(
              key: ValueKey(index),
              child: index==addButtonIndex? _addIconButton() : 
              _buildDottedContainer(
                isDynamicContainer: true,
                index: index + 2, // Adding 2 for header and footer
                isSelected: _selectedContainerIndex == index + 2,
                child: _buildReorderableWidget(index, widget),
              ),
            ),
          );
        })
        .values
        .toList(),
    onReorder: (oldIndex, newIndex) {
      setState(() {
        if (oldIndex == addButtonIndex || newIndex == addButtonIndex) {
          // Disable reordering if the addButton is involved
          return;
        }
        if (oldIndex < newIndex) {
          newIndex -= 1;
        }
        final Widget item = _dynamicContainers.removeAt(oldIndex);
        _dynamicContainers.insert(newIndex, item);
      });
    },
  );
}

Widget _buildReorderableWidget(int index, Widget widget) {
  if (index == _dynamicContainers.length - 1) {
    // Return the addButton widget without making it reorderable
    return widget;
  }
  return KeyedSubtree(
    key: ValueKey(index),
    child: widget,
  );
}


  void _addNewContainer() {
    setState(() {
      _dynamicContainers.removeAt(_dynamicContainers.length - 1);
      _dynamicContainers.add(
        Container(
          height: _deviceHeight * 0.3,
          width: _deviceWidth * 0.68,
          color: Color.fromARGB(255, 234, 148, 44),
          child: Center(
            child: Text(
              "New Container",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      );
      _dynamicContainers.add(_addIconButton());
    });
  }

  Widget _addIconButton() {
    return IconButton(
      onPressed: _addNewContainer,
      icon: Icon(
        Icons.add,
        color: Colors.black,
      ),
    );
  }

  //   Widget _buildDottedContainer({required bool isSelected, required Widget child}) {
  //   return DottedBorder(
  //     color: isSelected ? Colors.black : Colors.transparent,
  //     strokeWidth: 2,
  //     dashPattern: [5, 5],
  //     child: Container(
  //       height: _deviceHeight * 0.15,
  //       width: _deviceWidth * 0.68,
  //       decoration: BoxDecoration(
  //         color: Color.fromARGB(255, 235, 81, 174),
  //       ),
  //       child: child,
  //     ),

  //   );

  // }

  Widget _buildDottedContainer(
      {required bool isDynamicContainer,
      required int index,
      required bool isSelected,
      required Widget child}) {
    double containerHeight =
        isDynamicContainer ? _deviceHeight * 0.3 : _deviceHeight * 0.15;
    double containerWidth = _deviceWidth * 0.68;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedContainerIndex = index;
        });
      },
      child: DottedBorder(
        color: isSelected ? Colors.black : Colors.transparent,
        strokeWidth: 1,
        dashPattern: [4, 4],
        child: Container(
          height: containerHeight,
          width: containerWidth,
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 235, 81, 174),
          ),
          child: child,
        ),
      ),
    );
  }


void _deleteContainer(int index) {
  setState(() {
    if (_dynamicContainers.length == 1) {
      // If there's only one container left, remove it and reset the selected index
      _dynamicContainers.removeAt(index);
      _selectedContainerIndex = -1;
    } else if (index < 2 || index >= _dynamicContainers.length + 1) {
      // Do not delete header, footer, or if index is out of bounds
      return;
    } else {
      // Adjust the selected index if needed
      if (_selectedContainerIndex == index) {
        _selectedContainerIndex = -1; // Reset selected index if the deleted container was selected
      } else if (_selectedContainerIndex > index) {
        _selectedContainerIndex -= 1; // Decrement selected index if it was after the deleted container
      }
      _dynamicContainers.removeAt(index); // Remove the container
    }
  });
}



}
