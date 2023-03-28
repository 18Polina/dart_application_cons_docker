import 'dart:io';

import 'package:conduit/conduit.dart';
import 'package:dart_application_cons/models/zametki.dart';

import '../models/user_model.dart';
import '../utils/app_utils.dart';
import '../utils/response_model.dart';

class NoteController extends ResourceController
{
  final ManagedContext managedContext;

  
  @Operation.post()
  Future<Response> ZametkiiAdd(
      @Bind.header(HttpHeaders.authorizationHeader) String header,
      @Bind.body() Zametki zametki) async {
    try {
      final id = AppUtils.getIdFromHeader(header);

      final qFindUser = Query<User>(managedContext)
        ..where((x) => x.id).equalTo(id)
        ..returningProperties((x) => [x.salt, x.hashPassword]);

      final fUser = await qFindUser.fetchOne();

      final ZametkiAdd = Query<Zametki>(managedContext)
        ..values.nomerzam = zametki.nomerzam
        ..values.namezam = zametki.namezam
        ..values.createdAt = DateTime.now()
        ..values.updatedAt = DateTime.now()
        ..values.soderjanie = zametki.soderjanie
        ..values.kategor!.id =
            zametki.kategor!.id
        ..values.user = fUser;

      ZametkiAdd.insert();
      return Response.ok(ModelResponse(message: "Заметка была добавлена"));
    } on QueryException catch (e) {
      return Response.badRequest(
          body: ModelResponse(
              message: "Данные не удалось добавить", error: e.message));
    }
  }

   @Operation.put('noteId')
  Future<Response> ZametkaUpd(
      @Bind.header(HttpHeaders.authorizationHeader) String header,
      @Bind.body() Zametki zametki,
      @Bind.path('noteId') int noteId) async {
    try {
      final id = AppUtils.getIdFromHeader(header);

      final qFindUser = Query<User>(managedContext)
        ..where((x) => x.id).equalTo(id)
        ..returningProperties((x) => [x.salt, x.hashPassword]);

      final fUser = await qFindUser.fetchOne();

      final ZametkiUpd = Query<Zametki>(managedContext)
        ..where((x) => x.id).equalTo(noteId)
         ..values.nomerzam = zametki.nomerzam
        ..values.namezam = zametki.namezam
        ..values.updatedAt = DateTime.now()
        ..values.soderjanie = zametki.soderjanie
        ..values.kategor!.id =
            zametki.kategor!.id
        ..values.user = fUser;


      ZametkiUpd.updateOne();
      return Response.ok(ModelResponse(message: "Заметка была успешно изменена"));
    } catch (e) {
      return Response.badRequest(
          body: ModelResponse(message: "Данные не удалось обновить"));
    }
  }

 @Operation.delete('noteId')
  Future<Response> ZametkiDel(
      @Bind.header(HttpHeaders.authorizationHeader) String header,
      @Bind.path('noteId') int noteId) async {
    try {
      final id = AppUtils.getIdFromHeader(header);
      var query = Query<Zametki>(managedContext)
        ..where((x) => x.id).equalTo(noteId);
        query.delete();
      return Response.ok(ModelResponse(message: "Заметка удалена"));
    } catch (e) {
      return Response.badRequest(
          body: ModelResponse(message: "Не удалось удалить данные"));
    }
  }

  @Operation.get()
  Future<Response> ZametkiProsmotr() async {
    try {
      var query = Query<Zametki>(managedContext)
        ..join(
          object: (x) => x.user,
        )
        ..join(
          object: (x) => x.kategor,
        );

      List<Zametki> zametkii = await query.fetch();

      for (var zam in zametkii) {
        zam.user!
            .removePropertiesFromBackingMap(['accessToken', 'refreshToken']);
      }

      return Response.ok(zametkii);
    } catch (e) {
      return Response.badRequest(
          body: ModelResponse(message: "Данные не показались"));
    }
  }
   @Operation.get("noteId")
  Future<Response> ZamProsm(
      @Bind.path('noteId') int noteId) async {
    try {
      var query = Query<Zametki>(managedContext)
        ..join(object: (x) => x.user)
        ..join(
          object: (x) => x.kategor,
        )
        ..where((x) => x.id).equalTo(noteId);

      final zametki = await query.fetchOne();

      if (zametki == null) {
        return Response.badRequest(
            body: ModelResponse(message: "Заметка с таким ID не найдена"));
      }

      zametki.user!
          .removePropertiesFromBackingMap(['refreshToken', 'accessToken']);
      return Response.ok(zametki);
    } catch (e) {
      return Response.badRequest(
          body: ModelResponse(message: "Данные не показались"));
    }
  }
  NoteController(this.managedContext);
}