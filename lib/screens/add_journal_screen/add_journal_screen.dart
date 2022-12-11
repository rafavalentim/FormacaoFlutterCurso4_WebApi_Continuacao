import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../helpers/logout.dart';
import '../../helpers/weekday.dart';
import '../../models/journal.dart';
import '../../services/journal_service.dart';
import '../commom/exception_dialog.dart';

class AddJournalScreen extends StatelessWidget {
  final Journal journal;
  final bool isEditing;

  AddJournalScreen({Key? key, required this.journal, required this.isEditing})
      : super(key: key);

  final TextEditingController _contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _contentController.text = journal.content;
    return Scaffold(
      appBar: AppBar(
        title: Text(WeekDay(journal.createdAt).toString()),
        actions: [
          IconButton(
            onPressed: () {
              registerJournal(context);
            },
            icon: const Icon(Icons.check),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: TextField(
          controller: _contentController,
          keyboardType: TextInputType.multiline,
          style: const TextStyle(fontSize: 24),
          expands: true,
          maxLines: null,
          minLines: null,
        ),
      ),
    );
  }

  registerJournal(BuildContext context) async {
    SharedPreferences.getInstance().then((prefs) {
      String? token = prefs.getString("accessToken");

      if (token != null) {
        JournalService journalService = JournalService();

        journal.content = _contentController.text;

        if (isEditing) {
          journalService.register(journal, token).then(
            (value) {
              if (value) {
                Navigator.pop(context, DisposeStatus.success);
              } else {
                Navigator.pop(context, DisposeStatus.error);
              }
            },
          ).catchError(
            test: (error) => error is TokenNotValidException,
                (error) {
              logout(context);
            },
          ).catchError(
            test: (error) => error is HttpException,
                (error) {
              var innerError = error as HttpException;
              showExceptionDialog(context, content: innerError.message);
            },
          );
        } else {
          journalService.edit(journal.id, journal, token).then((value) {
            if (value) {
              Navigator.pop(context, DisposeStatus.success);
            } else {
              Navigator.pop(context, DisposeStatus.error);
            }
          }).catchError(
            test: (error) => error is TokenNotValidException,
            (error) {
              logout(context);
            },
          ).catchError(
            test: (error) => error is HttpException,
            (error) {
              var innerError = error as HttpException;
              showExceptionDialog(context, content: innerError.message);
            },
          );
        }
      }
    });
  }
}

enum DisposeStatus { exit, error, success }
