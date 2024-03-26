import 'package:formz/formz.dart';
import 'package:glocation/presentation/providers/management_data_provider.dart';
import 'package:glocation/presentation/shared/inputs/inputs.dart';
import 'package:riverpod/riverpod.dart';





//Creación
class WriteFormState {
  final bool complete;
  final bool isPosting;
  final bool isFormPosted;
  final bool isValid;
  final String vehicle;
  final String devices;
  final Name name;
  final Email email;
  final Password password;

  WriteFormState(
      {
      this.complete = false,
      this.isPosting = false,
      this.isFormPosted = false,
      this.isValid = false,
      this.vehicle = '',
      this.devices = '',
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

  WriteFormState copyWith (
    {
      bool? complete,
      bool? isPosting,
      bool? isFormPosted,
      bool? isValid,
      String? vehicle,
      String? devices,
      Name? name,
      Email? email,
      Password? password,
    }
  ) {
    return WriteFormState(
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

class WriteFormNotifier extends StateNotifier<WriteFormState> {
  final Function(String, String, String,String,String) writeUserCallback;
WriteFormNotifier({ required this.writeUserCallback}): super(WriteFormState());

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

  onVehicleChange(String value){
    state = state.copyWith(
      vehicle: value,
    );
  }

  onDevicesChange(String value){
    state = state.copyWith(
      devices: value,
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
    
    await writeUserCallback(
      state.email.value,
      state.password.value,
      state.name.value,
      state.vehicle,
      state.devices
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
      complete: Formz.validate([name,email, pass]),
      isValid: Formz.validate([name,email, pass]) && state.vehicle.isNotEmpty && state.devices.isNotEmpty
    );
  }
}


//Provider/ como se consume 

// ignore: non_constant_identifier_names
final WriteFormProvider = StateNotifierProvider.autoDispose<WriteFormNotifier, WriteFormState>((ref) {

  final writeData = ref.watch(managementDataProvider.notifier)
  .writeData;

  return WriteFormNotifier(
    writeUserCallback: writeData,
  );
});
