define class historico as Custom

	procedure listarHistorico
		
		text to lcComandoSql textmerge noshow
			SELECT notas.codigo AS Nota, usuarios.nome, historico.data, operacao, notas.status
			FROM historico
	        INNER JOIN usuarios ON usuarios.idUsuario = historico.idUsuario
	        INNER JOIN notas ON  notas.idNota = historico.idNota
        endtext
	
	oSql = newobject("Sql","bancoDeDados.prg")
	oSql.Executar(lcComandoSql,"cListarHistorico")
	
	endproc
	
	
	procedure limparMemoria
	
		if used("cListarHistorico")
			use in cListarHistorico	
		endif
	
	endproc

enddefine

