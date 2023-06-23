import 'package:flutter/material.dart';
import 'package:my_tiffin/widgets/progress_bar.dart';

class DialogLoading extends StatelessWidget {
  final String? message;
   const DialogLoading({super.key, this.message});



  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      key: key,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          circularProgress(),
          const SizedBox(height: 10,),
          Text(message!+',Please wait...')
        ],
      )
    );
  }
}
