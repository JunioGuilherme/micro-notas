define class sql as Custom

	hidden SGBD
	
	procedure init && Construtor
		this.SGBD = sqlstringconnect("DRIVER={MySQL ODBC 5.1 Driver};database=micronotas;SERVER=localhost;UID=root;PWD=1234;PORT=3306;OPTION=2051;")
	endproc

	procedure executar(lcQrySql,lcNomeCursor as String)
	
		if empty(lcNomeCursor)
			lcNomeCursor = "cCursor"
		endif
		
		_cliptext = lcQrySql
		lnVerifica = sqlexec(this.SGBD,lcQrySql,lcNomeCursor) && verifica se é valido
		
		if lnVerifica <= 0
			messagebox("Não foi possível concluir a operação verifique os campos",48,_screen.caption) && mensagem generica
		endif
			
	endproc

	procedure destroy
		sqldisconnect(this.SGBD)
	endproc

enddefine