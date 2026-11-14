Add-Type -AssemblyName System.Drawing

$width = 1280
$height = 360
$bmp = [System.Drawing.Bitmap]::new($width, $height)
$g = [System.Drawing.Graphics]::FromImage($bmp)
$g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
$g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::ClearTypeGridFit

# Background
$bgBrush = [System.Drawing.SolidBrush]::new([System.Drawing.ColorTranslator]::FromHtml('#160D12'))
$g.FillRectangle($bgBrush, 0, 0, $width, $height)

# Border
$borderPen = [System.Drawing.Pen]::new([System.Drawing.ColorTranslator]::FromHtml('#432532'), 2)
$g.DrawRectangle($borderPen, 1, 1, $width - 2, $height - 2)

$fontTitle = [System.Drawing.Font]::new([System.Drawing.FontFamily]::GenericSansSerif, 14, [System.Drawing.FontStyle]::Bold)
$fontSub = [System.Drawing.Font]::new([System.Drawing.FontFamily]::GenericSansSerif, 10, [System.Drawing.FontStyle]::Regular)
$fontColorName = [System.Drawing.Font]::new([System.Drawing.FontFamily]::GenericSansSerif, 9, [System.Drawing.FontStyle]::Bold)
$fontColorHex = [System.Drawing.Font]::new("Consolas", 8.5, [System.Drawing.FontStyle]::Regular)

$brushWhite = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::White)
$brushMuted = [System.Drawing.SolidBrush]::new([System.Drawing.ColorTranslator]::FromHtml('#B09AA3'))

$g.DrawString("BURGUNDY PRO COLOR SYSTEM", $fontTitle, $brushWhite, 40, 24)
$g.DrawString("Curated luxury dark palette engineered with WCAG AAA contrast and zero eye fatigue", $fontSub, $brushMuted, 40, 52)

# Swatches definition
$swatches = @(
    @{ Name = "Main BG"; Hex = "#1A1015"; TextLight = $true },
    @{ Name = "Editor BG"; Hex = "#160D12"; TextLight = $true },
    @{ Name = "Sidebar"; Hex = "#211319"; TextLight = $true },
    @{ Name = "Status Bar"; Hex = "#702D45"; TextLight = $true },
    @{ Name = "Active Tab"; Hex = "#321923"; TextLight = $true },
    @{ Name = "Selection"; Hex = "#583044"; TextLight = $true },
    @{ Name = "Border"; Hex = "#432532"; TextLight = $true },
    @{ Name = "Keywords"; Hex = "#E5A0B0"; TextLight = $false },
    @{ Name = "Functions"; Hex = "#E8B47A"; TextLight = $false },
    @{ Name = "Strings"; Hex = "#C5D6A5"; TextLight = $false },
    @{ Name = "Numbers"; Hex = "#D7A6E0"; TextLight = $false },
    @{ Name = "Types"; Hex = "#D9A1B5"; TextLight = $false },
    @{ Name = "Constants"; Hex = "#E5C18A"; TextLight = $false },
    @{ Name = "Comments"; Hex = "#88717B"; TextLight = $true }
)

$swatchW = 78
$swatchH = 140
$spacing = 10
$startX = 40
$startY = 96

for ($i = 0; $i -lt $swatches.Count; $i++) {
    $sw = $swatches[$i]
    $x = $startX + ($i * ($swatchW + $spacing))
    $rect = [System.Drawing.Rectangle]::new($x, $startY, $swatchW, $swatchH)
    
    # Rounded card
    $path = [System.Drawing.Drawing2D.GraphicsPath]::new()
    $rad = 8
    $d = $rad * 2
    $path.AddArc($rect.X, $rect.Y, $d, $d, 180, 90)
    $path.AddArc($rect.Right - $d, $rect.Y, $d, $d, 270, 90)
    $path.AddArc($rect.Right - $d, $rect.Bottom - $d, $d, $d, 0, 90)
    $path.AddArc($rect.X, $rect.Bottom - $d, $d, $d, 90, 90)
    $path.CloseFigure()

    $swBrush = [System.Drawing.SolidBrush]::new([System.Drawing.ColorTranslator]::FromHtml($sw.Hex))
    $g.FillPath($swBrush, $path)

    $cardPen = [System.Drawing.Pen]::new([System.Drawing.ColorTranslator]::FromHtml('#432532'), 1)
    $g.DrawPath($cardPen, $path)

    # Text inside or below
    $textBrush = if ($sw.TextLight) { $brushWhite } else { [System.Drawing.SolidBrush]::new([System.Drawing.Color]::Black) }
    $g.DrawString($sw.Name, $fontColorName, $textBrush, $x + 6, $startY + 12)
    $g.DrawString($sw.Hex, $fontColorHex, $textBrush, $x + 6, $startY + 32)
}

# Footer stats
$g.DrawString("Contrast: 14.32:1 (AAA)   |   Tokens: 238 Workbench Keys   |   Language Support: 20+ Languages   |   Variants: Pro & Soft", $fontSub, $brushMuted, 40, 260)

$outPath1 = Join-Path (Get-Location) "images\color-palette.png"
$bmp.Save($outPath1, [System.Drawing.Imaging.ImageFormat]::Png)

$outPath2 = Join-Path (Get-Location) "assets\color-palette.png"
$bmp.Save($outPath2, [System.Drawing.Imaging.ImageFormat]::Png)

$g.Dispose()
$bmp.Dispose()
Write-Host "Generated: $outPath1 and $outPath2"
