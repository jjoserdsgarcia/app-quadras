import 'package:app_quadras/esporte.dart';
import 'package:app_quadras/quadras.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CadastroQuadra extends StatefulWidget {
  const CadastroQuadra({super.key, this.quadra});

  final Quadra? quadra;

  @override
  State<CadastroQuadra> createState() => _CadastroQuadraState();
}

class _CadastroQuadraState extends State<CadastroQuadra> {
  List<Esporte> esportes = [];
  late TextEditingController descricaoController;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  Map<Esporte, bool> esportesHabilitados = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    descricaoController = TextEditingController();
    if (widget.quadra != null) {
      descricaoController = TextEditingController(text: widget.quadra!.descricao);
      esportesHabilitados = {};
      for (var esporte in widget.quadra!.esportesHabilitados) {
        esportesHabilitados[esporte] = true;
      }
    }
    descricaoController = TextEditingController();
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
              id: esporteSupabase['id'],
              descricao: esporteSupabase['descricao'],
              numeroJogadores: esporteSupabase['numero_jogadores'],
            ),
          )
          .toList();
    });
    esportesHabilitados.clear();
    for (var esp in esportes) {
      esportesHabilitados[esp] = false;
    }
    if (widget.quadra != null) {
      for (var esp in esportesHabilitados.entries) {
        if (widget.quadra!.esportesHabilitados.contains(esp.key)) {
          esportesHabilitados[esp.key] = true;
        }
      }
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cadastro de Quadra"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Form(
        key: formKey,
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Descrição",
              ),
              controller: descricaoController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Campo obrigatório!";
                }
                return null;
              },
            ),
            ...esportes.map((e) {
              return Row(
                children: [
                  Checkbox.adaptive(
                    value: esportesHabilitados[e],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          esportesHabilitados[e] = value;
                        });
                      }
                    },
                  ),
                  Text(e.descricao),
                ],
              );
            }),
            ElevatedButton(
              onPressed: () async {
                try {
                  if (formKey.currentState!.validate()) {
                    final supabase = Supabase.instance.client;
                    await supabase.from('quadra').insert({
                      'descricao': descricaoController.text,
                    });

                    List<Map<String, dynamic>> registros = await supabase.from('quadra').select().eq('descricao', descricaoController.text);
                    int idQuadra = registros.first['id'];
                    for (var esporte in esportesHabilitados.entries.where((element) => element.value)) {
                      await supabase.from('quadra_esporte').insert({
                        'quadra_id': idQuadra,
                        'esporte_id': esporte.key.id,
                      });
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Quadra cadastrada com sucesso!"),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Erro ao cadastrar quadra: $e"),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: Text("Salvar"),
            ),
          ],
        ),
      ),
    );
  }
}
