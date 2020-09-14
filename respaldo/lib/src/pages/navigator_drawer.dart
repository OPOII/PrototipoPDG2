import 'package:flutter/material.dart';
import 'package:respaldo/src/helpers/collapsin_list_tile.dart';
import 'package:respaldo/src/helpers/navigation_model.dart';
import 'package:respaldo/src/models/theme.dart';

class NavitagorDrawer extends StatefulWidget {
  @override
  NavigatorDrawerState createState() {
    return new NavigatorDrawerState();
  }
}

class NavigatorDrawerState extends State<NavitagorDrawer>
    with SingleTickerProviderStateMixin {
  double maxWidth = 220;
  double minWidth = 70;
  bool isColllapsed = false;
  AnimationController _animationController;
  Animation<double> widthAnimation;
  int currentSelectedIndex = 0;
  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    widthAnimation = Tween<double>(begin: maxWidth, end: minWidth)
        .animate(_animationController);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _animationController,
        builder: (context, widget) => getWidget(context, widget));
  }

  Widget getWidget(BuildContext context, widget) {
    return Container(
      width: widthAnimation.value,
      color: drawerBackgroundColor,
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 50.0,
          ),
          CollapsingListTile(
            title: 'Cenicaña',
            icon: Icons.person,
            animationController: _animationController,
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, counter) {
                return CollapsingListTile(
                    onTap: () {
                      setState(() {
                        currentSelectedIndex = counter;
                      });
                    },
                    isSelected: currentSelectedIndex == counter,
                    title: navigationItem[counter].title,
                    icon: navigationItem[counter].icon,
                    animationController: _animationController);
              },
              itemCount: navigationItem.length,
            ),
          ),
          InkWell(
            onTap: () {
              setState(() {
                isColllapsed = !isColllapsed;
                isColllapsed
                    ? _animationController.forward()
                    : _animationController.reverse();
              });
            },
            child: AnimatedIcon(
              icon: AnimatedIcons.close_menu,
              progress: _animationController,
              color: Colors.white,
              size: 50,
            ),
          ),
          SizedBox(
            height: 50.0,
          ),
        ],
      ),
    );
  }
}
