import 'package:unpub/unpub.dart' as unpub;

void main(List<String> args) async {
  const basedir = '/packages';
  const db =
      'mongodb://ap_master:L043Ya1aMiWiaCnFijUF@apogeupubdev-shard-00-00.93vch.mongodb.net:27017,apogeupubdev-shard-00-01.93vch.mongodb.net:27017,apogeupubdev-shard-00-02.93vch.mongodb.net:27017/ApogeuPubDev?ssl=true&replicaSet=atlas-kmsagm-shard-0&authSource=admin&retryWrites=true&w=majority';

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
