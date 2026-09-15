import '../../models/document.dart';

abstract class DocumentRepository {
  Future<List<Document>> getDocuments();
  Future<Document?> getDocumentById(String id);
  Future<void> saveDocument(Document document);
  Future<void> deleteDocument(String id);
  Future<List<Document>> searchDocuments(String query);
  Future<List<Document>> getDocumentsByCategory(String category);
}
