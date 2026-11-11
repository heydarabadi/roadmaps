$root=(Get-Location).Path
$sourceRoot=$root
$enRoot=Join-Path $root 'en'
$nl=[Environment]::NewLine
$enScript=[IO.File]::ReadAllText((Join-Path $root '.tmp_expand_english_topics.ps1'),[Text.Encoding]::UTF8)
$rowMatches=[regex]::Matches($enScript,"'([^'\r\n|]+)\|([^'\r\n]+)'")
$map=@{}
foreach($m in $rowMatches){$map[$m.Groups[1].Value]=$m.Groups[2].Value}
$nested=@{
'03/object-oriented-programming/topics/abstraction/README.md'='^### .*Abstraction'
'03/object-oriented-programming/topics/encapsulation/README.md'='^### .*Encapsulation'
'03/object-oriented-programming/topics/inheritance/README.md'='^### .*Inheritance'
'03/object-oriented-programming/topics/polymorphism/README.md'='^### .*Polymorphism'
'03/object-oriented-programming/topics/abstract-classes/README.md'='^### Abstract class$'
'03/object-oriented-programming/topics/concrete-classes/README.md'='^### Concrete class$'
'03/object-oriented-programming/topics/scope-visibility/README.md'='^### Scope و visibility'
'03/object-oriented-programming/topics/interfaces/README.md'='^### Interface$'
'03/object-oriented-programming/topics/anemic-models/README.md'='^### Domain model غنی'
'03/object-oriented-programming/topics/domain-language/README.md'='^### زبان مشترک'
'03/object-oriented-programming/topics/class-variants/README.md'='^### Entity، value'
'04/design-principles/topics/single-responsibility/README.md'='^### S'
'04/design-principles/topics/open-closed/README.md'='^### O'
'04/design-principles/topics/liskov-substitution/README.md'='^### L'
'04/design-principles/topics/interface-segregation/README.md'='^### I'
'04/design-principles/topics/dependency-inversion/README.md'='^### D'
}
$files=Get-ChildItem -LiteralPath $sourceRoot -Recurse -File -Filter README.md | Where-Object { $_.FullName -match '\\topics\\' -and $_.FullName -notmatch '\\01\\clean-code\\' }
$done=0
$missing=[System.Collections.Generic.List[string]]::new()
foreach($file in $files){
  $relative=$file.FullName.Substring($sourceRoot.Length+1).Replace('\','/')
  $selector=$null
  if($map.ContainsKey($relative)){ $selector=$map[$relative] }
  elseif($relative -match '^05/design-patterns/topics/gof-design-patterns/patterns/([^/]+)/README\.md$'){
    $slug=$Matches[1]
    $create='abstract-factory,builder,factory-method,prototype,singleton'
    $struct='adapter,bridge,composite,decorator,facade,flyweight,proxy'
    if($create.Split(',') -contains $slug){$selector='^## 1\.'}
    elseif($struct.Split(',') -contains $slug){$selector='^## 2\.'}
    else{$selector='^## 3\.'}
  } else { continue }
  $parts=$relative.Split('/')
  $lessonPath=Join-Path (Join-Path $sourceRoot ($parts[0]+'/'+$parts[1])) 'lessons.md'
  if(-not(Test-Path -LiteralPath $lessonPath)){ $missing.Add("$relative => no lesson file"); continue }
  $lines=[IO.File]::ReadAllLines($lessonPath,[Text.Encoding]::UTF8)
  $start=-1
  $end=$lines.Length
  $level=0
  if($selector -eq 'FULL'){
    $start=1
    for($i=1;$i -lt $lines.Length;$i++){if($lines[$i] -match '^##\s+(منابع اختیاری|منابع تکمیلی|منابع)'){ $end=$i; break }}
  } elseif($nested.ContainsKey($relative)){
    $pattern=$nested[$relative]
    for($i=0;$i -lt $lines.Length;$i++){if($lines[$i] -match $pattern){$start=$i;break}}
  } elseif($selector -match '^\^##\s+(\d+)'){
    $number=$Matches[1]
    $faNumber=$number.Replace('0','۰').Replace('1','۱').Replace('2','۲').Replace('3','۳').Replace('4','۴').Replace('5','۵').Replace('6','۶').Replace('7','۷').Replace('8','۸').Replace('9','۹')
    $pattern='^##\s+'+[regex]::Escape($faNumber)+'\.'
    for($i=0;$i -lt $lines.Length;$i++){if($lines[$i] -match $pattern){$start=$i;break}}
  }
  if($start -lt 0){$missing.Add("$relative => $selector");continue}
  if($selector -ne 'FULL'){
    $level=([regex]::Match($lines[$start],'^#+')).Length
    for($i=$start+1;$i -lt $lines.Length;$i++){if($lines[$i] -match '^(#{1,6})\s' -and $Matches[1].Length -le $level){$end=$i;break}}
  }
  $section=[System.Collections.Generic.List[string]]::new()
  for($i=$start;$i -lt $end;$i++){
    $line=$lines[$i]
    if($line -match '^(#{1,6})(\s.*)$'){$newLevel=[Math]::Min(6,$Matches[1].Length+1);$line=('#' * $newLevel)+$Matches[2]}
    $section.Add($line)
  }
  $addition='## آموزش تکمیلی مستقل'+$nl+$nl+($section -join $nl)+$nl+$nl
  $text=[IO.File]::ReadAllText($file.FullName,[Text.Encoding]::UTF8)
  if($text.Contains('## آموزش تکمیلی مستقل')){continue}
  $insert=$text.IndexOf('## منابع',[StringComparison]::Ordinal)
  if($insert -lt 0){$insert=$text.LastIndexOf('</div>')}
  if($insert -lt 0){$text+=$addition}else{$text=$text.Insert($insert,$addition)}
  [IO.File]::WriteAllText($file.FullName,$text,[Text.UTF8Encoding]::new($false))
  $done++
}
"بخش‌های تکمیلی فصل به $done صفحهٔ موضوعی فارسی افزوده شد."
if($missing.Count -gt 0){'صفحه‌های نیازمند نگاشت:';$missing}
