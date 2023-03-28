import 'dart:async';
import 'dart:developer';
import 'dart:ffi';
import 'package:dart_application_cons/models/zametki.dart';
import 'package:quiver/iterables.dart';
import 'package:conduit/conduit.dart';

class PadinZametki extends ResourceController {
  final ManagedContext managedContext;

  PadinZametki(this.managedContext);

  @Operation.get()
  Future<Response> paginZam(
      @Bind.query('page') int page, @Bind.query('limit') int limit) async {
    final query = Query<Zametki>(managedContext)
      ..join(
        object: (x) => x.user,
      )
      ..join(
        object: (x) => x.kategor,
      );

    final zametkii = await query.fetch();

    final pages = partition(zametkii, limit);

    return Response.ok({
      "data": _toJSON(pages.elementAt(page - 1)),
    });
  }

  List _toJSON(List<Zametki> zametkii) {
    final array = [];
    for (var zametki in zametkii) {
      array.add({
        "id": zametki.id,
        "nomerzam": zametki.nomerzam,
        "namezam": zametki.namezam,
        "soderjanie": zametki.soderjanie,
        "dateCr": zametki.createdAt.toString(),
        "dateUp": zametki.updatedAt.toString(),
        "user": {
          "id": zametki.user!.id,
          "username": zametki.user!.username,
          "email": zametki.user!.email,
        },
        "Kategorii": {
          "id": zametki.kategor!.id,
          "namekategor": zametki.kategor!.namekategor,
        }
      });
    }

    return array;
  }
}
