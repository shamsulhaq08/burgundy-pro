const fs = require('fs');
const path = require('path');

function createTheme({ name, type, palette }) {
  const {
    bgMain,
    bgEditor,
    bgSidebar,
    bgActivityBar,
    bgPanel,
    bgTitleBar,
    bgTitleBarInactive,
    bgStatusBar,
    bgStatusBarRemote,
    bgStatusBarDebugging,
    bgStatusBarNoFolder,
    bgActiveTab,
    bgInactiveTab,
    bgTabBorder,
    bgSelection,
    bgSelectionHighlight,
    bgActiveLine,
    border,
    focusBorder,
    textMain,
    textMuted,
    textSecondary,
    badgeBg,
    badgeFg,
    inputBg,
    inputBorder,
    dropdownBg,
    dropdownBorder,
    listHoverBg,
    listActiveSelectionBg,
    listInactiveSelectionBg,
    bracket1,
    bracket2,
    bracket3,
    bracket4,
    bracket5,
    bracket6,
    gitAdded,
    gitModified,
    gitDeleted,
    gitUntracked,
    gitIgnored,
    error,
    warning,
    info,
    hint
  } = palette;

  // Syntax colors (Unified Burgundy Pro Color System)
  const syntax = {
    keywords: '#E5A0B0',
    control: '#E5A0B0',
    functions: '#E8B47A',
    variables: '#E8DCE1',
    strings: '#C5D6A5',
    numbers: '#D7A6E0',
    classes: '#E8B47A',
    types: '#D9A1B5',
    constants: '#E5C18A',
    comments: '#88717B',
    operators: '#D7A0AE',
    htmlTags: '#E58BA2',
    htmlAttrs: '#D6B0C0',
    cssProps: '#D6A4B5',
    cssSelectors: '#E5A0B0',
    sqlKeywords: '#D7A0AE',
    regex: '#E2A882',
    markupHeading: '#E58BA2',
    markupBold: '#E8B47A',
    markupItalic: '#E5A0B0',
    markupCode: '#C5D6A5',
    markupLink: '#9B9AE5',
    markupQuote: '#B09AA3',
    jsonKey: '#D9A1B5',
    xmlTag: '#E58BA2',
    xmlAttr: '#D6B0C0'
  };

  const baseSelection = bgSelection.substring(0, 7);
  const baseStatusBar = bgStatusBar.substring(0, 7);

  const colors = {
    // Base Colors
    focusBorder: focusBorder,
    foreground: textMain,
    disabledForeground: '#765D67',
    'widget.shadow': '#00000066',
    'selection.background': bgSelection,
    descriptionForeground: textMuted,
    errorForeground: error,
    'icon.foreground': textMuted,
    'sash.hoverBorder': focusBorder,

    // Window / Title Bar
    'titleBar.activeBackground': bgTitleBar,
    'titleBar.activeForeground': textMain,
    'titleBar.inactiveBackground': bgTitleBarInactive || bgTitleBar,
    'titleBar.inactiveForeground': textMuted,
    'titleBar.border': border,

    // Activity Bar
    'activityBar.background': bgActivityBar,
    'activityBar.foreground': '#F3C5D4',
    'activityBar.inactiveForeground': '#826573',
    'activityBar.border': border,
    'activityBar.activeBorder': '#C44D76',
    'activityBar.activeFocusBorder': '#E5A0B0',
    'activityBarBadge.background': badgeBg,
    'activityBarBadge.foreground': badgeFg,

    // Sidebar
    'sideBar.background': bgSidebar,
    'sideBar.foreground': textMain,
    'sideBar.border': border,
    'sideBar.dropBackground': `${baseSelection}55`,
    'sideBarTitle.foreground': textMain,
    'sideBarSectionHeader.background': bgTitleBar,
    'sideBarSectionHeader.foreground': textMain,
    'sideBarSectionHeader.border': border,

    // Lists and Trees
    'list.hoverBackground': listHoverBg,
    'list.hoverForeground': '#FFFFFF',
    'list.activeSelectionBackground': listActiveSelectionBg,
    'list.activeSelectionForeground': '#FFFFFF',
    'list.inactiveSelectionBackground': listInactiveSelectionBg,
    'list.inactiveSelectionForeground': textMain,
    'list.focusBackground': listHoverBg,
    'list.focusForeground': '#FFFFFF',
    'list.highlightForeground': '#F587A7',
    'list.focusHighlightForeground': '#FFA5BF',
    'list.dropBackground': `${baseSelection}55`,
    'tree.indentGuidesStroke': '#3D2431',

    // Editor Groups & Tabs
    'editorGroup.border': border,
    'editorGroup.dropBackground': `${baseSelection}50`,
    'editorGroupHeader.tabsBackground': bgTitleBar,
    'editorGroupHeader.tabsBorder': border,
    'editorGroupHeader.noTabsBackground': bgEditor,
    'tab.activeBackground': bgActiveTab,
    'tab.activeForeground': '#FFFFFF',
    'tab.activeBorderTop': '#C44D76',
    'tab.border': bgTabBorder || border,
    'tab.inactiveBackground': bgInactiveTab,
    'tab.inactiveForeground': textMuted,
    'tab.hoverBackground': bgActiveTab,
    'tab.hoverForeground': '#FFFFFF',
    'tab.unfocusedActiveBackground': bgActiveTab,
    'tab.unfocusedActiveForeground': textMuted,
    'tab.unfocusedInactiveBackground': bgInactiveTab,
    'tab.unfocusedInactiveForeground': '#765D67',
    'tab.activeModifiedBorder': '#E8B47A',
    'tab.inactiveModifiedBorder': '#B09AA3',

    // Editor Area
    'editor.background': bgEditor,
    'editor.foreground': textMain,
    'editorLineNumber.foreground': '#6B4D5B',
    'editorLineNumber.activeForeground': '#E5A0B0',
    'editorCursor.foreground': '#F587A7',
    'editor.lineHighlightBackground': bgActiveLine,
    'editor.lineHighlightBorder': '#00000000',
    'editor.selectionBackground': bgSelection,
    'editor.selectionHighlightBackground': bgSelectionHighlight,
    'editor.inactiveSelectionBackground': `${baseSelection}70`,
    'editor.wordHighlightBackground': `${baseSelection}60`,
    'editor.wordHighlightStrongBackground': `${baseStatusBar}70`,
    'editor.findMatchBackground': '#A33B5FAA',
    'editor.findMatchHighlightBackground': '#702D4566',
    'editor.findRangeHighlightBackground': '#43253244',
    'editor.hoverHighlightBackground': '#43253255',
    'editorWhitespace.foreground': '#3E2430',
    'editorRuler.foreground': '#331B26',
    'editorCodeLens.foreground': textMuted,

    // Bracket Matching & Guides
    'editorBracketMatch.background': `${baseSelection}70`,
    'editorBracketMatch.border': '#C44D76',
    'editorBracketHighlight.foreground1': bracket1,
    'editorBracketHighlight.foreground2': bracket2,
    'editorBracketHighlight.foreground3': bracket3,
    'editorBracketHighlight.foreground4': bracket4,
    'editorBracketHighlight.foreground5': bracket5,
    'editorBracketHighlight.foreground6': bracket6,
    'editorBracketHighlight.unexpectedBracket.foreground': error,
    'editorIndentGuide.background1': '#311B25',
    'editorIndentGuide.activeBackground1': '#66344A',
    'editorIndentGuide.background2': '#2A1720',
    'editorIndentGuide.activeBackground2': '#542B3D',

    // Inlay Hints
    'editorInlayHint.background': '#2C1721',
    'editorInlayHint.foreground': textMuted,
    'editorInlayHint.parameterBackground': '#2C1721',
    'editorInlayHint.parameterForeground': textMuted,
    'editorInlayHint.typeBackground': '#2C1721',
    'editorInlayHint.typeForeground': syntax.types,

    // Overview Ruler
    'editorOverviewRuler.border': border,
    'editorOverviewRuler.findMatchForeground': '#C44D76',
    'editorOverviewRuler.rangeHighlightForeground': '#583044',
    'editorOverviewRuler.selectionHighlightForeground': '#702D45',
    'editorOverviewRuler.wordHighlightForeground': '#583044',
    'editorOverviewRuler.wordHighlightStrongForeground': '#702D45',
    'editorOverviewRuler.modifiedForeground': gitModified,
    'editorOverviewRuler.addedForeground': gitAdded,
    'editorOverviewRuler.deletedForeground': gitDeleted,
    'editorOverviewRuler.errorForeground': error,
    'editorOverviewRuler.warningForeground': warning,
    'editorOverviewRuler.infoForeground': info,

    // Diagnostics Squiggles
    'editorError.foreground': error,
    'editorWarning.foreground': warning,
    'editorInfo.foreground': info,
    'editorHint.foreground': hint,

    // Minimap
    'minimap.background': bgEditor,
    'minimap.selectionHighlight': '#702D45AA',
    'minimap.findMatchHighlight': '#C44D76CC',
    'minimap.errorHighlight': error,
    'minimap.warningHighlight': warning,
    'minimapSlider.background': '#58304433',
    'minimapSlider.hoverBackground': '#58304466',
    'minimapSlider.activeBackground': '#702D4588',

    // Breadcrumbs
    'breadcrumb.background': bgEditor,
    'breadcrumb.foreground': textMuted,
    'breadcrumb.focusForeground': '#FFFFFF',
    'breadcrumb.activeSelectionForeground': '#FFFFFF',
    'breadcrumbPicker.background': bgSidebar,

    // Panels (Terminal, Output, Debug, Problems)
    'panel.background': bgPanel,
    'panel.border': border,
    'panelTitle.activeBorder': '#C44D76',
    'panelTitle.activeForeground': textMain,
    'panelTitle.inactiveForeground': textMuted,
    'panelSection.border': border,
    'panelSectionHeader.background': bgTitleBar,

    // Status Bar
    'statusBar.background': bgStatusBar,
    'statusBar.foreground': '#FFFFFF',
    'statusBar.border': border,
    'statusBar.debuggingBackground': bgStatusBarDebugging,
    'statusBar.debuggingForeground': '#FFFFFF',
    'statusBar.noFolderBackground': bgStatusBarNoFolder,
    'statusBar.noFolderForeground': '#FFFFFF',
    'statusBarItem.activeBackground': `${bgStatusBarRemote}CC`,
    'statusBarItem.hoverBackground': bgStatusBarRemote,
    'statusBarItem.prominentBackground': bgStatusBarRemote,
    'statusBarItem.prominentHoverBackground': '#A33B5F',
    'statusBarItem.remoteBackground': bgStatusBarRemote,
    'statusBarItem.remoteForeground': '#FFFFFF',

    // Quick Pick / Command Palette
    'quickInput.background': bgSidebar,
    'quickInput.foreground': textMain,
    'quickInputTitle.background': bgTitleBar,
    'pickerGroup.border': border,
    'pickerGroup.foreground': '#F587A7',

    // Notifications
    'notificationCenter.border': border,
    'notificationCenterHeader.foreground': textMain,
    'notificationCenterHeader.background': bgTitleBar,
    'notificationToast.border': border,
    'notifications.foreground': textMain,
    'notifications.background': bgSidebar,
    'notifications.border': border,
    'notificationLink.foreground': '#F587A7',

    // Extensions & Buttons
    'button.background': '#8A2D4F',
    'button.foreground': '#FFFFFF',
    'button.hoverBackground': '#A63860',
    'button.secondaryBackground': '#3D202D',
    'button.secondaryForeground': textMain,
    'button.secondaryHoverBackground': '#4D2939',
    'badge.background': badgeBg,
    'badge.foreground': badgeFg,
    'progressBar.background': '#C44D76',

    // Inputs & Dropdowns
    'input.background': inputBg,
    'input.border': inputBorder,
    'input.foreground': textMain,
    'input.placeholderForeground': '#7E646E',
    'inputOption.activeBorder': '#C44D76',
    'inputValidation.errorBackground': '#431923',
    'inputValidation.errorBorder': error,
    'inputValidation.warningBackground': '#3F2818',
    'inputValidation.warningBorder': warning,
    'inputValidation.infoBackground': '#18243A',
    'inputValidation.infoBorder': info,
    'dropdown.background': dropdownBg,
    'dropdown.border': dropdownBorder,
    'dropdown.foreground': textMain,
    'checkbox.background': inputBg,
    'checkbox.border': inputBorder,
    'checkbox.foreground': textMain,

    // Scrollbar
    'scrollbar.shadow': '#00000055',
    'scrollbarSlider.background': '#58304440',
    'scrollbarSlider.hoverBackground': '#58304470',
    'scrollbarSlider.activeBackground': '#702D4590',

    // Diff Editor & Git
    'diffEditor.insertedTextBackground': `${gitAdded}1F`,
    'diffEditor.removedTextBackground': `${gitDeleted}22`,
    'diffEditor.border': border,
    'gitDecoration.addedResourceForeground': gitAdded,
    'gitDecoration.modifiedResourceForeground': gitModified,
    'gitDecoration.deletedResourceForeground': gitDeleted,
    'gitDecoration.untrackedResourceForeground': gitUntracked,
    'gitDecoration.ignoredResourceForeground': gitIgnored,
    'gitDecoration.conflictingResourceForeground': '#E88267',
    'gitDecoration.submoduleResourceForeground': '#9B9AE5',

    // Terminal
    'terminal.background': bgPanel,
    'terminal.foreground': textMain,
    'terminalCursor.foreground': '#F587A7',
    'terminal.selectionBackground': bgSelection,
    'terminal.ansiBlack': '#1A1015',
    'terminal.ansiBrightBlack': '#614451',
    'terminal.ansiRed': '#E57388',
    'terminal.ansiBrightRed': '#F28D9F',
    'terminal.ansiGreen': '#A8C982',
    'terminal.ansiBrightGreen': '#BCE094',
    'terminal.ansiYellow': '#E8B47A',
    'terminal.ansiBrightYellow': '#F2C894',
    'terminal.ansiBlue': '#9B9AE5',
    'terminal.ansiBrightBlue': '#B5B4F5',
    'terminal.ansiMagenta': '#D7A6E0',
    'terminal.ansiBrightMagenta': '#E5BAED',
    'terminal.ansiCyan': '#89C4BA',
    'terminal.ansiBrightCyan': '#A5DDD3',
    'terminal.ansiWhite': '#E8DCE1',
    'terminal.ansiBrightWhite': '#FFFFFF',

    // Debugging
    'debugToolBar.background': bgTitleBar,
    'debugToolBar.border': border,
    'editor.stackFrameHighlightBackground': '#702D4540',
    'editor.focusedStackFrameHighlightBackground': '#8A2D4F60',

    // Peek View
    'peekView.border': '#A33B5F',
    'peekViewEditor.background': bgEditor,
    'peekViewEditorGutter.background': bgEditor,
    'peekViewEditor.matchHighlightBackground': '#702D4566',
    'peekViewResult.background': bgSidebar,
    'peekViewResult.fileForeground': textMain,
    'peekViewResult.lineForeground': textMuted,
    'peekViewResult.matchHighlightBackground': '#702D4566',
    'peekViewResult.selectionBackground': listActiveSelectionBg,
    'peekViewResult.selectionForeground': '#FFFFFF',
    'peekViewTitle.background': bgTitleBar,
    'peekViewTitleDescription.foreground': textMuted,
    'peekViewTitleLabel.foreground': textMain
  };

  const tokenColors = [
    // Comments
    {
      name: 'Comments',
      scope: [
        'comment',
        'punctuation.definition.comment',
        'unused.comment'
      ],
      settings: {
        foreground: syntax.comments,
        fontStyle: 'italic'
      }
    },
    // Documentation Comments
    {
      name: 'Doc Comments',
      scope: [
        'comment.block.documentation',
        'comment.block.javadoc',
        'comment.line.documentation'
      ],
      settings: {
        foreground: '#9C8590',
        fontStyle: 'italic'
      }
    },
    // Keywords & Control Flow
    {
      name: 'Keywords',
      scope: [
        'keyword',
        'keyword.control',
        'keyword.operator.new',
        'keyword.operator.expression',
        'keyword.operator.logical.python',
        'keyword.operator.wordlike'
      ],
      settings: {
        foreground: syntax.keywords
      }
    },
    // Storage (const, let, var, function, class, public, private, void)
    {
      name: 'Storage Modifiers',
      scope: [
        'storage',
        'storage.type',
        'storage.modifier'
      ],
      settings: {
        foreground: syntax.keywords
      }
    },
    // Operators
    {
      name: 'Operators',
      scope: [
        'keyword.operator',
        'keyword.operator.arithmetic',
        'keyword.operator.comparison',
        'keyword.operator.assignment',
        'keyword.operator.relational',
        'keyword.operator.bitwise'
      ],
      settings: {
        foreground: syntax.operators
      }
    },
    // Functions & Methods
    {
      name: 'Functions & Methods',
      scope: [
        'entity.name.function',
        'meta.function-call',
        'support.function',
        'keyword.other.special-method',
        'variable.function'
      ],
      settings: {
        foreground: syntax.functions
      }
    },
    // Classes, Interfaces, Structs & Namespaces
    {
      name: 'Classes & Interfaces',
      scope: [
        'entity.name.type.class',
        'entity.name.class',
        'entity.name.type.interface',
        'entity.name.type.struct',
        'entity.name.type.enum',
        'entity.name.namespace',
        'entity.name.scope-resolution',
        'support.class'
      ],
      settings: {
        foreground: syntax.classes
      }
    },
    // Types & Primitives
    {
      name: 'Types & Primitives',
      scope: [
        'entity.name.type',
        'support.type',
        'support.type.primitive',
        'storage.type.primitive',
        'storage.type.numeric',
        'storage.type.string',
        'storage.type.boolean'
      ],
      settings: {
        foreground: syntax.types
      }
    },
    // Variables
    {
      name: 'Variables',
      scope: [
        'variable',
        'variable.other',
        'variable.other.readwrite',
        'variable.parameter',
        'meta.definition.variable'
      ],
      settings: {
        foreground: syntax.variables
      }
    },
    // Object / Struct Properties & Fields
    {
      name: 'Object Properties & Fields',
      scope: [
        'variable.other.property',
        'variable.other.object.property',
        'support.variable.property'
      ],
      settings: {
        foreground: '#DDC9D2'
      }
    },
    // Constants & Readonly Identifiers
    {
      name: 'Constants & Readonly',
      scope: [
        'variable.other.constant',
        'variable.other.enummember',
        'support.constant',
        'constant.language',
        'constant.other'
      ],
      settings: {
        foreground: syntax.constants
      }
    },
    // Strings & Characters
    {
      name: 'Strings',
      scope: [
        'string',
        'string.quoted',
        'string.template',
        'punctuation.definition.string'
      ],
      settings: {
        foreground: syntax.strings
      }
    },
    // Numbers & Booleans
    {
      name: 'Numbers & Booleans',
      scope: [
        'constant.numeric',
        'constant.language.boolean',
        'constant.language.null',
        'constant.language.undefined'
      ],
      settings: {
        foreground: syntax.numbers
      }
    },
    // Escape Characters & Regular Expressions
    {
      name: 'Escape & RegEx',
      scope: [
        'constant.character.escape',
        'string.regexp',
        'string.regexp punctuation'
      ],
      settings: {
        foreground: syntax.regex
      }
    },
    // Punctuation & Delimiters
    {
      name: 'Punctuation & Delimiters',
      scope: [
        'punctuation.separator',
        'punctuation.terminator',
        'punctuation.accessor',
        'punctuation.definition.parameters',
        'punctuation.definition.block',
        'punctuation.definition.array'
      ],
      settings: {
        foreground: '#B8A2AC'
      }
    },
    // HTML / XML Tags
    {
      name: 'HTML/XML Tags',
      scope: [
        'entity.name.tag',
        'meta.tag.sgml',
        'punctuation.definition.tag'
      ],
      settings: {
        foreground: syntax.htmlTags
      }
    },
    // HTML / XML Attributes
    {
      name: 'HTML/XML Attributes',
      scope: [
        'entity.other.attribute-name',
        'entity.other.attribute-name.html',
        'entity.other.attribute-name.xml'
      ],
      settings: {
        foreground: syntax.htmlAttrs
      }
    },
    // CSS Selectors
    {
      name: 'CSS Selectors',
      scope: [
        'entity.other.attribute-name.class.css',
        'entity.other.attribute-name.id.css',
        'entity.other.attribute-name.pseudo-class.css',
        'entity.other.attribute-name.pseudo-element.css',
        'source.css entity.name.tag'
      ],
      settings: {
        foreground: syntax.cssSelectors
      }
    },
    // CSS Properties
    {
      name: 'CSS Properties',
      scope: [
        'support.type.property-name.css',
        'support.type.property-name.media',
        'meta.property-name.css'
      ],
      settings: {
        foreground: syntax.cssProps
      }
    },
    // CSS Values & Units
    {
      name: 'CSS Values & Units',
      scope: [
        'support.constant.property-value.css',
        'support.constant.color.w3c-standard-color-name.css',
        'keyword.other.unit.css'
      ],
      settings: {
        foreground: syntax.numbers
      }
    },
    // SQL Keywords
    {
      name: 'SQL Keywords',
      scope: [
        'keyword.other.DML.sql',
        'keyword.other.DDL.sql',
        'keyword.other.data-integrity.sql',
        'keyword.other.alias.sql',
        'source.sql keyword.other'
      ],
      settings: {
        foreground: syntax.sqlKeywords
      }
    },
    // JSON Keys
    {
      name: 'JSON Keys',
      scope: [
        'support.type.property-name.json',
        'source.json meta.structure.dictionary.json > string.quoted.json'
      ],
      settings: {
        foreground: syntax.jsonKey
      }
    },
    // YAML Keys
    {
      name: 'YAML Keys',
      scope: [
        'entity.name.tag.yaml'
      ],
      settings: {
        foreground: syntax.jsonKey
      }
    },
    // Markdown
    {
      name: 'Markdown Headings',
      scope: [
        'markup.heading',
        'entity.name.section.markdown',
        'punctuation.definition.heading.markdown'
      ],
      settings: {
        foreground: syntax.markupHeading,
        fontStyle: 'bold'
      }
    },
    {
      name: 'Markdown Bold',
      scope: ['markup.bold'],
      settings: {
        foreground: syntax.markupBold,
        fontStyle: 'bold'
      }
    },
    {
      name: 'Markdown Italic',
      scope: ['markup.italic'],
      settings: {
        foreground: syntax.markupItalic,
        fontStyle: 'italic'
      }
    },
    {
      name: 'Markdown Inline Code',
      scope: ['markup.inline.raw', 'markup.raw.block'],
      settings: {
        foreground: syntax.markupCode
      }
    },
    {
      name: 'Markdown Link & URL',
      scope: [
        'string.other.link.title.markdown',
        'markup.underline.link'
      ],
      settings: {
        foreground: syntax.markupLink
      }
    },
    {
      name: 'Markdown Blockquote',
      scope: ['markup.quote'],
      settings: {
        foreground: syntax.markupQuote,
        fontStyle: 'italic'
      }
    },
    // Shell & PowerShell
    {
      name: 'Shell & PowerShell Cmdlets & Commands',
      scope: [
        'support.function.powershell',
        'support.function.command.shell',
        'entity.name.function.powershell'
      ],
      settings: {
        foreground: syntax.functions
      }
    },
    {
      name: 'Shell & PowerShell Variables',
      scope: [
        'variable.other.readwrite.powershell',
        'punctuation.definition.variable.powershell',
        'variable.other.normal.shell'
      ],
      settings: {
        foreground: syntax.variables
      }
    },
    {
      name: 'Shell & PowerShell Parameters',
      scope: [
        'support.function.attribute.powershell',
        'variable.parameter.powershell'
      ],
      settings: {
        foreground: syntax.htmlAttrs
      }
    },
    // PHP & WordPress
    {
      name: 'PHP Variables',
      scope: [
        'variable.other.php',
        'punctuation.definition.variable.php'
      ],
      settings: {
        foreground: syntax.variables
      }
    },
    {
      name: 'WordPress Functions & Hooks',
      scope: [
        'support.function.wordpress'
      ],
      settings: {
        foreground: syntax.functions
      }
    },
    // C# & ASP.NET & Razor & Blazor
    {
      name: 'C# Attributes',
      scope: [
        'storage.type.cs',
        'entity.name.type.attribute.cs'
      ],
      settings: {
        foreground: syntax.types
      }
    },
    {
      name: 'Razor Directive & Blazor Components',
      scope: [
        'keyword.other.directive.razor',
        'entity.name.tag.razor',
        'support.class.blazor'
      ],
      settings: {
        foreground: syntax.htmlTags
      }
    },
    // Python Special Identifiers
    {
      name: 'Python Self & Magic Methods',
      scope: [
        'variable.language.special.self.python',
        'variable.language.special.cls.python',
        'support.variable.magic.python'
      ],
      settings: {
        foreground: '#E5A0B0',
        fontStyle: 'italic'
      }
    },
    {
      name: 'Python Decorators',
      scope: [
        'entity.name.function.decorator.python',
        'punctuation.definition.decorator.python'
      ],
      settings: {
        foreground: syntax.functions
      }
    }
  ];

  const semanticTokenColors = {
    keyword: syntax.keywords,
    'keyword.control': syntax.keywords,
    function: syntax.functions,
    'function.declaration': syntax.functions,
    method: syntax.functions,
    'method.declaration': syntax.functions,
    class: syntax.classes,
    'class.declaration': syntax.classes,
    interface: syntax.classes,
    struct: syntax.classes,
    type: syntax.types,
    'type.defaultLibrary': syntax.types,
    typeParameter: syntax.types,
    enum: syntax.classes,
    enumMember: syntax.constants,
    variable: syntax.variables,
    'variable.readonly': syntax.constants,
    'variable.defaultLibrary': syntax.constants,
    property: '#DDC9D2',
    'property.readonly': syntax.constants,
    parameter: syntax.variables,
    string: syntax.strings,
    number: syntax.numbers,
    comment: {
      foreground: syntax.comments,
      italic: true
    },
    regexp: syntax.regex,
    operator: syntax.operators,
    namespace: syntax.classes,
    // JSX / TSX
    'jsx.tag': syntax.htmlTags,
    'jsx.attribute': syntax.htmlAttrs
  };

  return {
    $schema: 'vscode://schemas/color-theme',
    name: name,
    type: type,
    semanticHighlighting: true,
    colors: colors,
    tokenColors: tokenColors,
    semanticTokenColors: semanticTokenColors
  };
}

