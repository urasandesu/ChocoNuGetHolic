# 
# File: Initialize-ChocoNuGetHolic.ps1
# 
# Author: Akira Sugiura (urasandesu@gmail.com)
# 
# 
# Copyright (c) 2016 Akira Sugiura
#  
#  This software is MIT License.
#  
#  Permission is hereby granted, free of charge, to any person obtaining a copy
#  of this software and associated documentation files (the "Software"), to deal
#  in the Software without restriction, including without limitation the rights
#  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#  copies of the Software, and to permit persons to whom the Software is
#  furnished to do so, subject to the following conditions:
#  
#  The above copyright notice and this permission notice shall be included in
#  all copies or substantial portions of the Software.
#  
#  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
#  THE SOFTWARE.
#

[CmdletBinding()]
param (
    [Parameter(Mandatory = $True, Position = 0)]
    [string]
    $PackageName, 

    [string]
    $Source
)

Write-Verbose ('PackageName : {0}' -f $PackageName)
Write-Verbose ('Source      : {0}' -f $Source)



function PushLocationTemporarily {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $True)]
        [string]
        $Path, 

        [Parameter(Mandatory = $True)]
        [scriptblock]
        $Script
    )

    try {
        Push-Location $Path
        [Environment]::CurrentDirectory = $PWD
        & $Script
    } finally {
        Pop-Location
        [Environment]::CurrentDirectory = $PWD
    }
}



function InitializeNuGetSpec {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $True)]
        [string]
        $PackageName
    )

    nuget spec $PackageName | Out-Null
    $nuspec = [xml](gc "$PackageName.nuspec")
    $files = $nuspec.CreateElement('files')
    $file = $nuspec.CreateElement('file')
    $src = $nuspec.CreateAttribute('src')
    $src.Value = '..\..\lib\**\*.*'
    $target = $nuspec.CreateAttribute('target')
    $target.Value = 'lib'
    [void]$file.Attributes.Append($src)
    [void]$file.Attributes.Append($target)
    [void]$files.AppendChild($file)
    $file = $nuspec.CreateElement('file')
    $src = $nuspec.CreateAttribute('src')
    $src.Value = 'tools\**\*.*'
    $target = $nuspec.CreateAttribute('target')
    $target.Value = 'tools'
    [void]$file.Attributes.Append($src)
    [void]$file.Attributes.Append($target)
    [void]$files.AppendChild($file)
    [void]$nuspec.package.AppendChild($files)
    try {
        $sw = New-Object System.IO.StreamWriter "$PackageName.nuspec"
        $nuspec.Save($sw)
    } finally {
        if ($null -ne $sw) {
            $sw.Dispose()
        }
    }

    Move-Item "$PackageName.nuspec" "$PackageName.nuspec.hedge" -Force
}



function InitializeChocolateySpec {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $True)]
        [string]
        $PackageName
    )

    nuget spec $PackageName | Out-Null
    $nuspec = [xml](gc "$PackageName.nuspec")
    $files = $nuspec.CreateElement('files')
    $file = $nuspec.CreateElement('file')
    $src = $nuspec.CreateAttribute('src')
    $src.Value = 'tools\**\*.*'
    $target = $nuspec.CreateAttribute('target')
    $target.Value = 'tools'
    [void]$file.Attributes.Append($src)
    [void]$file.Attributes.Append($target)
    [void]$files.AppendChild($file)
    [void]$nuspec.package.AppendChild($files)
    try {
        $sw = New-Object System.IO.StreamWriter "$PackageName.nuspec"
        $nuspec.Save($sw)
    } finally {
        if ($null -ne $sw) {
            $sw.Dispose()
        }
    }
}



if ([string]::IsNullOrEmpty($Source)) {
    $Source = $PWD
}

Copy-Item ([IO.Path]::Combine((Split-Path $MyInvocation.MyCommand.Path), 'Chocolatey')) $Source -Recurse -Force

PushLocationTemporarily $Source {
    PushLocationTemporarily Chocolatey {
        InitializeChocolateySpec $PackageName
        PushLocationTemporarily tools\NuGet {
            InitializeNuGetSpec $PackageName
        }
    }
}
