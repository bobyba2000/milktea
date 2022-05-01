import 'package:equatable/equatable.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:milktea/model/menu_item_model.dart';

class MenuState extends Equatable {
  @override
  List<Object?> get props => [listMenuItem];

  final List<MenuItemModel> listMenuItem;
  final String? textSearch;

  const MenuState({
    this.listMenuItem = const [],
    this.textSearch,
  });

  MenuState copyWith({List<MenuItemModel>? listMenuItem, String? textSearch}) {
    return MenuState(
      listMenuItem: listMenuItem ?? this.listMenuItem,
      textSearch: textSearch ?? this.textSearch,
    );
  }
}

class MenuBloc extends Cubit<MenuState> {
  MenuBloc() : super(const MenuState());

  Future<void> addMenuItem(List<MenuItemModel> item) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref('menu');
    for (MenuItemModel e in item) {
      await ref.push().set({
        'name': e.name,
        'price': e.price,
        'imageUrl': e.imageUrl,
        'type': e.type,
      });
    }
  }

  Future<void> getMenuItem() async {
    EasyLoading.show();
    DataSnapshot response = await FirebaseDatabase.instance.ref('menu').get();
    EasyLoading.dismiss();
    final List<MenuItemModel> listMenuItems = [];
    for (var element in response.children) {
      listMenuItems.add(MenuItemModel.fromJson(element.value));
    }
    emit(state.copyWith(listMenuItem: listMenuItems));
  }

  Future<void> search(String textSearch) async {
    EasyLoading.show();
    DataSnapshot response = await FirebaseDatabase.instance.ref('menu').get();
    EasyLoading.dismiss();
    final List<MenuItemModel> listMenuItems = [];
    for (var element in response.children) {
      listMenuItems.add(MenuItemModel.fromJson(element.value));
    }
    emit(
      state.copyWith(
        textSearch: textSearch,
        listMenuItem: listMenuItems
            .where((element) =>
                element.name
                    ?.toUpperCase()
                    .contains(textSearch.toUpperCase()) ??
                false)
            .toList(),
      ),
    );
  }
}
