import 'package:flutter/material.dart';
import 'package:glocation/models/register_model.dart';
import 'package:glocation/services/sqlite/glocation_crud_db.dart';
class LoadDataScreen extends StatefulWidget {
  const LoadDataScreen({super.key});
  static const name = 'LoadDataScreen';

  @override
  State<LoadDataScreen> createState() => _LoadDataScreenState();
}

class _LoadDataScreenState extends State<LoadDataScreen> {
  Future<List<Register>>? futureRegisters;
  final GlocationDB glocationDB = GlocationDB();
  @override
  void initState() {
    super.initState();
    fetchRegisters();
  }
    void showMessage(int id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title:  const Text(
            'Are you sure?',
            style: TextStyle(fontSize: 35, color: Colors.black),
          ),
          content:  const Text("You can't undo this action!",
              style: TextStyle(fontSize: 25)),
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
                    style: TextStyle(fontSize: 20, color: Colors.white)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 20, bottom: 5),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  minimumSize: const Size(100, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
                child: const Text("Yes, delete it!",
                    style: TextStyle(fontSize: 20, color: Colors.white)),
                onPressed: () {
                  glocationDB.delete(id);
                  fetchRegisters();
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        );
      },
    );
  }

  void fetchRegisters() {
    setState(() {
      futureRegisters = glocationDB.fetchAll();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Load Data Screen'),
      ),
      body: Column(
        children: [


          FutureBuilder(future: futureRegisters, builder: (context, snapshot){
            if(snapshot.connectionState == ConnectionState.waiting){
              return const CircularProgressIndicator();
            }else if(snapshot.hasError){
              return Text('Error: ${snapshot.error}');
            }
            else{
              final registers = snapshot.data! ;
              return registers.isEmpty ? const Text('No data found'):ListView.builder(
                shrinkWrap: true,
                itemCount: registers.length,
                itemBuilder: (context, index){
                  final register = registers[index];
                  return ListTile(
                    title: Text("Name: ${register.name} \nEmail:${register.email}"),
                    subtitle: Text("Vehicle: ${register.vehicle} \nDevice: ${register.devices}"),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: (){
                        showMessage(register.id);
                      },
                    ),
                  );
                },
              );
            }
          }),
        ],
      ),
    );
  }
}