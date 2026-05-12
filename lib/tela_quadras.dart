import 'package:app_quadras/cadastro_quadra.dart';
import 'package:app_quadras/esporte.dart';
import 'package:app_quadras/quadras.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TelaQuadras extends StatefulWidget {
  const TelaQuadras({super.key});

  @override
  State<TelaQuadras> createState() => _TelaQuadrasState();
}

class _TelaQuadrasState extends State<TelaQuadras> {
  List<Quadra> quadras = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    consultarQuadras();
  }

  void consultarQuadras() async {
    final supabase = Supabase.instance.client;
    var quadrasSupabase = await supabase
        .from("quadra") //
        .select();
    for (var quadra in quadrasSupabase) {
      var idsEsportesHabilitados = await supabase
          .from("quadra_esporte") //
          .select()
          .eq("quadra_id", quadra['id']);

      var esportesQuadra = <Esporte>[];
      for (var esporteHabilitado in idsEsportesHabilitados) {
        var esporte = await supabase
            .from("esporte") //
            .select()
            .eq("id", esporteHabilitado['esporte_id']);
        esportesQuadra.add(
          Esporte(
            id: esporte.first['id'],
            descricao: esporte.first['descricao'],
            numeroJogadores: esporte.first['numero_jogadores'],
          ),
        );
      }
      quadras.add(
        Quadra(
          id: quadra['id'],
          descricao: quadra['descricao'],
          esportesHabilitados: esportesQuadra,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tela Quadras"),
      ),
      body: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: 400,
        ),
        child: ListView.builder(
          itemCount: quadras.length,
          itemBuilder: (context, index) {
            final quadra = quadras[index];
            return GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return CadastroQuadra(
                        quadra: 
                        quadras[index]
                        );
                    },
                  ),
                );
              },
              child: Card(
                elevation: 9.0,
                child: ListTile(
                  title: Text(quadra.descricao),
                  subtitle: Text("ID: ${quadra.id}"),
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context)
              .push(
                MaterialPageRoute(
                  builder: (context) {
                    return Card(
                      elevation: 9.0,
                      child: ListTile(
                        title: Text("Cadastro de Quadra"),
                      ),
                    );
                  },
                ),
              )
              .then((value) {
                if (value != null) {
                  print("Valor retornado: $value");
                }
                consultarQuadras();
              });
        },
      ),
    );
  }
}
