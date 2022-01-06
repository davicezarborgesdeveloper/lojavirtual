import 'package:flutter/material.dart';
import 'package:loja_virtual/models/order.dart';

class CancelOrderdialog extends StatefulWidget {
  const CancelOrderdialog(this.order);

  final Order order;

  @override
  _CancelOrderdialogState createState() => _CancelOrderdialogState();
}

class _CancelOrderdialogState extends State<CancelOrderdialog> {
  bool loading = false;
  String error;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: AlertDialog(
        title: Text('Cancelar ${widget.order.formattedID}?'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(loading
                ? 'Cancelando...'
                : 'Esta ação não poderá ser defeita!'),
            if (error != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  error,
                  style: TextStyle(color: Colors.red),
                ),
              )
          ],
        ),
        actions: [
          FlatButton(
            onPressed: !loading
                ? () {
                    Navigator.of(context).pop();
                  }
                : null,
            child: const Text('Voltar'),
          ),
          FlatButton(
            onPressed: !loading
                ? () async {
                    setState(() {
                      loading = true;
                    });
                    try {
                      await widget.order.cancel();
                      Navigator.of(context).pop();
                    } catch (e) {
                      setState(() {
                        loading = false;
                        error = e.toString();
                      });
                    }
                  }
                : null,
            textColor: Colors.red,
            child: const Text('Cancelar Pedido'),
          ),
        ],
      ),
    );
  }
}
