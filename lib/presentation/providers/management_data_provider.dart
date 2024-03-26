import 'package:glocation/services/sqlite/glocation_crud_db.dart';
import 'package:riverpod/riverpod.dart';


enum AuthStatus { checking, authenticated, unauthenticated }

class ManagementDataState{
  final AuthStatus status;
  final String errorMessage;
  ManagementDataState({
    this.status = AuthStatus.checking,
    this.errorMessage = '',
  });
  ManagementDataState copyWith({
    AuthStatus? status,
    String? errorMessage,
  }) {
    return ManagementDataState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}


class ManagementDataNotifier extends StateNotifier<ManagementDataState>{
  ManagementDataNotifier() : super(ManagementDataState()){
    checkAuthStatus();
  }
  void checkAuthStatus() async {
    await Future.delayed(const Duration(seconds: 1));
    state = state.copyWith(status: AuthStatus.authenticated);
  }

  Future<bool> writeData(String email,password,fullName,vehicle, devices) async {
    await Future.delayed(const Duration(seconds: 1));
    try {
      print("Paso caca");
      await GlocationDB().create(title: fullName,email: email,password: password,vehicle: vehicle,devices: devices);
      return true;
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
      return false;
    }
  }
}
final managementDataProvider = StateNotifierProvider<ManagementDataNotifier, ManagementDataState>((ref) {
  return ManagementDataNotifier();
});

