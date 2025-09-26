import 'package:apni_ride_user/pages/home/wallet.dart';
import 'package:flutter/material.dart';

import '../../config/constant.dart';
import 'dashboard.dart';
import 'earnings.dart';

//const Color primaryColor = Colors.blue;

class BottomBarView extends StatefulWidget {
  const BottomBarView({
    Key? key,
    required this.tabIconsList,
    required this.changeIndex,
    this.addClick,
  }) : super(key: key);

  final List<TabIconData> tabIconsList;
  final Function(int index) changeIndex;
  final Function()? addClick;

  @override
  _BottomBarViewState createState() => _BottomBarViewState();
}

class _BottomBarViewState extends State<BottomBarView>
    with TickerProviderStateMixin {
  AnimationController? animationController;

  @override
  void initState() {
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();
    super.initState();
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          color: Colors.white,
          height: 60,
          child: Row(
            children:
                widget.tabIconsList.asMap().entries.map((entry) {
                  final int index = entry.key;
                  final TabIconData tab = entry.value;
                  return Expanded(
                    child: TabIcons(
                      tabIconData: tab,
                      removeAllSelect: () {
                        setRemoveAllSelection(tab);
                        widget.changeIndex(index);
                      },
                    ),
                  );
                }).toList(),
          ),
        ),
        SizedBox(height: MediaQuery.of(context).padding.bottom),
      ],
    );
  }

  void setRemoveAllSelection(TabIconData? tabIconData) {
    if (!mounted || tabIconData == null) return;
    setState(() {
      widget.tabIconsList.forEach((TabIconData tab) {
        tab.isSelected = tab.index == tabIconData.index;
      });
    });
  }
}

class TabIcons extends StatefulWidget {
  const TabIcons({
    Key? key,
    required this.tabIconData,
    required this.removeAllSelect,
  }) : super(key: key);

  final TabIconData tabIconData;
  final Function() removeAllSelect;

  @override
  _TabIconsState createState() => _TabIconsState();
}

class _TabIconsState extends State<TabIcons> with TickerProviderStateMixin {
  @override
  void initState() {
    widget.tabIconData.animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    )..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (!mounted) return;
        widget.removeAllSelect();
        widget.tabIconData.animationController?.reverse();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    widget.tabIconData.animationController?.dispose();
    super.dispose();
  }

  void setAnimation() {
    widget.tabIconData.animationController?.forward();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Center(
        child: InkWell(
          splashColor: Colors.transparent,
          focusColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
          onTap: () {
            if (!widget.tabIconData.isSelected) {
              setAnimation();
            }
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              ScaleTransition(
                scale: Tween<double>(begin: 0.88, end: 1.0).animate(
                  CurvedAnimation(
                    parent: widget.tabIconData.animationController!,
                    curve: const Interval(
                      0.1,
                      1.0,
                      curve: Curves.fastOutSlowIn,
                    ),
                  ),
                ),
                child: Image.asset(
                  widget.tabIconData.isSelected
                      ? widget.tabIconData.selectedImagePath
                      : widget.tabIconData.imagePath,
                  color:
                      widget.tabIconData.isSelected
                          ? Theme.of(context).primaryColor
                          : Colors.grey,
                  // size: 28,
                ),
              ),
              if (widget.tabIconData.isSelected)
                Positioned(
                  bottom: 4,
                  child: ScaleTransition(
                    scale: Tween<double>(begin: 0.0, end: 1.0).animate(
                      CurvedAnimation(
                        parent: widget.tabIconData.animationController!,
                        curve: const Interval(
                          0.2,
                          1.0,
                          curve: Curves.fastOutSlowIn,
                        ),
                      ),
                    ),
                    child: Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: primaryColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class TabIconData {
  TabIconData({
    required this.imagePath,
    required this.selectedImagePath,
    required this.index,
    this.isSelected = false,
    this.animationController,
  });

  String imagePath;
  String selectedImagePath;
  bool isSelected;
  int index;
  AnimationController? animationController;

  static List<TabIconData> tabIconsList = [
    TabIconData(
      imagePath: 'assets/images/menu.png',
      selectedImagePath: 'assets/images/selected_menu.png',
      index: 0,
      isSelected: true,
    ),
    TabIconData(
      imagePath: 'assets/images/earnings.png',
      selectedImagePath: 'assets/images/selected_earnings.png',
      index: 1,
      isSelected: false,
    ),
    TabIconData(
      imagePath: 'assets/images/wallet.png',
      selectedImagePath: 'assets/images/selected_wallet.png',
      index: 2,
      isSelected: false,
    ),
  ];
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  AnimationController? animationController;
  List<TabIconData> tabIconsList = TabIconData.tabIconsList;
  Widget tabBody = const Dashboard();

  @override
  void initState() {
    tabIconsList.forEach((tab) => tab.isSelected = false);
    tabIconsList[0].isSelected = true;
    animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    super.initState();
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tabBody,
      bottomNavigationBar: BottomBarView(
        tabIconsList: tabIconsList,
        changeIndex: (index) {
          animationController?.reverse().then((_) {
            if (!mounted) return;
            setState(() {
              if (index == 0) {
                tabBody = const Dashboard();
              } else if (index == 1) {
                tabBody = const Earnings();
              } else if (index == 2) {
                tabBody = const Wallet();
              }
            });
          });
        },
      ),
    );
  }
}
