import 'package:app_quadras/esporte.dart';

class Quadra {
  final String descricao;
  final int id;
  final List<Esporte> esportesHabilitados;

  Quadra({
    required this.descricao,
    required this.id,
    required this.esportesHabilitados,
  });
}
