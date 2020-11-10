define class historico as Custom

	procedure listarHistorico as String

		oSql = newobject("Sql","bancoDeDados.prg")
		
		oSql.executar(" SELECT notas.codigo AS Nota, usuarios.nome, historico.data ,operacao "+;
					  " FROM historico " +;
                      " INNER JOIN usuarios ON usuarios.idUsuario = historico.idUsuario "+;
                      " INNER JOIN notas ON  notas.idNota = historico.idNota","cListarHistorico")
	
*!*		messagebox(oValidarAcesso.getUsusarioAdmin())
	
	endproc
	
	
	procedure limparMemoria
	
		if used("cListarHistorico")
			use in cListarHistorico	
		endif
	
	endproc

enddefine



