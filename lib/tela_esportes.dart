import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TelaEsportes extends StatefulWidget {
  const TelaEsportes({super.key});

  @override
  State<TelaEsportes> createState() => _TelaEsportesState();
}

class _TelaEsportesState extends State<TelaEsportes> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    consultarEsportes();
  }

  void consultarEsportes() async {
    final supabase = Supabase.instance.client;
    final esportes = await supabase
        .from("esporte") //
        .select();
    print("esportes: $esportes");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tela Esportes"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return TelaEsportes();
              },
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
