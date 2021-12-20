import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:graphql/client.dart';
import 'package:space_missions/model/mission_model.dart';

String missionQuery(
    {String offset = '0', String limit = '10', String missionSearchTerm = ""}) {
  return '''
  query {
  launches(offset: $offset, limit: $limit, find: {mission_name: "$missionSearchTerm"}) {
    mission_name
    details
  }
}
''';
}

class GetMissionsRequestFailure implements Exception {}

class MissionsApiClient {
  const MissionsApiClient({required GraphQLClient graphQLClient})
      : _graphQLClient = graphQLClient;

  GraphQLClient get graphQLClient => _graphQLClient;

  factory MissionsApiClient.create() {
    final httpLink = HttpLink('https://api.spacex.land/graphql/');
    final link = Link.from([httpLink]);
    return MissionsApiClient(
      graphQLClient: GraphQLClient(
          cache: GraphQLCache(store: InMemoryStore()), link: link),
    );
  }

  final GraphQLClient _graphQLClient;

  Future<List<Mission>> getMissions(
      int offs, int lim, String searchterm) async {
    final result = await _graphQLClient.query(
      QueryOptions(
          document: gql(missionQuery(
              offset: offs.toString(),
              limit: lim.toString(),
              missionSearchTerm: searchterm))),
    );
    if (result.hasException) throw GetMissionsRequestFailure();
    final data = result.data?['launches'] as List;
    return data.map((e) => Mission.fromJson(e)).toList();
  }
}
