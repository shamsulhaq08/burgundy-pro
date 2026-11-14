Add-Type -AssemblyName System.IO.Compression
Add-Type -AssemblyName System.IO.Compression.FileSystem

$outVsix = Join-Path (Get-Location) "burgundy-pro-visual-studio.vsix"
if (Test-Path $outVsix) {
    Remove-Item $outVsix -Force
}

$zipStream = [System.IO.File]::Create($outVsix)
$archive = [System.IO.Compression.ZipArchive]::new($zipStream, [System.IO.Compression.ZipArchiveMode]::Create)

$sourceDir = Join-Path (Get-Location) "visual-studio-ide"

# Sort so that [Content_Types].xml comes first (standard OPC best practice)
$files = Get-ChildItem -Path $sourceDir -Recurse -File | Sort-Object -Property @{
    Expression = { if ($_.Name -eq "[Content_Types].xml") { 0 } else { 1 } }
}

foreach ($f in $files) {
    # CRITICAL: Path in VSIX/OPC MUST use forward slashes '/', NEVER backslashes '\'
    $relPath = $f.FullName.Substring($sourceDir.Length + 1).Replace('\', '/')
    Write-Host "Adding: $relPath ($($f.Length) bytes)"
    
    $entry = $archive.CreateEntry($relPath, [System.IO.Compression.CompressionLevel]::Optimal)
    $entryStream = $entry.Open()
    $fileStream = [System.IO.File]::OpenRead($f.FullName)
    $fileStream.CopyTo($entryStream)
    $fileStream.Dispose()
    $entryStream.Dispose()
}

$archive.Dispose()
$zipStream.Dispose()

Write-Host "VSIX Package created successfully: $outVsix"
