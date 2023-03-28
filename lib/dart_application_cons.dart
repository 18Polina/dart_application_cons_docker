import 'dart:io';

import 'package:conduit/conduit.dart';
import 'package:dart_application_cons/controllers/Pagin.dart';
import 'package:dart_application_cons/controllers/note_controller.dart';
import 'package:dart_application_cons/controllers/search.dart';
import 'controllers/app_auth_controller.dart';
import 'controllers/app_token_controller.dart';
import 'controllers/app_user_controller.dart';
import 'models/kategoriya.dart';
import 'models/user_model.dart';
import 'models/zametki.dart';

class AppService extends ApplicationChannel
{
  late final ManagedContext managedContext;
  
@override
  Future prepare() {
    final persistentStore = _initDatabase();

    managedContext = ManagedContext(
      ManagedDataModel.fromCurrentMirrorSystem(), persistentStore);
    return super.prepare();
  }
   @override
  Controller get entryPoint => Router()
    ..route('token/[:refresh]').link(
      () => AppAuthController(managedContext),
    )
    ..route('user')
        .link(AppTokenController.new)!
        .link(() => AppUserController(managedContext))
    ..route('notes/[:noteId]')
        .link(AppTokenController.new)!
        .link(() => NoteController(managedContext))
    ..route('serchZametki/')
        .link(AppTokenController.new)!
        .link(() => SearchZametka(managedContext))
    ..route('paginZametki/')
        .link(AppTokenController.new)!
        .link(() => PadinZametki(managedContext));

PersistentStore _initDatabase()
{
  final username = Platform.environment['DB_USERNAME'] ?? 'postgres';
  final password = Platform.environment['DB_PASSWORD'] ?? '123';
  final host = Platform.environment['DB_HOST'] ?? 'localhost';
  final port = int.parse(Platform.environment['DB_PORT'] ?? '5432');
  final databaseName = Platform.environment['DB_NAME'] ?? 'Practan';

  return PostgreSQLPersistentStore(username, password, host, port, databaseName);
}

}
