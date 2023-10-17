import 'package:hive/hive.dart';

import '../models/contato_model.dart';

const CONTATO_MODEL = "CONTATO_MODEL";

class ContatoRepository {
  static late Box _box;

  ContatoRepository._criar();

  static Future<ContatoRepository> carregar() async {
    if (Hive.isBoxOpen(CONTATO_MODEL)) {
      _box = Hive.box(CONTATO_MODEL);
    } else {
      _box = await Hive.openBox(CONTATO_MODEL);
    }
    return ContatoRepository._criar();
  }

  adicionar(ContatoModel contato) async {
    _box.add(contato);
  }

  atualizar(ContatoModel contato) async {
    contato.save();
  }

  remover(ContatoModel contato) async {
    contato.delete();
  }

  List<ContatoModel> listar() {
    return _box.values
        .cast<ContatoModel>()
        .toList();
  }
}