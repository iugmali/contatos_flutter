import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'contato_model.g.dart';

@HiveType(typeId: 1)
class ContatoModel extends HiveObject {
  ContatoModel(this.name, this.number, this.imgPath);

  @HiveField(0)
  final _id = const Uuid().v4();

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String number;

  @HiveField(3)
  final String imgPath;

  String get id => _id;
}