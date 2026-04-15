import 'package:app_quadras/cadastro_esporte.dart';
import 'package:app_quadras/esporte.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TelaQuadras extends StatefulWidget {
  const TelaQuadras({super.key});

  @override
  State<TelaQuadras> createState() => _TelaQuadrasState();
}

class _TelaQuadrasState extends State<TelaQuadras> {
  List<Esporte> esportes = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    consultarEsportes();
  }

  void consultarEsportes() async {
    final supabase = Supabase.instance.client;
    final esportesSupabase = await supabase
        .from("esporte") //
        .select();
    print("esportes: $esportesSupabase");
    setState(() {
      esportes = esportesSupabase
          .map(
            (esporteSupabase) => Esporte(
              descricao: esporteSupabase['descricao'],
              numeroJogadores: esporteSupabase['numero_jogadores'],
            ),
          )
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tela Esportes"),
      ),
      body: ListView.builder(
        itemCount: esportes.length,
        itemBuilder: (context, index) {
          final esporte = esportes[index];
          return Card(
            elevation: 9.0,
            child: ListTile(
              title: Text(esporte.descricao),
              subtitle: Text("Número de jogadores: ${esporte.numeroJogadores}"),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(
                MaterialPageRoute(
                  builder: (context) {
                    return CadastroEsporte();
                  },
                ),
              )
              .then((value) {
                if (value != null) {
                  print("Valor retornado: $value");
                }
                consultarEsportes();
              });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
