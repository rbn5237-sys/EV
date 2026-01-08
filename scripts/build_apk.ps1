param(
    [string]$ProjectPath = "${PSScriptRoot}..\",
    [switch]$SplitPerAbi
)

Write-Host "Project path: $ProjectPath"

if (-not (Get-Command flutter -ErrorAction SilentlyContinue)) {
  Write-Error "flutter CLI not found in PATH. Install Flutter and ensure 'flutter' is on PATH."
  exit 1
}

Push-Location $ProjectPath

Write-Host "Running flutter doctor..."
flutter doctor -v

Write-Host "Fetching packages..."
flutter pub get

if ($SplitPerAbi) {
  Write-Host "Building split-per-ABI APKs..."
  flutter build apk --split-per-abi --release
} else {
  Write-Host "Building single release APK..."
  flutter build apk --release
}

$outDir = Join-Path -Path $ProjectPath -ChildPath "build\app\outputs\flutter-apk"
Write-Host "APKs should be in: $outDir"

if (Test-Path $outDir) {
  Get-ChildItem -Path $outDir -Filter "*.apk" | ForEach-Object { Write-Host $_.FullName }
} else {
  Write-Error "Output directory not found. Build may have failed."
}

Pop-Location
