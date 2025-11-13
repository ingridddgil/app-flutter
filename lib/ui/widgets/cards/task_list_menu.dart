import 'package:flutter/material.dart';
import 'item_task.dart';
import 'dart:math';
import '../progress_bar.dart';
import '../../../data/models/temp.dart';

class TaskList extends StatelessWidget {
  const TaskList({
    super.key
  });

  @override
  Widget build(BuildContext context){
    final random = Random();
    final listTasks = List.generate(6, (i) => '${random.nextInt(100000)}');
    final per = List.generate(6, (_) => random.nextDouble());
    final client = List.generate(6, (i) => clients[random.nextInt(clients.length)]);
    return ListView.separated(
      itemCount: projectTitles.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, i) => CardItemTask(

        title: listTasks[i],
        
        subtitle: projectTitles[i],

        action1: Column(
          children: [
            ProgressBar(
              progress: per[i], 
            )
          ],
        ),
        client: client[i],
      ),
    );
  }
}