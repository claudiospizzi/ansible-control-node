
$version = Get-Content -Path 'CHANGELOG.md' |
               Select-String -Pattern '## (.*)' |
                   Select-Object -First 1 |
                       ForEach-Object { $_.Line.Substring(3).Split('-')[0].Trim() }

docker build -t "claudiospizzi/ansible-control-node:$version" .
