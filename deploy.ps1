[CmdletBinding(ConfirmImpact = 'High')]
param ()

$imageName = 'claudiospizzi/ansible-control-node'

$version =
    Get-Content -Path 'CHANGELOG.md' |
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

docker build -t "$imageName`:latest" .

docker image tag "$imageName`:latest" "$imageName`:$tagMajor"
docker image tag "$imageName`:latest" "$imageName`:$tagMinor"
docker image tag "$imageName`:latest" "$imageName`:$tagPatch"

foreach ($image in "$imageName`:latest", "$imageName`:$tagMajor", "$imageName`:$tagMinor", "$imageName`:$tagPatch")
{
    if ($PSCmdlet.ShouldProcess($image, 'Push Image to Docker Hub'))
    {
        docker image push $image
    }
}
