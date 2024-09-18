# script from https://superuser.com/a/1712715
# run to bring up gui for toggling power setting visibility:
# ./unhide-power-settings.ps1

Function Toggle-PowerSettingsVisibility {
    $Title         = 'Select option(s) to toggle visibility'
    $PowerSettings = 'HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerSettings'
    @( [PSCustomObject]@{
            Attributes  = 0
            PSChildName = '{ -- No Changes -- }'
            Name        = ' "Safety" row to clear selection'
    } ) +
    @( Get-ChildItem $PowerSettings -Recurse | ? Property -contains 'Attributes' | Get-ItemProperty |
        Select Attributes, PSCHildName,
               @{ N = 'Name' ; E = { $_.FriendlyName.Split(',')[-1] }} ) | Sort PSChildName |
    Out-GridView -Passthru -Title $Title | ForEach {
        $Splat = @{
            Path  = Resolve-Path "$PowerSettings\*\$($_.PSChildName)"
            Name  = 'Attributes'
            Value = $_.Attributes -bXor 0x0000003 
        }
        Set-ItemProperty @Splat
    }
}
Toggle-PowerSettingsVisibility