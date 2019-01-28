#Requires -Modules InvokeBuild, platyPs, MarkdownToHtml, ChangelogManagement, BuildHelpers

[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingCmdletAliases", "", Justification="This erroneously triggers on Invoke-Build scripts.")]
[CmdletBinding()]
param (
    [parameter(Mandatory=$true)]
    [string]$Version
)
$NL = [System.Environment]::NewLine

$MarkdownToHtmlTemplate = (
    '<!DOCTYPE html>' + $NL +
    '<html>' + $NL +
    '<head>' + $NL +
    "`t" +'<meta charset="utf-8" />' + $NL +
    "`t" +'<title>[title]</title>' + $NL +
    "`t" +'<style>' + $NL +
    "`t" +'.markdown-body{-ms-text-size-adjust:100%;-webkit-text-size-adjust:100%;line-height:1.5;color:#24292e;font-family:-apple-system,BlinkMacSystemFont,"Segoe UI",Helvetica,Arial,sans-serif,"Apple Color Emoji","Segoe UI Emoji","Segoe UI Symbol";font-size:16px;line-height:1.5;word-wrap:break-word}.markdown-body .pl-c{color:#6a737d}.markdown-body .pl-c1,.markdown-body .pl-s .pl-v{color:#005cc5}.markdown-body .pl-e,.markdown-body .pl-en{color:#6f42c1}.markdown-body .pl-smi,.markdown-body .pl-s .pl-s1{color:#24292e}.markdown-body .pl-ent{color:#22863a}.markdown-body .pl-k{color:#d73a49}.markdown-body .pl-s,.markdown-body .pl-pds,.markdown-body .pl-s .pl-pse .pl-s1,.markdown-body .pl-sr,.markdown-body .pl-sr .pl-cce,.markdown-body .pl-sr .pl-sre,.markdown-body .pl-sr .pl-sra{color:#032f62}.markdown-body .pl-v,.markdown-body .pl-smw{color:#e36209}.markdown-body .pl-bu{color:#b31d28}.markdown-body .pl-ii{color:#fafbfc;background-color:#b31d28}.markdown-body .pl-c2{color:#fafbfc;background-color:#d73a49}.markdown-body .pl-c2::before{content:"^M"}.markdown-body .pl-sr .pl-cce{font-weight:700;color:#22863a}.markdown-body .pl-ml{color:#735c0f}.markdown-body .pl-mh,.markdown-body .pl-mh .pl-en,.markdown-body .pl-ms{font-weight:700;color:#005cc5}.markdown-body .pl-mi{font-style:italic;color:#24292e}.markdown-body .pl-mb{font-weight:700;color:#24292e}.markdown-body .pl-md{color:#b31d28;background-color:#ffeef0}.markdown-body .pl-mi1{color:#22863a;background-color:#f0fff4}.markdown-body .pl-mc{color:#e36209;background-color:#ffebda}.markdown-body .pl-mi2{color:#f6f8fa;background-color:#005cc5}.markdown-body .pl-mdr{font-weight:700;color:#6f42c1}.markdown-body .pl-ba{color:#586069}.markdown-body .pl-sg{color:#959da5}.markdown-body .pl-corl{text-decoration:underline;color:#032f62}.markdown-body .octicon{display:inline-block;vertical-align:text-top;fill:currentColor}.markdown-body a{background-color:transparent}.markdown-body a:active,.markdown-body a:hover{outline-width:0}.markdown-body strong{font-weight:inherit;font-weight:bolder}.markdown-body h1{font-size:2em;margin:.67em 0}.markdown-body img{border-style:none}.markdown-body code,.markdown-body kbd,.markdown-body pre{font-family:monospace,monospace;font-size:1em}.markdown-body hr{box-sizing:content-box;height:0;overflow:visible}.markdown-body input{font:inherit;margin:0;overflow:visible}.markdown-body [type="checkbox"]{box-sizing:border-box;padding:0}.markdown-body *{box-sizing:border-box}.markdown-body input{font-family:inherit;font-size:inherit;line-height:inherit}.markdown-body a{color:#0366d6;text-decoration:none}.markdown-body a:hover{text-decoration:underline}.markdown-body strong{font-weight:600}.markdown-body hr{height:0;margin:15px 0;overflow:hidden;background:transparent;border:0;border-bottom:1px solid #dfe2e5}.markdown-body hr::before{display:table;content:""}.markdown-body hr::after{display:table;clear:both;content:""}.markdown-body table{border-spacing:0;border-collapse:collapse}.markdown-body td,.markdown-body th{padding:0}.markdown-body h1,.markdown-body h2,.markdown-body h3,.markdown-body h4,.markdown-body h5,.markdown-body h6{margin-top:0;margin-bottom:0}.markdown-body h1{font-size:32px;font-weight:600}.markdown-body h2{font-size:24px;font-weight:600}.markdown-body h3{font-size:20px;font-weight:600}.markdown-body h4{font-size:16px;font-weight:600}.markdown-body h5{font-size:14px;font-weight:600}.markdown-body h6{font-size:12px;font-weight:600}.markdown-body p{margin-top:0;margin-bottom:10px}.markdown-body blockquote{margin:0}.markdown-body ul,.markdown-body ol{padding-left:0;margin-top:0;margin-bottom:0}.markdown-body ol ol,.markdown-body ul ol{list-style-type:lower-roman}.markdown-body ul ul ol,.markdown-body ul ol ol,.markdown-body ol ul ol,.markdown-body ol ol ol{list-style-type:lower-alpha}.markdown-body dd{margin-left:0}.markdown-body code{font-family:"SFMono-Regular",Consolas,"Liberation Mono",Menlo,Courier,monospace;font-size:12px}.markdown-body pre{margin-top:0;margin-bottom:0;font-family:"SFMono-Regular",Consolas,"Liberation Mono",Menlo,Courier,monospace;font-size:12px}.markdown-body .octicon{vertical-align:text-bottom}.markdown-body .pl-0{padding-left:0!important}.markdown-body .pl-1{padding-left:4px!important}.markdown-body .pl-2{padding-left:8px!important}.markdown-body .pl-3{padding-left:16px!important}.markdown-body .pl-4{padding-left:24px!important}.markdown-body .pl-5{padding-left:32px!important}.markdown-body .pl-6{padding-left:40px!important}.markdown-body::before{display:table;content:""}.markdown-body::after{display:table;clear:both;content:""}.markdown-body>:first-child{margin-top:0!important}.markdown-body>:last-child{margin-bottom:0!important}.markdown-body a:not([href]){color:inherit;text-decoration:none}.markdown-body .anchor{float:left;padding-right:4px;margin-left:-20px;line-height:1}.markdown-body .anchor:focus{outline:none}.markdown-body p,.markdown-body blockquote,.markdown-body ul,.markdown-body ol,.markdown-body dl,.markdown-body table,.markdown-body pre{margin-top:0;margin-bottom:16px}.markdown-body hr{height:.25em;padding:0;margin:24px 0;background-color:#e1e4e8;border:0}.markdown-body blockquote{padding:0 1em;color:#6a737d;border-left:.25em solid #dfe2e5}.markdown-body blockquote>:first-child{margin-top:0}.markdown-body blockquote>:last-child{margin-bottom:0}.markdown-body kbd{display:inline-block;padding:3px 5px;font-size:11px;line-height:10px;color:#444d56;vertical-align:middle;background-color:#fafbfc;border:solid 1px #c6cbd1;border-bottom-color:#959da5;border-radius:3px;box-shadow:inset 0 -1px 0 #959da5}.markdown-body h1,.markdown-body h2,.markdown-body h3,.markdown-body h4,.markdown-body h5,.markdown-body h6{margin-top:24px;margin-bottom:16px;font-weight:600;line-height:1.25}.markdown-body h1 .octicon-link,.markdown-body h2 .octicon-link,.markdown-body h3 .octicon-link,.markdown-body h4 .octicon-link,.markdown-body h5 .octicon-link,.markdown-body h6 .octicon-link{color:#1b1f23;vertical-align:middle;visibility:hidden}.markdown-body h1:hover .anchor,.markdown-body h2:hover .anchor,.markdown-body h3:hover .anchor,.markdown-body h4:hover .anchor,.markdown-body h5:hover .anchor,.markdown-body h6:hover .anchor{text-decoration:none}.markdown-body h1:hover .anchor .octicon-link,.markdown-body h2:hover .anchor .octicon-link,.markdown-body h3:hover .anchor .octicon-link,.markdown-body h4:hover .anchor .octicon-link,.markdown-body h5:hover .anchor .octicon-link,.markdown-body h6:hover .anchor .octicon-link{visibility:visible}.markdown-body h1{padding-bottom:.3em;font-size:2em;border-bottom:1px solid #eaecef}.markdown-body h2{padding-bottom:.3em;font-size:1.5em;border-bottom:1px solid #eaecef}.markdown-body h3{font-size:1.25em}.markdown-body h4{font-size:1em}.markdown-body h5{font-size:.875em}.markdown-body h6{font-size:.85em;color:#6a737d}.markdown-body ul,.markdown-body ol{padding-left:2em}.markdown-body ul ul,.markdown-body ul ol,.markdown-body ol ol,.markdown-body ol ul{margin-top:0;margin-bottom:0}.markdown-body li{word-wrap:break-all}.markdown-body li>p{margin-top:16px}.markdown-body li+li{margin-top:.25em}.markdown-body dl{padding:0}.markdown-body dl dt{padding:0;margin-top:16px;font-size:1em;font-style:italic;font-weight:600}.markdown-body dl dd{padding:0 16px;margin-bottom:16px}.markdown-body table{display:block;width:100%;overflow:auto}.markdown-body table th{font-weight:600}.markdown-body table th,.markdown-body table td{padding:6px 13px;border:1px solid #dfe2e5}.markdown-body table tr{background-color:#fff;border-top:1px solid #c6cbd1}.markdown-body table tr:nth-child(2n){background-color:#f6f8fa}.markdown-body img{max-width:100%;box-sizing:content-box;background-color:#fff}.markdown-body img[align=right]{padding-left:20px}.markdown-body img[align=left]{padding-right:20px}.markdown-body code{padding:.2em .4em;margin:0;font-size:85%;background-color:rgba(27,31,35,0.05);border-radius:3px}.markdown-body pre{word-wrap:normal}.markdown-body pre>code{padding:0;margin:0;font-size:100%;word-break:normal;white-space:pre;background:transparent;border:0}.markdown-body .highlight{margin-bottom:16px}.markdown-body .highlight pre{margin-bottom:0;word-break:normal}.markdown-body .highlight pre,.markdown-body pre{padding:16px;overflow:auto;font-size:85%;line-height:1.45;background-color:#f6f8fa;border-radius:3px}.markdown-body pre code{display:inline;max-width:auto;padding:0;margin:0;overflow:visible;line-height:inherit;word-wrap:normal;background-color:transparent;border:0}.markdown-body .full-commit .btn-outline:not(:disabled):hover{color:#005cc5;border-color:#005cc5}.markdown-body kbd{display:inline-block;padding:3px 5px;font:11px SFMono-Regular,Consolas,"Liberation Mono",Menlo,Courier,monospace;line-height:10px;color:#444d56;vertical-align:middle;background-color:#fafbfc;border:solid 1px #d1d5da;border-bottom-color:#c6cbd1;border-radius:3px;box-shadow:inset 0 -1px 0 #c6cbd1}.markdown-body :checked+.radio-label{position:relative;z-index:1;border-color:#0366d6}.markdown-body .task-list-item{list-style-type:none}.markdown-body .task-list-item+.task-list-item{margin-top:3px}.markdown-body .task-list-item input{margin:0 .2em .25em -1.6em;vertical-align:middle}.markdown-body hr{border-bottom-color:#eee}.markdown-body{box-sizing:border-box;min-width:200px;max-width:980px;margin:0 auto;padding:45px}@media (max-width: 767px){.markdown-body{padding:15px}}' + $NL +
    "`t" +'</style>' + $NL +
    '</head>' + $NL +
    '<body>' + $NL +
    "`t" +'<article class="markdown-body">' + $NL +
    "`t" +'[content]' + $NL +
    '</article>' + $NL +
    '</body>' + $NL +
    '</html>'
)

Enter-Build {
    $global:ModuleName = Get-ProjectName
    $global:ModulePath = "$PSScriptRoot\src\$ModuleName.psm1"
    $global:ManifestPath = "$PSScriptRoot\src\$ModuleName.psd1"
}

# Synopsis: Perform all build tasks.
task . Init, UpdateChangelog, UpdateManifest, GenerateMarkdownHelp, GenerateHtmlHelp, CopySource

# Synopsis: Removes files from docs and out, makes out\$ModuleName if needed, runs Set-BuildEnvironment for BuildHelpers commands.
task Init {
    Remove-Item -Path "docs\*" -Recurse -ErrorAction SilentlyContinue
    Remove-Item -Path "out\*" -Recurse -ErrorAction SilentlyContinue

    if (!(Test-Path -Path "out\$ModuleName")) {
        New-Item -Path "out\$ModuleName" -ItemType Directory | Out-Null
    }

    Set-BuildEnvironment
}

# Synopsis: Updates the CHANGELOG.md file for the new release.
task UpdateChangelog {
    $SafeVersion = ($Version -split "-")[0]
    Update-Changelog -ReleaseVersion $SafeVersion -LinkBase "https://github.com/natescherer/ChangelogManagement" -ReleasePrefix "v"
}

# Synopsis: Updates the module manifest file for the new release.
task UpdateManifest {
    $Description = ((Get-Content -Path ".\README.md" -Raw) -split "## Getting Started")[0] -replace "#.*", ""

    $SafeVersion = ($Version -split "-")[0]

    $FunctionsToExport = @()	
    $ModuleData = Get-Content $ModulePath	
    foreach ($Line in $ModuleData) {	
        if ($Line -like "Export-ModuleMember*") {	
            $LineFunctions = ((($Line -replace "Export-ModuleMember","") -replace "-Function","") -replace " ","") -split ","	
            foreach ($Function in $LineFunctions) {	
                $FunctionsToExport += $Function	
            }	
        }	
    }

    if (!$IsLinux) {
        $ReleaseNotes = (Get-ChangelogData).Released[0].RawData
    } else {
        $ReleaseNotes = "This is a shim to make Ubuntu builds pass temporarily!"
    }

    $ManifestData = @{
        Path = $ManifestPath
        ReleaseNotes = $ReleaseNotes
        Description = $Description
        ModuleVersion = $SafeVersion
        FunctionsToExport = $FunctionsToExport
        LicenseUri = "https://github.com/$env:APPVEYOR_REPO_NAME/blob/master/LICENSE"
        ProjectUri = "https://github.com/$env:APPVEYOR_REPO_NAME"
        HelpInfoUri = "https://github.com/$env:APPVEYOR_REPO_NAME"
    }

    if ($Version -like "*-*") {
        $ManifestData += @{Prerelease = ($Version -split "-")[1]}
    }

    Update-ModuleManifest @ManifestData

    $ManifestData = Get-Content $ManifestPath
    $ManifestData = $ManifestData -replace "^CmdletsToExport.*$", "CmdletsToExport = @()" 
    $ManifestData = $ManifestData -replace "^AliasesToExport.*", "AliasesToExport = @()"
    Set-Content -Path $ManifestPath -Value $ManifestData
}

# Synopsis: Generates Markdown help file from comment-based help in script.
task GenerateMarkdownHelp {
    Get-Module -Name $ModuleName -All | Remove-Module -Force -ErrorAction Ignore
    Import-Module -Name $ModulePath -Force -ErrorAction Stop

    New-MarkdownHelp -Module $ModuleName -OutputFolder docs | Out-Null
}

# Synopsis: Creates HTML help files for inclusion in releases.
task GenerateHtmlHelp {
    Convertfrom-Changelog -Path .\CHANGELOG.md -Format Release -OutputPath docs\CHANGELOG.md
    Copy-Item -Path "README.md" -Destination "docs\"

    New-Item -Path "$env:temp\MarkdownToHtml" -Type Directory | Out-Null
    Set-Content -Value $MarkdownToHtmlTemplate -Path "$env:temp\MarkdownToHtml\md-template.html" -NoNewLine

    Convert-MarkdownToHTML -Path "docs" -Destination "out\$ModuleName\docs" -Template "$env:temp\MarkdownToHtml" | Out-Null

    Remove-Item -Path "$env:temp\MarkdownToHtml" -Recurse -Force
    Remove-Item -Path "docs\README.md"
    Remove-Item -Path "docs\CHANGELOG.md"

    Move-Item -Path "out\$ModuleName\docs\README.html" -Destination "out\$ModuleName"
    Move-Item -Path "out\$ModuleName\docs\CHANGELOG.html" -Destination "out\$ModuleName"
}

# Synopsis: Copies source files into out\$ModuleName.
task CopySource {
    Copy-Item -Path "src\*" -Destination "out\$ModuleName\"
}