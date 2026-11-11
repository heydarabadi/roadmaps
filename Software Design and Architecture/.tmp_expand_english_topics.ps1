$root=(Get-Location).Path
$enRoot=Join-Path $root 'en'
$nl=[Environment]::NewLine
$rows=@(
'02/programming-paradigms/topics/programming-paradigms/README.md|FULL',
'03/object-oriented-programming/topics/object-oriented-programming/README.md|FULL',
'03/object-oriented-programming/topics/primary-principles/README.md|^## 2\.',
'03/object-oriented-programming/topics/inheritance/README.md|^### Inheritance',
'03/object-oriented-programming/topics/polymorphism/README.md|^### Polymorphism',
'03/object-oriented-programming/topics/abstraction/README.md|^### Abstraction',
'03/object-oriented-programming/topics/encapsulation/README.md|^### Encapsulation',
'03/object-oriented-programming/topics/paradigm-features/README.md|^## 3\.',
'03/object-oriented-programming/topics/abstract-classes/README.md|^### Abstract class',
'03/object-oriented-programming/topics/concrete-classes/README.md|^### Concrete class',
'03/object-oriented-programming/topics/scope-visibility/README.md|^### Scope and visibility',
'03/object-oriented-programming/topics/interfaces/README.md|^### Interface$',
'03/object-oriented-programming/topics/model-driven-design/README.md|^## 4\.',
'03/object-oriented-programming/topics/domain-models/README.md|^## 4\.',
'03/object-oriented-programming/topics/anemic-models/README.md|^### Rich domain model',
'03/object-oriented-programming/topics/domain-language/README.md|^### common language',
'03/object-oriented-programming/topics/class-variants/README.md|^### Entity, value and class variant',
'03/object-oriented-programming/topics/layered-architectures-oop/README.md|^## 5\.',
'04/design-principles/topics/design-principles/README.md|FULL',
'04/design-principles/topics/solid/README.md|^## 1\.',
'04/design-principles/topics/single-responsibility/README.md|^### S',
'04/design-principles/topics/open-closed/README.md|^### O',
'04/design-principles/topics/liskov-substitution/README.md|^### L',
'04/design-principles/topics/interface-segregation/README.md|^### I',
'04/design-principles/topics/dependency-inversion/README.md|^### D',
'04/design-principles/topics/dry/README.md|^## 2\.',
'04/design-principles/topics/yagni/README.md|^## 3\.',
'04/design-principles/topics/law-of-demeter/README.md|^## 4\.',
'04/design-principles/topics/tell-dont-ask/README.md|^## 5\.',
'04/design-principles/topics/hollywood-principle/README.md|^## 6\.',
'04/design-principles/topics/composition-over-inheritance/README.md|^## 7\.',
'04/design-principles/topics/encapsulate-what-varies/README.md|^## 8\.',
'04/design-principles/topics/program-to-abstractions/README.md|^## 9\.',
'05/design-patterns/topics/gof-design-patterns/README.md|FULL',
'05/design-patterns/topics/posa-patterns/README.md|^## 5\.',
'06/architectural-principles/topics/architectural-principles/README.md|FULL',
'06/architectural-principles/topics/component-principles/README.md|^## 1\.',
'06/architectural-principles/topics/policy-vs-detail/README.md|^## 2\.',
'06/architectural-principles/topics/coupling-cohesion/README.md|^## 3\.',
'06/architectural-principles/topics/boundaries/README.md|^## 4\.',
'07/architectural-styles/topics/architectural-styles/README.md|FULL',
'07/architectural-styles/topics/component-based/README.md|^## 1\.',
'07/architectural-styles/topics/monolithic/README.md|^## 2\.',
'07/architectural-styles/topics/layered/README.md|^## 3\.',
'07/architectural-styles/topics/structural-style/README.md|^## 4\.',
'07/architectural-styles/topics/client-server/README.md|^## 5\.',
'07/architectural-styles/topics/peer-to-peer/README.md|^## 6\.',
'07/architectural-styles/topics/distributed/README.md|^## 7\.',
'07/architectural-styles/topics/event-driven/README.md|^## 8\.',
'07/architectural-styles/topics/publish-subscribe/README.md|^## 9\.',
'07/architectural-styles/topics/messaging/README.md|^## 9\.',
'08/architectural-patterns/topics/domain-driven-design/README.md|^## 1\.',
'08/architectural-patterns/topics/mvc/README.md|^## 2\.',
'08/architectural-patterns/topics/microservices/README.md|^## 3\.',
'08/architectural-patterns/topics/blackboard/README.md|^## 4\.',
'08/architectural-patterns/topics/microkernel/README.md|^## 5\.',
'08/architectural-patterns/topics/serverless/README.md|^## 6\.',
'08/architectural-patterns/topics/queues-streams/README.md|^## 7\.',
'08/architectural-patterns/topics/event-sourcing/README.md|^## 8\.',
'08/architectural-patterns/topics/soa/README.md|^## 9\.',
'08/architectural-patterns/topics/cqrs/README.md|^## 10\.',
'09/enterprise-patterns/topics/dto/README.md|^## 1\.',
'09/enterprise-patterns/topics/identity-map/README.md|^## 2\.',
'09/enterprise-patterns/topics/use-cases/README.md|^## 3\.',
'09/enterprise-patterns/topics/repositories/README.md|^## 4\.',
'09/enterprise-patterns/topics/mappers/README.md|^## 5\.',
'09/enterprise-patterns/topics/transaction-script/README.md|^## 6\.',
'09/enterprise-patterns/topics/commands-queries/README.md|^## 7\.',
'09/enterprise-patterns/topics/value-objects/README.md|^## 8\.',
'09/enterprise-patterns/topics/domain-model-enterprise/README.md|^## 9\.',
'09/enterprise-patterns/topics/entities/README.md|^## 9\.',
'09/enterprise-patterns/topics/orms/README.md|^## 10\.'
)
$map=@{}
foreach($row in $rows){ $pair=$row -split '\|',2; $map[$pair[0]]=$pair[1] }
$files=Get-ChildItem -LiteralPath $enRoot -Recurse -File -Filter README.md | Where-Object { $_.FullName -match '\\topics\\' }
$done=0
$missing=[System.Collections.Generic.List[string]]::new()
foreach($file in $files){
  $relative=$file.FullName.Substring($enRoot.Length+1).Replace('\','/')
  if(-not $map.ContainsKey($relative)){continue}
  $parts=$relative.Split('/')
  $lessonPath=Join-Path (Join-Path $enRoot ($parts[0]+'/'+$parts[1])) 'lessons.md'
  if(-not (Test-Path -LiteralPath $lessonPath)){ $missing.Add("$relative => no chapter lesson"); continue }
  $lessonLines=[IO.File]::ReadAllLines($lessonPath,[Text.Encoding]::UTF8)
  $selector=$map[$relative]
  $start=-1
  $end=$lessonLines.Length
  $level=0
  if($selector -eq 'FULL'){
    $start=1
    for($j=1;$j -lt $lessonLines.Length;$j++){ if($lessonLines[$j] -match '^##\s+(Optional resources|Optional resources for further study|Further reading|Resources)'){ $end=$j; break } }
  } else {
    for($j=0;$j -lt $lessonLines.Length;$j++){ if($lessonLines[$j] -match $selector){ $start=$j; break } }
    if($start -ge 0){
      $level=([regex]::Match($lessonLines[$start],'^#+')).Length
      for($j=$start+1;$j -lt $lessonLines.Length;$j++){ if($lessonLines[$j] -match '^(#{1,6})\s' -and $Matches[1].Length -le $level){ $end=$j; break } }
    }
  }
  if($start -lt 0){ $missing.Add("$relative => $selector"); continue }
  $section=[System.Collections.Generic.List[string]]::new()
  for($j=$start;$j -lt $end;$j++){
    $line=$lessonLines[$j]
    if($line -match '^(#{1,6})(\s.*)$'){ $newLevel=[Math]::Min(6,$Matches[1].Length+1); $line=('#' * $newLevel)+$Matches[2] }
    $section.Add($line)
  }
  $addition='## In-depth lesson for this topic'+$nl+$nl+($section -join $nl)+$nl+$nl
  $text=[IO.File]::ReadAllText($file.FullName,[Text.Encoding]::UTF8)
  if($text.Contains('## In-depth lesson for this topic')){continue}
  $insert=$text.IndexOf('## Resources',[StringComparison]::OrdinalIgnoreCase)
  if($insert -lt 0){ $insert=$text.IndexOf('## Further reading',[StringComparison]::OrdinalIgnoreCase) }
  if($insert -lt 0){ $insert=$text.LastIndexOf('</div>') }
  if($insert -lt 0){ $text+=$addition } else { $text=$text.Insert($insert,$addition) }
  [IO.File]::WriteAllText($file.FullName,$text,[Text.UTF8Encoding]::new($false))
  $done++
}
"Inserted extracted chapter sections into $done English topic pages."
if($missing.Count -gt 0){ 'Unmatched mappings:'; $missing }
