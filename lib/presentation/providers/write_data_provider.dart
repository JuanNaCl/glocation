import 'package:formz/formz.dart';
import 'package:glocation/presentation/providers/management_data_provider.dart';
import 'package:glocation/presentation/shared/inputs/inputs.dart';
import 'package:riverpod/riverpod.dart';





//Creación
class RegisterFormState {
  final bool complete;
  final bool isPosting;
  final bool isFormPosted;
  final bool isValid;
  final String vehicle;
  final List<String> devices;
  final Name name;
  final Email email;
  final Password password;

  RegisterFormState(
      {
      this.complete = false,
      this.isPosting = false,
      this.isFormPosted = false,
      this.isValid = false,
      this.vehicle = '',
      this.devices = const [],
      this.name = const Name.pure(),
      this.email = const Email.pure(),
      this.password = const Password.pure(),
      
      });
            @override
  String toString() {
    
    return ''' 
    LoginFormState(
      isPosting : $isPosting
      isFormPosted : $isFormPosted
      isValid : $isValid
      vehicle : $vehicle
      devices : $devices
      name: $name
      email : $email
      password : $password
    )
    ''';  
  }

  RegisterFormState copyWith (
    {
      bool? complete,
      bool? isPosting,
      bool? isFormPosted,
      bool? isValid,
      String? vehicle,
      List<String>? devices,
      Name? name,
      Email? email,
      Password? password,
    }
  ) {
    return RegisterFormState(
      complete: complete ?? this.complete,
      isPosting: isPosting ?? this.isPosting,
      isFormPosted: isFormPosted ?? this.isFormPosted,
      isValid: isValid ?? this.isValid,
      vehicle: vehicle ?? this.vehicle,
      devices: devices ?? this.devices,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }
  
}


//Implementación

class RegisterFormNotifier extends StateNotifier<RegisterFormState> {
  final Function(String, String, String,String,List<String>) registerUserCallback;
RegisterFormNotifier({ required this.registerUserCallback}): super(RegisterFormState());

  onEmailChange(String value){
    final newEmail = Email.dirty(value);
    state = state.copyWith(
      email: newEmail,
      isValid: Formz.validate([newEmail, state.password, state.name])
    );
  }
  onPasswordChange(String value){
        final newPassword = Password.dirty(value);
    state = state.copyWith(
      password: newPassword,
      isValid: Formz.validate([newPassword, state.email, state.name])
    );
  }

  onNameChange(String value){
    final newName = Name.dirty(value);
    state = state.copyWith(
      name: newName,
      isValid: Formz.validate([newName, state.email, state.password])
    );
  }
  onFormSubmit() async{
    // if (state.password != state.confirmPassword) {

    //   print('No paso');
    //   return null;
    // };
    _touchEveryField();
    if(!state.isValid) return null;
    // print(state);
    
    await registerUserCallback(
      state.email.value,
      state.password.value,
      state.name.value,
      state.vehicle,
      state.devices
    );
    state = state.copyWith(
      complete: true,
    );
    await Future.delayed(const Duration(seconds: 2));
    state = state.copyWith(
      complete: false,
    );
  }
    _touchEveryField(){
    final name = Name.dirty(state.name.value);
    final email = Email.dirty(state.email.value);
    final pass = Password.dirty(state.password.value);
    state = state.copyWith(
      isFormPosted: true,
      name: name,
      email: email,
      password: pass,
      isValid: Formz.validate([name,email, pass])
    );
  }
}


//Provider/ como se consume 

// ignore: non_constant_identifier_names
final RegisterFormProvider = StateNotifierProvider.autoDispose<RegisterFormNotifier, RegisterFormState>((ref) {

  final writeData = ref.watch(managementDataProvider.notifier)
  .writeData;

  return RegisterFormNotifier(
    registerUserCallback: writeData,
  );
});
