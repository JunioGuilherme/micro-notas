&& seta paths
set default to sys(5)+"\micronotas"
set path to sys(5)+curdir()+"menus"   additive
set path to sys(5)+curdir()+"forms"   additive
set path to sys(5)+curdir()+"classes" additive
set path to sys(5)+curdir()+"prgs"    additive
set path to sys(5)+curdir()+"imagens" additive

&& Abre classes
set procedure to BancoDeDados additive
set procedure to Notas additive
set procedure to usuarios additive
set procedure to historico additive
set classlib to menus additive