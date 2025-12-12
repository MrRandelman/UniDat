// ignore_for_file: deprecated_member_use
// OJBSOIIDB

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unidat_core/ui/layout/main_scaffold.dart';

void main() {
  runApp(const ProviderScope(child: UniDatApp()));
}

/// ----------------------------------------------------------
/// Haupt-App
/// ----------------------------------------------------------

class UniDatApp extends StatelessWidget {
  const UniDatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainScaffold(),
    );
  }
}

/// ----------------------------------------------------------
/// Shell: Sidebar links, Hauptbereich rechts
/// ----------------------------------------------------------
class LayoutShell extends StatelessWidget {
  const LayoutShell({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: const [
          _Sidebar(),
          Expanded(child: _MainDashboard()),
        ],
      ),
    );
  }
}

/// ----------------------------------------------------------
/// Sidebar – Logo, Navigation, Lernprozess, Streak
/// ----------------------------------------------------------
class _Sidebar extends StatelessWidget {
  const _Sidebar();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: 90,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          const SizedBox(height: 24),
          Icon(Icons.school, size: 40, color: colorScheme.primary),
          const SizedBox(height: 40),

          _NavItem(icon: Icons.home_rounded, label: 'Home', active: true),
          _NavItem(icon: Icons.folder_rounded, label: 'Docs'),
          _NavItem(icon: Icons.calendar_month_rounded, label: 'Cal'),
          _NavItem(icon: Icons.check_circle_rounded, label: 'Tasks'),

          const Spacer(),

          // Lernprozess (klein, dezent)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Column(
              children: [
                Text(
                  'Lern-\nprozess',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 10, color: Colors.grey.shade700),
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: LinearProgressIndicator(
                    value: 0.3,
                    minHeight: 5,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Streak Badge
          Padding(
            padding: const EdgeInsets.only(bottom: 18, top: 4),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF3E0),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(
                        Icons.local_fire_department_rounded,
                        size: 16,
                        color: Color(0xFFFFA726),
                      ),
                      SizedBox(width: 4),
                      Text(
                        '3 Tage',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFFB8C00),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Streak',
                  style: TextStyle(fontSize: 10, color: Colors.grey.shade700),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;

  const _NavItem({
    required this.icon,
    required this.label,
    this.active = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final baseColor = active ? colorScheme.primary : Colors.grey.shade700;
    final bgColor = active ? colorScheme.primary.withOpacity(0.12) : null;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Icon(icon, size: 24, color: baseColor),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: baseColor,
              fontWeight: active ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

/// ----------------------------------------------------------
/// Main Dashboard – Topbar, Kalender, Explorer, Aufgaben
/// ----------------------------------------------------------
class _MainDashboard extends StatelessWidget {
  const _MainDashboard();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(
          left: 20,
          right: 20,
          top: 18,
          bottom: 18,
        ),
        child: Column(
          children: [
            const _TopBar(),
            const SizedBox(height: 18),
            const _CalendarCard(),
            const SizedBox(height: 18),
            const _ExplorerRow(), // 3 Spalten: Ordner | Dateien | Preview
            const SizedBox(height: 18),
            Expanded(
              child: Row(
                children: const [
                  Expanded(child: _ImportantTodayCard()),
                  SizedBox(width: 18),
                  Expanded(child: _TasksListCard()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Top-Leiste: Suche, Filter, Einstellungen
class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search_rounded),
              hintText: 'Suche in UniDat…',
              filled: true,
              fillColor: Colors.white.withOpacity(0.9),
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        _TopIconButton(icon: Icons.filter_alt_rounded, tooltip: 'Filter'),
        const SizedBox(width: 8),
        _TopIconButton(icon: Icons.settings_rounded, tooltip: 'Einstellungen'),
        const SizedBox(width: 8),
        CircleAvatar(
          radius: 16,
          backgroundColor: colorScheme.primary,
          child: const Text(
            'MP',
            style: TextStyle(fontSize: 12, color: Colors.white),
          ),
        ),
      ],
    );
  }
}

class _TopIconButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;

  const _TopIconButton({required this.icon, required this.tooltip});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.white,
        shape: const CircleBorder(),
        elevation: 0,
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(icon, size: 20, color: Colors.grey.shade700),
          ),
        ),
      ),
    );
  }
}

/// ----------------------------------------------------------
/// Kalender – oben, größte Card
/// ----------------------------------------------------------
class _CalendarCard extends StatelessWidget {
  const _CalendarCard();

