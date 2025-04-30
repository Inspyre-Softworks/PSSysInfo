@{
    RootModule        = 'PSSysInfo.psm1'
    ModuleVersion     = '1.0.0'
    GUID              = '2dc89998-d893-4c1c-9906-3aa549870144'
    Author            = 'Taylor-Jayde Blackstone'
    CompanyName       = 'Inspyre-Softworks'
    Copyright         = '2025 Inspyre-Softworks'
    Description       = 'Quick system-info cmdlet with optional clipboard copy.'
    PowerShellVersion = '5.1'
    FunctionsToExport = @('Get-SystemInfo')
    AliasesToExport   = @('gsys')
    Tags = @('System', 'Info', 'SysInfo', 'SystemInfo', 'Hardware', 'Report')
    LicenseUri = 'https://raw.githubusercontent.com/Inspyre-Softworks/PSSysInfo/refs/heads/main/LICENSE'
    ProjectUri = 'https://github.com/Inspyre-Softworks/PSSysInfo'
}
