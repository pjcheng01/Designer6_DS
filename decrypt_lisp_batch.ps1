Add-Type -AssemblyName UIAutomationClient
Add-Type -AssemblyName UIAutomationTypes
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
$nm5src = @"
using System;
using System.Runtime.InteropServices;
public class NM5 {
    [DllImport("user32.dll")] public static extern bool SetForegroundWindow(IntPtr h);
    [DllImport("user32.dll")] public static extern bool SetCursorPos(int x, int y);
    [DllImport("user32.dll")] public static extern void mouse_event(uint f,int x,int y,int d,int e);
    [DllImport("user32.dll")] public static extern IntPtr SendMessage(IntPtr h, uint msg, IntPtr wp, IntPtr lp);
    [DllImport("user32.dll", EntryPoint="SendMessageW", CharSet=CharSet.Unicode)]
    public static extern IntPtr SendMessageStr(IntPtr h, uint msg, IntPtr wp, string lp);
    public const uint LD=2; public const uint LU=4; public const uint BM_CLICK=0xF5;
    public const uint WM_SETTEXT=0x000C;
}
"@
if (-not ([System.Management.Automation.PSTypeName]'NM5').Type) { Add-Type $nm5src }

$dp   = "C:\Users\User\Desktop\protected-lisp-decompiler.exe"
$desk = [Environment]::GetFolderPath("Desktop")
$maps = @(
    @{S="C:\DESIGNER6"; D="$desk\Designer6_Lisp"},
    @{S="C:\POWPARTS";  D="$desk\Powparts_Lisp"}
)

$enc = [System.Collections.Generic.List[hashtable]]::new()
$cpy = [System.Collections.Generic.List[hashtable]]::new()

