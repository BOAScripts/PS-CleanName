<#
----------------------------------------------------------------------------------------
PURPOSE : 2 Functions to clean strings for building a {Display Name} and an {Email Name}
----------------------------------------------------------------------------------------

Display Name:
    - All (ascii) letters  accepted
    - Single quote (') and hyphen (-) accepted
    - Upper case first letter.
    - Upper case first letters after a whitespace, a single quote or an hyphen

Mail Name:
    - Only lower case
    - Replace special characters with a-z characters
    - Remove non a-z characters

Print test case with
$firstname = "fRa<nç/ois-piER+~re "
$lastname = "  D'éK=:;ko   "
#>

function Get-CleanedDisplayName ([string]$Strinput)
{
    $string = $Strinput.Trim()
    $string = $string -replace "\s+", " " # replace extra whitespaces with 1 whitespace
    $string = $string -replace "[^A-Za-zŒŽœžŸÀ-ÖØ-öø-ÿ\s'-]" # remove anything but (letters in ASCII;';-)
    $string = (Get-Culture).TextInfo.ToTitleCase($string) # Title Case the string (but not after a single quote)
    # Upper Case after a single quote (only first occurrence)
    if ($string -match "(?<=')."){
        $string  = $string -replace "(?<=').", (Select-String -Pattern "(?<=')." -InputObject $string).Matches[0].value.ToUpper()
    }
    Return $string 
}

function Get-CleanedMailName ([string]$Strinput)
{
    $string = $Strinput.Replace(" ","").ToLower()

    $replaceTable = @{"ß"="ss";"à"="a";"á"="a";"â"="a";"ã"="a";"ä"="a";"å"="a";"æ"="ae";"ç"="c";"è"="e";"é"="e";"ê"="e";"ë"="e";"ì"="i";"í"="i";"î"="i";"ï"="i";"ð"="d";"ñ"="n";"ò"="o";"ó"="o";"ô"="o";"õ"="o";"ö"="o";"ø"="o";"ù"="u";"ú"="u";"û"="u";"ü"="u";"ý"="y";"þ"="p";"ÿ"="y"}
    foreach($key in $replaceTable.Keys){
        $string = $string -Replace($key,$replaceTable.$key)
    }
    $string = $string -replace "[^a-z]"

    Return $string
}

# Display test

$firstname = "fRa<nç/ois-piER+~re "
$lastname = "  D'éK=:;ko   "
Write-Host("Test String ='$firstname $lastname'")

$Dfname = Get-CleanedDisplayName($firstname)
$Dlname = Get-CleanedDisplayName($lastname)
Write-Host("Display Name ='$Dfname $Dlname'")

$Mfname = Get-CleanedMailName($firstname)
$Mlname = Get-CleanedMailName($lastname)
Write-Host("Mail Name ='$Mfname$Mlname'")