import 'package:dk_docs/app/models/document_model.dart';
import 'package:dk_docs/app/repositories/document_repo.dart';
import 'package:dk_docs/auth/providers/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final documentRepoProvider = Provider(
  (ref) => DocumentRepo(
    client: ref.watch(httpClientProvider),
    localStorageRepo: ref.watch(localStorageRepoProvider),
  ),
);

final getDocumentProvider = FutureProvider.family<DocumentModel?, String>(
  (ref, id) => ref.watch(documentRepoProvider).getDocument(id),
);

final getMyDocumentsProvider = FutureProvider(
  (ref) => ref.watch(documentRepoProvider).getMyDocuments(),
);

Future<void> refreshAllDocumentsProvider(WidgetRef ref) async {
  ref.invalidate(getMyDocumentsProvider);
  ref.invalidate(getDocumentProvider);
   final _ = ref.refresh(getMyDocumentsProvider.future);
}
