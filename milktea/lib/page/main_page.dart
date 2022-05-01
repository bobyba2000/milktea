import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:milktea/bloc/main_bloc.dart';
import 'package:milktea/model/order_model.dart';
import 'package:milktea/page/home_page.dart';
import 'package:milktea/page/menu/menu_page.dart';
import 'package:milktea/page/user/user_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<MainPage> {
  int _selectIndex = 1;
  late PageController pageController;
  late OrderModel orderModel;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: _selectIndex);
    orderModel = OrderModel(
      listOrderItem: [],
      userID: FirebaseAuth.instance.currentUser?.uid ?? '',
    );
  }

  void onChangePage(int index) {
    setState(() {
      _selectIndex = index;
    });
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: BlocProvider(
          create: (_) => MainBloc(const MainState())..getStoreInfo(),
          child: BlocBuilder<MainBloc, MainState>(
            builder: (context, state) => PageView(
              onPageChanged: ((value) {
                setState(() {
                  _selectIndex = value;
                });
              }),
              controller: pageController,
              children: [
                MenuPage(
                  onChangeOrder: (orderModel) {
                    setState(() {
                      this.orderModel = orderModel;
                    });
                  },
                  orderModel: orderModel,
                ),
                HomePage(
                  listImageUrls: state.listImageUrls,
                  youtubeUrl: state.storeVideo,
                  location: state.storeLocation,
                ),
                const UserPage(),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
              icon: Icon(
                Iconsax.cake,
                size: 20,
              ),
              label: 'Menu',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Iconsax.home,
                size: 20,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Iconsax.user,
                size: 20,
              ),
              label: 'Account',
            ),
          ],
          currentIndex: _selectIndex,
          selectedItemColor: Theme.of(context).primaryColor,
          unselectedItemColor: Colors.grey,
          onTap: onChangePage,
        ),
      ),
    );
  }
}
