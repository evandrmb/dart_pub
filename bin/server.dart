import 'package:unpub/unpub.dart' as unpub;

void main(List<String> args) async {
  const basedir = '/packages';
  const db = String.fromEnvironment('MONGODB_URI');

  final metaStore = unpub.MongoStore(db);
  await metaStore.db.open();

  final packageStore = unpub.FileStore(basedir);

  final app = unpub.App(
    metaStore: metaStore,
    packageStore: packageStore,
  );

  final server = await app.serve('0.0.0.0', 8080);
  print('Serving at http://${server.address.host}:${server.port}');
}
