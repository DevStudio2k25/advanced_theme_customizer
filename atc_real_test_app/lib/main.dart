import 'package:advanced_theme_customizer/advanced_theme_customizer.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const AtcRealTestApp());
}

enum _HostMenuAction {
  openSettingsMode,
  openPageMode,
  exportJson,
  importReplace,
  importMerge,
  importDefaults,
  reimportLastExport,
  clearRuntimeDiagnostics,
}

class AtcRealTestApp extends StatefulWidget {
  const AtcRealTestApp({super.key});

  @override
  State<AtcRealTestApp> createState() => _AtcRealTestAppState();
}

class _AtcRealTestAppState extends State<AtcRealTestApp> {
  static const String _seedProfileJson = '''
{
  "schemaVersion": 2,
  "profile": {
    "id": "movie_seed",
    "name": "Movie Studio Theme",
    "updatedAt": "2026-04-08T12:00:00Z"
  },
  "base": {
    "presetId": "cinematic"
  },
  "rules": [
    {
      "scope": "global",
      "target": "global",
      "priority": 100,
      "styles": {
        "movie.home.banner.surface": {
          "default": {
            "fill": "#FF0F172A",
            "border": "#FF334155",
            "radius": 24,
            "borderWidth": 1
          }
        },
        "movie.home.banner.title": {
          "default": {
            "text": "#FFF8FAFC"
          }
        },
        "movie.home.input.search": {
          "default": {
            "fill": "#FFFFFFFF",
            "border": "#FF94A3B8",
            "text": "#FF0F172A",
            "radius": 14,
            "borderWidth": 1
          }
        },
        "movie.home.card.surface": {
          "default": {
            "fill": "#FF111827",
            "border": "#FF374151",
            "radius": 16,
            "borderWidth": 1
          }
        },
        "movie.home.card.title": {
          "default": {
            "text": "#FFF8FAFC"
          }
        },
        "movie.home.card.subtitle": {
          "default": {
            "text": "#FFCBD5E1"
          }
        },
        "movie.home.button.watch": {
          "default": {
            "fill": "#FFEA580C",
            "border": "#FFFB923C",
            "text": "#FFFFFFFF",
            "radius": 18,
            "borderWidth": 1
          }
        },
        "movie.details.poster.surface": {
          "default": {
            "fill": "#FF1F2937",
            "border": "#FF4B5563",
            "radius": 20,
            "borderWidth": 1
          }
        },
        "movie.details.title.text": {
          "default": {
            "text": "#FFF9FAFB"
          }
        },
        "movie.details.subtitle.text": {
          "default": {
            "text": "#FFD1D5DB"
          }
        },
        "movie.details.button.play": {
          "default": {
            "fill": "#FF16A34A",
            "border": "#FF4ADE80",
            "text": "#FF052E16",
            "radius": 20,
            "borderWidth": 1
          }
        },
        "movie.details.button.watchlist": {
          "default": {
            "fill": "#FF0F172A",
            "border": "#FF475569",
            "text": "#FFE2E8F0",
            "radius": 20,
            "borderWidth": 1
          }
        },
        "movie.details.chip.genre": {
          "default": {
            "fill": "#FF6D28D9",
            "text": "#FFFFFFFF",
            "radius": 14
          }
        }
      }
    },
    {
      "scope": "page",
      "target": "details",
      "priority": 200,
      "styles": {
        "movie.details.button.play": {
          "hover": {
            "fill": "#FF22C55E"
          }
        }
      }
    }
  ]
}
''';

