import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:milktea_server/page/category/category_page.dart';
import 'package:milktea_server/page/menu/menu_page.dart';
import 'package:milktea_server/page/order/order_page.dart';
import 'package:milktea_server/page/user/change_pass_dialog.dart';
import 'package:milktea_server/page/user/user_info_dialog.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  PageController page = PageController();

  bool isExpanded = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SideMenu(
            controller: page,
            style: SideMenuStyle(
              displayMode: isExpanded
                  ? SideMenuDisplayMode.open
                  : SideMenuDisplayMode.compact,
              hoverColor: const Color.fromRGBO(207, 152, 98, 0.5),
              compactSideMenuWidth: 62,
              selectedColor: const Color.fromRGBO(207, 152, 98, 1),
              selectedTitleTextStyle: const TextStyle(color: Colors.white),
              selectedIconColor: Colors.white,
              backgroundColor: Colors.white,
              iconSize: 36,
            ),
            title: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: isExpanded ? 80 : 50,
                          maxWidth: isExpanded ? 80 : 50,
                        ),
                        child: Image.asset(
                          'images/logo.png',
                        ),
                      ),
                      onTap: () {
                        if (!isExpanded) {
                          setState(() {
                            isExpanded = true;
                          });
                        }
                      },
                    ),
                    Visibility(
                      visible: isExpanded,
                      child: InkWell(
                        child: Container(
                          margin: const EdgeInsets.only(right: 10),
                          padding: const EdgeInsets.all(10),
                          child: const Icon(
                            Icons.arrow_back,
                            color: Colors.black,
                            size: 20,
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            isExpanded = false;
                          });
                        },
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 40),
                const Divider(
                  indent: 8.0,
                  endIndent: 8.0,
                ),
              ],
            ),
            items: [
              SideMenuItem(
                priority: 0,
                title: 'Menu',
                onTap: () {
                  page.jumpToPage(0);
                },
                icon: const Icon(Icons.local_dining),
              ),
              SideMenuItem(
                priority: 1,
                title: 'Danh mục',
                onTap: () {
                  page.jumpToPage(1);
                },
                icon: const Icon(Icons.apps),
              ),
              SideMenuItem(
                priority: 2,
                title: 'Đơn Hàng',
                onTap: () {
                  page.jumpToPage(2);
                },
                icon: const Icon(Icons.assignment),
              ),
            ],
          ),
          Expanded(
            child: Container(
              color: const Color.fromARGB(255, 241, 241, 241),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  PopupMenuButton(
                    tooltip: '',
                    itemBuilder: (BuildContext context) => [
                      PopupMenuItem(
                        child: const Text(
                          'Thông tin cá nhân',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w400),
                        ),
                        onTap: () {
                          Future.delayed(
                            const Duration(seconds: 0),
                            () => showDialog(
                              context: context,
                              builder: (context) => const AlertDialog(
                                title: Text(
                                  'Thông tin cá nhân',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                content: UserInfoDialog(),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      PopupMenuItem(
                        child: const Text(
                          'Đổi mật khẩu',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w400),
                        ),
                        onTap: () async {
                          Future.delayed(
                            const Duration(seconds: 0),
                            () => showDialog(
                              context: context,
                              builder: (context) => const AlertDialog(
                                title: Text(
                                  'Đổi mật khẩu',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                content: ChangePassDialog(),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      PopupMenuItem(
                        child: const Text(
                          'Đăng xuất',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w400),
                        ),
                        onTap: () {
                          FirebaseAuth.instance.signOut();
                        },
                      )
                    ],
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).primaryColor,
                      ),
                      padding: const EdgeInsets.all(8),
                      margin: const EdgeInsets.only(top: 40, right: 40),
                      child: const Icon(
                        Icons.account_box,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                  Expanded(
                    child: PageView(
                      controller: page,
                      children: [
                        Container(
                          color: const Color.fromARGB(255, 241, 241, 241),
                          child: const Padding(
                            padding: EdgeInsets.all(24),
                            child: MenuPage(),
                          ),
                        ),
                        Container(
                          color: const Color.fromARGB(255, 241, 241, 241),
                          child: const Center(
                            child: Padding(
                              padding: EdgeInsets.all(24),
                              child: CategoryPage(),
                            ),
                          ),
                        ),
                        Container(
                          color: const Color.fromARGB(255, 241, 241, 241),
                          child: const Center(
                            child: Padding(
                              padding: EdgeInsets.all(24),
                              child: OrderPage(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
