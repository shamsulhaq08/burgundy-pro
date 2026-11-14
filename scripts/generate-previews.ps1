Add-Type -AssemblyName System.Drawing

function Render-ThemePreview {
    param (
        [string]$ThemeTitle,
        [string]$VariantName,
        [hashtable]$Palette,
        [string]$OutFile
    )

    $width = 1280
    $height = 720
    $bmp = [System.Drawing.Bitmap]::new($width, $height)
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::ClearTypeGridFit

    $fontFamily = [System.Drawing.FontFamily]::GenericSansSerif
    $monoFamily = [System.Drawing.FontFamily]::GenericMonospace

    $fontTitle = [System.Drawing.Font]::new($fontFamily, 10, [System.Drawing.FontStyle]::Regular)
    $fontSidebar = [System.Drawing.Font]::new($fontFamily, 9.5, [System.Drawing.FontStyle]::Regular)
    $fontSidebarHeader = [System.Drawing.Font]::new($fontFamily, 8.5, [System.Drawing.FontStyle]::Bold)
    $fontTab = [System.Drawing.Font]::new($fontFamily, 9.5, [System.Drawing.FontStyle]::Regular)
    $fontCode = [System.Drawing.Font]::new("Consolas", 11.5, [System.Drawing.FontStyle]::Regular)
    $fontCodeBold = [System.Drawing.Font]::new("Consolas", 11.5, [System.Drawing.FontStyle]::Bold)
    $fontCodeItalic = [System.Drawing.Font]::new("Consolas", 11.5, [System.Drawing.FontStyle]::Italic)
    $fontStatus = [System.Drawing.Font]::new($fontFamily, 9, [System.Drawing.FontStyle]::Regular)

    # 1. Base window background
    $brushMain = [System.Drawing.SolidBrush]::new([System.Drawing.ColorTranslator]::FromHtml($Palette.bgMain))
    $g.FillRectangle($brushMain, 0, 0, $width, $height)

    # 2. Title Bar (Height: 38px)
    $titleH = 38
    $brushTitle = [System.Drawing.SolidBrush]::new([System.Drawing.ColorTranslator]::FromHtml($Palette.bgTitleBar))
    $g.FillRectangle($brushTitle, 0, 0, $width, $titleH)
    $penBorder = [System.Drawing.Pen]::new([System.Drawing.ColorTranslator]::FromHtml($Palette.border), 1)
    $g.DrawLine($penBorder, 0, $titleH, $width, $titleH)

    # Title Bar window controls (macOS / clean dots on left)
    $dotClose = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::FromArgb(255, 235, 95, 115))
    $dotMin = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::FromArgb(255, 235, 180, 85))
    $dotMax = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::FromArgb(255, 120, 195, 100))
    $g.FillEllipse($dotClose, 16, 13, 12, 12)
    $g.FillEllipse($dotMin, 36, 13, 12, 12)
    $g.FillEllipse($dotMax, 56, 13, 12, 12)

    # Title text
    $brushTextMain = [System.Drawing.SolidBrush]::new([System.Drawing.ColorTranslator]::FromHtml($Palette.textMain))
    $brushTextMuted = [System.Drawing.SolidBrush]::new([System.Drawing.ColorTranslator]::FromHtml($Palette.textMuted))
    $titleString = "$VariantName  —  ThemePreview.tsx  —  Visual Studio Code"
    $titleSize = $g.MeasureString($titleString, $fontTitle)
    $g.DrawString($titleString, $fontTitle, $brushTextMuted, ($width - $titleSize.Width) / 2, 10)

    # 3. Status Bar (Bottom Height: 26px)
    $statusH = 26
    $statusY = $height - $statusH
    $brushStatus = [System.Drawing.SolidBrush]::new([System.Drawing.ColorTranslator]::FromHtml($Palette.bgStatusBar))
    $g.FillRectangle($brushStatus, 0, $statusY, $width, $statusH)
    $g.DrawLine($penBorder, 0, $statusY, $width, $statusY)

    # Remote status item on bottom left
    $brushRemote = [System.Drawing.SolidBrush]::new([System.Drawing.ColorTranslator]::FromHtml($Palette.bgStatusBarRemote))
    $g.FillRectangle($brushRemote, 0, $statusY, 48, $statusH)
    $brushWhite = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::White)
    $g.DrawString("><", $fontStatus, $brushWhite, 14, $statusY + 5)
    $g.DrawString("main*  0↓ 1↑", $fontStatus, $brushWhite, 58, $statusY + 5)
    $g.DrawString("0 errors, 0 warnings", $fontStatus, $brushWhite, 160, $statusY + 5)

    $statusRightText = "Spaces: 2   UTF-8   CRLF   TypeScript JSX   Prettier   $VariantName"
    $srSize = $g.MeasureString($statusRightText, $fontStatus)
    $g.DrawString($statusRightText, $fontStatus, $brushWhite, $width - $srSize.Width - 16, $statusY + 5)

    # 4. Activity Bar (Width: 50px)
    $actW = 50
    $bodyY = $titleH + 1
    $bodyH = $statusY - $bodyY
    $brushAct = [System.Drawing.SolidBrush]::new([System.Drawing.ColorTranslator]::FromHtml($Palette.bgActivityBar))
    $g.FillRectangle($brushAct, 0, $bodyY, $actW, $bodyH)
    $g.DrawLine($penBorder, $actW, $bodyY, $actW, $statusY)

    # Active Indicator Bar on Activity Bar
    $brushRoseAccent = [System.Drawing.SolidBrush]::new([System.Drawing.ColorTranslator]::FromHtml('#C44D76'))
    $g.FillRectangle($brushRoseAccent, 0, $bodyY + 12, 3, 26)

    # Activity Bar Icons
    $brushActActive = [System.Drawing.SolidBrush]::new([System.Drawing.ColorTranslator]::FromHtml('#F3C5D4'))
    $brushActInactive = [System.Drawing.SolidBrush]::new([System.Drawing.ColorTranslator]::FromHtml('#826573'))
    $g.DrawString("📄", $fontTitle, $brushActActive, 14, $bodyY + 16)
    $g.DrawString("🔍", $fontTitle, $brushActInactive, 14, $bodyY + 60)
    $g.DrawString("🔀", $fontTitle, $brushActInactive, 14, $bodyY + 104)
    $g.DrawString("🐞", $fontTitle, $brushActInactive, 14, $bodyY + 148)
    $g.DrawString("🧩", $fontTitle, $brushActInactive, 14, $bodyY + 192)

    # Badge on Extensions icon
    $brushBadge = [System.Drawing.SolidBrush]::new([System.Drawing.ColorTranslator]::FromHtml($Palette.badgeBg))
    $g.FillEllipse($brushBadge, 26, $bodyY + 188, 16, 16)
    $fontBadge = [System.Drawing.Font]::new($fontFamily, 7.5, [System.Drawing.FontStyle]::Bold)
    $g.DrawString("1", $fontBadge, $brushWhite, 31, $bodyY + 190)

    # 5. Sidebar (Width: 230px)
    $sbX = $actW + 1
    $sbW = 230
    $brushSidebar = [System.Drawing.SolidBrush]::new([System.Drawing.ColorTranslator]::FromHtml($Palette.bgSidebar))
    $g.FillRectangle($brushSidebar, $sbX, $bodyY, $sbW, $bodyH)
    $g.DrawLine($penBorder, $sbX + $sbW, $bodyY, $sbX + $sbW, $statusY)

    # Sidebar Header
    $g.DrawString("EXPLORER", $fontSidebarHeader, $brushTextMuted, $sbX + 16, $bodyY + 12)
    $g.DrawString("BURGUNDY-PRO", $fontSidebarHeader, $brushTextMain, $sbX + 16, $bodyY + 36)

    # Explorer File Tree Items
    $treeItems = @(
        @{ Name = "v  themes"; Color = $Palette.textMain; IsDir = $true; Y = 62 },
        @{ Name = "     burgundy-pro.json"; Color = if ($VariantName -eq "Burgundy Pro") { '#E5A0B0' } else { '#E8B47A' }; IsDir = $false; Y = 84 },
        @{ Name = "     burgundy-soft.json"; Color = if ($VariantName -eq "Burgundy Soft") { '#E5A0B0' } else { '#E8B47A' }; IsDir = $false; Y = 106 },
        @{ Name = "v  src"; Color = $Palette.textMain; IsDir = $true; Y = 128 },
        @{ Name = "   >  components"; Color = $Palette.textMuted; IsDir = $true; Y = 150 },
        @{ Name = "      ThemePreview.tsx"; Color = '#E5A0B0'; IsDir = $false; Y = 172; IsActive = $true },
        @{ Name = "      App.styles.css"; Color = '#D6A4B5'; IsDir = $false; Y = 194 },
        @{ Name = "      BurgundyEngine.ts"; Color = '#9B9AE5'; IsDir = $false; Y = 216 },
        @{ Name = "   package.json"; Color = '#C5D6A5'; IsDir = $false; Y = 238 },
        @{ Name = "   README.md"; Color = '#9B9AE5'; IsDir = $false; Y = 260 }
    )

    $brushActiveItemBg = [System.Drawing.SolidBrush]::new([System.Drawing.ColorTranslator]::FromHtml($Palette.listActiveSelectionBg))
    foreach ($item in $treeItems) {
        if ($item.IsActive) {
            $g.FillRectangle($brushActiveItemBg, $sbX, $bodyY + $item.Y - 3, $sbW, 22)
            $brushItem = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::White)
        } else {
            $brushItem = [System.Drawing.SolidBrush]::new([System.Drawing.ColorTranslator]::FromHtml($item.Color))
        }
        $g.DrawString($item.Name, $fontSidebar, $brushItem, $sbX + 14, $bodyY + $item.Y)
    }

    # 6. Editor Header / Tabs Bar (Height: 36px)
    $tabX = $sbX + $sbW + 1
    $tabW = $width - $tabX
    $tabH = 36
    $brushTabHeader = [System.Drawing.SolidBrush]::new([System.Drawing.ColorTranslator]::FromHtml($Palette.bgTitleBar))
    $g.FillRectangle($brushTabHeader, $tabX, $bodyY, $tabW, $tabH)
    $g.DrawLine($penBorder, $tabX, $bodyY + $tabH, $width, $bodyY + $tabH)

    # Active Tab
    $activeTabW = 180
    $brushActiveTab = [System.Drawing.SolidBrush]::new([System.Drawing.ColorTranslator]::FromHtml($Palette.bgActiveTab))
    $g.FillRectangle($brushActiveTab, $tabX, $bodyY, $activeTabW, $tabH)
    # Active tab top border
    $brushTabBorderTop = [System.Drawing.SolidBrush]::new([System.Drawing.ColorTranslator]::FromHtml('#C44D76'))
    $g.FillRectangle($brushTabBorderTop, $tabX, $bodyY, $activeTabW, 2)
    $g.DrawLine($penBorder, $tabX + $activeTabW, $bodyY, $tabX + $activeTabW, $bodyY + $tabH)
    $g.DrawString("⚛  ThemePreview.tsx  ✕", $fontTab, $brushWhite, $tabX + 14, $bodyY + 9)

    # Inactive Tab 1
    $inTab1X = $tabX + $activeTabW + 1
    $inTabW = 160
    $brushInactiveTab = [System.Drawing.SolidBrush]::new([System.Drawing.ColorTranslator]::FromHtml($Palette.bgInactiveTab))
    $g.FillRectangle($brushInactiveTab, $inTab1X, $bodyY, $inTabW, $tabH)
    $g.DrawLine($penBorder, $inTab1X + $inTabW, $bodyY, $inTab1X + $inTabW, $bodyY + $tabH)
    $g.DrawString("#  App.styles.css", $fontTab, $brushTextMuted, $inTab1X + 14, $bodyY + 9)

    # Inactive Tab 2
    $inTab2X = $inTab1X + $inTabW + 1
    $g.FillRectangle($brushInactiveTab, $inTab2X, $bodyY, $inTabW, $tabH)
    $g.DrawLine($penBorder, $inTab2X + $inTabW, $bodyY, $inTab2X + $inTabW, $bodyY + $tabH)
    $g.DrawString("{}  package.json", $fontTab, $brushTextMuted, $inTab2X + 14, $bodyY + 9)

    # 7. Breadcrumbs Bar (Height: 24px)
    $bcY = $bodyY + $tabH + 1
    $bcH = 24
    $brushEditor = [System.Drawing.SolidBrush]::new([System.Drawing.ColorTranslator]::FromHtml($Palette.bgEditor))
    $g.FillRectangle($brushEditor, $tabX, $bcY, $tabW, $bcH)
    $g.DrawLine($penBorder, $tabX, $bcY + $bcH, $width, $bcY + $bcH)
    $g.DrawString("src  >  components  >  ThemePreview.tsx  >  $VariantName", $fontSidebar, $brushTextMuted, $tabX + 16, $bcY + 4)

    # 8. Editor Code Area
    $codeY = $bcY + $bcH + 1
    $codeH = $statusY - $codeY
    $g.FillRectangle($brushEditor, $tabX, $codeY, $tabW, $codeH)

    # Active Line Highlight (Line 8)
    $lineH = 22
    $lineHighlightY = $codeY + (8 * $lineH)
    $brushLineHighlight = [System.Drawing.SolidBrush]::new([System.Drawing.ColorTranslator]::FromHtml($Palette.bgActiveLine))
    $g.FillRectangle($brushLineHighlight, $tabX, $lineHighlightY, $tabW - 120, $lineH)

    # Selection Highlight on Line 12
    $selectionY = $codeY + (12 * $lineH)
    $brushSelection = [System.Drawing.SolidBrush]::new([System.Drawing.ColorTranslator]::FromHtml($Palette.bgSelection))
    $g.FillRectangle($brushSelection, $tabX + 175, $selectionY, 195, $lineH)

    # Minimap (Width: 100px on right)
    $minimapW = 100
    $minimapX = $width - $minimapW
    $g.DrawLine($penBorder, $minimapX, $codeY, $minimapX, $statusY)

    # Code Line Numbers and Code Lines
    $gutterW = 54
    $gutterColor = if ($VariantName -eq "Burgundy Pro") { '#6B4D5B' } else { '#5E4450' }
    $gutterActiveColor = if ($VariantName -eq "Burgundy Pro") { '#E5A0B0' } else { '#D9A1B5' }
    $brushGutter = [System.Drawing.SolidBrush]::new([System.Drawing.ColorTranslator]::FromHtml($gutterColor))
    $brushGutterActive = [System.Drawing.SolidBrush]::new([System.Drawing.ColorTranslator]::FromHtml($gutterActiveColor))

    # Syntax Brushes
    $cKeywords = [System.Drawing.SolidBrush]::new([System.Drawing.ColorTranslator]::FromHtml('#E5A0B0'))
    $cFunctions = [System.Drawing.SolidBrush]::new([System.Drawing.ColorTranslator]::FromHtml('#E8B47A'))
    $cVariables = [System.Drawing.SolidBrush]::new([System.Drawing.ColorTranslator]::FromHtml($Palette.textMain))
    $cStrings = [System.Drawing.SolidBrush]::new([System.Drawing.ColorTranslator]::FromHtml('#C5D6A5'))
    $cNumbers = [System.Drawing.SolidBrush]::new([System.Drawing.ColorTranslator]::FromHtml('#D7A6E0'))
    $cTypes = [System.Drawing.SolidBrush]::new([System.Drawing.ColorTranslator]::FromHtml('#D9A1B5'))
    $cConstants = [System.Drawing.SolidBrush]::new([System.Drawing.ColorTranslator]::FromHtml('#E5C18A'))
    $cComments = [System.Drawing.SolidBrush]::new([System.Drawing.ColorTranslator]::FromHtml('#88717B'))
    $cOperators = [System.Drawing.SolidBrush]::new([System.Drawing.ColorTranslator]::FromHtml('#D7A0AE'))
    $cTags = [System.Drawing.SolidBrush]::new([System.Drawing.ColorTranslator]::FromHtml('#E58BA2'))
    $cAttrs = [System.Drawing.SolidBrush]::new([System.Drawing.ColorTranslator]::FromHtml('#D6B0C0'))
    $cPunct = [System.Drawing.SolidBrush]::new([System.Drawing.ColorTranslator]::FromHtml('#B8A2AC'))

    $variantString = if ($VariantName -eq "Burgundy Pro") { "'burgundy-pro'" } else { "'burgundy-soft'" }
    $variantAccent = if ($VariantName -eq "Burgundy Pro") { "'#702D45'" } else { "'#5E273A'" }
    $variantContrast = if ($VariantName -eq "Burgundy Pro") { "14.32" } else { "13.03" }

    $codeLines = @(
        @{ Line = 1; Tokens = @(@{ T = "// $VariantName Theme - $variantContrast:1 AAA Contrast"; B = $cComments; I = $true }) },
        @{ Line = 2; Tokens = @(@{ T = "import"; B = $cKeywords }, @{ T = " React, { FC, useState, useMemo } "; B = $cVariables }, @{ T = "from"; B = $cKeywords }, @{ T = " 'react'"; B = $cStrings }, @{ T = ";"; B = $cPunct }) },
        @{ Line = 3; Tokens = @() },
        @{ Line = 4; Tokens = @(@{ T = "export interface "; B = $cKeywords }, @{ T = "ThemeConfig "; B = $cTypes }, @{ T = "{"; B = $cPunct }) },
        @{ Line = 5; Tokens = @(@{ T = "  readonly "; B = $cKeywords }, @{ T = "themeId"; B = $cAttrs }, @{ T = ": "; B = $cOperators }, @{ T = $variantString; B = $cStrings }, @{ T = ";"; B = $cPunct }) },
        @{ Line = 6; Tokens = @(@{ T = "  accentColor"; B = $cAttrs }, @{ T = ": "; B = $cOperators }, @{ T = "string"; B = $cTypes }, @{ T = ";"; B = $cPunct }) },
        @{ Line = 7; Tokens = @(@{ T = "  contrastRatio"; B = $cAttrs }, @{ T = ": "; B = $cOperators }, @{ T = "number"; B = $cTypes }, @{ T = ";"; B = $cPunct }) },
        @{ Line = 8; Tokens = @(@{ T = "}"; B = $cPunct }) },
        @{ Line = 9; Tokens = @(@{ T = "export const "; B = $cKeywords }, @{ T = "BurgundyPreview"; B = $cFunctions }, @{ T = ": "; B = $cOperators }, @{ T = "FC"; B = $cTypes }, @{ T = "<"; B = $cPunct }, @{ T = "ThemeConfig"; B = $cTypes }, @{ T = "> = ({"; B = $cPunct }) },
        @{ Line = 10; Tokens = @(@{ T = "  themeId = "; B = $cVariables }, @{ T = $variantString; B = $cStrings }, @{ T = ","; B = $cPunct }) },
        @{ Line = 11; Tokens = @(@{ T = "  accentColor = "; B = $cVariables }, @{ T = $variantAccent; B = $cStrings }, @{ T = ","; B = $cPunct }) },
        @{ Line = 12; Tokens = @(@{ T = "  contrastRatio = "; B = $cVariables }, @{ T = $variantContrast; B = $cNumbers }) },
        @{ Line = 13; Tokens = @(@{ T = "}) => {"; B = $cPunct }) },
        @{ Line = 14; Tokens = @(@{ T = "  const ["; B = $cVariables }, @{ T = "isActive"; B = $cConstants }, @{ T = ", "; B = $cPunct }, @{ T = "setActive"; B = $cFunctions }, @{ T = "] = "; B = $cOperators }, @{ T = "useState"; B = $cFunctions }, @{ T = "<"; B = $cPunct }, @{ T = "boolean"; B = $cTypes }, @{ T = ">("; B = $cPunct }, @{ T = "true"; B = $cNumbers }, @{ T = ");"; B = $cPunct }) },
        @{ Line = 15; Tokens = @() },
        @{ Line = 16; Tokens = @(@{ T = "  return ("; B = $cKeywords }) },
        @{ Line = 17; Tokens = @(@{ T = "    <"; B = $cPunct }, @{ T = "section "; B = $cTags }, @{ T = "className"; B = $cAttrs }, @{ T = "="; B = $cOperators }, @{ T = '"shams-burgundy-card"'; B = $cStrings }, @{ T = ">"; B = $cPunct }) },
        @{ Line = 18; Tokens = @(@{ T = "      <"; B = $cPunct }, @{ T = "header "; B = $cTags }, @{ T = "style"; B = $cAttrs }, @{ T = "={{ backgroundColor: "; B = $cPunct }, @{ T = "accentColor"; B = $cVariables }, @{ T = " }}>"; B = $cPunct }) },
        @{ Line = 19; Tokens = @(@{ T = "        <"; B = $cPunct }, @{ T = "h1"; B = $cTags }, @{ T = ">$VariantName Edition</"; B = $cVariables }, @{ T = "h1"; B = $cTags }, @{ T = ">"; B = $cPunct }) },
        @{ Line = 20; Tokens = @(@{ T = "      </"; B = $cPunct }, @{ T = "header"; B = $cTags }, @{ T = ">"; B = $cPunct }) },
        @{ Line = 21; Tokens = @(@{ T = "    </"; B = $cPunct }, @{ T = "section"; B = $cTags }, @{ T = ">"; B = $cPunct }) },
        @{ Line = 22; Tokens = @(@{ T = "  );"; B = $cPunct }) },
        @{ Line = 23; Tokens = @(@{ T = "};"; B = $cPunct }) }
    )

    $startX = $tabX + $gutterW + 16
    for ($i = 0; $i -lt $codeLines.Count; $i++) {
        $lNum = $i + 1
        $currY = $codeY + ($i * $lineH)
        
        # Line number
        $gBrush = if ($lNum -eq 9) { $brushGutterActive } else { $brushGutter }
        $g.DrawString($lNum.ToString().PadLeft(3), $fontCode, $gBrush, $tabX + 12, $currY)

        # Draw tokens
        $currX = $startX
        foreach ($tok in $codeLines[$i].Tokens) {
            $f = if ($tok.I) { $fontCodeItalic } else { $fontCode }
            $g.DrawString($tok.T, $f, $tok.B, $currX, $currY)
            $size = $g.MeasureString($tok.T, $f)
            $currX += ($size.Width - 4.5)
        }
    }

    # Cursor on line 9
    $penCursor = [System.Drawing.Pen]::new([System.Drawing.ColorTranslator]::FromHtml('#F587A7'), 2)
    $g.DrawLine($penCursor, $startX + 188, $codeY + (8 * $lineH) + 2, $startX + 188, $codeY + (8 * $lineH) + $lineH - 2)

    # Bracket pair highlight line guide
    $penGuide = [System.Drawing.Pen]::new([System.Drawing.ColorTranslator]::FromHtml('#66344A'), 1)
    $g.DrawLine($penGuide, $startX + 14, $codeY + (13 * $lineH), $startX + 14, $codeY + (22 * $lineH))

    # Save Bitmap
    $bmp.Save($OutFile, [System.Drawing.Imaging.ImageFormat]::Png)

    $g.Dispose()
    $bmp.Dispose()
    Write-Host "Generated preview: $OutFile"
}

