

import 'package:conduit/conduit.dart';
import 'package:dart_application_cons/models/kategoriya.dart';
import 'package:dart_application_cons/models/user_model.dart';

import 'kategoriya.dart';

class Zametki extends ManagedObject<_Zametki> implements _Zametki{}

class _Zametki
{
  @primaryKey
  int? id;
  @Column(unique:true, indexed: true)
  String? nomerzam;
    @Column(unique:true, indexed: true)
  String? namezam;
    @Column(unique:true, indexed: true)
  String? soderjanie;
   @Relate(#zametki)
  Kategor? kategor;
   @Column(indexed: true)
   DateTime? createdAt;
   @Column(indexed: true)
   DateTime? updatedAt;
   @Relate(#zametki)
  User? user;


}