  static const AdvancedComponentRegistry _registry = AdvancedComponentRegistry(
    pages: <AdvancedPageDescriptor>[
      AdvancedPageDescriptor(pageId: 'home', displayName: 'Home'),
      AdvancedPageDescriptor(pageId: 'details', displayName: 'Details'),
    ],
    groups: <AdvancedComponentGroupDescriptor>[
      AdvancedComponentGroupDescriptor(
        groupId: 'home.hero',
        pageId: 'home',
        displayName: 'Home Hero',
      ),
      AdvancedComponentGroupDescriptor(
        groupId: 'home.search',
        pageId: 'home',
        displayName: 'Home Search',
      ),
      AdvancedComponentGroupDescriptor(
        groupId: 'home.discover',
        pageId: 'home',
        displayName: 'Home Discover',
      ),
      AdvancedComponentGroupDescriptor(
        groupId: 'home.actions',
        pageId: 'home',
        displayName: 'Home Actions',
      ),
      AdvancedComponentGroupDescriptor(
        groupId: 'details.poster',
        pageId: 'details',
        displayName: 'Details Poster',
      ),
      AdvancedComponentGroupDescriptor(
        groupId: 'details.hero',
        pageId: 'details',
        displayName: 'Details Hero',
      ),
      AdvancedComponentGroupDescriptor(
        groupId: 'details.meta',
        pageId: 'details',
        displayName: 'Details Meta',
      ),
      AdvancedComponentGroupDescriptor(
        groupId: 'details.actions',
        pageId: 'details',
        displayName: 'Details Actions',
      ),
    ],
    components: <AdvancedComponentDescriptor>[
      AdvancedComponentDescriptor(
        componentId: 'movie.home.banner.surface',
        pageId: 'home',
        groupId: 'home.hero',
        componentTypeId: 'surface.banner',
        displayName: 'Home Banner Surface',
      ),
      AdvancedComponentDescriptor(
        componentId: 'movie.home.banner.title',
        pageId: 'home',
        groupId: 'home.hero',
        componentTypeId: 'text.title',
        displayName: 'Home Banner Title',
      ),
      AdvancedComponentDescriptor(
        componentId: 'movie.home.input.search',
        pageId: 'home',
        groupId: 'home.search',
        componentTypeId: 'input.search',
        displayName: 'Home Search Input',
      ),
      AdvancedComponentDescriptor(
        componentId: 'movie.home.card.surface',
        pageId: 'home',
        groupId: 'home.discover',
        componentTypeId: 'surface.card',
        displayName: 'Movie Card Surface',
      ),
      AdvancedComponentDescriptor(
        componentId: 'movie.home.card.title',
        pageId: 'home',
        groupId: 'home.discover',
        componentTypeId: 'text.cardTitle',
        displayName: 'Movie Card Title',
      ),
      AdvancedComponentDescriptor(
        componentId: 'movie.home.card.subtitle',
        pageId: 'home',
        groupId: 'home.discover',
        componentTypeId: 'text.cardSubtitle',
        displayName: 'Movie Card Subtitle',
      ),
      AdvancedComponentDescriptor(
        componentId: 'movie.home.button.watch',
        pageId: 'home',
        groupId: 'home.actions',
        componentTypeId: 'button.primary',
        displayName: 'Home Watch Button',
      ),
      AdvancedComponentDescriptor(
        componentId: 'movie.details.poster.surface',
        pageId: 'details',
        groupId: 'details.poster',
        componentTypeId: 'surface.poster',
        displayName: 'Details Poster Surface',
      ),
      AdvancedComponentDescriptor(
        componentId: 'movie.details.title.text',
        pageId: 'details',
        groupId: 'details.hero',
        componentTypeId: 'text.detailsTitle',
        displayName: 'Details Title',
      ),
      AdvancedComponentDescriptor(
        componentId: 'movie.details.subtitle.text',
        pageId: 'details',
        groupId: 'details.hero',
        componentTypeId: 'text.detailsSubtitle',
        displayName: 'Details Subtitle',
      ),
      AdvancedComponentDescriptor(
        componentId: 'movie.details.button.play',
        pageId: 'details',
        groupId: 'details.actions',
        componentTypeId: 'button.play',
        displayName: 'Details Play Button',
      ),
      AdvancedComponentDescriptor(
        componentId: 'movie.details.button.watchlist',
        pageId: 'details',
        groupId: 'details.actions',
        componentTypeId: 'button.watchlist',
        displayName: 'Details Watchlist Button',
      ),
      AdvancedComponentDescriptor(
        componentId: 'movie.details.chip.genre',
        pageId: 'details',
        groupId: 'details.meta',
        componentTypeId: 'chip.genre',
        displayName: 'Details Genre Chip',
      ),
    ],
  );

  late final AdvancedCustomizerController _controller;
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  int _tabIndex = 0;
  String _status = 'Ready';
  String? _lastExportedJson;

  String get _activePageId => _tabIndex == 0 ? 'home' : 'details';

  @override
  void initState() {
    super.initState();
    _controller = AdvancedCustomizerController(
      config: const AdvancedCustomizerConfig(
        registry: _registry,
        panelSkin: AdvancedCustomizerPanelSkin(cornerRadius: 18, elevation: 2),
        panelStrings: AdvancedCustomizerPanelStrings(
          title: 'ATC Real Test Studio',
        ),
      ),
    );

    final AdvancedCustomizerImportResult loaded = _controller.importProfileJson(
      _seedProfileJson,
      AdvancedCustomizerImportMode.replace,
    );

    _status = loaded.success
        ? 'Seed profile loaded. Open Live Studio to test draft/apply/discard flow with real page preview.'
        : _buildOperationStatus(
            action: 'Seed profile import',
            success: loaded.success,
            warningCount: loaded.warnings.length,
            diagnosticCount: loaded.diagnostics.length,
            errorMessage: loaded.errorMessage,
          );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildPagePreview(String pageId) {
    if (pageId == 'details') {
      return _MovieDetailsPage(controller: _controller);
    }
    return _MovieHomePage(controller: _controller);
  }

  String _buildOperationStatus({
    required String action,
    required bool success,
    int warningCount = 0,
    int diagnosticCount = 0,
    String? errorMessage,
  }) {
    final String message =
        '$action ${success ? 'succeeded' : 'failed'} '
        '(warnings: $warningCount, diagnostics: $diagnosticCount).';

    if (!success && errorMessage != null && errorMessage.trim().isNotEmpty) {
      return '$message Error: $errorMessage';
    }
    return message;
  }

  Future<void> _openLiveStudio() async {
    final BuildContext? appContext = _navigatorKey.currentContext;
    if (appContext == null) {
      if (mounted) {
        setState(() {
          _status = 'Navigator context not ready yet.';
        });
      }
      return;
    }

    final bool? applied = await Navigator.of(appContext).push<bool>(
      MaterialPageRoute<bool>(
        builder: (BuildContext context) {
          return MovieCustomizerStudioPage(
            controller: _controller,
            registry: _registry,
            initialPageId: _activePageId,
            previewBuilder: _buildPagePreview,
          );
        },
      ),
    );

    if (!mounted) {
      return;
    }

    setState(() {
      if (applied == true) {
        _status =
            'Applied and closed studio. Main app now reflects committed styles.';
      } else {
        _status = 'Studio closed without apply.';
      }
    });
  }

  Future<void> _openSettingsModeLauncher() async {
    final BuildContext? appContext = _navigatorKey.currentContext;
    if (appContext == null) {
      if (mounted) {
        setState(() {
          _status = 'Navigator context not ready yet.';
        });
      }
      return;
    }

    await openSettingsModeCustomizer<void>(
      context: appContext,
      controller: _controller,
      useBottomSheet: true,
      protectUnsavedChanges: true,
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _status =
          'Settings mode launcher closed. Use panel apply/discard/undo to verify core safety semantics.';
    });
  }

