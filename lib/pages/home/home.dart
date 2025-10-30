import 'package:apni_ride_user/pages/home/wallet.dart';
import 'package:flutter/material.dart';

import '../../config/constant.dart';
import 'dashboard.dart';
import 'earnings.dart';

//const Color primaryColor = Colors.blue;

class BottomBarView extends StatefulWidget {
  BottomBarView({
    Key? key,
    required this.tabIconsList,
    required this.changeIndex,
    this.addClick,
    this.isTapDisabled = false,
  }) : super(key: key);

  final List<TabIconData> tabIconsList;
  final Function(int index) changeIndex;
  final Function()? addClick;
  bool isTapDisabled;

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
                      isTapDisabled: widget.isTapDisabled,
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

class TabIcons extends StatelessWidget {
  const TabIcons({
    Key? key,
    required this.tabIconData,
    required this.removeAllSelect,
    this.isTapDisabled = false,
  }) : super(key: key);

  final TabIconData tabIconData;
  final Function() removeAllSelect;
  final bool isTapDisabled;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Center(
        child: InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () {
            if (isTapDisabled || tabIconData.isSelected) return;
            removeAllSelect();
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              Image.asset(
                tabIconData.isSelected
                    ? tabIconData.selectedImagePath
                    : tabIconData.imagePath,
                color:
                    tabIconData.isSelected
                        ? Theme.of(context).primaryColor
                        : Colors.grey,
              ),
              if (tabIconData.isSelected)
                Positioned(
                  bottom: 4,
                  child: Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: primaryColor,
                      shape: BoxShape.circle,
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
  });

  String imagePath;
  String selectedImagePath;
  bool isSelected;
  int index;

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
    ),
    TabIconData(
      imagePath: 'assets/images/wallet.png',
      selectedImagePath: 'assets/images/selected_wallet.png',
      index: 2,
    ),
  ];
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  //AnimationController? animationController;
  List<TabIconData> tabIconsList = TabIconData.tabIconsList;
  Widget tabBody = const Dashboard();
  bool _isDialogShowing = false;

  @override
  void initState() {
    tabIconsList.forEach((tab) => tab.isSelected = false);
    tabIconsList[0].isSelected = true;
    /* animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );*/
    super.initState();
  }

  @override
  void dispose() {
    //animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tabBody,
      bottomNavigationBar: BottomBarView(
        tabIconsList: tabIconsList,
        isTapDisabled: _isDialogShowing, // Pass flag

        changeIndex: (index) {
          /*  animationController?.reverse().then((_) {*/
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
          // });
        },
      ),
    );
  }
}
