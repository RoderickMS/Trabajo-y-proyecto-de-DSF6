import 'package:flutter/material.dart';
import 'package:task_app_client/task_app_client.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../main.dart';
import 'contact_form_screen.dart';
import 'contact_detail_screen.dart';

class ContactListScreen extends StatefulWidget {
  const ContactListScreen({super.key});

  @override
  State<ContactListScreen> createState() => _ContactListScreenState();
}

class _ContactListScreenState extends State<ContactListScreen>
    with SingleTickerProviderStateMixin {
  List<Contact> _contacts = [];
  List<Contact> _filtered = [];
  bool _loading = true;
  bool _searchActive = false;
  final _searchController = TextEditingController();
  final _searchFocus = FocusNode();
  late AnimationController _fabController;
  late Animation<double> _fabScale;

  @override
  void initState() {
    super.initState();
    _fabController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fabScale = CurvedAnimation(parent: _fabController, curve: Curves.easeOutBack);
    _loadContacts();
  }

  @override
  void dispose() {
    _fabController.dispose();
    _searchController.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  Future<void> _loadContacts() async {
    setState(() => _loading = true);
    final contacts = await client.contact.getAll();
    contacts.sort((a, b) => a.name.compareTo(b.name));
    setState(() {
      _contacts = contacts;
      _filtered = contacts;
      _loading = false;
    });
    _fabController.forward();
  }

  void _search(String query) {
    final q = query.toLowerCase().trim();
    setState(() {
      if (q.isEmpty) {
        _filtered = _contacts;
      } else {
        _filtered = _contacts.where((c) {
          final name = c.name.toLowerCase();
          final phone = c.phone.toLowerCase();
          final email = (c.email ?? '').toLowerCase();
          // Búsqueda por prefijo, subcadena en nombre, teléfono o email
          return name.startsWith(q) ||
              name.contains(q) ||
              phone.contains(q) ||
              email.contains(q);
        }).toList();
      }
    });
  }

  void _activateSearch() {
    setState(() => _searchActive = true);
    Future.delayed(const Duration(milliseconds: 50), () {
      _searchFocus.requestFocus();
    });
  }

  void _deactivateSearch() {
    setState(() {
      _searchActive = false;
      _searchController.clear();
      _filtered = _contacts;
    });
    _searchFocus.unfocus();
  }

  Future<void> _delete(Contact contact) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Eliminar contacto'),
        content: Text('¿Eliminar a ${contact.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red.shade400),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await client.contact.delete(contact.id!);
      _loadContacts();
    }
  }

  // Agrupa contactos por primera letra
  Map<String, List<Contact>> _groupByLetter(List<Contact> contacts) {
    final Map<String, List<Contact>> map = {};
    for (final c in contacts) {
      final letter = c.name[0].toUpperCase();
      map.putIfAbsent(letter, () => []).add(c);
    }
    return map;
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final grouped = _groupByLetter(_filtered);
    final letters = grouped.keys.toList()..sort();

    // Construir lista plana con encabezados de letra
    final List<dynamic> items = [];
    for (final letter in letters) {
      items.add(letter); // encabezado
      items.addAll(grouped[letter]!);
    }

    return Scaffold(
      backgroundColor: scheme.surface,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            expandedHeight: 120,
            floating: true,
            snap: true,
            pinned: true,
            backgroundColor: scheme.surface,
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              title: _searchActive
                  ? TextField(
                      controller: _searchController,
                      focusNode: _searchFocus,
                      onChanged: _search,
                      style: TextStyle(
                        fontSize: 16,
                        color: scheme.onSurface,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Buscar contacto...',
                        hintStyle: TextStyle(color: scheme.outline),
                        border: InputBorder.none,
                        isDense: true,
                      ),
                    )
                  : Text(
                      'Contactos',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: scheme.onSurface,
                        letterSpacing: -0.5,
                      ),
                    ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      scheme.primary.withOpacity(0.08),
                      scheme.surface,
                    ],
                  ),
                ),
              ),
            ),
            actions: [
              if (_searchActive)
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: _deactivateSearch,
                )
              else ...[
                IconButton(
                  icon: Icon(Icons.search, color: scheme.primary),
                  onPressed: _activateSearch,
                ),
                IconButton(
                  icon: Icon(Icons.refresh_rounded, color: scheme.primary),
                  onPressed: _loadContacts,
                ),
              ],
            ],
          ),
        ],
        body: _loading
            ? Center(
                child: CircularProgressIndicator(color: scheme.primary),
              )
            : _filtered.isEmpty
                ? _buildEmpty(scheme)
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                    itemCount: items.length,
                    itemBuilder: (context, i) {
                      final item = items[i];
                      if (item is String) {
                        // Encabezado de letra
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(4, 16, 4, 6),
                          child: Text(
                            item,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: scheme.primary,
                              letterSpacing: 1.2,
                            ),
                          ),
                        );
                      }
                      final contact = item as Contact;
                      return _buildContactTile(context, contact, scheme);
                    },
                  ),
      ),
      floatingActionButton: ScaleTransition(
        scale: _fabScale,
        child: FloatingActionButton.extended(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ContactFormScreen()),
          ).then((_) => _loadContacts()),
          icon: const Icon(Icons.person_add_rounded),
          label: const Text(
            'Nuevo contacto',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          elevation: 4,
        ),
      ),
    );
  }

  Widget _buildEmpty(ColorScheme scheme) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: scheme.primaryContainer.withOpacity(0.4),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _searchActive ? Icons.search_off_rounded : Icons.contacts_outlined,
              size: 56,
              color: scheme.primary,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            _searchActive ? 'Sin resultados' : 'Sin contactos',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: scheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _searchActive
                ? 'Probá con otro término'
                : 'Tocá + para agregar uno',
            style: TextStyle(fontSize: 14, color: scheme.outline),
          ),
        ],
      ),
    );
  }

  Widget _buildContactTile(
      BuildContext context, Contact contact, ColorScheme scheme) {
    final avatarColor = Color(contact.avatarColor);

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Slidable(
        key: ValueKey(contact.id),
        endActionPane: ActionPane(
          motion: const BehindMotion(),
          extentRatio: 0.45,
          children: [
            SlidableAction(
              onPressed: (_) => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ContactFormScreen(contact: contact),
                ),
              ).then((_) => _loadContacts()),
              backgroundColor: scheme.primary,
              foregroundColor: Colors.white,
              icon: Icons.edit_rounded,
              label: 'Editar',
              borderRadius:
                  const BorderRadius.horizontal(left: Radius.circular(16)),
            ),
            SlidableAction(
              onPressed: (_) => _delete(contact),
              backgroundColor: Colors.red.shade400,
              foregroundColor: Colors.white,
              icon: Icons.delete_rounded,
              label: 'Eliminar',
              borderRadius:
                  const BorderRadius.horizontal(right: Radius.circular(16)),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ContactDetailScreen(contact: contact),
              ),
            ).then((_) => _loadContacts()),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: scheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: scheme.outlineVariant.withOpacity(0.4),
                  width: 0.5,
                ),
              ),
              child: Row(
                children: [
                  // Avatar con inicial
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: avatarColor,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: avatarColor.withOpacity(0.35),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        contact.name[0].toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          contact.name,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            color: scheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          contact.phone,
                          style: TextStyle(
                            fontSize: 13,
                            color: scheme.outline,
                          ),
                        ),
                        if (contact.email != null && contact.email!.isNotEmpty)
                          Text(
                            contact.email!,
                            style: TextStyle(
                              fontSize: 12,
                              color: scheme.outline.withOpacity(0.7),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: scheme.outlineVariant,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}