  @override
  Widget build(BuildContext context) {
    final deco = softCardDecoration();

    return Container(
      height: 190,
      decoration: deco,
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Titelzeile
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Kalender – Woche',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
              ),
              Row(
                children: [
                  Text(
                    '01.–07. März',
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.chevron_left_rounded,
                    size: 20,
                    color: Colors.grey.shade700,
                  ),
                  Icon(
                    Icons.chevron_right_rounded,
                    size: 20,
                    color: Colors.grey.shade700,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Wochenband
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _weekdayChip('Mo', 1, active: true),
              _weekdayChip('Di', 2),
              _weekdayChip('Mi', 3),
              _weekdayChip('Do', 4),
              _weekdayChip('Fr', 5),
              _weekdayChip('Sa', 6),
              _weekdayChip('So', 7),
            ],
          ),

          const SizedBox(height: 16),
          const Divider(height: 1),

          const SizedBox(height: 10),
          // Tagesliste – nur Beispiel, keine Logik
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _calendarItem('Datenbanken VL', '09:20 – 10:50'),
                _calendarItem('Selbstlern-Session Mathe', '14:00 – 16:00'),
                _calendarItem('Projektbesprechung UniDat', '18:00 – 19:00'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _weekdayChip(String label, int day, {bool active = false}) {
    final baseColor = active ? const Color(0xFF0EA48F) : Colors.grey.shade700;
    final bg = active ? const Color(0xFFE0F5F2) : Colors.transparent;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: baseColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            day.toString(),
            style: TextStyle(fontSize: 11, color: baseColor),
          ),
        ],
      ),
    );
  }

  Widget _calendarItem(String title, String time) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 6,
            height: 32,
            decoration: BoxDecoration(
              color: const Color(0xFF0EA48F),
              borderRadius: BorderRadius.circular(999),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  time,
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade700),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// ----------------------------------------------------------
/// Explorer Row – 3 Spalten: Ordner | Dateien | Preview
/// (Explorer = Variante A)
/// ----------------------------------------------------------
class _ExplorerRow extends StatelessWidget {
  const _ExplorerRow();

