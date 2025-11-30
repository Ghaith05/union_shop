import 'dart:async';

import 'package:union_shop/data/sample_data.dart';

/// Tiny collection service abstraction.
/// This keeps the data access surface minimal for now and returns the
/// in-repo `sampleCollections`. Implemented as async to make wiring
/// to real backends trivial later.
Future<List<CollectionItem>> fetchCollections() async {
  // Simulate a short async delay so UI can show a loading state in tests/dev.
  return Future<List<CollectionItem>>.value(sampleCollections);
}
