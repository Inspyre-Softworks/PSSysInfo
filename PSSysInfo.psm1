using namespace System.Management
using namespace System

class SystemInfoReport {
    [string]$Hostname
    [string]$User
    [string]$OS
    [string]$Uptime
    [string]$CPU
    [string]$Memory
    [string]$GPU
    [string]$BIOS

    SystemInfoReport() {
        # raw-data locals — **not** class properties
        $osInfo   = Get-CimInstance Win32_OperatingSystem
        $cs       = Get-CimInstance Win32_ComputerSystem
        $cpuInfo  = Get-CimInstance Win32_Processor       | Select-Object -First 1
        $gpuInfo  = Get-CimInstance Win32_VideoController | Select-Object -First 1
        $biosInfo = Get-CimInstance Win32_BIOS

        # populate only the declared properties via $this.<PropertyName>
        $this.Hostname = $cs.Name
        $this.User     = [Environment]::UserName
        $this.OS       = "$($osInfo.Caption) $($osInfo.Version) (Build $($osInfo.BuildNumber))"
        $this.Uptime   = "{0:%d}d {0:%h}h {0:%m}m" -f ((Get-Date) - $osInfo.LastBootUpTime)

        $totalGB     = [math]::Round($cs.TotalPhysicalMemory / 1GB, 1)
        $freeGB      = [math]::Round($osInfo.FreePhysicalMemory * 1KB / 1GB, 1)
        $usedPercent = "{0:P0}" -f (1 - ($osInfo.FreePhysicalMemory * 1KB / $cs.TotalPhysicalMemory))
        $this.Memory = "$([math]::Round($totalGB - $freeGB,1)) / ${totalGB} GB ($usedPercent)"

        $this.CPU    = "$($cpuInfo.Name) ($($cpuInfo.NumberOfLogicalProcessors) threads)"
        $this.GPU    = $gpuInfo.Name
        $this.BIOS   = "$($biosInfo.Manufacturer) $($biosInfo.SMBIOSBIOSVersion)"
    }

    [string] ToString() {
        return @"
=======  System Information  =======
Hostname : $($this.Hostname)
User     : $($this.User)
OS       : $($this.OS)
Uptime   : $($this.Uptime)
CPU      : $($this.CPU)
Memory   : $($this.Memory)
GPU      : $($this.GPU)
BIOS     : $($this.BIOS)
"@
    }
}


function Get-SystemInfo {
    [CmdletBinding()]
    param(
        [switch]$Copy
    )

    $report = [SystemInfoReport]::new()
    $text   = $report.ToString()

    # write to pipeline
    $text

    if ($Copy) {
        try   { $text | Set-Clipboard; Write-Verbose 'Copied to clipboard.' }
        catch { Write-Warning "Copy failed: $_" }
    }
}

Set-Alias -Name gsys -Value Get-SystemInfo

Export-ModuleMember -Function Get-SystemInfo -Alias gsys

