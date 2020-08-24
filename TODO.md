# To Do List

* Search History by provided string
  * `Get-History | Where-Object {$_.CommandLine -like "*cd c:*"}`
* Search History by provided string and output formatted
  * `Get-History | Where-Object {$_.CommandLine -like "*cd c:*"} | Format-List -Property *`

