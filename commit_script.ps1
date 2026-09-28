# Git Commit Script - 30 commits with random delays
# Delays: 10, 20, 40, 60, 70 seconds

$delays = @(10, 20, 40, 60, 70)
$commitCount = 30

# Stage all changes
git add -A

# Get list of all changed files
$files = git diff --name-only HEAD
$untracked = git ls-files --others --exclude-standard
$allFiles = $files + $untracked

if ($allFiles.Count -eq 0) {
    Write-Host "No changes to commit"
    exit
}

Write-Host "Total files to commit: $($allFiles.Count)"
Write-Host "Will create $commitCount commits with random delays"
Write-Host ""

# Distribute files across commits
$filesPerCommit = [math]::Ceiling($allFiles.Count / $commitCount)
$fileIndex = 0

for ($i = 1; $i -le $commitCount; $i++) {
    # Select files for this commit
    $commitFiles = @()
    for ($j = 0; $j -lt $filesPerCommit -and $fileIndex -lt $allFiles.Count; $j++) {
        $commitFiles += $allFiles[$fileIndex]
        $fileIndex++
    }
    
    if ($commitFiles.Count -eq 0) {
        break
    }
    
    # Stage files for this commit
    foreach ($file in $commitFiles) {
        git add "$file"
    }
    
    # Create commit
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $commitMessage = "Commit $i of $commitCount - $timestamp"
    git commit -m "$commitMessage"
    
    Write-Host "[$i/$commitCount] Committed: $commitMessage"
    Write-Host "  Files: $($commitFiles.Count)"
    
    # Random delay (except after last commit)
    if ($i -lt $commitCount) {
        $delay = $delays | Get-Random
        Write-Host "  Waiting $delay seconds..."
        Start-Sleep -Seconds $delay
    }
}

# Push to GitHub
Write-Host ""
Write-Host "Pushing to GitHub..."
git push origin main
Write-Host "Done!"