foreach ($m in $maps) {
    foreach ($f in (Get-ChildItem $m.S -Recurse -Include "*.lsp","*.fas","*.vlx" -File)) {
        $rel = $f.FullName.Substring($m.S.Length).TrimStart('\')
        $dst = Join-Path $m.D $rel
        $b   = [System.IO.File]::ReadAllBytes($f.FullName)
        $hdr = [System.Text.Encoding]::ASCII.GetString($b[0..[math]::Min(26,$b.Length-1)])
        if ($hdr -match "AutoCAD PROTECTED") {
            $hex = ($b[30..33] | ForEach-Object { $_.ToString("x2") }) -join ""
            if ($hex -eq "645f8530") { $enc.Add(@{S=$f.FullName;D=$dst}) }
            else { $cpy.Add(@{S=$f.FullName;D=$dst}); Write-Host "SKIP: $($f.Name)" }
        } else { $cpy.Add(@{S=$f.FullName;D=$dst}) }
    }
}
Write-Host "Enc:$($enc.Count) Copy:$($cpy.Count)"

foreach ($f in $cpy) {
    $d = Split-Path $f.D -Parent
    if (-not (Test-Path $d)) { New-Item -ItemType Directory $d -Force | Out-Null }
    Copy-Item $f.S $f.D -Force
}
Write-Host "Copied."

function Clk($x, $y) {
    [NM5]::SetCursorPos($x, $y) | Out-Null
    Start-Sleep -Milliseconds 60
    [NM5]::mouse_event([NM5]::LD, $x, $y, 0, 0)
    Start-Sleep -Milliseconds 60
    [NM5]::mouse_event([NM5]::LU, $x, $y, 0, 0)
}

Write-Host "Starting decompiler..."
$proc = Start-Process $dp -PassThru
$dl   = [DateTime]::Now.AddSeconds(15)
while ([DateTime]::Now -lt $dl) {
    $proc.Refresh()
    if ($proc.MainWindowHandle -ne 0) { break }
    Start-Sleep -Milliseconds 150
}
if ($proc.MainWindowHandle -eq 0) { Write-Host "ERROR: no window"; exit 1 }

$hwnd = $proc.MainWindowHandle
Start-Sleep -Milliseconds 1000

$root = [System.Windows.Automation.AutomationElement]::RootElement
$wc   = New-Object System.Windows.Automation.PropertyCondition(
            [System.Windows.Automation.AutomationElement]::NativeWindowHandleProperty, [int]$hwnd)
$win  = $root.FindFirst([System.Windows.Automation.TreeScope]::Children, $wc)
$all  = $win.FindAll([System.Windows.Automation.TreeScope]::Descendants,
            [System.Windows.Automation.Condition]::TrueCondition)

$paneRUN    = $null
$emptyPanes = [System.Collections.Generic.List[object]]::new()
foreach ($el in $all) {
    $n = $el.Current.Name
    if ($n -eq "RUN") { $paneRUN = $el }
    if ($n -eq "" -and $el.Current.NativeWindowHandle -gt 0) { $emptyPanes.Add($el) }
}
$emptyPanes = $emptyPanes | Sort-Object { $_.Current.BoundingRectangle.Y }
$hwndIN  = [IntPtr]($emptyPanes[0].Current.NativeWindowHandle)
$hwndOUT = [IntPtr]($emptyPanes[1].Current.NativeWindowHandle)

$rr = $paneRUN.Current.BoundingRectangle
$rx = [int]($rr.X + $rr.Width / 2)
$ry = [int]($rr.Y + $rr.Height / 2)
Write-Host "RUN at ($rx,$ry)  hwndIN=$hwndIN  hwndOUT=$hwndOUT"

$ok2 = 0; $fail = @(); $tot = $enc.Count

for ($i = 0; $i -lt $tot; $i++) {
    $f   = $enc[$i]; $src = $f.S; $dst = $f.D
    $dd  = Split-Path $dst -Parent
    if (-not (Test-Path $dd)) { New-Item -ItemType Directory $dd -Force | Out-Null }

    Write-Host "[$($i+1)/$tot] $([System.IO.Path]::GetFileName($src))" -NoNewline

    [NM5]::SendMessageStr($hwndIN,  [NM5]::WM_SETTEXT, [IntPtr]::Zero, $src) | Out-Null
    [NM5]::SendMessageStr($hwndOUT, [NM5]::WM_SETTEXT, [IntPtr]::Zero, $dst) | Out-Null
    Start-Sleep -Milliseconds 100

    [NM5]::SetForegroundWindow([IntPtr]$hwnd) | Out-Null
    Start-Sleep -Milliseconds 150
    Clk $rx $ry

    $ok = $false
    $et = [DateTime]::Now.AddSeconds(60)
    while ([DateTime]::Now -lt $et) {
        Start-Sleep -Milliseconds 300
        $allEls = $win.FindAll([System.Windows.Automation.TreeScope]::Descendants,
                      [System.Windows.Automation.Condition]::TrueCondition)
        foreach ($el in $allEls) {
            try {
                $eName = $el.Current.Name
                $eHwnd = $el.Current.NativeWindowHandle
                if ($eName -eq ([char]0x78BA + [char]0x5B9A) -or $eName -match "(?i)^(ok|yes)$") {
                    if ($eHwnd -gt 0) {
                        [NM5]::SendMessage([IntPtr]$eHwnd, [NM5]::BM_CLICK, [IntPtr]::Zero, [IntPtr]::Zero) | Out-Null
                    } else {
                        $er = $el.Current.BoundingRectangle
                        Clk ([int]($er.X+$er.Width/2)) ([int]($er.Y+$er.Height/2))
                    }
                    break
                }
            } catch {}
        }
        if (Test-Path $dst) { $ok = $true; break }
    }
    if ($ok) { $ok2++; Write-Host " OK" } else { $fail += $src; Write-Host " FAIL" }
}

try { $proc.CloseMainWindow() | Out-Null; Start-Sleep -Milliseconds 500 } catch {}
try { if (-not $proc.HasExited) { $proc.Kill() } } catch {}

Write-Host ""
Write-Host "OK:$ok2/$tot  Copy:$($cpy.Count)  Fail:$($fail.Count)"
if ($fail.Count -gt 0) {
    Write-Host "Failed:"
    $fail | ForEach-Object { Write-Host "  $_" }
}
$fail | Out-File "$desk\decrypt_lisp_log.txt" -Encoding UTF8 -Force
Write-Host "Done."
