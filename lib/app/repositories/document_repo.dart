import 'dart:convert';

import 'package:dk_docs/app/models/document_model.dart';
import 'package:dk_docs/auth/repo/local_storage_repo.dart';
import 'package:dk_docs/shared/resources/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class DocumentRepo {
  final http.Client _client;
  final LocalStorageRepo _localStorageRepo;

  DocumentRepo({required this._client, required this._localStorageRepo});

  Future<DocumentModel?> createDocument() async {
    try {
      final uri = Uri.parse("${Constants.serverBaseUrl}/documents/create");
      final token = await _localStorageRepo.getVal(
        key: Constants.tokenHeaderValue,
      );
      final response = await _client.post(
        uri,
        headers: {
          "Content-Type": "applicaton/json",
          "x-auth-token": token ?? "",
        },
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 201) {
        return DocumentModel.fromMap(data);
      } else {
        throw Exception(data['message'] ?? "An error occurred");
      }
    } catch (e) {
      debugPrint(e.toString());

      return null;
    }
  }

  Future<DocumentModel?> getDocument(String documentId) async {
    try {
      final uri = Uri.parse(
        "${Constants.serverBaseUrl}/documents",
      ).replace(queryParameters: {'id': documentId});
      debugPrint(uri.toString());

      final token = await _localStorageRepo.getVal(
        key: Constants.tokenHeaderValue,
      );
      final response = await _client.get(
        uri,
        headers: {"x-auth-token": token ?? ""},
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return DocumentModel.fromMap(data);
      }
      throw Exception(data['message'] ?? "An error occurred");
    } catch (e) {
      debugPrint(e.toString());
      throw Exception("An error occurred");
    }
  }

  Future<List<DocumentModel>> getMyDocuments() async {
    try {
      final uri = Uri.parse("${Constants.serverBaseUrl}/documents/me");

      final token = await _localStorageRepo.getVal(
        key: Constants.tokenHeaderValue,
      );
      final response = await _client.get(
        uri,
        headers: {"x-auth-token": token ?? ""},
      );

      final data = jsonDecode(response.body);
      final List<dynamic> dataDoc = data;
      if (response.statusCode == 200) {
        return dataDoc.map((doc) => DocumentModel.fromMap(doc)).toList();
      }
      return throw Exception(data['message'] ?? "An error occurred");
    } catch (e) {
      debugPrint(e.toString());

      return throw Exception(e.toString);
    }
  }

  Future<DocumentModel?> updateDocument(DocumentModel newDoc) async {
    try {
      final uri = Uri.parse("${Constants.serverBaseUrl}/documents");
      debugPrint(uri.toString());

      final token = await _localStorageRepo.getVal(
        key: Constants.tokenHeaderValue,
      );
      final response = await _client.put(
        uri,
        body: jsonEncode({
          "id": newDoc.id,
          "title": newDoc.title,
          "content": newDoc.content,
        }),
        headers: {
          "x-auth-token": token ?? "",
          'Content-Type': 'application/json',
        },
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return DocumentModel.fromMap(data);
      }
      throw Exception(data['message'] ?? "An error occurred");
    } catch (e) {
      debugPrint(e.toString());
      throw Exception("An error occurred");
    }
  }
}
