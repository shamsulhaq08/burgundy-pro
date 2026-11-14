Add-Type -AssemblyName System.Drawing

$width = 128
$height = 128
$bmp = [System.Drawing.Bitmap]::new($width, $height)
$g = [System.Drawing.Graphics]::FromImage($bmp)
$g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
$g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
$g.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality

# Clear with transparent
$g.Clear([System.Drawing.Color]::Transparent)

# Background squircle path
$rect = [System.Drawing.Rectangle]::new(4, 4, 120, 120)
$radius = 28
$path = [System.Drawing.Drawing2D.GraphicsPath]::new()
$d = $radius * 2
$path.AddArc($rect.X, $rect.Y, $d, $d, 180, 90)
$path.AddArc($rect.Right - $d, $rect.Y, $d, $d, 270, 90)
$path.AddArc($rect.Right - $d, $rect.Bottom - $d, $d, $d, 0, 90)
$path.AddArc($rect.X, $rect.Bottom - $d, $d, $d, 90, 90)
$path.CloseFigure()

# Background Gradient
$pt1 = [System.Drawing.Point]::new(0, 0)
$pt2 = [System.Drawing.Point]::new(128, 128)
$cTop = [System.Drawing.Color]::FromArgb(255, 48, 18, 33)
$cBottom = [System.Drawing.Color]::FromArgb(255, 18, 8, 14)
$bgBrush = [System.Drawing.Drawing2D.LinearGradientBrush]::new($pt1, $pt2, $cTop, $cBottom)
$g.FillPath($bgBrush, $path)

# Subtle Radial / Center Glow
$glowPath = [System.Drawing.Drawing2D.GraphicsPath]::new()
$glowPath.AddEllipse(16, 12, 96, 80)
$pbg = [System.Drawing.Drawing2D.PathGradientBrush]::new($glowPath)
$pbg.CenterColor = [System.Drawing.Color]::FromArgb(160, 150, 45, 85)
$pbg.SurroundColors = @([System.Drawing.Color]::FromArgb(0, 150, 45, 85))
$g.FillPath($pbg, $path)

# Border pen
$borderPen = [System.Drawing.Pen]::new([System.Drawing.Color]::FromArgb(220, 212, 93, 134), 2.5)
$g.DrawPath($borderPen, $path)

# Inner accent border
$innerPath = [System.Drawing.Drawing2D.GraphicsPath]::new()
$inRect = [System.Drawing.Rectangle]::new(7, 7, 114, 114)
$inRadius = 24
$inD = $inRadius * 2
$innerPath.AddArc($inRect.X, $inRect.Y, $inD, $inD, 180, 90)
$innerPath.AddArc($inRect.Right - $inD, $inRect.Y, $inD, $inD, 270, 90)
$innerPath.AddArc($inRect.Right - $inD, $inRect.Bottom - $inD, $inD, $inD, 0, 90)
$innerPath.AddArc($inRect.X, $inRect.Bottom - $inD, $inD, $inD, 90, 90)
$innerPath.CloseFigure()
$innerPen = [System.Drawing.Pen]::new([System.Drawing.Color]::FromArgb(50, 245, 135, 167), 1.0)
$g.DrawPath($innerPen, $innerPath)

# Bracket Pen (Rose Gold / Blush)
$bracketPen = [System.Drawing.Pen]::new([System.Drawing.Color]::FromArgb(255, 232, 180, 122), 5.5)
$bracketPen.StartCap = [System.Drawing.Drawing2D.LineCap]::Round
$bracketPen.EndCap = [System.Drawing.Drawing2D.LineCap]::Round
$bracketPen.LineJoin = [System.Drawing.Drawing2D.LineJoin]::Round

# Draw Left Bracket <
$leftPts = [System.Drawing.Point[]]@(
    [System.Drawing.Point]::new(43, 44),
    [System.Drawing.Point]::new(28, 64),
    [System.Drawing.Point]::new(43, 84)
)
$g.DrawLines($bracketPen, $leftPts)

# Draw Right Bracket >
$rightPts = [System.Drawing.Point[]]@(
    [System.Drawing.Point]::new(85, 44),
    [System.Drawing.Point]::new(100, 64),
    [System.Drawing.Point]::new(85, 84)
)
$g.DrawLines($bracketPen, $rightPts)

# Central Slash / Dev Slash
$slashPen = [System.Drawing.Pen]::new([System.Drawing.Color]::FromArgb(255, 229, 139, 162), 4.5)
$slashPen.StartCap = [System.Drawing.Drawing2D.LineCap]::Round
$slashPen.EndCap = [System.Drawing.Drawing2D.LineCap]::Round
$g.DrawLine($slashPen, 72, 42, 56, 86)

# Central Diamond Core
$diamondPts = [System.Drawing.Point[]]@(
    [System.Drawing.Point]::new(64, 55),
    [System.Drawing.Point]::new(72, 64),
    [System.Drawing.Point]::new(64, 73),
    [System.Drawing.Point]::new(56, 64)
)
$diamondBrush = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::FromArgb(240, 245, 163, 183))
$g.FillPolygon($diamondBrush, $diamondPts)

# Center highlight dot
$dotBrush = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::FromArgb(255, 255, 255, 255))
$g.FillEllipse($dotBrush, 62, 62, 4, 4)

$outPath = Join-Path (Get-Location) "assets\icon.png"
$bmp.Save($outPath, [System.Drawing.Imaging.ImageFormat]::Png)

$g.Dispose()
$bmp.Dispose()
Write-Host "Generated: $outPath successfully"
