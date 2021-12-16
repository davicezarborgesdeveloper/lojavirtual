import 'package:flutter/material.dart';
import 'package:loja_virtual/models/order.dart';

class CancelOrderdialog extends StatelessWidget {
  const CancelOrderdialog(this.order);

  final Order order;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Cancelar ${order.formattedID}?'),
      content: const Text('Esta ação não poderá ser desfeita!'),
      actions: [
        FlatButton(
          onPressed: () {
            order.cancel();
            Navigator.of(context).pop();
          },
          textColor: Colors.red,
          child: const Text('Cancelar Pedido'),
        ),
      ],
    );
  }
}
