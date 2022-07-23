
$image = 'claudiospizzi/ansible-control-node'

$version = Get-Content -Path 'CHANGELOG.md' |
              Select-String -Pattern '## (.*)' |
                  Select-Object -First 1 |
                      ForEach-Object { $_.Line.Substring(3).Split('-')[0].Trim() }

if ($version -notmatch '^[0-9]+\.[0-9]+\.[0-9]+$')
{
    throw 'Invalid version format. Please use semantic versioning.'
}

$version = [System.Version] $version

$tagMajor = 'v{0}' -f $version.Major
$tagMinor = 'v{0}.{1}' -f $version.Major, $version.Minor
$tagPatch = 'v{0}.{1}.{2}' -f $version.Major, $version.Minor, $version.Build

docker build -t "$image`:latest" .

docker image tag "$image`:latest" "$image`:$tagMajor"
docker image tag "$image`:latest" "$image`:$tagMinor"
docker image tag "$image`:latest" "$image`:$tagPatch"

docker image push "$image`:latest"
docker image push "$image`:$tagMajor"
docker image push "$image`:$tagMinor"
docker image push "$image`:$tagPatch"
