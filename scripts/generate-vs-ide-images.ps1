Add-Type -AssemblyName System.Drawing

function Render-VisualStudioPreview {
    param (
        [string]$VariantTitle,
        [string]$ActiveFile,
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
    $fontMenu = [System.Drawing.Font]::new($fontFamily, 9, [System.Drawing.FontStyle]::Regular)
    $fontTitle = [System.Drawing.Font]::new($fontFamily, 9.5, [System.Drawing.FontStyle]::Regular)
    $fontTab = [System.Drawing.Font]::new($fontFamily, 9.5, [System.Drawing.FontStyle]::Regular)
    $fontCode = [System.Drawing.Font]::new("Consolas", 11, [System.Drawing.FontStyle]::Regular)
    $fontCodeBold = [System.Drawing.Font]::new("Consolas", 11, [System.Drawing.FontStyle]::Bold)
    $fontCodeItalic = [System.Drawing.Font]::new("Consolas", 11, [System.Drawing.FontStyle]::Italic)
    $fontTree = [System.Drawing.Font]::new($fontFamily, 9, [System.Drawing.FontStyle]::Regular)
    $fontTreeBold = [System.Drawing.Font]::new($fontFamily, 9, [System.Drawing.FontStyle]::Bold)
    $fontStatus = [System.Drawing.Font]::new($fontFamily, 9, [System.Drawing.FontStyle]::Regular)

    # Brushes & Pens
    $brushMain = [System.Drawing.SolidBrush]::new([System.Drawing.ColorTranslator]::FromHtml($Palette.bgMain))
    $brushTitle = [System.Drawing.SolidBrush]::new([System.Drawing.ColorTranslator]::FromHtml($Palette.bgTitle))
    $brushToolbar = [System.Drawing.SolidBrush]::new([System.Drawing.ColorTranslator]::FromHtml($Palette.bgToolbar))
    $brushSide = [System.Drawing.SolidBrush]::new([System.Drawing.ColorTranslator]::FromHtml($Palette.bgSide))
    $brushStatus = [System.Drawing.SolidBrush]::new([System.Drawing.ColorTranslator]::FromHtml($Palette.bgStatus))
    $brushTabActive = [System.Drawing.SolidBrush]::new([System.Drawing.ColorTranslator]::FromHtml($Palette.tabActive))
    $brushTabInactive = [System.Drawing.SolidBrush]::new([System.Drawing.ColorTranslator]::FromHtml($Palette.tabInactive))
    $brushAccent = [System.Drawing.SolidBrush]::new([System.Drawing.ColorTranslator]::FromHtml($Palette.accent))
    $penBorder = [System.Drawing.Pen]::new([System.Drawing.ColorTranslator]::FromHtml($Palette.border), 1)
    $brushText = [System.Drawing.SolidBrush]::new([System.Drawing.ColorTranslator]::FromHtml($Palette.text))
    $brushMuted = [System.Drawing.SolidBrush]::new([System.Drawing.ColorTranslator]::FromHtml($Palette.textMuted))
    $brushWhite = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::White)

    # 1. Base Background
    $g.FillRectangle($brushMain, 0, 0, $width, $height)

    # 2. Visual Studio Title Bar (Height: 34px)
    $titleH = 34
    $g.FillRectangle($brushTitle, 0, 0, $width, $titleH)
    $g.DrawLine($penBorder, 0, $titleH, $width, $titleH)

    # VS Icon (Stylized ribbon on left)
    $vsRibbonPen = [System.Drawing.Pen]::new([System.Drawing.Color]::FromArgb(255, 196, 77, 118), 2.5)
    $g.DrawLine($vsRibbonPen, 14, 11, 26, 23)
    $g.DrawLine($vsRibbonPen, 26, 11, 14, 23)

    # Menu items
    $menus = @("File", "Edit", "View", "Git", "Project", "Build", "Debug", "Test", "Analyze", "Tools", "Extensions", "Window", "Help")
    $menuX = 38
    foreach ($m in $menus) {
        $g.DrawString($m, $fontMenu, $brushText, $menuX, 9)
        $mSize = $g.MeasureString($m, $fontMenu)
        $menuX += [int]$mSize.Width + 14
    }

    # Center Title text: Visual Studio 2022
    $titleStr = "BurgundyApp - Microsoft Visual Studio (Administrator) [$VariantTitle]"
    $titleSize = $g.MeasureString($titleStr, $fontTitle)
    $g.DrawString($titleStr, $fontTitle, $brushMuted, [int](($width - $titleSize.Width) / 2), 8)

    # Right Window Controls
    $g.DrawString("shamsulhaq08", $fontMenu, $brushAccent, $width - 170, 9)
    $g.DrawString("—", $fontMenu, $brushText, $width - 70, 9)
    $g.DrawString("□", $fontMenu, $brushText, $width - 45, 9)
    $g.DrawString("✕", $fontMenu, $brushText, $width - 20, 9)

    # 3. Standard Toolbar (Height: 36px)
    $tbY = $titleH + 1
    $tbH = 36
    $g.FillRectangle($brushToolbar, 0, $tbY, $width, $tbH)
    $g.DrawLine($penBorder, 0, $tbY + $tbH, $width, $tbY + $tbH)

    # Toolbar items: Run button ▶ BurgundyApp
    $runBrush = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::FromArgb(255, 60, 180, 100))
    $g.FillPolygon($runBrush, [System.Drawing.Point[]]@(
        [System.Drawing.Point]::new(16, $tbY + 11),
        [System.Drawing.Point]::new(26, $tbY + 18),
        [System.Drawing.Point]::new(16, $tbY + 25)
    ))
    $fontRun = [System.Drawing.Font]::new($fontFamily, 9, [System.Drawing.FontStyle]::Bold)
    $g.DrawString("BurgundyApp", $fontRun, $brushWhite, 32, $tbY + 10)
    $g.DrawString("(Debug | Any CPU)", $fontMenu, $brushMuted, 120, $tbY + 10)

    # Standard icons on toolbar
    $tbIcons = "🖫   🖪   ↩   ↪   🔍   💬   ⚙"
    $g.DrawString($tbIcons, $fontMenu, $brushText, 260, $tbY + 10)

    # Search Bar (Ctrl+Q)
    $searchRect = [System.Drawing.Rectangle]::new($width - 290, $tbY + 6, 260, 24)
    $searchBrush = [System.Drawing.SolidBrush]::new([System.Drawing.ColorTranslator]::FromHtml($Palette.bgMain))
    $g.FillRectangle($searchBrush, $searchRect)
    $g.DrawRectangle($penBorder, $searchRect)
    $g.DrawString("🔍 Search (Ctrl+Q)", $fontMenu, $brushMuted, $width - 282, $tbY + 10)

    # 4. Status Bar (Bottom 26px)
    $statusH = 26
    $statusY = $height - $statusH
    $g.FillRectangle($brushStatus, 0, $statusY, $width, $statusH)
    $g.DrawLine($penBorder, 0, $statusY, $width, $statusY)

    $g.DrawString("Ready", $fontStatus, $brushWhite, 16, $statusY + 5)
    $statusRight = "📍 main*   0 errors, 0 warnings   Ln 24, Col 18   Ch 18   SPC   CRLF   UTF-8   Visual Studio 2022 ($VariantTitle)"
    $srSize = $g.MeasureString($statusRight, $fontStatus)
    $g.DrawString($statusRight, $fontStatus, $brushWhite, $width - $srSize.Width - 16, $statusY + 5)

    # 5. Bottom Dock Window: Output / Error List (Height: 110px)
    $dockH = 110
    $dockY = $statusY - $dockH
    $g.FillRectangle($brushSide, 0, $dockY, $width, $dockH)
    $g.DrawLine($penBorder, 0, $dockY, $width, $dockY)

    # Dock Header Tabs
    $dockTabs = @("Error List", "Output", "Terminal", "Git Changes")
    $dtX = 16
    foreach ($dt in $dockTabs) {
        $color = if ($dt -eq "Output") { $brushWhite } else { $brushMuted }
        $g.DrawString($dt, $fontMenu, $color, $dtX, $dockY + 6)
        if ($dt -eq "Output") {
            $g.FillRectangle($brushAccent, $dtX, $dockY + 24, 46, 2)
        }
        $dtX += 90
    }
    $g.DrawLine($penBorder, 0, $dockY + 26, $width, $dockY + 26)

    # Output log content
    $fontOutput = [System.Drawing.Font]::new("Consolas", 9.5, [System.Drawing.FontStyle]::Regular)
    $g.DrawString("------ Build started: Project: BurgundyApp, Configuration: Debug Any CPU ------", $fontOutput, $brushMuted, 16, $dockY + 34)
    $g.DrawString("BurgundyApp -> bin\Debug\net8.0\BurgundyApp.dll", $fontOutput, $brushText, 16, $dockY + 54)
    $brushSuccess = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::FromArgb(255, 120, 200, 130))
    $g.DrawString("========== Build: 1 succeeded, 0 failed, 0 up-to-date, 0 skipped ==========", $fontOutput, $brushSuccess, 16, $dockY + 74)

    # 6. Main Body: Split into Code Editor (Left) & Solution Explorer (Right)
    $bodyY = $tbY + $tbH + 1
    $bodyH = $dockY - $bodyY
    $sideW = 320
    $editorW = $width - $sideW

    # Vertical divider between Editor and Solution Explorer
    $g.DrawLine($penBorder, $editorW, $bodyY, $editorW, $dockY)

    # ------------------ Solution Explorer (Right Dock) ------------------
    $g.FillRectangle($brushSide, $editorW, $bodyY, $sideW, $bodyH)

    # Solution Explorer Header (Height: 30px)
    $seHeaderH = 30
    $g.DrawString("Solution Explorer", $fontTreeBold, $brushWhite, $editorW + 12, $bodyY + 7)
    $g.DrawString("🔄   ⊟   📄   ⚙", $fontTree, $brushMuted, $width - 90, $bodyY + 7)
    $g.DrawLine($penBorder, $editorW, $bodyY + $seHeaderH, $width, $bodyY + $seHeaderH)

    # Search Solution Explorer
    $seSearchY = $bodyY + $seHeaderH + 4
    $g.FillRectangle($brushMain, $editorW + 8, $seSearchY, $sideW - 16, 22)
    $g.DrawRectangle($penBorder, $editorW + 8, $seSearchY, $sideW - 16, 22)
    $g.DrawString("🔍 Search Solution Explorer (Ctrl+;)", $fontMenu, $brushMuted, $editorW + 14, $seSearchY + 3)

    # Solution Tree Items
    $treeY = $seSearchY + 30
    $treeItems = @(
        @{ Text = "Solution 'BurgundyApp' (1 of 1 project)"; Level = 0; Icon = "🗎"; Bold = $true },
        @{ Text = "BurgundyApp"; Level = 1; Icon = "📦"; Bold = $true },
        @{ Text = "Connected Services"; Level = 2; Icon = "⚙"; Bold = $false },
        @{ Text = "Properties"; Level = 2; Icon = "📁"; Bold = $false },
        @{ Text = "Dependencies"; Level = 2; Icon = "📚"; Bold = $false },
        @{ Text = "Controllers"; Level = 2; Icon = "📁"; Bold = $false },
        @{ Text = "BurgundyController.cs"; Level = 3; Icon = "#"; Bold = ($ActiveFile -eq "BurgundyController.cs") },
        @{ Text = "Services"; Level = 2; Icon = "📁"; Bold = $false },
        @{ Text = "BurgundyService.cs"; Level = 3; Icon = "#"; Bold = ($ActiveFile -eq "BurgundyService.cs") },
        @{ Text = "Program.cs"; Level = 2; Icon = "#"; Bold = ($ActiveFile -eq "Program.cs") },
        @{ Text = "appsettings.json"; Level = 2; Icon = "{ }"; Bold = $false }
    )

    foreach ($item in $treeItems) {
        $indent = $editorW + 14 + ($item.Level * 16)
        if ($item.Bold) {
            # Highlight active tree item
            $g.FillRectangle([System.Drawing.SolidBrush]::new([System.Drawing.ColorTranslator]::FromHtml($Palette.treeActive)), $editorW, $treeY - 2, $sideW, 20)
        }
        $fTree = if ($item.Bold) { $fontTreeBold } else { $fontTree }
        $cTree = if ($item.Bold) { $brushWhite } else { $brushText }
        $g.DrawString($item.Icon, $fontTree, $brushAccent, $indent, $treeY)
        $g.DrawString($item.Text, $fTree, $cTree, $indent + 20, $treeY)
        $treeY += 21
    }

    # ------------------ Code Editor Canvas (Left) ------------------
    # Editor Tab Well (Height: 32px)
    $tabH = 32
    $g.FillRectangle($brushToolbar, 0, $bodyY, $editorW, $tabH)
    $g.DrawLine($penBorder, 0, $bodyY + $tabH, $editorW, $bodyY + $tabH)

    $tabs = @("Program.cs", "BurgundyController.cs", "BurgundyService.cs", "appsettings.json")
    $tabX = 0
    foreach ($tab in $tabs) {
        $isActive = ($tab -eq $ActiveFile)
        $tabWidth = 160
        $tBrush = if ($isActive) { $brushTabActive } else { $brushTabInactive }
        $g.FillRectangle($tBrush, $tabX, $bodyY, $tabWidth, $tabH)
        $g.DrawLine($penBorder, $tabX + $tabWidth, $bodyY, $tabX + $tabWidth, $bodyY + $tabH)

        if ($isActive) {
            # Top accent bar on active tab
            $g.FillRectangle($brushAccent, $tabX, $bodyY, $tabWidth, 3)
            $g.DrawString("C#", $fontMenu, $brushAccent, $tabX + 12, $bodyY + 8)
            $g.DrawString($tab, $fontTab, $brushWhite, $tabX + 34, $bodyY + 7)
            $g.DrawString("✕", $fontMenu, $brushMuted, $tabX + $tabWidth - 18, $bodyY + 8)
        } else {
            $g.DrawString("C#", $fontMenu, $brushMuted, $tabX + 12, $bodyY + 8)
            $g.DrawString($tab, $fontTab, $brushMuted, $tabX + 34, $bodyY + 7)
            $g.DrawString("✕", $fontMenu, $brushMuted, $tabX + $tabWidth - 18, $bodyY + 8)
        }
        $tabX += $tabWidth
    }

    # Breadcrumb bar (Height: 22px)
    $bcY = $bodyY + $tabH + 1
    $bcH = 22
    $g.FillRectangle($brushMain, 0, $bcY, $editorW, $bcH)
    $g.DrawLine($penBorder, 0, $bcY + $bcH, $editorW, $bcY + $bcH)
    $bcText = "BurgundyApp  >  Controllers  >  BurgundyController  >  GetThemePalette()"
    $g.DrawString($bcText, $fontMenu, $brushMuted, 16, $bcY + 3)

    # Editor Text Surface
    $edY = $bcY + $bcH + 1
    $edH = $dockY - $edY
    $g.FillRectangle($brushMain, 0, $edY, $editorW, $edH)

    # Line Number Margin (Width: 50px)
    $marginW = 50
    $brushMargin = [System.Drawing.SolidBrush]::new([System.Drawing.ColorTranslator]::FromHtml($Palette.bgMain))
    $g.FillRectangle($brushMargin, 0, $edY, $marginW, $edH)
    $g.DrawLine($penBorder, $marginW, $edY, $marginW, $dockY)

    # Syntax Brushes
    $cKeyword = [System.Drawing.SolidBrush]::new([System.Drawing.ColorTranslator]::FromHtml('#E5A0B0'))
    $cControl = [System.Drawing.SolidBrush]::new([System.Drawing.ColorTranslator]::FromHtml('#C44D76'))
    $cComment = [System.Drawing.SolidBrush]::new([System.Drawing.ColorTranslator]::FromHtml('#9D858D'))
    $cString = [System.Drawing.SolidBrush]::new([System.Drawing.ColorTranslator]::FromHtml('#E8A87C'))
    $cNumber = [System.Drawing.SolidBrush]::new([System.Drawing.ColorTranslator]::FromHtml('#DDAA88'))
    $cType = [System.Drawing.SolidBrush]::new([System.Drawing.ColorTranslator]::FromHtml('#F0C2CC'))
    $cInterface = [System.Drawing.SolidBrush]::new([System.Drawing.ColorTranslator]::FromHtml('#E5C18A'))
    $cMethod = [System.Drawing.SolidBrush]::new([System.Drawing.ColorTranslator]::FromHtml('#C5D6A5'))
    $cParam = [System.Drawing.SolidBrush]::new([System.Drawing.ColorTranslator]::FromHtml('#D9A1B5'))
    $cProp = [System.Drawing.SolidBrush]::new([System.Drawing.ColorTranslator]::FromHtml('#F3C5D4'))
    $cOp = [System.Drawing.SolidBrush]::new([System.Drawing.ColorTranslator]::FromHtml('#D7A6E0'))
    $cLineNum = [System.Drawing.SolidBrush]::new([System.Drawing.ColorTranslator]::FromHtml($Palette.lineNumber))

    # C# Code Lines
    $lines = @(
        @{ Num = "1"; Tokens = @(
            @{ T = "// Burgundy Pro Dark Theme for Visual Studio 2022 / 2019"; B = $cComment }
        )},
        @{ Num = "2"; Tokens = @(
            @{ T = "using "; B = $cKeyword },
            @{ T = "System"; B = $cType },
            @{ T = ";"; B = $brushText }
        )},
        @{ Num = "3"; Tokens = @(
            @{ T = "using "; B = $cKeyword },
            @{ T = "Microsoft.AspNetCore.Mvc"; B = $cType },
            @{ T = ";"; B = $brushText }
        )},
        @{ Num = "4"; Tokens = @(
            @{ T = "using "; B = $cKeyword },
            @{ T = "Burgundy.Pro.Core"; B = $cType },
            @{ T = ";"; B = $brushText }
        )},
        @{ Num = "5"; Tokens = @() },
        @{ Num = "6"; Tokens = @(
            @{ T = "namespace "; B = $cControl },
            @{ T = "BurgundyApp.Controllers"; B = $cType },
            @{ T = ";"; B = $brushText }
        )},
        @{ Num = "7"; Tokens = @() },
        @{ Num = "8"; Tokens = @(
            @{ T = "["; B = $brushText },
            @{ T = "ApiController"; B = $cType },
            @{ T = "]"; B = $brushText }
        )},
        @{ Num = "9"; Tokens = @(
            @{ T = "["; B = $brushText },
            @{ T = "Route"; B = $cType },
            @{ T = '("'; B = $brushText },
            @{ T = 'api/[controller]'; B = $cString },
            @{ T = '")]'; B = $brushText }
        )},
        @{ Num = "10"; Tokens = @(
            @{ T = "public class "; B = $cKeyword },
            @{ T = "BurgundyController"; B = $cType },
            @{ T = " : "; B = $cOp },
            @{ T = "ControllerBase"; B = $cType }
        )},
        @{ Num = "11"; Tokens = @(
            @{ T = "{"; B = $brushText }
        )},
        @{ Num = "12"; Tokens = @(
            @{ T = "    private readonly "; B = $cKeyword },
            @{ T = "IBurgundyThemeEngine "; B = $cInterface },
            @{ T = "_themeEngine;"; B = $cProp }
        )},
        @{ Num = "13"; Tokens = @() },
        @{ Num = "14"; Tokens = @(
            @{ T = "    public "; B = $cKeyword },
            @{ T = "BurgundyController"; B = $cMethod },
            @{ T = "("; B = $brushText },
            @{ T = "IBurgundyThemeEngine "; B = $cInterface },
            @{ T = "engine"; B = $cParam },
            @{ T = ")"; B = $brushText }
        )},
        @{ Num = "15"; Tokens = @(
            @{ T = "    {"; B = $brushText }
        )},
        @{ Num = "16"; Tokens = @(
            @{ T = "        _themeEngine = engine ?? throw new "; B = $cKeyword },
            @{ T = "ArgumentNullException"; B = $cType },
            @{ T = "(nameof(engine));"; B = $brushText }
        )},
        @{ Num = "17"; Tokens = @(
            @{ T = "    }"; B = $brushText }
        )},
        @{ Num = "18"; Tokens = @() },
        @{ Num = "19"; Tokens = @(
            @{ T = "    ["; B = $brushText },
            @{ T = "HttpGet"; B = $cType },
            @{ T = '("'; B = $brushText },
            @{ T = 'palette'; B = $cString },
            @{ T = '")]'; B = $brushText }
        )},
        @{ Num = "20"; Tokens = @(
            @{ T = "    public async "; B = $cKeyword },
            @{ T = "Task"; B = $cType },
            @{ T = "<"; B = $cOp },
            @{ T = "IActionResult"; B = $cType },
            @{ T = "> "; B = $cOp },
            @{ T = "GetThemePalette"; B = $cMethod },
            @{ T = "()"; B = $brushText }
        )},
        @{ Num = "21"; Tokens = @(
            @{ T = "    {"; B = $brushText }
        )},
        @{ Num = "22"; Tokens = @(
            @{ T = "        var "; B = $cKeyword },
            @{ T = "palette = await _themeEngine."; B = $brushText },
            @{ T = "LoadPaletteAsync"; B = $cMethod },
            @{ T = '("'; B = $brushText },
            @{ T = $VariantTitle; B = $cString },
            @{ T = '");'; B = $brushText }
        )},
        @{ Num = "23"; Tokens = @(
            @{ T = "        return "; B = $cControl },
            @{ T = "Ok"; B = $cMethod },
            @{ T = "(palette);"; B = $brushText }
        )},
        @{ Num = "24"; Tokens = @(
            @{ T = "    }"; B = $brushText }
        )},
        @{ Num = "25"; Tokens = @(
            @{ T = "}"; B = $brushText }
        )}
    )

    $lineY = $edY + 10
    foreach ($line in $lines) {
        # Current Line Highlight on line 22
        if ($line.Num -eq "22") {
            $g.FillRectangle([System.Drawing.SolidBrush]::new([System.Drawing.ColorTranslator]::FromHtml($Palette.lineHighlight)), $marginW + 1, $lineY - 2, $editorW - $marginW - 1, 22)
            $cNum = $brushAccent
        } else {
            $cNum = $cLineNum
        }

        # Draw line number
        $numSize = $g.MeasureString($line.Num, $fontCode)
        $g.DrawString($line.Num, $fontCode, $cNum, $marginW - $numSize.Width - 10, $lineY)

        # Draw code tokens
        $tokenX = $marginW + 16
        foreach ($tok in $line.Tokens) {
            $g.DrawString($tok.T, $fontCode, $tok.B, $tokenX, $lineY)
            $tokSize = $g.MeasureString($tok.T, $fontCode)
            $tokenX += [int]($tokSize.Width - 6)
        }

        $lineY += 21
    }

    # Save to disk
    $bmp.Save($OutFile, [System.Drawing.Imaging.ImageFormat]::Png)
    $g.Dispose()
    $bmp.Dispose()
    Write-Host "Generated: $OutFile"
}

