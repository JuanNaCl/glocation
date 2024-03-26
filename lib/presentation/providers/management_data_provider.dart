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

  void writeData(String email,password,fullName,vehicle, List<String> devices) async {
    await Future.delayed(const Duration(seconds: 1));
    try {
      // final user = await authRepository.register(email, password, fullName);
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }
}
final managementDataProvider = StateNotifierProvider<ManagementDataNotifier, ManagementDataState>((ref) {
  return ManagementDataNotifier();
});

