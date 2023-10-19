import 'dart:io';

import 'package:contatos_flutter/pages/contato_form_page.dart';
import 'package:flutter/material.dart';

import '../repositories/contato_repository.dart';
import '../models/contato_model.dart';

class ContatosListPage extends StatefulWidget {
  const ContatosListPage({super.key});

  @override
  State<ContatosListPage> createState() => _ContatosListPageState();
}

class _ContatosListPageState extends State<ContatosListPage> {
  late ContatoRepository contatoRepository;
  List<ContatoModel> _contatos = [];

  @override
  void initState() {
    _listarContatos();
    super.initState();
  }

  void _listarContatos() async {
    contatoRepository = await ContatoRepository.carregar();
    setState(() {
      _contatos = contatoRepository.listar();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      appBar: AppBar(title: const Text("Lista de Contatos"),),
      body: (_contatos.isEmpty) ?
      const Padding(padding: EdgeInsets.all(16.0), child: Center(child: Text("Ainda não existem contatos adicionados. Adicione um contato pressionando o botão do canto inferior direito.", textAlign: TextAlign.justify),),)
      : ListView.builder(
          itemCount: _contatos.length,
          itemBuilder: (BuildContext bc, i) {
            var contato = _contatos[i];
            return Dismissible(
                key: Key(contato.id),
                confirmDismiss: (DismissDirection direction) async {
                  return await showDialog(
                      context: context,
                      builder: (_) {
                        return AlertDialog(
                          title: const Text("Remover Registro"),
                          content: const Text("Deseja remover o registro de contato salvo?"),
                          actions: [
                            TextButton(
                                onPressed: () => Navigator.of(context).pop(false),
                                child: const Text('Cancelar')
                            ),
                            ElevatedButton(
                              style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll<Color>(Colors.red)),
                              onPressed: () => Navigator.of(context).pop(true),
                              child: const Text('Remover contato'),
                            ),
                          ],
                        );
                      });
                },
                onDismissed: (direction) async {
                  contatoRepository.remover(contato);
                  _listarContatos();
                },
                direction: DismissDirection.endToStart,
                background: Container(decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Colors.redAccent,
                        Colors.red,
                      ],
                      stops: [
                        0.15,
                        0.90,
                      ]),
                ),
                ),
                child: Card(
                  elevation: 5,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.black,
                      radius: 25.0,
                      child: CircleAvatar(
                        radius: 24.0,
                        backgroundColor: Colors.grey,
                        child: ClipOval(
                          child: (contato.imgPath.isNotEmpty)
                              ? Image.file(File(contato.imgPath))
                              : Icon(Icons.person, color: Colors.white,),
                        ),
                      ),
                    ),
                    title: Text(contato.name),
                    subtitle: Text(contato.number),
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ContatoFormPage(contato: contato,))),
                  ),
                )
            );
          }
      ),
      floatingActionButton: FloatingActionButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ContatoFormPage())), child: const Icon(Icons.add),),
    ));
  }
}
