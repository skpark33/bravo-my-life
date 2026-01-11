import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../models/life_year.dart';
import '../models/life_event.dart';
import '../providers/life_data_provider.dart';

class YearDetailDialog extends StatefulWidget {
  final int year;
  final int age;
  final LifeYear lifeYear;

  const YearDetailDialog({
    super.key,
    required this.year,
    required this.age,
    required this.lifeYear,
  });

  @override
  State<YearDetailDialog> createState() => _YearDetailDialogState();
}

class _YearDetailDialogState extends State<YearDetailDialog> {
  late int? _score;
  late String? _photoPath;
  late List<LifeEvent> _events;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _score = widget.lifeYear.score;
    _photoPath = widget.lifeYear.photoPath;
    _events = List.from(widget.lifeYear.events);
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _photoPath = image.path;
      });
    }
  }

  void _addEvent() {
    showDialog(
      context: context,
      builder: (context) => EventEditDialog(
        onSave: (title, desc) {
          setState(() {
            _events.add(LifeEvent(
              id: DateTime.now().millisecondsSinceEpoch.toString(), // Simple ID
              title: title,
              description: desc,
            ));
          });
        },
      ),
    );
  }

  void _editEvent(LifeEvent event) {
    showDialog(
       context: context,
       builder: (context) => EventEditDialog(
         initialTitle: event.title,
         initialDescription: event.description,
         onSave: (title, desc) {
           setState(() {
             final index = _events.indexWhere((e) => e.id == event.id);
             if (index != -1) {
               _events[index] = LifeEvent(
                 id: event.id, 
                 title: title, 
                 description: desc,
                 date: event.date
               );
             }
           });
         },
       ),
    );
  }

  void _deleteEvent(String id) {
    setState(() {
      _events.removeWhere((e) => e.id == id);
    });
  }

  void _save() {
    final newYear = LifeYear(
      year: widget.year,
      score: _score,
      photoPath: _photoPath,
      events: _events,
    );
    context.read<LifeDataProvider>().updateYear(newYear);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Dialog(
      child: Container(
        width: 600,
        height: 800,
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${widget.year}${l10n.year} (${widget.age}${l10n.age})',
                    style: Theme.of(context).textTheme.headlineSmall),
                IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
              ],
            ),
            const Divider(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Score
                    Text("Evaluation", style: Theme.of(context).textTheme.titleMedium),
                    Wrap(
                      spacing: 8,
                      children: List.generate(7, (index) {
                        final score = index + 1;
                        final isSelected = _score == score;
                        return ChoiceChip(
                          label: Text('$score'),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              _score = selected ? score : null;
                            });
                          },
                          // Add color/tooltip for meaning
                        );
                      }),
                    ),
                    const SizedBox(height: 24),
                    
                    // Photo
                    Text(l10n.selectPhoto, style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        height: 200,
                        width: double.infinity,
                        color: Colors.grey[200],
                        child: _photoPath != null
                          ? Image.file(File(_photoPath!), fit: BoxFit.cover)
                          : const Icon(Icons.add_a_photo, size: 50, color: Colors.grey),
                      ),
                    ),
                     const SizedBox(height: 24),

                    // Events
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Events", style: Theme.of(context).textTheme.titleMedium),
                        IconButton(icon: const Icon(Icons.add), onPressed: _addEvent),
                      ],
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _events.length,
                      itemBuilder: (context, index) {
                        final event = _events[index];
                        return ListTile(
                          title: Text(event.title),
                          subtitle: Text(event.description),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, size: 18),
                                onPressed: () => _editEvent(event),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, size: 18),
                                onPressed: () => _deleteEvent(event.id),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(onPressed: () => Navigator.pop(context), child: Text(l10n.cancel)),
                const SizedBox(width: 8),
                FilledButton(onPressed: _save, child: Text(l10n.save)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class EventEditDialog extends StatefulWidget {
  final String? initialTitle;
  final String? initialDescription;
  final Function(String title, String desc) onSave;

  const EventEditDialog({
    super.key,
    this.initialTitle,
    this.initialDescription,
    required this.onSave,
  });

  @override
  State<EventEditDialog> createState() => _EventEditDialogState();
}

class _EventEditDialogState extends State<EventEditDialog> {
  late TextEditingController _titleController;
  late TextEditingController _descController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialTitle);
    _descController = TextEditingController(text: widget.initialDescription);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text(widget.initialTitle == null ? l10n.addEvent : l10n.edit),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _titleController,
            decoration: InputDecoration(labelText: l10n.eventTitle),
          ),
          TextField(
            controller: _descController,
            decoration: InputDecoration(labelText: l10n.eventDescription),
            maxLines: 3,
          ),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text(l10n.cancel)),
        FilledButton(
          onPressed: () {
            widget.onSave(_titleController.text, _descController.text);
            Navigator.pop(context);
          },
          child: Text(l10n.save),
        ),
      ],
    );
  }
}
