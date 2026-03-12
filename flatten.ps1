$baseDir = "s:\just app\assets\stickers"
$packs = @("business", "shower", "feel", "love", "queen", "porn1")

foreach ($pack in $packs) {
    if ($pack -eq "porn1") { $prefix = "mov" } else { $prefix = $pack }
    $dir = Join-Path $baseDir $pack
    if (Test-Path $dir) {
        $files = Get-ChildItem -Path $dir -Include *.webp, *.png -File | Sort-Object Name
        $i = 1
        foreach ($file in $files) {
            $newName = $prefix + "_" + $i + $file.Extension
            $dest = Join-Path $baseDir $newName
            Move-Item -Path $file.FullName -Destination $dest -Force
            $i++
        }
    }
}
