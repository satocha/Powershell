<#　使い方
$f="HTML ファイル|*.html;*.htm,テキストファイル|*.txt,全てのファイル|*.*"
show-FileFolderDialog -title タイトル -Message ファイルを選んでね -filters $f

#"D:\"をルートとしてダイヤログを開く。ユーザがちゃんとファイルを指定するまで何度でも開く。
show-FileFolderDialog -title タイトル -Message ファイルを選んでね -filters $f -InitialDirectory D:\ #-persistent

#フォルダを選択する場合
show-FileFolderDialog -title 次はフォルダ選択 -Message フォルダを選んでね -FolderPicker

#保存のときは-FolderPickerオプションは無視
show-FileFolderDialog -title 保存 -Message フォルダを選んでね -FolderPicker -save

#>

try{
    #アセンブリのロードを確認
    [void][Microsoft.WindowsAPICodePack.Controls.WindowsForms.ExplorerBrowser]
}catch{
    #スクリプトをNASに置いても動作するため、テンポラリに移してからロードする
    "Path\Of\Microsoft.WindowsAPICodePack.dll",
    "Path\Of\Microsoft.WindowsAPICodePack.Shell.dll"|%{
        $Leaf=split-path -leaf $_
        $Dest="$Env:Temp\$Leaf"
        if ( !( test-path "$Dest" ) ){
            Copy-Item $_ $Dest
        }
        add-type -Path $Dest
    }
}
function show-FileFolderDialog{
    param(
        [string]$title="",
        [string]$Message="",
        [string]$filters="全てのファイル|*.*",
        [string]$InitialDirectory="",
        [switch]$FolderPicker,
        [switch]$Save,
        [switch]$persistent
    )
    if ( $Save ){
        $dlg=new-object Microsoft.WindowsAPICodePack.Dialogs.CommonSaveFileDialog( $title )
    } else {
        $dlg=new-object Microsoft.WindowsAPICodePack.Dialogs.CommonOpenFileDialog( $title )
    }

    if ( $Message ){
        $label=new-object Microsoft.WindowsAPICodePack.Dialogs.Controls.CommonFileDialogLabel($Message)
        $dlg.Controls.Add($label)
    }

    if ( $InitialDirectory ){
        $dlg.InitialDirectory=$InitialDirectory
    }
    foreach( $filter in ( $filters -split "," ) ){
        $ary=$filter.split('|')
        if( $ary.length -ne 2){
            continue
        }
        $DisplayName=$ary[0]
        $Extensions=$ary[1]
        $newfil=new-object Microsoft.WindowsAPICodePack.Dialogs.CommonFileDialogFilter($DisplayName,$Extensions)
        $dlg.Filters.Add($newfil)|out-null
    }
    if ($FolderPicker -and !$Save ){
        $dlg.IsFolderPicker=$true
    }
    do{
        if( $dlg.showdialog() -eq [Microsoft.WindowsAPICodePack.Dialogs.CommonFileDialogResult]::ok){
            $dlg.FileName
            break
        }
    }while($persistent)
}
