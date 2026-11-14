const fs = require('fs');
const path = require('path');

// Helper to convert hex #RRGGBB to Visual Studio ARGB format FFxxxxxx
function toARGB(hex) {
  if (!hex) return 'FFFFFFFF';
  let clean = hex.replace('#', '');
  if (clean.length === 6) {
    return 'FF' + clean.toUpperCase();
  } else if (clean.length === 8) {
    // #RRGGBBAA -> AARRGGBB
    let r = clean.substring(0, 2);
    let g = clean.substring(2, 4);
    let b = clean.substring(4, 6);
    let a = clean.substring(6, 8);
    return (a + r + g + b).toUpperCase();
  }
  return 'FFFFFFFF';
}

function generateVsThemeXml(name, guid, colors) {
  const bg = toARGB(colors.editorBg);
  const fg = toARGB(colors.editorFg);
  const lineHighlight = toARGB(colors.lineHighlight);
  const selection = toARGB(colors.selection);
  const lineNumber = toARGB(colors.lineNumber);
  const titleBar = toARGB(colors.titleBar);
  const sideBar = toARGB(colors.sideBar);
  const statusBar = toARGB(colors.statusBar);
  const border = toARGB(colors.border);
  const tabActive = toARGB(colors.tabActive);
  const tabInactive = toARGB(colors.tabInactive);
  const accent = toARGB(colors.accent);

  return `<?xml version="1.0" encoding="utf-8"?>
<Themes>
  <Theme Name="${name}" GUID="${guid}">
    <!-- Environment / Shell Window Colors -->
    <Category Name="Environment" GUID="{624ED9C3-BDFD-41FA-96C3-7C824EA32E3D}">
      <Color Name="EnvironmentBackground">
        <Background Type="CT_RAW" Source="${bg}" />
      </Color>
      <Color Name="MainWindowActiveCaption">
        <Background Type="CT_RAW" Source="${titleBar}" />
        <Foreground Type="CT_RAW" Source="${fg}" />
      </Color>
      <Color Name="MainWindowInactiveCaption">
        <Background Type="CT_RAW" Source="${bg}" />
        <Foreground Type="CT_RAW" Source="FFB09AA3" />
      </Color>
      <Color Name="CommandBarBackground">
        <Background Type="CT_RAW" Source="${titleBar}" />
        <Foreground Type="CT_RAW" Source="${fg}" />
      </Color>
      <Color Name="CommandBarBorder">
        <Background Type="CT_RAW" Source="${border}" />
      </Color>
      <Color Name="CommandBarMouseOver">
        <Background Type="CT_RAW" Source="FF321A25" />
      </Color>
      <Color Name="CommandBarSelected">
        <Background Type="CT_RAW" Source="FF482434" />
      </Color>
      <Color Name="ToolWindowBackground">
        <Background Type="CT_RAW" Source="${sideBar}" />
      </Color>
      <Color Name="ToolWindowBorder">
        <Background Type="CT_RAW" Source="${border}" />
      </Color>
      <Color Name="ToolWindowTabSelectedBackground">
        <Background Type="CT_RAW" Source="${tabActive}" />
        <Foreground Type="CT_RAW" Source="FFFFFFFF" />
      </Color>
      <Color Name="ToolWindowTabSelectedBorder">
        <Background Type="CT_RAW" Source="${accent}" />
      </Color>
      <Color Name="StatusBarBackground">
        <Background Type="CT_RAW" Source="${statusBar}" />
        <Foreground Type="CT_RAW" Source="FFFFFFFF" />
      </Color>
      <Color Name="FileTabChannelBackground">
        <Background Type="CT_RAW" Source="${titleBar}" />
      </Color>
      <Color Name="FileTabSelectedBackground">
        <Background Type="CT_RAW" Source="${tabActive}" />
        <Foreground Type="CT_RAW" Source="FFFFFFFF" />
      </Color>
      <Color Name="FileTabSelectedBorder">
        <Background Type="CT_RAW" Source="${accent}" />
      </Color>
      <Color Name="FileTabInactiveBackground">
        <Background Type="CT_RAW" Source="${tabInactive}" />
        <Foreground Type="CT_RAW" Source="FFB09AA3" />
      </Color>
      <Color Name="ScrollBarBackground">
        <Background Type="CT_RAW" Source="FF190E13" />
      </Color>
      <Color Name="ScrollBarThumbBackground">
        <Background Type="CT_RAW" Source="FF583044" />
      </Color>
      <Color Name="TreeBackground">
        <Background Type="CT_RAW" Source="${sideBar}" />
      </Color>
      <Color Name="TreeSelectedBackground">
        <Background Type="CT_RAW" Source="FF482434" />
        <Foreground Type="CT_RAW" Source="FFFFFFFF" />
      </Color>
      <Color Name="NotificationBadgeBackground">
        <Background Type="CT_RAW" Source="FF8A2D4F" />
        <Foreground Type="CT_RAW" Source="FFFFFFFF" />
      </Color>
    </Category>

    <!-- Text Editor Core Elements -->
    <Category Name="Text Editor" GUID="{75A88B63-04E1-46E3-A7B0-27A73457C014}">
      <Color Name="Plain Text">
        <Background Type="CT_RAW" Source="${bg}" />
        <Foreground Type="CT_RAW" Source="${fg}" />
      </Color>
      <Color Name="Selected Text">
        <Background Type="CT_RAW" Source="${selection}" />
        <Foreground Type="CT_RAW" Source="FFFFFFFF" />
      </Color>
      <Color Name="Inactive Selected Text">
        <Background Type="CT_RAW" Source="FF432532" />
        <Foreground Type="CT_RAW" Source="${fg}" />
      </Color>
      <Color Name="Line Numbers">
        <Background Type="CT_RAW" Source="${bg}" />
        <Foreground Type="CT_RAW" Source="${lineNumber}" />
      </Color>
      <Color Name="Indicator Margin">
        <Background Type="CT_RAW" Source="${bg}" />
      </Color>
      <Color Name="Visible White Space">
        <Foreground Type="CT_RAW" Source="FF3E2430" />
      </Color>
      <Color Name="Brace Matching">
        <Background Type="CT_RAW" Source="FF583044" />
        <Foreground Type="CT_RAW" Source="${accent}" />
      </Color>
      <Color Name="Current Line Active">
        <Background Type="CT_RAW" Source="${lineHighlight}" />
      </Color>
      <Color Name="Find Match Highlight">
        <Background Type="CT_RAW" Source="FF702D45" />
      </Color>
      <Color Name="Collapsible Region">
        <Foreground Type="CT_RAW" Source="FF826573" />
      </Color>
    </Category>

    <!-- Syntax Highlighting (Language Service Items) -->
    <Category Name="Text Editor Language Service Items" GUID="{E0186530-9115-4014-9B0E-898EF47514A3}">
      <Color Name="Keyword">
        <Foreground Type="CT_RAW" Source="FFE5A0B0" />
      </Color>
      <Color Name="Keyword - Control">
        <Foreground Type="CT_RAW" Source="FFC44D76" />
      </Color>
      <Color Name="Comment">
        <Foreground Type="CT_RAW" Source="FF9D858D" />
      </Color>
      <Color Name="String">
        <Foreground Type="CT_RAW" Source="FFE8A87C" />
      </Color>
      <Color Name="String - Verbatim">
        <Foreground Type="CT_RAW" Source="FFE8B47A" />
      </Color>
      <Color Name="Number">
        <Foreground Type="CT_RAW" Source="FFDDAA88" />
      </Color>
      <Color Name="Operator">
        <Foreground Type="CT_RAW" Source="FFD7A6E0" />
      </Color>
      <Color Name="Punctuation">
        <Foreground Type="CT_RAW" Source="FFB09AA3" />
      </Color>
      <Color Name="Identifier">
        <Foreground Type="CT_RAW" Source="${fg}" />
      </Color>
      <Color Name="Local Variable">
        <Foreground Type="CT_RAW" Source="${fg}" />
      </Color>
      <Color Name="Parameter">
        <Foreground Type="CT_RAW" Source="FFD9A1B5" />
      </Color>
      <Color Name="Class Name">
        <Foreground Type="CT_RAW" Source="FFF0C2CC" />
      </Color>
      <Color Name="Structure Name">
        <Foreground Type="CT_RAW" Source="FFF0C2CC" />
      </Color>
      <Color Name="Interface Name">
        <Foreground Type="CT_RAW" Source="FFE5C18A" />
      </Color>
      <Color Name="Enum Name">
        <Foreground Type="CT_RAW" Source="FFE5C18A" />
      </Color>
      <Color Name="Delegate Name">
        <Foreground Type="CT_RAW" Source="FFD7A6E0" />
      </Color>
      <Color Name="Type Parameter Name">
        <Foreground Type="CT_RAW" Source="FFE5C18A" />
      </Color>
      <Color Name="Method Name">
        <Foreground Type="CT_RAW" Source="FFC5D6A5" />
      </Color>
      <Color Name="Extension Method Name">
        <Foreground Type="CT_RAW" Source="FFC5D6A5" />
      </Color>
      <Color Name="Property Name">
        <Foreground Type="CT_RAW" Source="FFF3C5D4" />
      </Color>
      <Color Name="Field Name">
        <Foreground Type="CT_RAW" Source="FFF3C5D4" />
      </Color>
      <Color Name="Preprocessor Keyword">
        <Foreground Type="CT_RAW" Source="FFC44D76" />
      </Color>
      <Color Name="XML Doc Comment">
        <Foreground Type="CT_RAW" Source="FF826573" />
      </Color>
      <Color Name="XML Doc Tag">
        <Foreground Type="CT_RAW" Source="FFC44D76" />
      </Color>
      <Color Name="HTML Element Name">
        <Foreground Type="CT_RAW" Source="FFE5A0B0" />
      </Color>
      <Color Name="HTML Attribute">
        <Foreground Type="CT_RAW" Source="FFF3C5D4" />
      </Color>
      <Color Name="HTML Attribute Value">
        <Foreground Type="CT_RAW" Source="FFE8A87C" />
      </Color>
      <Color Name="JSON Property Name">
        <Foreground Type="CT_RAW" Source="FFE5A0B0" />
      </Color>
      <Color Name="JSON String">
        <Foreground Type="CT_RAW" Source="FFE8A87C" />
      </Color>
    </Category>
  </Theme>
</Themes>
`;
}

