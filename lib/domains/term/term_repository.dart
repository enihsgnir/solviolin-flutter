import 'package:solviolin/domains/term/term.dart';
import 'package:solviolin/domains/term/term_client.dart';
import 'package:solviolin/utils/client.dart';

final _client = TermClient(dio);

Future<List<Term>> getTerms(int take) async {
  return await _client.getTerms(take);
}

Future<List<Term>> getAllTerms() async {
  return await getTerms(0);
}
