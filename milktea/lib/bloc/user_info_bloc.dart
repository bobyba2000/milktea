import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:milktea/utils/storage_service.dart';

class UserInfoState extends Equatable {
  final String? name;
  final String? email;
  final String? photoUrl;
  final bool isImageLocal;

  const UserInfoState({
    this.name,
    this.email,
    this.photoUrl,
    this.isImageLocal = false,
  });

  UserInfoState copyWith({
    String? name,
    String? email,
    String? photoUrl,
    bool? isImageLocal,
  }) {
    var newState = UserInfoState(
      name: name ?? this.name,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      isImageLocal: isImageLocal ?? this.isImageLocal,
    );
    return newState;
  }

  @override
  List<Object?> get props => [name, email, photoUrl, isImageLocal];
}

class UserInfoBloc extends Cubit<UserInfoState> {
  UserInfoBloc(UserInfoState state) : super(state);

  void initState() {}

  void getUserInfo() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final name = user.displayName;
      final email = user.email;
      final photoUrl = user.photoURL;
      emit(
        state.copyWith(
          name: name,
          email: email,
          photoUrl: photoUrl,
        ),
      );
    }
  }

  void updatePhotoUrl(String path, String name) {
    var newState = state.copyWith(
      photoUrl: path,
      isImageLocal: true,
      name: name,
    );
    if (state == newState) {
      print('newState == state');
    } else {
      print('newState != state');
    }
    emit(newState);
  }

  Future<void> updateUserInfo({
    String? name,
  }) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (state.isImageLocal) {
      String url = await Storage.uploadFile(
            state.photoUrl ?? '',
            DateTime.now().toString(),
            '/user_image',
          ) ??
          '';
      await user?.updatePhotoURL(url);
    }
    await user?.updateDisplayName(name);
  }
}