  @override
  Widget build(BuildContext context) {
    final deco = softCardDecoration();

    return SizedBox(
      height: 210,
      child: Row(
        children: [
          // Ordnerbaum
          Expanded(
            flex: 2,
            child: Container(
              decoration: deco,
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionHeader('Ordner'),
                  const SizedBox(height: 8),
                  Expanded(
                    child: ListView(
                      children: const [
                        _FolderItem(label: 'Semester 1'),
                        _FolderItem(label: 'Semester 2'),
                        _FolderItem(label: 'Datenbanken'),
                        _FolderItem(label: 'Mathe'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 16),

          // Dateiliste
          Expanded(
            flex: 3,
            child: Container(
              decoration: deco,
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionHeader('Dateien'),
                  const SizedBox(height: 8),
                  const _FileRow(
                    name: 'DB_VL03_Einführung.pdf',
                    tag: 'Vorlesung',
                  ),
                  const _FileRow(
                    name: 'DB_Übung03_Aufgabenblatt.pdf',
                    tag: 'Übung',
                  ),
                  const _FileRow(
                    name: 'UniDat_Projektbeschreibung.docx',
                    tag: 'Projekt',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 16),

          // Preview
          Expanded(
            flex: 3,
            child: Container(
              decoration: deco,
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionHeader('Vorschau'),
                  const SizedBox(height: 8),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Center(
                        child: Text(
                          'Dokument-Vorschau\n(Platzhalter)',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionHeader(String label) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}

class _FolderItem extends StatelessWidget {
  final String label;

  const _FolderItem({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Icon(Icons.folder_rounded, size: 18, color: Colors.amber.shade700),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}

class _FileRow extends StatelessWidget {
  final String name;
  final String tag;

  const _FileRow({required this.name, required this.tag});

  @override
  Widget build(BuildContext context) {
    final tagColor = Colors.teal.shade50;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          const Icon(
            Icons.picture_as_pdf_rounded,
            size: 18,
            color: Colors.redAccent,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              name,
              style: const TextStyle(fontSize: 12),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: tagColor,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              tag,
              style: const TextStyle(fontSize: 10, color: Color(0xFF0EA48F)),
            ),
          ),
        ],
      ),
    );
  }
}

/// ----------------------------------------------------------
/// Unten: Wichtigste Aufgaben (links) & allgemeine Aufgabenliste (rechts)
/// ----------------------------------------------------------
class _ImportantTodayCard extends StatelessWidget {
  const _ImportantTodayCard();

  @override
  Widget build(BuildContext context) {
    final deco = softCardDecoration();

    return Container(
      decoration: deco,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Wichtig heute',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          _importantItem(
            'Abgabe DB Übungsblatt 3',
            'Fällig: 16:00',
            critical: true,
          ),
          _importantItem('Mathe: Vorbereitung Kurztest', 'Für morgen'),
          _importantItem('Notizen für UniDat Meeting ordnen', 'Heute Abend'),
        ],
      ),
    );
  }

  Widget _importantItem(
    String title,
    String subtitle, {
    bool critical = false,
  }) {
    final dotColor = critical
        ? const Color(0xFFFF7043)
        : const Color(0xFF0EA48F);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: dotColor,
              borderRadius: BorderRadius.circular(999),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade700),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TasksListCard extends StatelessWidget {
  const _TasksListCard();

  @override
  Widget build(BuildContext context) {
    final deco = softCardDecoration();

    return Container(
      decoration: deco,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Aufgabenliste',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView(
              children: const [
                _TaskRow(
                  title: 'DB – Kapitel 4 lesen',
                  module: 'Datenbanken',
                  done: false,
                ),
                _TaskRow(
                  title: 'Mathe – Übungsblatt 4',
                  module: 'Mathematik',
                  done: false,
                ),
                _TaskRow(
                  title: 'Softwaretechnik – Use-Case Diagramm',
                  module: 'SWT',
                  done: true,
                ),
                _TaskRow(
                  title: 'Notizen aus VL sortieren',
                  module: 'Allgemein',
                  done: false,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TaskRow extends StatelessWidget {
  final String title;
  final String module;
  final bool done;

  const _TaskRow({
    required this.title,
    required this.module,
    this.done = false,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = done
        ? Colors.grey.shade500
        : Theme.of(context).colorScheme.onSurface;
    final decoration = done ? TextDecoration.lineThrough : TextDecoration.none;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Icon(
            done
                ? Icons.check_circle_rounded
                : Icons.radio_button_unchecked_rounded,
            size: 18,
            color: done ? const Color(0xFF0EA48F) : Colors.grey.shade500,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 13,
                color: textColor,
                decoration: decoration,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              module,
              style: TextStyle(fontSize: 10, color: Colors.grey.shade700),
            ),
          ),
        ],
      ),
    );
  }
}

/// ----------------------------------------------------------
/// Helper: Soft Card Decoration (Stil B)
/// ----------------------------------------------------------
BoxDecoration softCardDecoration() {
  return BoxDecoration(
    color: Colors.white.withOpacity(0.9),
    borderRadius: BorderRadius.circular(20),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.07),
        blurRadius: 24,
        offset: const Offset(0, 8),
      ),
    ],
  );
}
