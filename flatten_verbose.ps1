$baseDir = "s:\just app\assets\stickers"
$packs = @("business", "shower", "feel", "love", "queen", "porn1")

foreach ($pack in $packs) {
    Write-Host "Processing pack: $pack"
    if ($pack -eq "porn1") { $prefix = "mov" } else { $prefix = $pack }
    $dirPath = "$baseDir\$pack"
    if (Test-Path $dirPath) {
        $files = Get-ChildItem -Path $dirPath -File | Where-Object { $_.Extension -eq ".webp" -or $_.Extension -eq ".png" }
        Write-Host "Found $($files.Count) files in $dirPath"
        $i = 1
        foreach ($file in $files) {
            $newName = "$prefix`_$i$($file.Extension)"
            $destPath = "$baseDir\$newName"
            Write-Host "Moving $($file.Name) to $newName"
            Move-Item -Path $file.FullName -Destination $destPath -Force
            $i++
        }
    } else {
        Write-Host "Directory not found: $dirPath"
    }
}
