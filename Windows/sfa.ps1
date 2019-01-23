<#
	.Title
		SFA (School File Administration)

	.Description
		An administration tool to copy or delete files from any student's
			home folder (their H:\ drive).

	.Syntax
		copy $student_full_name - Copy $student_full_name's home folder to yours.
			- May fail if their home folder is larger than the space left in yours.
				It is recommended to backup copied data to avoid this issue
				when copying data from multiple folders.
		delete $student_full_name - Delete $student_full_name's home folder.
#>

function Main {
	$year_dirs = "2019", "2020", "2021", "2022", "2023"
	$cmd = Read-Host -Prompt "SFA> "
	if($cmd.contains("copy") {
		$student_name = $cmd[5:]
		$cmd = $cmd[:4]
	} else if($cmd.contains("delete") {
		$student_name = $cmd[7:]
		$cmd = $cmd[:6]
	} else {
		Main
	}
	$student_name -replace " ", "."
	for($i = 0; $i -le $year_dirs.Count; $i++) {
		if(Test-Path "\\serverfs02\$year_dirs[$i]\$student_name) {
			$student_folder = "\\serverfs02\$year_dirs[$i]\$student_name"
			$student_year = [int]$year_dirs - ([int](get-date - Format yyyy) - 8)
			Write-Output "Name: $student_name"
			Write-Output "Year: $student_year"
			if($cmd -eq "delete") {
				Remove-Item -Path "$student_folder\*" -Recurse
			} else {
				Copy-Item -Path $student_folder -Destination "H:\" -Container -Recurse
			}
		}
	}
}
Main
