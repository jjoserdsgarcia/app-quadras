import 'package:flutter/material.dart';

class TelaQuadras extends StatefulWidget {
  const TelaQuadras({super.key});

  @override
  State<TelaQuadras> createState() => _TelaQuadrasState();
}

class _TelaQuadrasState extends State<TelaQuadras> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Quadras"),
      ),
    );
  }
}
