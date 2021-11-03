import 'package:unpub/unpub.dart' as unpub;
import 'dart:io' show Platform;
import 'package:unpub_aws/unpub_aws.dart' as unpub_aws;
import 'package:mongo_dart/mongo_dart.dart';
import 'package:unpub_aws/unpub_aws.dart';

void main(List<String> args) async {
  final dbUri = Platform.environment['MONGODB_URI'];

  if (dbUri == null) {
    throw StateError('Mongo URI was not defined');
  }

  final metaStore = unpub.MongoStore(Db(dbUri));
  await metaStore.db.open();

  final awsId = Platform.environment['AWS_ACCESS_KEY_ID'];
  final secret = Platform.environment['AWS_SECRET_ACCESS_KEY'];

  final app = unpub.App(
    metaStore: metaStore,
    packageStore: unpub_aws.S3Store(
      'apogeu-unpub',
      region: 'us-east-2',
      // endpoint: 'aws-alternative.example.com',
      getObjectPath: (String name, String version) =>
          '$name/$name-$version.tar.gz',
      credentials: AwsCredentials(
          awsAccessKeyId: awsId ?? '', awsSecretAccessKey: secret ?? ''),
    ),
  );

  final portEnv = Platform.environment['PORT'];

  final server =
      await app.serve('0.0.0.0', int.tryParse(portEnv ?? '') ?? 8080);

  print('Serving at http://${server.address.host}:${server.port}');
}
