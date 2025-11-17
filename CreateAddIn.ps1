# Quick script to create and install the .esriAddinX file

Write-Host "`n=== Creating ArcGIS Pro Add-In ===" -ForegroundColor Cyan

# Build the project
Write-Host "`nBuilding project..." -ForegroundColor Yellow
dotnet build -c Release

# Create package folder
$packageFolder = ".\Package"
if (Test-Path $packageFolder) { Remove-Item $packageFolder -Recurse -Force }
New-Item -ItemType Directory -Path $packageFolder | Out-Null

# Copy required files
Write-Host "Copying files..." -ForegroundColor Yellow
Copy-Item ".\bin\Release\net8.0-windows\win-x64\BufferToolPlugin.dll" $packageFolder
Copy-Item ".\Config.daml" $packageFolder
Copy-Item ".\Images" "$packageFolder\Images" -Recurse

# Create .esriAddinX (ZIP file with different extension)
Write-Host "Creating package..." -ForegroundColor Yellow
if (Test-Path ".\BufferToolPlugin.esriAddinX") { Remove-Item ".\BufferToolPlugin.esriAddinX" }
Compress-Archive -Path "$packageFolder\*" -DestinationPath ".\BufferToolPlugin.zip" -Force
Move-Item ".\BufferToolPlugin.zip" "BufferToolPlugin.esriAddinX" -Force

# Copy to ArcGIS folder
$arcgisFolder = "$env:USERPROFILE\Documents\ArcGIS\AddIns\ArcGISPro"
New-Item -ItemType Directory -Path $arcgisFolder -Force | Out-Null
Copy-Item ".\BufferToolPlugin.esriAddinX" $arcgisFolder -Force

Write-Host "`n✓ Add-in created and installed!" -ForegroundColor Green
Write-Host "Location: $arcgisFolder\BufferToolPlugin.esriAddinX" -ForegroundColor Gray
Write-Host "`nNext: Close and restart ArcGIS Pro, then look for 'Buffer Tools' tab`n" -ForegroundColor Yellow

# Cleanup
Remove-Item $packageFolder -Recurse -Force

# Check if add-in is in the correct folder
$addInPath = "$env:USERPROFILE\Documents\ArcGIS\AddIns\ArcGISPro"
Write-Host "Checking: $addInPath"
Get-ChildItem $addInPath -Filter "*.esriAddinX"

Test-Path "$env:USERPROFILE\Documents\ArcGIS\AddIns\ArcGISPro\BufferToolPlugin.esriAddinX"

# Run from your project directory
cd "C:\Users\Hafiz\Desktop\Github\ArcGIS Pro Plugin\BufferToolPlugin"
.\CreateAddIn.ps1