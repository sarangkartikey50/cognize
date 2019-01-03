// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';



const double _kPickerSheetHeight = 216.0;
const double _kPickerItemHeight = 32.0;

class CupertinoPickerWidget extends StatefulWidget {

  _CupertinoPickerState _state;
  List<String> _items;

  CupertinoPickerWidget(List<String> items){
    print(items);
    _items = items;
    _state = new _CupertinoPickerState(_items);
  }

  String get getValue => _state.getValue;

  @override
  _CupertinoPickerState createState() => _state;
}

class _CupertinoPickerState extends State<CupertinoPickerWidget> {
  int _selectedItemIndex = 0;
  List<String> _items;
  double _width = 150.0;

  _CupertinoPickerState(List<String> items){
    _items = items;
  }

  String get getValue => _items[_selectedItemIndex];

  Widget _buildMenu(BuildContext context) {
    return new Container(
      padding: const EdgeInsets.only(top: 5.0),
      child: new Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          new Container(
            child: new Column(
              children: <Widget>[
                new Container(
                    width: _width,
                    child: new Text(
                      _items[_selectedItemIndex],
                      style: new TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.white
                      ),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    )
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomPicker() {
    final FixedExtentScrollController scrollController = new FixedExtentScrollController(initialItem: _selectedItemIndex);

    return new Container(
      height: _kPickerSheetHeight,
      color: CupertinoColors.white,
      child: new DefaultTextStyle(
        style: const TextStyle(
          color: CupertinoColors.black,
          fontSize: 22.0,
          fontFamily: 'GoogleSans',
          fontWeight: FontWeight.w400
        ),
        child: new GestureDetector(
          // Blocks taps from propagating to the modal sheet and popping.
          onTap: () {},
          child: new SafeArea(
            child: new CupertinoPicker(
              scrollController: scrollController,
              itemExtent: _kPickerItemHeight,
              backgroundColor: CupertinoColors.white,
              onSelectedItemChanged: (int index) {
                setState(() {
                  _selectedItemIndex = index;
                });
              },
              children: new List<Widget>.generate(_items.length, (int index) {
                return new Center(child:
                new Text(_items[index]),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new GestureDetector(
        onTap: () async {
          await showModalBottomSheet<void>(
            context: context,
            builder: (BuildContext context) {
              return _buildBottomPicker();
            },
          );
        },
        child: _buildMenu(context),
      ),
    );
  }
}