# Output directories
$outDir = Join-Path (Get-Location) "visual-studio-ide\images"
if (-not (Test-Path $outDir)) {
    New-Item -ItemType Directory -Force -Path $outDir | Out-Null
}

# 1. Render Visual Studio Burgundy Pro Preview
Render-VisualStudioPreview -VariantTitle "Burgundy Pro" -ActiveFile "BurgundyController.cs" -Palette @{
    bgMain = "#160D12"
    bgTitle = "#24151C"
    bgToolbar = "#24151C"
    bgSide = "#211319"
    bgStatus = "#702D45"
    tabActive = "#321923"
    tabInactive = "#211319"
    accent = "#C44D76"
    border = "#432532"
    text = "#E8DCE1"
    textMuted = "#B09AA3"
    lineNumber = "#6B4D5B"
    lineHighlight = "#281820"
    treeActive = "#482434"
} -OutFile (Join-Path $outDir "preview-burgundy-pro.png")

# 2. Render Visual Studio Burgundy Soft Preview
Render-VisualStudioPreview -VariantTitle "Burgundy Soft" -ActiveFile "BurgundyService.cs" -Palette @{
    bgMain = "#1A1216"
    bgTitle = "#251920"
    bgToolbar = "#251920"
    bgSide = "#21161D"
    bgStatus = "#5E273A"
    tabActive = "#2F1E27"
    tabInactive = "#21161D"
    accent = "#B0476C"
    border = "#3D2833"
    text = "#E4DAE0"
    textMuted = "#A8949E"
    lineNumber = "#6E5562"
    lineHighlight = "#2A1C23"
    treeActive = "#422432"
} -OutFile (Join-Path $outDir "preview-burgundy-soft.png")
