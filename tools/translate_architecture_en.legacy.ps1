# Disabled after the repository was split into `fa/` and `en/` trees.
# This legacy script writes translated files into a broad `en/` directory and
# can overwrite maintained English lessons if run against the new layout.
throw 'This legacy translator is disabled for the bilingual repository layout. Edit the paired lesson under fa/ or en/ directly.'

$ErrorActionPreference = 'Stop'
$root = (Get-Location).Path
$destination = Join-Path $root 'en'

function Invoke-Translation([string]$text) {
  if ([string]::IsNullOrWhiteSpace($text)) { return $text }
  $encoded = [uri]::EscapeDataString($text)
  $uri = 'https://translate.googleapis.com/translate_a/single?client=gtx&sl=fa&tl=en&dt=t&q=' + $encoded
  $attempt = 0
  while ($true) {
    try {
      $response = Invoke-RestMethod -Uri $uri -Method Get -TimeoutSec 45
      return (($response[0] | ForEach-Object { [string]$_[0] }) -join '')
    } catch {
      $attempt++
      if ($attempt -ge 5) { throw "Translation failed after retries: $($_.Exception.Message)" }
      Start-Sleep -Seconds ([Math]::Min(2 * $attempt, 10))
    }
  }
}

function Translate-Prose([string]$text) {
  if ([string]::IsNullOrEmpty($text)) { return $text }
  $saved = [System.Collections.Generic.List[string]]::new()
  $tick = [char]96
  $inlineCode = $tick.ToString() + '[^' + $tick + ']+' + $tick.ToString()
  $pattern = '(?<=\]\()[^)]+(?=\))|' + $inlineCode + '|https?://[^\s)\]]+|</?[^>]+>'
  $protected = [regex]::Replace($text, $pattern, [System.Text.RegularExpressions.MatchEvaluator]{
    param($match)
    $key = 'ZXQKEEP{0}QXZ' -f $saved.Count
    $saved.Add($match.Value)
    return $key
  })
  $parts = [System.Collections.Generic.List[string]]::new()
  $buffer = ''
  foreach ($line in [regex]::Split($protected, '(?<=\n)')) {
    if ($buffer.Length -gt 0 -and ($buffer.Length + $line.Length) -gt 2800) {
      $parts.Add((Invoke-Translation $buffer))
      $buffer = ''
    }
    if ($line.Length -gt 2800) {
      if ($buffer.Length -gt 0) { $parts.Add((Invoke-Translation $buffer)); $buffer = '' }
      for ($offset = 0; $offset -lt $line.Length; $offset += 2400) {
        $length = [Math]::Min(2400, $line.Length - $offset)
        $parts.Add((Invoke-Translation $line.Substring($offset, $length)))
      }
    } else { $buffer += $line }
  }
  if ($buffer.Length -gt 0) { $parts.Add((Invoke-Translation $buffer)) }
  $translated = $parts -join ''
  for ($i = $saved.Count - 1; $i -ge 0; $i--) {
    $key = 'ZXQKEEP{0}QXZ' -f $i
    $translated = $translated.Replace($key, $saved[$i])
  }
  return $translated
}

$files = Get-ChildItem -LiteralPath $root -Recurse -File -Filter '*.md' | Where-Object { $_.FullName -notlike "$destination*" }
$total = $files.Count
$index = 0
$fence = ([char]96).ToString() * 3
foreach ($file in $files) {
  $index++
  $relative = $file.FullName.Substring($root.Length + 1)
  $outPath = Join-Path $destination $relative
  $outDir = Split-Path -Parent $outPath
  [System.IO.Directory]::CreateDirectory($outDir) | Out-Null
  $raw = [System.IO.File]::ReadAllText($file.FullName, [System.Text.Encoding]::UTF8)
  $raw = $raw.Replace('<div dir="rtl" align="right">', '<div dir="ltr" align="left">')
  $segments = [regex]::Split($raw, '(?s)(\x60{3}.*?\x60{3}|~~~.*?~~~)')
  $translatedSegments = [System.Collections.Generic.List[string]]::new()
  foreach ($segment in $segments) {
    if ($segment.StartsWith($fence) -or $segment.StartsWith('~~~')) { $translatedSegments.Add($segment) }
    else { $translatedSegments.Add((Translate-Prose $segment)) }
  }
  $translated = $translatedSegments -join ''
  [System.IO.File]::WriteAllText($outPath, $translated, [System.Text.UTF8Encoding]::new($false))
  Write-Progress -Activity 'Creating English edition' -Status "$index / $total : $relative" -PercentComplete (($index / [Math]::Max(1,$total)) * 100)
}
Write-Progress -Activity 'Creating English edition' -Completed
Write-Output "Translated $total Markdown files into $destination"