// Generate files for visual-studio-ide
const outDir = path.resolve(__dirname, '../visual-studio-ide');
const themesDir = path.join(outDir, 'Themes');

if (!fs.existsSync(themesDir)) {
  fs.mkdirSync(themesDir, { recursive: true });
}

// Burgundy Pro
const proXml = generateVsThemeXml('Burgundy Pro', '{4C20DF4E-B5F7-4DC1-BC95-6B586C91A011}', {
  editorBg: '#160D12',
  editorFg: '#E8DCE1',
  lineHighlight: '#281820',
  selection: '#583044',
  lineNumber: '#6B4D5B',
  titleBar: '#24151C',
  sideBar: '#211319',
  statusBar: '#702D45',
  border: '#432532',
  tabActive: '#321923',
  tabInactive: '#211319',
  accent: '#C44D76'
});
fs.writeFileSync(path.join(themesDir, 'BurgundyPro.vstheme'), proXml, 'utf8');

// Burgundy Soft
const softXml = generateVsThemeXml('Burgundy Soft', '{4C20DF4E-B5F7-4DC1-BC95-6B586C91A012}', {
  editorBg: '#1A1216',
  editorFg: '#E4DAE0',
  lineHighlight: '#2A1C23',
  selection: '#523040',
  lineNumber: '#6E5562',
  titleBar: '#251920',
  sideBar: '#21161D',
  statusBar: '#5E273A',
  border: '#3D2833',
  tabActive: '#2F1E27',
  tabInactive: '#21161D',
  accent: '#B0476C'
});
fs.writeFileSync(path.join(themesDir, 'BurgundySoft.vstheme'), softXml, 'utf8');

