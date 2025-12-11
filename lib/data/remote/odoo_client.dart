import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter_demo/data/models/project_data.dart';
import 'package:flutter_demo/env.dart';


class OdooClient {
  String green(String msg) => "\x1B[32m$msg\x1B[0m";
  String red(String msg)   => "\x1B[31m$msg\x1B[0m";
  String yellow(String msg)=> "\x1B[33m$msg\x1B[0m";
  String pink(String msg) => "\x1B[38;2;255;105;180m$msg\x1B[0m";

  OdooClient._internal();
  static final OdooClient instance = OdooClient._internal();

  final String baseUrl = Env.url;
  final String dbName = Env.db;
  String? _sessionId;


  Future<bool> authenticate(String username, String password) async {
    try {
      final url = Uri.parse('$baseUrl/web/session/authenticate');
      debugPrint(pink('Attempting authentication to: $url'));

      final payload = {
        'jsonrpc': '2.0',
        'method': 'call',
        'params': {
          'db': dbName,
          'login': username,
          'password': password,
        }
      };

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          // 'Accept-Encoding': 'identity'
          },
        body: jsonEncode(payload),
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw TimeoutException(red('Connection timeout after 10 seconds'));
        },
      );

      debugPrint(green('Auth status: ${response.statusCode}'));
      debugPrint(pink('Auth body: ${response.body}'));

      if (response.statusCode != 200) {
        debugPrint(red('Auth failed with status: ${response.statusCode}'));
        return false;
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final result = data['result'] as Map<String, dynamic>?;

      if (result == null) {
        debugPrint(red('No result in response'));
        return false;
      }

      final uid = result['uid'];
      debugPrint(pink('authenticate() uid: $uid'));

      if (uid == null) {
        debugPrint(red('No UID returned - authentication failed'));
        return false;
      }

      // Read session_id from Set-Cookie
      final cookies = response.headers['set-cookie'];
      debugPrint(pink('Set-Cookie: $cookies'));

      if (cookies != null) {
        final parts = cookies.split(';');
        for (final part in parts) {
          final trimmed = part.trim();
          if (trimmed.startsWith('session_id=')) {
            _sessionId = trimmed.substring('session_id='.length);
            debugPrint(green('Saved session_id: $_sessionId'));
            break;
          }
        }
      }

      return true;
    } on SocketException catch (e) {
      debugPrint(red('SocketException: ${e.message}'));
      debugPrint(pink('   Address: ${e.address}, Port: ${e.port}'));
      debugPrint(pink('   Check: Is Odoo server running? Is IP/port correct?'));
      return false;
    } on TimeoutException catch (e) {
      debugPrint(red('TimeoutException: ${e.message}'));
      debugPrint('   The server is not responding. Check firewall/network.');
      return false;
    } on http.ClientException catch (e) {
      debugPrint(red('ClientException: $e'));
      debugPrint('   Actual URL attempted: $baseUrl/web/session/authenticate');
      return false;
    } catch (e) {
      debugPrint(red('Unexpected error during authentication: $e'));
      return false;
    }
  }

  Future<dynamic> callKw({
    required String model,
    required String method,
    required List args,
    Map<String, dynamic>? kwargs,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/web/dataset/call_kw/$model/$method');
      debugPrint(pink('Calling: $url'));

      final payload = {
        'jsonrpc': '2.0',
        'params': {
          'model': model,
          'method': method,
          'args': args,
          'kwargs': kwargs ?? {},
        }
      };

      final headers = <String, String>{
        'Content-Type': 'application/json',
      };

      if (_sessionId != null) {
        headers['Cookie'] = 'session_id=$_sessionId';
      } else {
        debugPrint(yellow('Warning: No session_id available'));
      }

      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(payload),
      ).timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          throw TimeoutException('Request timeout after 15 seconds');
        },
      );

      debugPrint(green('callKw $model.$method status: ${response.statusCode}'));
      debugPrint(pink('callKw body: ${response.body}'));

      if (response.statusCode != 200) {
        throw Exception(red('HTTP error ${response.statusCode}'));
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;

      if (data['error'] != null) {
        final err = data['error'] as Map<String, dynamic>;
        debugPrint(red('Odoo error: ${err['message']}'));
        throw Exception(red('Odoo error: ${err['message']}'));
      }

      return data['result'];
    } on SocketException catch (e) {
      debugPrint(red('SocketException in callKw: ${e.message}'));
      rethrow;
    } on TimeoutException catch (e) {
      debugPrint(red('TimeoutException in callKw: ${e.message}'));
      rethrow;
    } catch (e) {
      debugPrint(red('Error in callKw: $e'));
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> fetchPersonnelRaw() async {
    final result = await callKw(
      model: 'hr.employee',
      method: 'search_read',
      args: [
        [], // domain
        ['id', 'name', 'job_id'],
      ],
    );
    return List<Map<String, dynamic>>.from(result as List);
  }

  Future<List<ProjectData>> fetchProjects() async {
    final result = await callKw(
      model: 'project.project',
      method: 'search_read',
      args: [
        [],
        [
          'id',
          'name',
          'partner_id',
          'company_id',
          'user_id',
          'supervisor',
          'coordinador',
          'date_start',
          'allocated_hours',
          'state',
        ],
      ],
      kwargs: {
        'limit': 50,
        'order': 'create_date desc',
      },
    );

    final projectMaps = List<Map<String, dynamic>>.from(result as List);
    return projectMaps
        .map((record) => ProjectData.fromOdoo(Map<String, dynamic>.from(record)))
        .toList(growable: false);
  }

  Future<int> createRecord(String model, Map<String, dynamic> values) async {
    final url = Uri.parse('$baseUrl/web/dataset/call_kw');

    final payload = {
      'jsonrpc': '2.0',
      'method': 'call',
      'params': {
        'model': model,
        'method': 'create',
        'args': [values],
        'kwargs': {},
      },
    };

    final headers = <String, String> {
      'Content-Type': 'application/json',
    };
    if (_sessionId != null) {
      headers['Cookie'] = 'session_id=$_sessionId';
    } else {
      debugPrint(yellow('Warning: creating record WITHOUT session_id'));
    }
    
    final res = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(payload),
    );

    if (res.statusCode != 200) {
      throw Exception('Error HTTP al crear registro: ${res.statusCode}');
    }

    final data = jsonDecode(res.body);

    if (data['error'] != null) {
      throw Exception('Error Odoo: ${data['error']}');
    }

    // Odoo regresa el ID del nuevo registro
    final id = data['result'];
    return id is int ? id : int.parse(id.toString());
  }
}