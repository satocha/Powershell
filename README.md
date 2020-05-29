# powershell_gui(powershellでGUI表示)
GUI表示ができるpowershellの自作関数をまとめてみました。基本、NASに置いて、いろんなマシンから使うことを考えているので、必要なライブラリなどはパッケージ管理ではなく、どこかのパスにDLLを置いてある前提で作っています。
##1. FileFolderDialog.ps1<br>
windows.formsのOpenFileDialogではフォルダが選択できないこと、何をしてほしいかユーザに伝えるにはタイトルにいれるしかないことなど不満があったので作りました。<br>
WindowsAPICodePackを使っているのでdllを取ってくる必要があります。<br>
入手先：[https://www.nuget.org/packages/WindowsAPICodePack-Core/1.1.1](https://www.nuget.org/packages/WindowsAPICodePack-Core/1.1.1)<br>
入手先：[WindowsAPICodePack-Shell](https://www.nuget.org/packages/WindowsAPICodePack-Shell/1.1.1)