// PKGDEF for theme registration
const pkgdefContent = `// Burgundy Pro Theme Package Definition for Visual Studio 2019 & 2022
[$RootKey$\\Themes\\{4C20DF4E-B5F7-4DC1-BC95-6B586C91A011}]
@="Burgundy Pro"
"FallbackId"="{1DED0138-47CE-435E-84EF-9EC1F439B749}"

[$RootKey$\\Themes\\{4C20DF4E-B5F7-4DC1-BC95-6B586C91A012}]
@="Burgundy Soft"
"FallbackId"="{1DED0138-47CE-435E-84EF-9EC1F439B749}"
`;
fs.writeFileSync(path.join(outDir, 'BurgundyPro.pkgdef'), pkgdefContent, 'utf8');

// [Content_Types].xml
const contentTypesXml = `<?xml version="1.0" encoding="utf-8"?>
<Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types">
  <Default Extension="vsixmanifest" ContentType="text/xml" />
  <Default Extension="vstheme" ContentType="text/xml" />
  <Default Extension="png" ContentType="image/png" />
  <Default Extension="pkgdef" ContentType="text/plain" />
  <Default Extension="txt" ContentType="text/plain" />
  <Default Extension="md" ContentType="text/plain" />
</Types>
`;
fs.writeFileSync(path.join(outDir, '[Content_Types].xml'), contentTypesXml, 'utf8');

