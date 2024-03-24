import 'package:flutter/material.dart';
import '../website_editing_page/main_layout_page.dart';

class PropertiesSection extends StatefulWidget {
  int selectedContainerIndex;
  final List<Widget> dynamicContainers;
  final Function(int) onDeleteContainer;

  PropertiesSection({Key? key, required this.selectedContainerIndex, required this.dynamicContainers, required this.onDeleteContainer,}) : super(key: key);

  @override
  State<PropertiesSection> createState() => _PropertiesSectionState();
}

class _PropertiesSectionState extends State<PropertiesSection> {
  late double _deviceHeight;
  late double _deviceWidth;

 
  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    return Container(
        width: _deviceWidth * 0.19,
        height: _deviceHeight * 0.9,
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  WhatToShow(),
                ],
              ),
            )
          ],
        ));
  }

  Widget WhatToShow() {
     if (widget.selectedContainerIndex > 1) {
      return _deleteButton();
    } else {
      return SizedBox(); // Return an empty SizedBox if conditions are not met
    }
  }

  Widget _deleteButton() {
    return Container(
      height: _deviceHeight * 0.06,
      width: _deviceWidth * 0.06,
      child: FloatingActionButton(
        onPressed: () => widget.onDeleteContainer(widget.selectedContainerIndex),
        child: Text(
          "Delete",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w200),
        ),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
      ),
    );
  }


  void _visibilityOfHeader(){

  }
}