# 1. Generate Burgundy Pro Preview
$proPalette = @{
    bgMain = '#1A1015'
    bgEditor = '#160D12'
    bgSidebar = '#211319'
    bgActivityBar = '#190E13'
    bgTitleBar = '#24151C'
    bgStatusBar = '#702D45'
    bgStatusBarRemote = '#8E3757'
    bgActiveTab = '#321923'
    bgInactiveTab = '#211319'
    bgActiveLine = '#281820'
    bgSelection = '#58304495'
    border = '#432532'
    textMain = '#E8DCE1'
    textMuted = '#B09AA3'
    badgeBg = '#8A2D4F'
    listActiveSelectionBg = '#482434'
}

# 2. Generate Burgundy Soft Preview
$softPalette = @{
    bgMain = '#1D1419'
    bgEditor = '#1A1216'
    bgSidebar = '#22181E'
    bgActivityBar = '#1B1116'
    bgTitleBar = '#251A20'
    bgStatusBar = '#5E273A'
    bgStatusBarRemote = '#773049'
    bgActiveTab = '#2E1C25'
    bgInactiveTab = '#22181E'
    bgActiveLine = '#261A21'
    bgSelection = '#4E2A3B90'
    border = '#3B222D'
    textMain = '#E2D6DC'
    textMuted = '#A6929B'
    badgeBg = '#7A2846'
    listActiveSelectionBg = '#3F2230'
}

# Generate in both images/ and assets/
Render-ThemePreview -ThemeTitle "Theme" -VariantName "Burgundy Pro" -Palette $proPalette -OutFile (Join-Path (Get-Location) "images\preview-burgundy-pro.png")
Render-ThemePreview -ThemeTitle "Theme" -VariantName "Burgundy Soft" -Palette $softPalette -OutFile (Join-Path (Get-Location) "images\preview-burgundy-soft.png")

Render-ThemePreview -ThemeTitle "Theme" -VariantName "Burgundy Pro" -Palette $proPalette -OutFile (Join-Path (Get-Location) "assets\preview-burgundy-pro.png")
Render-ThemePreview -ThemeTitle "Theme" -VariantName "Burgundy Soft" -Palette $softPalette -OutFile (Join-Path (Get-Location) "assets\preview-burgundy-soft.png")
