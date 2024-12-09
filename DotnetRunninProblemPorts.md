stop the services

*windows firewall

*HNS

*Application guard

remove all the ports with this script in powershell ps1:


```
# PowerShell script to remove all reserved port ranges for TCP protocol

# Run the command to get excluded port ranges
$excludedPorts = netsh int ipv4 show excludedportrange protocol=tcp

# Parse the output to extract port ranges
$lines = $excludedPorts -split "`n" | Where-Object { $_ -match '^\s*\d+\s+\d+' }

foreach ($line in $lines) {
    # Extract Start and End Ports using regex
    if ($line -match '^\s*(\d+)\s+(\d+)') {
        $startPort = [int]$matches[1]
        $endPort = [int]$matches[2]

        # Calculate the number of ports in the range
        $numberOfPorts = $endPort - $startPort + 1

        # Attempt to remove the reserved port range
        Write-Host "Removing reserved port range: Start=$startPort, Count=$numberOfPorts"
        Start-Process -FilePath "netsh" -ArgumentList "int ipv4 delete excludedportrange protocol=tcp startport=$startPort numberofports=$numberOfPorts" -NoNewWindow -Wait
    } else {
        Write-Host "Could not parse line: $line"
    }
}

Write-Host "All reserved port ranges have been processed."
```



and then get a list:

netsh interface ipv4 show excludedportrange protocol=tcp


You can remove or add ports using this command:




netsh int ipv4 add excludedportrange protocol=tcp startport=16000 numberofports=1000 store=persistent





