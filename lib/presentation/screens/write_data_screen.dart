import 'package:flutter/material.dart';
import 'package:glocation/presentation/providers/management_data_provider.dart';
import 'package:glocation/presentation/providers/write_data_provider.dart';
import 'package:glocation/presentation/shared/custom_filled_button.dart';
import 'package:glocation/presentation/shared/custom_text_form_field.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class WriteDataScreen extends ConsumerWidget {
  const WriteDataScreen({super.key});
  static const name = 'WriteDataScreen';
  
//Error proveniente de la base de datos  
  void showSnackBar(BuildContext context, String errorMessage) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(errorMessage),
        backgroundColor: Colors.red.shade400,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
  
  //Confirmación de la escritura de datos 
  void showMessage(String message, subMessage, bool complete) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title:  Text(
            message,
            style: const TextStyle(fontSize: 35, color: Colors.black),
          ),
          content:  Text(subMessage,
              style: const TextStyle(fontSize: 25)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20, bottom: 5),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  minimumSize: const Size(100, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
                child: const Text("Close",
                    style: TextStyle(fontSize: 25, color: Colors.white)),
                onPressed: () {
                  if (complete){
                    context.go('/');
                  }else{
                  Navigator.of(context).pop();
                  }
                },
              ),
            ),
          ],
        );
      },
    );
  }
    final size = MediaQuery.of(context).size;
    final writeForm = ref.watch(WriteFormProvider);
    ref.listen(managementDataProvider, (previous, next) {
      if (next.errorMessage.isEmpty) return;
      showSnackBar(context, next.errorMessage);
    });
    return Scaffold(
      appBar: AppBar(
        title: const Text('Write Data Screen'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const Text('Write Data Screen'),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomTextFormField(
                  label: 'Full Name',
                  hint: 'Enter your name',
                  onChanged: ref.read(WriteFormProvider.notifier).onNameChange,
                  errorMessage:
                      writeForm.isFormPosted ? writeForm.name.errorMessage : null,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomTextFormField(
                  label: 'E-mail',
                  hint: 'Enter your E-mail',
                  onChanged: ref.read(WriteFormProvider.notifier).onEmailChange,
                  errorMessage:
                      writeForm.isFormPosted ? writeForm.email.errorMessage : null,
                ),
              ),
              
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomTextFormField(
                  label: 'Password',
                  hint: 'Enter your Password',
                  obscureText: true,
                  onChanged: ref.read(WriteFormProvider.notifier).onPasswordChange,
                  errorMessage:
                      writeForm.isFormPosted ? writeForm.password.errorMessage : null,
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: VehicleSelector(),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropDownMenu(size: size),
              ),
              const SizedBox( height: 20),
              SizedBox(
                width: size.width * 0.95,
                height: 50,
                child: CustomFilledButton(
                  buttonColor: Colors.black,
                    onPressed: () {
                      ref.read(WriteFormProvider.notifier).onFormSubmit();
                      if(ref.watch(WriteFormProvider).isValid){
                        try {
                          showMessage('Written successful', 'Data has been written successfully', true);
                        } catch (e) {
                          showMessage('Error', e.toString(), false);
                        }
                      }
                    },
                    text: 'Write Data'),
              ),
              const SizedBox( height: 10),
              SizedBox(
                width: size.width * 0.95,
                height: 50,
                child: CustomFilledButton(
                  onPressed: () {
                    context.push('/loadData');
                  },
                  text: 'Load Data',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DropDownMenu extends ConsumerWidget {
  const DropDownMenu({
    super.key,
    required this.size,
  });

  final Size size;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Material(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      shadowColor: Colors.black.withOpacity(0.3),
      elevation: 20,
      child: DropdownMenu(
        label: const Text('What device are you using?'),
        width: size.width * 0.95,
        menuHeight: size.height * 0.2 ,
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
        ),
        initialSelection: 'Phone',
        onSelected: (value) {
          if(value != null){
            ref.read(WriteFormProvider.notifier).onDevicesChange(value);
          }
        },
        dropdownMenuEntries:const <DropdownMenuEntry<String>>[
        DropdownMenuEntry(value: 'Android Phone', label: 'Phone'),
        DropdownMenuEntry(value: 'Android Tablet', label: 'Tablet'),
        DropdownMenuEntry(value: 'Windows Laptop', label: 'Laptop'),
        DropdownMenuEntry(value: 'Windows Pc', label: 'Pc'),
        DropdownMenuEntry(value: 'Mac', label: 'Mac'),
        DropdownMenuEntry(value: 'Iphone', label: 'Iphone'),
        DropdownMenuEntry(value: 'Ipad', label: 'Ipad'),
        DropdownMenuEntry(value: 'Linux System', label: 'Linux System'),
        
      ] ),
    );
  }
}


enum Transportation { car, boat, bike, horse }
class VehicleSelector extends ConsumerStatefulWidget {
  const VehicleSelector({super.key});


  @override
  ConsumerState<VehicleSelector> createState() => _VehicleSelectorState();
}


class _VehicleSelectorState extends ConsumerState<VehicleSelector> {
  Transportation selectedTransportation = Transportation.car;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.95,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(15)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0,5)
          )
        ]
      ),
      child: ExpansionTile(
        collapsedBackgroundColor: Colors.white,
            title:  Text('Selected vehicle: ${selectedTransportation.name}'),
            children: [
              RadioListTile(
                title: const Text('Car'),
                subtitle: const Text('Travel in a car'),
                value: Transportation.car,
                groupValue: selectedTransportation,
                onChanged: (value) => setState(() {
                  selectedTransportation = Transportation.car;
                  ref.read(WriteFormProvider.notifier).onVehicleChange(selectedTransportation.name);
                }),
              ),
              RadioListTile(
                title: const Text('Boat'),
                subtitle: const Text('Travel in a'),
                value: Transportation.boat,
                groupValue: selectedTransportation,
                onChanged: (value) => setState(() {
                  selectedTransportation = Transportation.boat;
                  ref.read(WriteFormProvider.notifier).onVehicleChange(selectedTransportation.name);
                }),
                
              ),
              RadioListTile(
                title: const Text('Bike'),
                subtitle: const Text('Travel in a bike'),
                value: Transportation.bike,
                groupValue: selectedTransportation,
                onChanged: (value) => setState(() {
                  selectedTransportation = Transportation.bike;
                  ref.read(WriteFormProvider.notifier).onVehicleChange(selectedTransportation.name);
                }),
              ),
              RadioListTile(
                title: const Text('Horse'),
                subtitle: const Text('Travel on a horse'),
                value: Transportation.horse,
                groupValue: selectedTransportation,
                onChanged: (value) => setState(() {
                  selectedTransportation = Transportation.horse;
                  ref.read(WriteFormProvider.notifier).onVehicleChange(selectedTransportation.name);
                }),
              ),
            ],
          ),
    );
  }
}