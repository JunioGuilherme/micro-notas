&& se for ambiante dev esse s� executa at� aqui
if version(2) != 0
	return
endif	

&& seta paths
set default to sys(5)+"\micronotas"
set path to sys(5)+curdir()+"menus"   additive
set path to sys(5)+curdir()+"forms"   additive
set path to sys(5)+curdir()+"classes" additive
set path to sys(5)+curdir()+"prgs"    additive
set path to sys(5)+curdir()+"imagens" additive

&& Abre classes
set library to vfpencryption additive
set procedure to BancoDeDados additive
set procedure to Notas additive
set procedure to usuarios additive
set procedure to historico additive
set classlib to menus additive

&& tela principal
_screen.BackColor = RGB(255,255,255)
_screen.Height = 600
_screen.Width = 1024
_screen.AutoCenter = .t.
_screen.Caption = "Micro-Notas"
_screen.BorderStyle = 3
_screen.MaxButton = .t.
_screen.Closable = .t.
_screen.BorderStyle = 1

&& Abre menus
_screen.AddObject("MenuInicial","mInicial")
_screen.AddObject("MenuNotas","mNotas")
_screen.AddObject("MenuSistema","mSistema")
oValidarAcesso = createobject("validarAcesso")

&&configura��es
set date dmy
set hours to 24
set century on
set deleted on
set sysmenu off
set talk off
set status bar off
set exclusive off

do form acesso

on shutdown quit
wait clear
read events