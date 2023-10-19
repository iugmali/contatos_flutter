import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'contato_model.g.dart';

@HiveType(typeId: 1)
class ContatoModel extends HiveObject {
  ContatoModel(this.name, this.number, this.imgPath);

  @HiveField(0)
  final _id = const Uuid().v4();

  @HiveField(1)
  String name;

  @HiveField(2)
  String number;

  @HiveField(3)
  String imgPath;

  String get id => _id;
}