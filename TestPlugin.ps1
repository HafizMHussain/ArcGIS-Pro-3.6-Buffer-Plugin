# Test Script for Buffer Tool Plugin
# This script copies the add-in to the ArcGIS Pro add-ins folder and launches ArcGIS Pro
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Buffer Tool Plugin - Test Script" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Define paths
$projectRoot = $PSScriptRoot
$buildOutput = Join-Path $projectRoot "bin\Debug\net8.0-windows\win-x64"
$addInsFolder = "$env:LOCALAPPDATA\ESRI\ArcGISPro\AssemblyCache"
$pluginName = "BufferToolPlugin"
$pluginFolder = Join-Path $addInsFolder $pluginName

Write-Host "Project Root: $projectRoot" -ForegroundColor Gray
Write-Host "Build Output: $buildOutput" -ForegroundColor Gray
Write-Host "Target Folder: $pluginFolder" -ForegroundColor Gray
Write-Host ""

# Check if build output exists
if (-not (Test-Path $buildOutput)) {
    Write-Host "ERROR: Build output not found!" -ForegroundColor Red
    Write-Host "Please build the project first: dotnet build -c Debug" -ForegroundColor Yellow
    exit 1
}

# Check if ArcGIS Pro is running
$arcgisProProcess = Get-Process -Name "ArcGISPro" -ErrorAction SilentlyContinue
if ($arcgisProProcess) {
    Write-Host "WARNING: ArcGIS Pro is currently running!" -ForegroundColor Yellow
    Write-Host "Please close ArcGIS Pro before testing the plugin." -ForegroundColor Yellow
    $continue = Read-Host "Do you want to close ArcGIS Pro now? (Y/N)"
    if ($continue -eq "Y" -or $continue -eq "y") {
        Write-Host "Closing ArcGIS Pro..." -ForegroundColor Yellow
        Stop-Process -Name "ArcGISPro" -Force
        Start-Sleep -Seconds 3
    } else {
        Write-Host "Test cancelled." -ForegroundColor Red
        exit 0
    }
}

# Create add-ins folder if it doesn't exist
if (-not (Test-Path $pluginFolder)) {
    Write-Host "Creating plugin folder..." -ForegroundColor Yellow
    New-Item -ItemType Directory -Path $pluginFolder -Force | Out-Null
}

# Copy files to add-ins folder
Write-Host "Copying plugin files..." -ForegroundColor Yellow
try {
    Copy-Item -Path "$buildOutput\*" -Destination $pluginFolder -Recurse -Force
    Write-Host "? Files copied successfully!" -ForegroundColor Green
} catch {
    Write-Host "ERROR: Failed to copy files!" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    exit 1
}

# List copied files
Write-Host ""
Write-Host "Copied files:" -ForegroundColor Cyan
Get-ChildItem $pluginFolder -Recurse | Select-Object -ExpandProperty FullName | ForEach-Object {
    Write-Host "  $_" -ForegroundColor Gray
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Ready to Test!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Launch Options:" -ForegroundColor Cyan
Write-Host "  1. Launch ArcGIS Pro now" -ForegroundColor White
Write-Host "  2. Exit (launch manually later)" -ForegroundColor White
Write-Host ""
$choice = Read-Host "Enter choice (1 or 2)"

if ($choice -eq "1") {
    Write-Host ""
    Write-Host "Launching ArcGIS Pro..." -ForegroundColor Yellow
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host "  Testing Instructions" -ForegroundColor Cyan
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host "1. Open or create a new project" -ForegroundColor White
    Write-Host "2. Open or create a map" -ForegroundColor White
    Write-Host "3. Add some feature layers (optional)" -ForegroundColor White
    Write-Host "4. Look for the 'Buffer Tools' tab in the ribbon" -ForegroundColor White
    Write-Host "5. Try both buttons:" -ForegroundColor White
    Write-Host "   - Interactive Buffer (creates buffer at map center)" -ForegroundColor White
    Write-Host "   - Buffer Selected Layer (buffers all features in selected layer)" -ForegroundColor White
    Write-Host ""
    Write-Host "Note: If you don't see the tab, check:" -ForegroundColor Yellow
    Write-Host "  - Add-In Manager (Project tab)" -ForegroundColor Yellow
    Write-Host "  - Look for 'Buffer Tool Plugin'" -ForegroundColor Yellow
    Write-Host ""
    
    Start-Process "C:\Program Files\ArcGIS\Pro\bin\ArcGISPro.exe"
    
    Write-Host "ArcGIS Pro launched!" -ForegroundColor Green
    Write-Host "Check the console for any errors..." -ForegroundColor Gray
} else {
    Write-Host ""
    Write-Host "Plugin installed!" -ForegroundColor Green
    Write-Host "Launch ArcGIS Pro manually to test." -ForegroundColor White
}

Write-Host ""
Write-Host "Plugin Location: $pluginFolder" -ForegroundColor Gray
Write-Host ""
