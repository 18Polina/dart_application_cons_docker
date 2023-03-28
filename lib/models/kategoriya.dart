import 'package:conduit/conduit.dart';
import 'package:dart_application_cons/models/zametki.dart';

class Kategor extends ManagedObject<_Kategor> implements _Kategor{}

class _Kategor
{
  @Column(primaryKey: true)
  int? id;
  @Column(unique:true, indexed: true)
  String? namekategor;
   ManagedSet<Zametki>? zametki;

}