  Future<void> _openPageModeLauncher() async {
    final BuildContext? appContext = _navigatorKey.currentContext;
    if (appContext == null) {
      if (mounted) {
        setState(() {
          _status = 'Navigator context not ready yet.';
        });
      }
      return;
    }

    final String pageId = _activePageId;
    await openPageModeCustomizer<void>(
      context: appContext,
      controller: _controller,
      pageId: pageId,
      useBottomSheet: true,
      protectUnsavedChanges: true,
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _status = 'Page mode launcher closed for $pageId.';
    });
  }

  Future<void> _showExportDialog() async {
    final AdvancedCustomizerExportResult result = _controller
        .exportProfileJson();

    if (!result.success || result.json == null) {
      if (mounted) {
        setState(() {
          _status = _buildOperationStatus(
            action: 'Export profile JSON',
            success: result.success,
            warningCount: result.warnings.length,
            diagnosticCount: result.diagnostics.length,
            errorMessage: result.errorMessage,
          );
        });
      }
      return;
    }

    final String json = result.json!;
    _lastExportedJson = json;

    if (!mounted) {
      return;
    }

    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Exported profile JSON'),
          content: SizedBox(
            width: 700,
            child: SingleChildScrollView(child: SelectableText(json)),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _status = _buildOperationStatus(
        action: 'Export profile JSON',
        success: true,
        warningCount: result.warnings.length,
        diagnosticCount: result.diagnostics.length,
      );
    });
  }

  Future<void> _showImportDialog(AdvancedCustomizerImportMode mode) async {
    final TextEditingController editor = TextEditingController(
      text: _lastExportedJson ?? _seedProfileJson,
    );

    final String? payload = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Import JSON (${mode.value})'),
          content: SizedBox(
            width: 700,
            child: TextField(
              controller: editor,
              maxLines: 20,
              minLines: 12,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Paste profile JSON here',
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(context).pop(editor.text);
              },
              child: const Text('Import'),
            ),
          ],
        );
      },
    );

    editor.dispose();

    if (payload == null) {
      return;
    }

    final String trimmed = payload.trim();
    if (trimmed.isEmpty) {
      if (mounted) {
        setState(() {
          _status = 'Import aborted: payload was empty.';
        });
      }
      return;
    }

    await _importRawJson(
      trimmed,
      mode,
      actionLabel: 'Import JSON (${mode.value})',
    );
  }

  Future<void> _importRawJson(
    String json,
    AdvancedCustomizerImportMode mode, {
    required String actionLabel,
  }) async {
    final AdvancedCustomizerImportResult result = _controller.importProfileJson(
      json,
      mode,
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _status = _buildOperationStatus(
        action: actionLabel,
        success: result.success,
        warningCount: result.warnings.length,
        diagnosticCount: result.diagnostics.length,
        errorMessage: result.errorMessage ?? result.errorCode,
      );
    });
  }

  Future<void> _reimportLastExport() async {
    final String? json = _lastExportedJson;
    if (json == null || json.trim().isEmpty) {
      if (mounted) {
        setState(() {
          _status = 'No exported JSON available yet. Export first.';
        });
      }
      return;
    }

    await _importRawJson(
      json,
      AdvancedCustomizerImportMode.replace,
      actionLabel: 'Re-import last exported JSON (replace)',
    );
  }

  void _clearRuntimeDiagnostics() {
    final int warningCount = _controller.consumeRuntimeWarnings().length;
    final int diagnosticCount = _controller.consumeRuntimeDiagnostics().length;

    setState(() {
      _status =
          'Cleared runtime logs (warnings: $warningCount, diagnostics: $diagnosticCount).';
    });
  }

  Future<void> _handleMenuAction(_HostMenuAction action) async {
    switch (action) {
      case _HostMenuAction.openSettingsMode:
        await _openSettingsModeLauncher();
      case _HostMenuAction.openPageMode:
        await _openPageModeLauncher();
      case _HostMenuAction.exportJson:
        await _showExportDialog();
      case _HostMenuAction.importReplace:
        await _showImportDialog(AdvancedCustomizerImportMode.replace);
      case _HostMenuAction.importMerge:
        await _showImportDialog(AdvancedCustomizerImportMode.merge);
      case _HostMenuAction.importDefaults:
        await _showImportDialog(AdvancedCustomizerImportMode.defaults);
      case _HostMenuAction.reimportLastExport:
        await _reimportLastExport();
      case _HostMenuAction.clearRuntimeDiagnostics:
        _clearRuntimeDiagnostics();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AdvancedCustomizerPreviewBridge(
      controller: _controller,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: _navigatorKey,
        title: 'ATC Real Test App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0F766E)),
          useMaterial3: true,
        ),
        home: Scaffold(
          appBar: AppBar(
            title: const Text('ATC Real Test App'),
            actions: <Widget>[
              IconButton(
                tooltip: 'Open full-screen live customizer studio',
                onPressed: _openLiveStudio,
                icon: const Icon(Icons.tune),
              ),
              PopupMenuButton<_HostMenuAction>(
                tooltip: 'Host QA actions',
                onSelected: (_HostMenuAction action) async {
                  await _handleMenuAction(action);
                },
                itemBuilder: (BuildContext context) =>
                    const <PopupMenuEntry<_HostMenuAction>>[
                      PopupMenuItem<_HostMenuAction>(
                        value: _HostMenuAction.openSettingsMode,
                        child: Text('Open settings-mode customizer'),
                      ),
                      PopupMenuItem<_HostMenuAction>(
                        value: _HostMenuAction.openPageMode,
                        child: Text('Open page-mode customizer'),
                      ),
                      PopupMenuDivider(),
                      PopupMenuItem<_HostMenuAction>(
                        value: _HostMenuAction.exportJson,
                        child: Text('Export committed profile JSON'),
                      ),
                      PopupMenuItem<_HostMenuAction>(
                        value: _HostMenuAction.importReplace,
                        child: Text('Import JSON (replace)'),
                      ),
                      PopupMenuItem<_HostMenuAction>(
                        value: _HostMenuAction.importMerge,
                        child: Text('Import JSON (merge)'),
                      ),
                      PopupMenuItem<_HostMenuAction>(
                        value: _HostMenuAction.importDefaults,
                        child: Text('Import JSON (defaults)'),
                      ),
                      PopupMenuItem<_HostMenuAction>(
                        value: _HostMenuAction.reimportLastExport,
                        child: Text('Re-import last export (replace)'),
                      ),
                      PopupMenuDivider(),
                      PopupMenuItem<_HostMenuAction>(
                        value: _HostMenuAction.clearRuntimeDiagnostics,
                        child: Text('Clear runtime diagnostics'),
                      ),
                    ],
              ),
            ],
          ),
          body: Column(
            children: <Widget>[
              _UsageBanner(status: _status),
              Expanded(
                child: IndexedStack(
                  index: _tabIndex,
                  children: <Widget>[
                    _MovieHomePage(controller: _controller),
                    _MovieDetailsPage(controller: _controller),
                  ],
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: _openLiveStudio,
            icon: const Icon(Icons.brush),
            label: Text('Customize $_activePageId'),
          ),
          bottomNavigationBar: NavigationBar(
            selectedIndex: _tabIndex,
            onDestinationSelected: (int index) {
              setState(() {
                _tabIndex = index;
              });
            },
            destinations: const <NavigationDestination>[
              NavigationDestination(icon: Icon(Icons.movie), label: 'Home'),
              NavigationDestination(
                icon: Icon(Icons.local_play),
                label: 'Details',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MovieCustomizerStudioPage extends StatefulWidget {
  const MovieCustomizerStudioPage({
    super.key,
    required this.controller,
    required this.registry,
    required this.initialPageId,
    required this.previewBuilder,
  });

  final AdvancedCustomizerController controller;
  final AdvancedComponentRegistry registry;
  final String initialPageId;
  final Widget Function(String pageId) previewBuilder;

  @override
  State<MovieCustomizerStudioPage> createState() =>
      _MovieCustomizerStudioPageState();
}

class _MovieCustomizerStudioPageState extends State<MovieCustomizerStudioPage> {
  late String _editingPageId;
  late AdvancedCustomizerSectionVisibility _originalVisibility;
  String _hint =
      'Select components, edit properties, watch preview update live.';

  @override
  void initState() {
    super.initState();
    _editingPageId = widget.initialPageId;

    _originalVisibility = widget.controller.sectionVisibility;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }

      if (_originalVisibility.showActionsSection) {
        widget.controller.setPanelSectionVisibility(
          AdvancedCustomizerSectionVisibility(
            showScopeSection: _originalVisibility.showScopeSection,
            showComponentsSection: _originalVisibility.showComponentsSection,
            showPropertiesSection: _originalVisibility.showPropertiesSection,
            showActionsSection: false,
          ),
        );
      }

      _primeEditorForPage(_editingPageId);
      widget.controller.enableInPagePreview(pageId: _editingPageId);
    });
  }

  @override
  void dispose() {
    widget.controller.disableInPagePreview();
    widget.controller.setPanelSectionVisibility(_originalVisibility);

    super.dispose();
  }

  void _primeEditorForPage(String pageId) {
    widget.controller.openCustomizerForPage(pageId);
    widget.controller.setActivePage(pageId);
    widget.controller.setActiveScope(AdvancedCustomizerScope.page);

    final Set<String> ids = widget.registry.componentIdsForPage(pageId).toSet();
    if (ids.isNotEmpty) {
      widget.controller.setSelectedComponents(ids);
    }

    widget.controller.setSelectedStates(const <AdvancedCustomizerState>{
      AdvancedCustomizerState.defaultState,
    });
  }

  void _onPageChanged(String pageId) {
    setState(() {
      _editingPageId = pageId;
      _hint = 'Editing page: $pageId. Changes preview live before apply.';
    });

    _primeEditorForPage(pageId);
    widget.controller.enableInPagePreview(pageId: pageId);
  }

  void _undoLastApply() {
    final bool undone = widget.controller.undoLastApply();
    setState(() {
      _hint = undone
          ? 'Undo success. Previous committed snapshot restored.'
          : 'Nothing to undo.';
    });
  }

  void _applyAndClose() {
    final bool applied = widget.controller.applyDraft();
    Navigator.of(context).pop(applied);
  }

  void _discardAndClose() {
    widget.controller.discardDraft();
    Navigator.of(context).pop(false);
  }

  Future<bool> _confirmExitIfNeeded() async {
    if (!widget.controller.hasDraftSession) {
      return true;
    }

    final _StudioExitDecision? decision = await showDialog<_StudioExitDecision>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Unsaved live changes'),
          content: const Text(
            'Apply and close, discard and close, or keep editing?',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(_StudioExitDecision.keepEditing);
              },
              child: const Text('Keep Editing'),
            ),
            OutlinedButton(
              onPressed: () {
                Navigator.of(context).pop(_StudioExitDecision.discardAndClose);
              },
              child: const Text('Discard'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(context).pop(_StudioExitDecision.applyAndClose);
              },
              child: const Text('Apply'),
            ),
          ],
        );
      },
    );

    switch (decision) {
      case _StudioExitDecision.applyAndClose:
        widget.controller.applyDraft();
        return true;
      case _StudioExitDecision.discardAndClose:
        widget.controller.discardDraft();
        return true;
      case _StudioExitDecision.keepEditing:
      case null:
        return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _confirmExitIfNeeded,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Live Customizer Studio'),
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () async {
              if (await _confirmExitIfNeeded() && mounted) {
                Navigator.of(context).pop(false);
              }
            },
          ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _editingPageId,
                  items: const <DropdownMenuItem<String>>[
                    DropdownMenuItem<String>(
                      value: 'home',
                      child: Text('Home Preview'),
                    ),
                    DropdownMenuItem<String>(
                      value: 'details',
                      child: Text('Details Preview'),
                    ),
                  ],
                  onChanged: (String? pageId) {
                    if (pageId != null) {
                      _onPageChanged(pageId);
                    }
                  },
                ),
              ),
            ),
          ],
        ),
        body: Column(
          children: <Widget>[
            _StudioGuideCard(
              editingPageId: _editingPageId,
              hint: _hint,
              selectedCount: widget.controller.selectedComponents.length,
            ),
            _StudioActionRow(
              onUndo: _undoLastApply,
              onDiscardAndClose: _discardAndClose,
              onApplyAndClose: _applyAndClose,
            ),
            Expanded(
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  final bool isWide = constraints.maxWidth >= 1080;

                  if (isWide) {
                    return Row(
                      children: <Widget>[
                        Expanded(
                          flex: 3,
                          child: _StudioPreviewPane(
                            child: widget.previewBuilder(_editingPageId),
                          ),
                        ),
                        const VerticalDivider(width: 1),
                        Expanded(
                          flex: 2,
                          child: _StudioPanelPane(
                            controller: widget.controller,
                          ),
                        ),
                      ],
                    );
                  }

                  return Column(
                    children: <Widget>[
                      Expanded(
                        flex: 3,
                        child: _StudioPreviewPane(
                          child: widget.previewBuilder(_editingPageId),
                        ),
                      ),
                      const Divider(height: 1),
                      Expanded(
                        flex: 2,
                        child: _StudioPanelPane(controller: widget.controller),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum _StudioExitDecision { applyAndClose, discardAndClose, keepEditing }

class _StudioGuideCard extends StatelessWidget {
  const _StudioGuideCard({
    required this.editingPageId,
    required this.hint,
    required this.selectedCount,
  });

  final String editingPageId;
  final String hint;
  final int selectedCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Theme.of(context).colorScheme.primaryContainer,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Text(
        'Page: $editingPageId | Selected components: $selectedCount\n'
        '$hint\n'
        'Apply & Close commits to real app page. Discard closes without commit.',
      ),
    );
  }
}

class _StudioActionRow extends StatelessWidget {
  const _StudioActionRow({
    required this.onUndo,
    required this.onDiscardAndClose,
    required this.onApplyAndClose,
  });

  final VoidCallback onUndo;
  final VoidCallback onDiscardAndClose;
  final VoidCallback onApplyAndClose;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: <Widget>[
          TextButton.icon(
            onPressed: onUndo,
            icon: const Icon(Icons.undo),
            label: const Text('Undo Last Apply'),
          ),
          OutlinedButton.icon(
            onPressed: onDiscardAndClose,
            icon: const Icon(Icons.close),
            label: const Text('Discard & Close'),
          ),
          FilledButton.icon(
            onPressed: onApplyAndClose,
            icon: const Icon(Icons.check),
            label: const Text('Apply & Close'),
          ),
        ],
      ),
    );
  }
}

class _StudioPreviewPane extends StatelessWidget {
  const _StudioPreviewPane({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surfaceContainerLowest,
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Actual Page Live Preview',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Expanded(
            child: DecoratedBox(
              decoration: BoxDecoration(
                border: Border.all(color: Theme.of(context).dividerColor),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: child,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StudioPanelPane extends StatelessWidget {
  const _StudioPanelPane({required this.controller});

  final AdvancedCustomizerController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surface,
      padding: const EdgeInsets.all(12),
      child: AdvancedCustomizerPanel(controller: controller),
    );
  }
}

class _UsageBanner extends StatelessWidget {
  const _UsageBanner({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Text(
        'QA flow: open Live Studio -> edit component styles -> watch live page preview -> '
        'Apply & Close to commit.\n'
        'Use toolbar menu for settings/page mode launchers and JSON import/export tests.\n'
        'Status: $status',
      ),
    );
  }
}

class _MovieHomePage extends StatelessWidget {
  const _MovieHomePage({required this.controller});

  final AdvancedCustomizerController controller;

  @override
  Widget build(BuildContext context) {
    return AdvancedCustomizerInPagePreviewContainer(
      controller: controller,
      pageId: 'home',
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          _ResolvedMovieSurface(
            controller: controller,
            componentKey: 'movie.home.banner.surface',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _ResolvedMovieText(
                  controller: controller,
                  componentKey: 'movie.home.banner.title',
                  text: 'Tonight: Interstellar Marathon',
                  style: Theme.of(context).textTheme.headlineSmall,
                  fallbackColor: Colors.white,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Stream curated sci-fi epics with real-time style customization.',
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _ResolvedMovieSearchField(
            controller: controller,
            componentKey: 'movie.home.input.search',
          ),
          const SizedBox(height: 16),
          Text('Trending Now', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 10),
          _MovieCard(
            controller: controller,
            title: 'The Last Voyager',
            subtitle: 'Sci-Fi | 2h 11m',
          ),
          const SizedBox(height: 10),
          _MovieCard(
            controller: controller,
            title: 'Midnight Code',
            subtitle: 'Thriller | 1h 52m',
          ),
          const SizedBox(height: 10),
          _MovieCard(
            controller: controller,
            title: 'Rising Tides',
            subtitle: 'Drama | 2h 03m',
          ),
          const SizedBox(height: 16),
          _ResolvedMovieButton(
            controller: controller,
            componentKey: 'movie.home.button.watch',
            label: 'Watch Trailer',
            icon: Icons.play_circle_fill,
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

class _MovieDetailsPage extends StatelessWidget {
  const _MovieDetailsPage({required this.controller});

  final AdvancedCustomizerController controller;

  @override
  Widget build(BuildContext context) {
    return AdvancedCustomizerInPagePreviewContainer(
      controller: controller,
      pageId: 'details',
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          _ResolvedMovieSurface(
            controller: controller,
            componentKey: 'movie.details.poster.surface',
            fallbackFill: const Color(0xFF1F2937),
            fallbackBorder: const Color(0xFF4B5563),
            fallbackRadius: 20,
            child: SizedBox(
              height: 220,
              child: Center(
                child: Icon(
                  Icons.local_movies,
                  size: 72,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          _ResolvedMovieText(
            controller: controller,
            componentKey: 'movie.details.title.text',
            text: 'The Last Voyager',
            style: Theme.of(context).textTheme.headlineMedium,
            fallbackColor: Colors.white,
          ),
          const SizedBox(height: 6),
          _ResolvedMovieText(
            controller: controller,
            componentKey: 'movie.details.subtitle.text',
            text: 'A lone pilot fights to save the final human colony.',
            style: Theme.of(context).textTheme.bodyLarge,
            fallbackColor: const Color(0xFFD1D5DB),
          ),
          const SizedBox(height: 12),
          _ResolvedGenreChip(
            controller: controller,
            componentKey: 'movie.details.chip.genre',
            label: 'Science Fiction',
          ),
          const SizedBox(height: 18),
          _ResolvedMovieButton(
            controller: controller,
            componentKey: 'movie.details.button.play',
            label: 'Play Movie',
            icon: Icons.play_arrow,
            onPressed: () {},
          ),
          const SizedBox(height: 10),
          _ResolvedMovieButton(
            controller: controller,
            componentKey: 'movie.details.button.watchlist',
            label: 'Add To Watchlist',
            icon: Icons.bookmark_add,
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

class _MovieCard extends StatelessWidget {
  const _MovieCard({
    required this.controller,
    required this.title,
    required this.subtitle,
  });

  final AdvancedCustomizerController controller;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return _ResolvedMovieSurface(
      controller: controller,
      componentKey: 'movie.home.card.surface',
      fallbackFill: const Color(0xFF111827),
      fallbackBorder: const Color(0xFF374151),
      fallbackRadius: 16,
      child: Row(
        children: <Widget>[
          Container(
            width: 64,
            height: 88,
            decoration: BoxDecoration(
              color: Colors.black26,
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: const Icon(Icons.movie_filter, size: 28),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _ResolvedMovieText(
                  controller: controller,
                  componentKey: 'movie.home.card.title',
                  text: title,
                  style: Theme.of(context).textTheme.titleMedium,
                  fallbackColor: const Color(0xFFF8FAFC),
                ),
                const SizedBox(height: 6),
                _ResolvedMovieText(
                  controller: controller,
                  componentKey: 'movie.home.card.subtitle',
                  text: subtitle,
                  style: Theme.of(context).textTheme.bodyMedium,
                  fallbackColor: const Color(0xFFCBD5E1),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ResolvedMovieSurface extends StatelessWidget {
  const _ResolvedMovieSurface({
    required this.controller,
    required this.componentKey,
    required this.child,
    this.fallbackFill = const Color(0xFF111827),
    this.fallbackBorder = const Color(0xFF374151),
    this.fallbackRadius = 14,
    this.fallbackBorderWidth = 1,
    this.padding = const EdgeInsets.all(14),
  });

  final AdvancedCustomizerController controller;
  final String componentKey;
  final Widget child;
  final Color fallbackFill;
  final Color fallbackBorder;
  final double fallbackRadius;
  final double fallbackBorderWidth;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return AdvancedCustomizerResolvedColor(
      controller: controller,
      componentKey: componentKey,
      property: AdvancedCustomizerProperty.fill,
      fallbackColor: fallbackFill,
      builder: (BuildContext context, Color? fill) {
        return AdvancedCustomizerResolvedColor(
          controller: controller,
          componentKey: componentKey,
          property: AdvancedCustomizerProperty.border,
          fallbackColor: fallbackBorder,
          builder: (BuildContext context, Color? border) {
            return AdvancedCustomizerResolvedDouble(
              controller: controller,
              componentKey: componentKey,
              property: AdvancedCustomizerProperty.radius,
              fallbackValue: fallbackRadius,
              builder: (BuildContext context, double? radius) {
                return AdvancedCustomizerResolvedDouble(
                  controller: controller,
                  componentKey: componentKey,
                  property: AdvancedCustomizerProperty.borderWidth,
                  fallbackValue: fallbackBorderWidth,
                  builder: (BuildContext context, double? borderWidth) {
                    return Container(
                      padding: padding,
                      decoration: BoxDecoration(
                        color: fill,
                        border: Border.all(
                          color: border ?? fallbackBorder,
                          width: borderWidth ?? fallbackBorderWidth,
                        ),
                        borderRadius: BorderRadius.circular(
                          radius ?? fallbackRadius,
                        ),
                      ),
                      child: child,
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}

class _ResolvedMovieText extends StatelessWidget {
  const _ResolvedMovieText({
    required this.controller,
    required this.componentKey,
    required this.text,
    required this.style,
    required this.fallbackColor,
  });

  final AdvancedCustomizerController controller;
  final String componentKey;
  final String text;
  final TextStyle? style;
  final Color fallbackColor;

  @override
  Widget build(BuildContext context) {
    return AdvancedCustomizerResolvedColor(
      controller: controller,
      componentKey: componentKey,
      property: AdvancedCustomizerProperty.text,
      fallbackColor: fallbackColor,
      builder: (BuildContext context, Color? textColor) {
        return Text(
          text,
          style: style?.copyWith(color: textColor ?? fallbackColor),
        );
      },
    );
  }
}

class _ResolvedMovieButton extends StatelessWidget {
  const _ResolvedMovieButton({
    required this.controller,
    required this.componentKey,
    required this.label,
    required this.onPressed,
    this.icon,
  });

  final AdvancedCustomizerController controller;
  final String componentKey;
  final String label;
  final VoidCallback onPressed;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return AdvancedCustomizerResolvedColor(
      controller: controller,
      componentKey: componentKey,
      property: AdvancedCustomizerProperty.fill,
      fallbackColor: Theme.of(context).colorScheme.primary,
      builder: (BuildContext context, Color? fill) {
        return AdvancedCustomizerResolvedColor(
          controller: controller,
          componentKey: componentKey,
          property: AdvancedCustomizerProperty.text,
          fallbackColor: Theme.of(context).colorScheme.onPrimary,
          builder: (BuildContext context, Color? textColor) {
            return AdvancedCustomizerResolvedColor(
              controller: controller,
              componentKey: componentKey,
              property: AdvancedCustomizerProperty.border,
              fallbackColor: Theme.of(context).colorScheme.primary,
              builder: (BuildContext context, Color? borderColor) {
                return AdvancedCustomizerResolvedDouble(
                  controller: controller,
                  componentKey: componentKey,
                  property: AdvancedCustomizerProperty.radius,
                  fallbackValue: 16,
                  builder: (BuildContext context, double? radius) {
                    return AdvancedCustomizerResolvedDouble(
                      controller: controller,
                      componentKey: componentKey,
                      property: AdvancedCustomizerProperty.borderWidth,
                      fallbackValue: 1,
                      builder: (BuildContext context, double? borderWidth) {
                        return SizedBox(
                          width: double.infinity,
                          child: FilledButton.icon(
                            style: FilledButton.styleFrom(
                              backgroundColor: fill,
                              foregroundColor: textColor,
                              side: BorderSide(
                                color:
                                    borderColor ??
                                    Theme.of(context).colorScheme.primary,
                                width: borderWidth ?? 1,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  radius ?? 16,
                                ),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            onPressed: onPressed,
                            icon: icon == null
                                ? const SizedBox.shrink()
                                : Icon(icon),
                            label: Text(label),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}

class _ResolvedMovieSearchField extends StatelessWidget {
  const _ResolvedMovieSearchField({
    required this.controller,
    required this.componentKey,
  });

  final AdvancedCustomizerController controller;
  final String componentKey;

  @override
  Widget build(BuildContext context) {
    return AdvancedCustomizerResolvedColor(
      controller: controller,
      componentKey: componentKey,
      property: AdvancedCustomizerProperty.fill,
      fallbackColor: Colors.white,
      builder: (BuildContext context, Color? fill) {
        return AdvancedCustomizerResolvedColor(
          controller: controller,
          componentKey: componentKey,
          property: AdvancedCustomizerProperty.border,
          fallbackColor: Theme.of(context).dividerColor,
          builder: (BuildContext context, Color? border) {
            return AdvancedCustomizerResolvedColor(
              controller: controller,
              componentKey: componentKey,
              property: AdvancedCustomizerProperty.text,
              fallbackColor: Theme.of(context).colorScheme.onSurface,
              builder: (BuildContext context, Color? textColor) {
                return AdvancedCustomizerResolvedDouble(
                  controller: controller,
                  componentKey: componentKey,
                  property: AdvancedCustomizerProperty.radius,
                  fallbackValue: 14,
                  builder: (BuildContext context, double? radius) {
                    return AdvancedCustomizerResolvedDouble(
                      controller: controller,
                      componentKey: componentKey,
                      property: AdvancedCustomizerProperty.borderWidth,
                      fallbackValue: 1,
                      builder: (BuildContext context, double? borderWidth) {
                        return TextField(
                          style: TextStyle(color: textColor),
                          decoration: InputDecoration(
                            hintText: 'Search movies, actors, genres',
                            prefixIcon: const Icon(Icons.search),
                            filled: true,
                            fillColor: fill,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(radius ?? 14),
                              borderSide: BorderSide(
                                color: border ?? Theme.of(context).dividerColor,
                                width: borderWidth ?? 1,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(radius ?? 14),
                              borderSide: BorderSide(
                                color:
                                    border ??
                                    Theme.of(context).colorScheme.primary,
                                width: (borderWidth ?? 1) + 1,
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}

class _ResolvedGenreChip extends StatelessWidget {
  const _ResolvedGenreChip({
    required this.controller,
    required this.componentKey,
    required this.label,
  });

  final AdvancedCustomizerController controller;
  final String componentKey;
  final String label;

  @override
  Widget build(BuildContext context) {
    return AdvancedCustomizerResolvedColor(
      controller: controller,
      componentKey: componentKey,
      property: AdvancedCustomizerProperty.fill,
      fallbackColor: const Color(0xFF6D28D9),
      builder: (BuildContext context, Color? fill) {
        return AdvancedCustomizerResolvedColor(
          controller: controller,
          componentKey: componentKey,
          property: AdvancedCustomizerProperty.text,
          fallbackColor: Colors.white,
          builder: (BuildContext context, Color? textColor) {
            return AdvancedCustomizerResolvedDouble(
              controller: controller,
              componentKey: componentKey,
              property: AdvancedCustomizerProperty.radius,
              fallbackValue: 14,
              builder: (BuildContext context, double? radius) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: fill,
                    borderRadius: BorderRadius.circular(radius ?? 14),
                  ),
                  child: Text(
                    label,
                    style: TextStyle(color: textColor ?? Colors.white),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