// 1. Burgundy Pro Palette (Deep, Rich, Luxurious Burgundy)
const burgundyProPalette = {
  bgMain: '#1A1015',
  bgEditor: '#160D12',
  bgSidebar: '#211319',
  bgActivityBar: '#190E13',
  bgPanel: '#211319',
  bgTitleBar: '#24151C',
  bgTitleBarInactive: '#1B0E14',
  bgStatusBar: '#702D45',
  bgStatusBarRemote: '#8E3757',
  bgStatusBarDebugging: '#8A3855',
  bgStatusBarNoFolder: '#4A1E2E',
  bgActiveTab: '#321923',
  bgInactiveTab: '#211319',
  bgTabBorder: '#28161F',
  bgSelection: '#58304495',
  bgSelectionHighlight: '#43253280',
  bgActiveLine: '#281820',
  border: '#432532',
  focusBorder: '#A33B5F',
  textMain: '#E8DCE1',
  textMuted: '#B09AA3',
  textSecondary: '#CCAEC0',
  badgeBg: '#8A2D4F',
  badgeFg: '#FFFFFF',
  inputBg: '#1E1117',
  inputBorder: '#432532',
  dropdownBg: '#211319',
  dropdownBorder: '#432532',
  listHoverBg: '#321A25',
  listActiveSelectionBg: '#482434',
  listInactiveSelectionBg: '#2D1721',
  bracket1: '#E5A0B0',
  bracket2: '#E8B47A',
  bracket3: '#C5D6A5',
  bracket4: '#D7A6E0',
  bracket5: '#D9A1B5',
  bracket6: '#E5C18A',
  gitAdded: '#88BA74',
  gitModified: '#E8B47A',
  gitDeleted: '#F27A8A',
  gitUntracked: '#A5D6A7',
  gitIgnored: '#68515B',
  error: '#F46E82',
  warning: '#E8B47A',
  info: '#89B4FA',
  hint: '#A5D6A7'
};

