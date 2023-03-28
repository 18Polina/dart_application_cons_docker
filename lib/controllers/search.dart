import 'dart:developer';
import 'dart:io';

import 'package:conduit/conduit.dart';
import 'package:dart_application_cons/models/zametki.dart';

import '../utils/response_model.dart';

class SearchZametka extends ResourceController {
  final ManagedContext managedContext;

  SearchZametka(this.managedContext);

  @Operation.get()
  Future<Response> searchZametka(@Bind.query('namezam') String namezam) async {
    try {
      var query = Query<Zametki>(managedContext)
        ..where((x) => x.namezam).contains(namezam, caseSensitive: false)
        ..join(
          object: (x) => x.user,
        )
        ..join(object: (x) => x.kategor);

      List<Zametki> zametkii = await query.fetch();

      if (zametkii.isEmpty) {
        return Response.ok(ModelResponse(message: "Не нашлось"));
      }

      for (var operation in zametkii) {
        operation.user!
            .removePropertiesFromBackingMap(['accessToken', 'refreshToken']);
      }

      return Response.ok(zametkii);
    } catch (e) {
      return Response.badRequest(
          body: ModelResponse(message: "Данные не нашлись"));
    }
  }
}