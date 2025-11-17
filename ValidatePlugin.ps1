# Validate Plugin Structure
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Plugin Validation" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$buildOutput = Join-Path $PSScriptRoot "bin\Debug\net8.0-windows\win-x64"
$requiredFiles = @(
    "BufferToolPlugin.dll",
    "Config.daml"
)

$optionalFiles = @(
    "Images\BufferTool16.png.txt",
    "Images\BufferTool32.png.txt",
    "Images\BufferButton16.png.txt",
    "Images\BufferButton32.png.txt",
    "Images\AddinDesktop32.png.txt"
)

Write-Host "Checking build output: $buildOutput" -ForegroundColor Gray
Write-Host ""

if (-not (Test-Path $buildOutput)) {
    Write-Host "? Build output folder not found!" -ForegroundColor Red
    Write-Host "  Run: dotnet build -c Debug" -ForegroundColor Yellow
    exit 1
}

Write-Host "Required Files:" -ForegroundColor Cyan
$allPresent = $true
foreach ($file in $requiredFiles) {
    $path = Join-Path $buildOutput $file
    if (Test-Path $path) {
        Write-Host "  ? $file" -ForegroundColor Green
    } else {
        Write-Host "  ? $file (MISSING)" -ForegroundColor Red
        $allPresent = $false
    }
}

Write-Host ""
Write-Host "Optional Files:" -ForegroundColor Cyan
foreach ($file in $optionalFiles) {
    $path = Join-Path $buildOutput $file
    if (Test-Path $path) {
        Write-Host "  ? $file" -ForegroundColor Green
    } else {
        Write-Host "  ? $file (missing)" -ForegroundColor Yellow
    }
}

Write-Host ""
if ($allPresent) {
    Write-Host "? All required files present!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Plugin is ready to test!" -ForegroundColor Green
    Write-Host "Run: .\TestPlugin.ps1" -ForegroundColor White
} else {
    Write-Host "? Some required files are missing!" -ForegroundColor Red
    Write-Host "  Please rebuild the project." -ForegroundColor Yellow
}

Write-Host ""

# Check Config.daml content
$configPath = Join-Path $buildOutput "Config.daml"
if (Test-Path $configPath) {
    Write-Host "Config.daml Preview:" -ForegroundColor Cyan
    $config = Get-Content $configPath -Raw
    if ($config -match 'id="([^"]+)".*caption="([^"]+)"') {
        Write-Host "  Add-in ID: $($matches[1])" -ForegroundColor Gray
    }
    if ($config -match 'caption="Buffer Tools"') {
        Write-Host "  ? Tab configured: 'Buffer Tools'" -ForegroundColor Green
    }
    if ($config -match 'BufferToolPlugin_BufferTool') {
        Write-Host "  ? Interactive Buffer button configured" -ForegroundColor Green
    }
    if ($config -match 'BufferToolPlugin_BufferButton') {
        Write-Host "  ? Buffer Selected Layer button configured" -ForegroundColor Green
    }
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