// extension.vsixmanifest
const vsixManifest = `<?xml version="1.0" encoding="utf-8"?>
<PackageManifest Version="2.0.0" xmlns="http://schemas.microsoft.com/developer/vsx-schema/2011" xmlns:d="http://schemas.microsoft.com/developer/vsx-schema-design/2011">
  <Metadata>
    <Identity Id="BurgundyProTheme.shamsulhaq08" Version="1.0.1" Language="en-US" Publisher="shamsulhaq08" />
    <DisplayName>Burgundy Pro</DisplayName>
    <Description xml:space="preserve">A premium, modern dark Burgundy theme for Visual Studio 2022 and Visual Studio 2019. Crafted with deep burgundy identity, wine-red accents, and soft rose syntax highlighting.</Description>
    <MoreInfo>https://github.com/shamsulhaq08/burgundy-pro</MoreInfo>
    <License>LICENSE.txt</License>
    <Icon>images/icon.png</Icon>
    <PreviewImage>images/preview-burgundy-pro.png</PreviewImage>
    <Tags>theme, dark theme, burgundy, visual studio 2022, visual studio 2019, color theme</Tags>
  </Metadata>
  <Installation>
    <InstallationTarget Id="Microsoft.VisualStudio.Community" Version="[16.0, 18.0)">
      <ProductArchitecture>x86,amd64,arm64</ProductArchitecture>
    </InstallationTarget>
    <InstallationTarget Id="Microsoft.VisualStudio.Pro" Version="[16.0, 18.0)">
      <ProductArchitecture>x86,amd64,arm64</ProductArchitecture>
    </InstallationTarget>
    <InstallationTarget Id="Microsoft.VisualStudio.Enterprise" Version="[16.0, 18.0)">
      <ProductArchitecture>x86,amd64,arm64</ProductArchitecture>
    </InstallationTarget>
  </Installation>
  <Dependencies>
    <Dependency Id="Microsoft.Framework.NDP" DisplayName="Microsoft .NET Framework" Version="[4.5,)" />
  </Dependencies>
  <Prerequisites>
    <Prerequisite Id="Microsoft.VisualStudio.Component.CoreEditor" Version="[16.0, 18.0)" DisplayName="Visual Studio core editor" />
  </Prerequisites>
  <Assets>
    <Asset Type="Microsoft.VisualStudio.Theme" Path="Themes/BurgundyPro.vstheme" />
    <Asset Type="Microsoft.VisualStudio.Theme" Path="Themes/BurgundySoft.vstheme" />
    <Asset Type="Microsoft.VisualStudio.VsPackage" Path="BurgundyPro.pkgdef" />
    <Asset Type="Microsoft.VisualStudio.Services.Icons.Default" Path="images/icon.png" />
    <Asset Type="Microsoft.VisualStudio.Services.Content.Details" Path="README.md" />
    <Asset Type="Microsoft.VisualStudio.Services.Content.License" Path="LICENSE.txt" />
  </Assets>
</PackageManifest>
`;
fs.writeFileSync(path.join(outDir, 'extension.vsixmanifest'), vsixManifest, 'utf8');

// Copy LICENSE to LICENSE.txt in visual-studio-ide
fs.copyFileSync(path.resolve(__dirname, '../LICENSE'), path.join(outDir, 'LICENSE.txt'));

// Create README.md for Visual Studio extension
const vsReadme = `# Burgundy Pro for Visual Studio 2022 & 2019

A luxurious, modern dark theme for **Visual Studio 2022** and **Visual Studio 2019**, crafted with deep burgundy identity, wine-red interactive surfaces, and soft rose syntax highlights.

## Variants
1. **Burgundy Pro**: Flagship deep burgundy contrast with vivid wine & rose accents.
2. **Burgundy Soft**: Softer charcoal-burgundy balance tailored for long coding sessions.

## Compatible With
- Visual Studio 2022 (Community, Professional, Enterprise) - x64 & ARM64
- Visual Studio 2019 (Community, Professional, Enterprise)

## How to Apply
1. Install this VSIX extension.
2. Open Visual Studio.
3. Go to **Tools** > **Options** > **Environment** > **General**.
4. In the **Color theme** dropdown, select **Burgundy Pro** or **Burgundy Soft**.
`;
fs.writeFileSync(path.join(outDir, 'README.md'), vsReadme, 'utf8');

console.log('Visual Studio IDE files generated successfully.');
