define class Notas as Custom
	
	hidden papelUsuario
	hidden dataEmissaoNota
	
	procedure init && Construtor
		this.dataEmissaoNota = "%"
	endproc
	

	&& Setters
	function setPapelUsuario(lcPapelUsuario)
		this.papelUsuario = lcPapelUsuario
	endfunc
	
	function setdataEmissaoNota(lcDataEmissaoNota)
		if !empty(lcDataEmissaoNota)
			this.DataEmissaoNota = lcDataEmissaoNota
		else		
			lcDataEmissaoNota = "%"
		endif	
	endfunc
	

	&& Getters
	function getPapelUsuario
		return this.PapelUsuario
	endfunc
	
	function getDataEmissaoNota
		return this.dataEmissaoNota
	endfunc
	
	
	procedure consultarNotas as String
		
		oSql = newObject("sql","bancodedados.prg")
		oSql.executar("select valorMin, valorMax, papel, idUsuario from usuarios where idUsuario = ?oValidarAcesso.getUsuarioId() ","cFiltroValoresUsuarios")			
		
		
		lcDataEmissaoNota = this.DataEmissaoNota
		
		if cFiltroValoresUsuarios.papel = "visto"
			oSql.executar(" SELECT dataEmissao, valorMercadoria, valorDesconto, valorFrete, valorTotal, vistos, idNota, qtdVistos "+;
		   			 	  " FROM notas "+;
					      " INNER JOIN faixas ON faixas.idFaixa = notas.idFaixa "+;
					      " WHERE faixas.vistos > 0 "+;
					      " AND faixas.vistos > notas.qtdVistos "+;
					      " AND idNota NOT IN (SELECT idNota FROM historico WHERE idUsuario = ?cFiltroValoresUsuarios.idUsuario) "+;
					      " AND valortotal BETWEEN ?cFiltroValoresUsuarios.ValorMin and ?cFiltroValoresUsuarios.ValorMax and status = 0 "+;
					      " AND dataEmissao like ?lcDataEmissaoNota ", "cConsultarNotas")
				
		
		
		else  && aprova��es
			oSql.executar(" SELECT dataEmissao, valorMercadoria, valorDesconto, valorFrete, valorTotal, idNota, aprovacoes, qtdAprovacoes"+;
		   			  	  " FROM notas"+;
					      " INNER JOIN faixas ON faixas.idFaixa = notas.idFaixa"+;
					      " WHERE faixas.aprovacoes > 0"+;
					      " AND faixas.vistos >= notas.qtdVistos "+;
					      " AND idNota NOT IN (SELECT idNota FROM historico WHERE idUsuario = ?cFiltroValoresUsuarios.idUsuario)"+;
					      " and valortotal BETWEEN ?cFiltroValoresUsuarios.ValorMin and ?cFiltroValoresUsuarios.ValorMax and status = 0"+;
					      " AND dataEmissao like ?lcDataEmissaoNota ", "cConsultarNotas")
		
		endif		
	
	endproc
	
	procedure mudaStatus as String
		
		if reccount("cConsultarNotas")=0
			cancel
		else
		endif
		
		oSql = newObject("sql","bancodedados.prg")
		lcIdNotaAtual = cConsultarNotas.idNota		 
		
		if messagebox("Confirma o visto da nota selecionada?",4+32+256,_screen.Caption)!=7	
			
			if cFiltroValoresUsuarios.papel = "aprovacao"	
				
								
				if  cConsultarNotas.aprovacoes - cConsultarNotas.qtdAprovacoes = 1
					oSql.executar(" INSERT INTO historico (idHistorico, idNota, idUsuario, data, operacao) VALUES "+; 
					              " (?sys(2015), ?lcIdNotaAtual, ?oValidarAcesso.getUsuarioId(), Now(), 'aprovacao')")
					
					
					oSql.executar(" UPDATE notas SET status = 1 WHERE idNota = ?lcIdNotaAtual ")	
					
					oSql.executar(" UPDATE notas SET qtdAprovacoes = qtdAprovacoes+1 WHERE idNota = ?lcIdNotaAtual ")
				else
					
					oSql.executar(" INSERT INTO historico (idHistorico, idNota, idUsuario, data, operacao) VALUES "+; 
					              " (?sys(2015), ?lcIdNotaAtual, ?oValidarAcesso.getUsuarioId(), Now(), 'aprovacao')")		              
					
				endif

			else 
				oSql.executar(" INSERT INTO historico (idHistorico, idNota, idUsuario, data, operacao) VALUES "+; 
							  " (?sys(2015), ?lcIdNotaAtual, ?oValidarAcesso.getUsuarioId(), Now(), 'visto') ")
									
				oSql.executar(" UPDATE notas SET qtdVistos = qtdVistos+1 WHERE idNota = ?lcIdNotaAtual ")
								
			endif
		endif	
	endproc
	
	procedure limparMemoria as String
	
		do case
		case used("cFiltroValoresUsuarios")
			use in cFiltroValoresUsuarios
		case used("cConsultarNotas")
			use in cConsultarNotas
		case used("cCursor") && cursor padr�o da classe
			use in cCursor
		endcase
					
			
	endproc
	
enddefine