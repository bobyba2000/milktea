import 'package:equatable/equatable.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../utils/storage_service.dart';

class MainBloc extends Cubit<MainState> {
  MainBloc(MainState initialState) : super(initialState);

  Future<void> getStoreInfo() async {
    EasyLoading.show();
    List<String> listImageUrls =
        await Storage.getAllFilesUrl(storagePath: '/store_image');
    Map storeInfo =
        (await FirebaseDatabase.instance.ref().child('store_info').get()).value
            as Map;
    EasyLoading.dismiss();
    emit(
      state.copyWith(
        listImageUrls: listImageUrls,
        storeVideo: storeInfo['video_url'],
        storeLocation: storeInfo['location'],
      ),
    );
  }
}

class MainState extends Equatable {
  final List<String> listImageUrls;
  final String storeVideo;
  final String storeLocation;

  const MainState({
    this.listImageUrls = const [],
    this.storeVideo = '',
    this.storeLocation = '',
  });

  MainState copyWith(
      {List<String>? listImageUrls,
      String? storeVideo,
      String? storeLocation}) {
    return MainState(
      listImageUrls: listImageUrls ?? this.listImageUrls,
      storeVideo: storeVideo ?? this.storeVideo,
      storeLocation: storeLocation ?? this.storeLocation,
    );
  }

  @override
  List<Object?> get props => [];
}
