import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImageSourceSheet extends StatelessWidget {
  ImageSourceSheet({this.onImageSelected});
  final Function(File) onImageSelected;
  final ImagePicker picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    Future<void> editImage(String path) async {
      final File croppedFile = await ImageCropper.cropImage(
          sourcePath: path,
          aspectRatio: const CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
          androidUiSettings: AndroidUiSettings(
            toolbarTitle: "Editar Image",
            toolbarColor: Theme.of(context).primaryColor,
            toolbarWidgetColor: Colors.white,
          ),
          iosUiSettings: const IOSUiSettings(
            title: "Editar Image",
            cancelButtonTitle: "Cancelar",
            doneButtonTitle: "Concluir",
          ));

      if (croppedFile != null) {
        onImageSelected(croppedFile);
      }
    }

    if (Platform.isAndroid)
      return BottomSheet(
        builder: (_) => Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FlatButton(
                onPressed: () async {
                  final PickedFile file =
                      await picker.getImage(source: ImageSource.camera);
                  editImage(file.path);
                },
                child: const Text("Câmera")),
            FlatButton(
                onPressed: () async {
                  final PickedFile file =
                      await picker.getImage(source: ImageSource.gallery);
                  editImage(file.path);
                },
                child: const Text("Galeria")),
          ],
        ),
        onClosing: () {},
      );
    else
      return CupertinoActionSheet(
        title: const Text("Selecionar foto para o item"),
        message: const Text('Escolha a origem da foto'),
        actions: [
          CupertinoActionSheetAction(
              isDefaultAction: true,
              onPressed: () async {
                final PickedFile file =
                    await picker.getImage(source: ImageSource.gallery);
                editImage(file.path);
              },
              child: const Text("Câmera")),
          CupertinoActionSheetAction(
              onPressed: () async {
                final PickedFile file =
                    await picker.getImage(source: ImageSource.gallery);
                editImage(file.path);
              },
              child: const Text("Galeria")),
        ],
        cancelButton: CupertinoActionSheetAction(
            onPressed: Navigator.of(context).pop,
            child: const Text("Cancelar")),
      );
  }
}