// 2. Burgundy Soft Palette (Softer Burgundy for Extended Coding Sessions)
const burgundySoftPalette = {
  bgMain: '#1D1419',
  bgEditor: '#1A1216',
  bgSidebar: '#22181E',
  bgActivityBar: '#1B1116',
  bgPanel: '#22181E',
  bgTitleBar: '#251A20',
  bgTitleBarInactive: '#1F151B',
  bgStatusBar: '#5E273A',
  bgStatusBarRemote: '#773049',
  bgStatusBarDebugging: '#79334B',
  bgStatusBarNoFolder: '#411C29',
  bgActiveTab: '#2E1C25',
  bgInactiveTab: '#22181E',
  bgTabBorder: '#291B22',
  bgSelection: '#4E2A3B90',
  bgSelectionHighlight: '#3E222F75',
  bgActiveLine: '#261A21',
  border: '#3B222D',
  focusBorder: '#843B5A',
  textMain: '#E2D6DC',
  textMuted: '#A6929B',
  textSecondary: '#C2A8B5',
  badgeBg: '#7A2846',
  badgeFg: '#FFFFFF',
  inputBg: '#1F141A',
  inputBorder: '#3B222D',
  dropdownBg: '#22181E',
  dropdownBorder: '#3B222D',
  listHoverBg: '#2C1B23',
  listActiveSelectionBg: '#3F2230',
  listInactiveSelectionBg: '#27171F',
  bracket1: '#E5A0B0',
  bracket2: '#E8B47A',
  bracket3: '#C5D6A5',
  bracket4: '#D7A6E0',
  bracket5: '#D9A1B5',
  bracket6: '#E5C18A',
  gitAdded: '#88BA74',
  gitModified: '#E8B47A',
  gitDeleted: '#F27A8A',
  gitUntracked: '#A5D6A7',
  gitIgnored: '#68515B',
  error: '#F46E82',
  warning: '#E8B47A',
  info: '#89B4FA',
  hint: '#A5D6A7'
};

const themePro = createTheme({
  name: 'Burgundy Pro',
  type: 'dark',
  palette: burgundyProPalette
});

const themeSoft = createTheme({
  name: 'Burgundy Soft',
  type: 'dark',
  palette: burgundySoftPalette
});

fs.writeFileSync(
  path.join(__dirname, '..', 'themes', 'burgundy-pro-color-theme.json'),
  JSON.stringify(themePro, null, 2)
);

fs.writeFileSync(
  path.join(__dirname, '..', 'themes', 'burgundy-soft-color-theme.json'),
  JSON.stringify(themeSoft, null, 2)
);

console.log('Successfully generated Burgundy Pro and Burgundy Soft themes!');
