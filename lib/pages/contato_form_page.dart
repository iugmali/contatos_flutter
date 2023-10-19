import 'dart:io';

import 'package:brasil_fields/brasil_fields.dart';
import 'package:contatos_flutter/models/contato_model.dart';
import 'package:contatos_flutter/pages/contatos_list_page.dart';
import 'package:contatos_flutter/repositories/contato_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class ContatoFormPage extends StatefulWidget {
  ContatoModel? contato;

  ContatoFormPage({this.contato, super.key});

  @override
  State<ContatoFormPage> createState() => _ContatoFormPageState();
}

class _ContatoFormPageState extends State<ContatoFormPage> {
  late ContatoRepository contatoRepository;
  XFile? _photo;
  final _nameController = TextEditingController();
  final _numberController = TextEditingController();
  String _imgPath = "";

  @override
  void initState() {
    super.initState();
    if (widget.contato != null) {
      _nameController.text = widget.contato!.name;
      _numberController.text = widget.contato!.number;
      _imgPath = widget.contato!.imgPath;
      if (_imgPath.isNotEmpty) {
        _photo = XFile(_imgPath);
      }
    }
    _carregarRepository();
    setState(() {});
  }

  void _carregarRepository() async {
    contatoRepository = await ContatoRepository.carregar();
  }

  void _cropImage(XFile imageFile) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.green,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Cropper',
        ),
      ],
    );
    if (croppedFile != null) {
      setState(() {
        _imgPath = croppedFile.path;
        _photo = XFile(_imgPath);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String appbarTitle =
        (widget.contato != null) ? "Editar Contato" : "Criar Contato";

    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text(appbarTitle),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
        children: [
          InkWell(
            onTap: () async {
              showModalBottomSheet(
                  context: context,
                  builder: (_) {
                    return Wrap(
                      children: [
                        ListTile(
                          leading: Icon(Icons.camera_alt),
                          title: Text("Camera"),
                          onTap: () async {
                            final ImagePicker _picker = ImagePicker();
                            _photo = await _picker.pickImage(
                                source: ImageSource.camera);
                            if (_photo != null) {
                              String path =
                                  (await getApplicationDocumentsDirectory())
                                      .path;
                              String name = basename(_photo!.path);
                              await _photo!.saveTo("$path/$name");
                              _imgPath = _photo!.path;
                              setState(() {});
                              Navigator.pop(context);
                              _cropImage(_photo!);
                            }
                          },
                        ),
                        ListTile(
                            leading: Icon(Icons.image_sharp),
                            title: Text("Galeria"),
                            onTap: () async {
                              final ImagePicker _picker = ImagePicker();
                              _photo = await _picker.pickImage(
                                  source: ImageSource.gallery);
                              String path =
                                  (await getApplicationDocumentsDirectory())
                                      .path;
                              String name = basename(_photo!.path);
                              await _photo!.saveTo("$path/$name");
                              _imgPath = _photo!.path;
                              setState(() {});
                              Navigator.pop(context);
                              _cropImage(_photo!);
                            })
                      ],
                    );
                  });
            },
            child: Center(
              child: CircleAvatar(
                backgroundColor: Colors.black,
                radius: 40.0,
                child: CircleAvatar(
                  radius: 38.0,
                  backgroundColor: Colors.grey,
                  child: ClipOval(
                    child: (_photo != null)
                        ? Image.file(File(_photo!.path))
                        : Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                          ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 16,
          ),
          TextField(
            decoration: const InputDecoration(
                border: OutlineInputBorder(), labelText: 'Nome'),
            controller: _nameController,
          ),
          SizedBox(
            height: 16,
          ),
          TextField(
            decoration: const InputDecoration(
                border: OutlineInputBorder(), labelText: 'Telefone'),
            controller: _numberController,
            keyboardType: TextInputType.number,
            inputFormatters: [
              // obrigatório
              FilteringTextInputFormatter.digitsOnly,
              TelefoneInputFormatter(),
            ],
          ),
          SizedBox(
            height: 16,
          ),
          ElevatedButton(
              onPressed: () {
                FocusManager.instance.primaryFocus?.unfocus();

                if (_nameController.text.isEmpty ||
                    _numberController.text.isEmpty) {
                  showDialog(
                      context: context,
                      builder: (_) {
                        return AlertDialog(
                          title: const Text("Campo não preenchido"),
                          content: const Wrap(
                            children: [
                              Text("Todos os campos devem ser preenchidos."),
                            ],
                          ),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text("OK"))
                          ],
                        );
                      });
                  return;
                }
                if (widget.contato != null) {
                  widget.contato!.name = _nameController.text;
                  widget.contato!.number = _numberController.text;
                  widget.contato!.imgPath = _imgPath;
                  contatoRepository.atualizar(widget.contato!);
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => ContatosListPage()),
                      (Route<dynamic> route) => false);
                } else {
                  ContatoModel contato = ContatoModel(
                      _nameController.text, _numberController.text, _imgPath);
                  contatoRepository.adicionar(contato);
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => ContatosListPage()),
                      (Route<dynamic> route) => false);
                }
              },
              child: (widget.contato != null)
                  ? Text(
                      "Atualizar Contato",
                      style: TextStyle(fontSize: 20),
                    )
                  : Text(
                      "Criar Contato",
                      style: TextStyle(fontSize: 20),
                    ))
        ],
      ),
    ));
  }
}
