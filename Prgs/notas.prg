define class Notas as Custom
	
	hidden dataEmissaoNota
	hidden valorMercadoria 
	hidden valorDesconto
	hidden valorFrete
	hidden valorTotal
	hidden dataEmissao
	
	procedure init
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
	
	function setValorMercadoria(lcValorMercadoria )
		this.valorMercadoria = lcValorMercadoria
	endfunc
	
	function setValorDesconto(lcValorDesconto)
		if empty(lcValorDesconto)
			lcValorDesconto	= 0
		endif
		this.valorDesconto = lcValorDesconto
	endfunc
	
	function setValorFrete(lcValorFrete)
		if empty(lcValorFrete)
			lcValorFrete = 0
		endif
		this.valorFrete = lcValorFrete
	endfunc

	function setValorTotal(lcValorTotal)
		lcValorTotal = this.valorMercadoria + this.valorFrete
		lcValorTotal = lcValorTotal - this.ValorDesconto
		this.valorTotal = lcValorTotal
	endfunc
	
	function setDataEmissao(lcDataEmissao)
		this.dataEmissao = lcDataEmissao
	endfunc
	
	
	&& Getters
	function getDataEmissaoNota
		return this.dataEmissaoNota
	endfunc
	
	procedure ListarNotas && Regras para mostrar conforme o teste
		
		oSql = newObject("sql","bancodedados.prg")
		oSql.executar("select valorMin, valorMax, papel, idUsuario from usuarios where idUsuario = ?oValidarAcesso.getUsuarioId() ","cFiltroValoresUsuarios")			
		lcDataEmissaoNota = this.DataEmissaoNota
		
		if cFiltroValoresUsuarios.papel = "visto"				
			text to lcComandoSql textmerge noshow
				
				SELECT notas.codigo as codigo ,dataEmissao, valorMercadoria, valorDesconto, valorFrete, valorTotal, vistos, aprovacoes, idNota, qtdVistos
		   		FROM notas
				INNER JOIN faixas ON faixas.idFaixa = notas.idFaixa
				WHERE faixas.vistos > 0
				AND faixas.vistos > notas.qtdVistos
				AND idNota NOT IN (SELECT idNota FROM historico WHERE idUsuario = '<<cFiltroValoresUsuarios.idUsuario)>>')
				AND valortotal BETWEEN '<<cFiltroValoresUsuarios.ValorMin>>' and '<<cFiltroValoresUsuarios.ValorMax>>' and status = 0
				AND dataEmissao like '<<lcDataEmissaoNota>>'
		
			endtext
			oSql.executar(lcComandoSql,"cListarNotas")
		
		
		else  && aprovações
			text to lcComandoSql textmerge noshow
			              
	          SELECT notas.codigo as codigo, dataEmissao, valorMercadoria, valorDesconto, valorFrete, valorTotal, idNota, aprovacoes, vistos, qtdAprovacoes
	   		  FROM notas
		      INNER JOIN faixas ON faixas.idFaixa = notas.idFaixa
		      WHERE faixas.aprovacoes > 0
		      AND faixas.vistos = notas.qtdVistos
		      AND idNota NOT IN (SELECT idNota FROM historico WHERE idUsuario = '<<cFiltroValoresUsuarios.idUsuario>>')
		      AND valortotal BETWEEN '<<cFiltroValoresUsuarios.ValorMin>>' AND '<<cFiltroValoresUsuarios.ValorMax>>' and status = 0
		      AND dataEmissao like '<<lcDataEmissaoNota>>'
		
		
			endtext
			oSql.executar(lcComandoSql,"cListarNotas")
		
		endif		
	
	endproc
	
	procedure mudarStatusNota && Regras para mudar status comforme o teste
		
		if reccount("cListarNotas")=0
			return .f.
		else
		endif
		
		oSql = newObject("sql","bancodedados.prg")
		lcIdNotaAtual = cListarNotas.idNota		 
		
		if messagebox("Confirma o Visto/Aprovação da nota selecionada?",4+32+256,_screen.Caption)!=7	
			
			if cFiltroValoresUsuarios.papel = "aprovacao"	
				
				if  cListarNotas.aprovacoes - cListarNotas.qtdAprovacoes = 1 && verifica se precisa mudar satus
					oSql.executar(" INSERT INTO historico (idHistorico, idNota, idUsuario, data, operacao) VALUES "+; 
					              " (?sys(2015), ?lcIdNotaAtual, ?oValidarAcesso.getUsuarioId(), Now(), 'aprovacao')")
					
					
					oSql.executar(" UPDATE notas SET status = 1 WHERE idNota = ?lcIdNotaAtual ")	
					oSql.executar(" UPDATE notas SET qtdAprovacoes = qtdAprovacoes+1 WHERE idNota = ?lcIdNotaAtual ")
				else
					
					oSql.executar(" INSERT INTO historico (idHistorico, idNota, idUsuario, data, operacao) VALUES "+; 
					              " (?sys(2015), ?lcIdNotaAtual, ?oValidarAcesso.getUsuarioId(), Now(), 'aprovacao')")		              
					
					oSql.executar(" UPDATE notas SET qtdAprovacoes = qtdAprovacoes+1 WHERE idNota = ?lcIdNotaAtual ")	
				
				endif

			else 
				if cListarNotas.vistos - cListarNotas.qtdVistos = 1 and cListarNotas.aprovacoes = 0
				
					oSql.executar(" UPDATE notas SET status = 1 WHERE idNota = ?lcIdNotaAtual ")	
					oSql.executar(" INSERT INTO historico (idHistorico, idNota, idUsuario, data, operacao) VALUES "+; 
								  " (?sys(2015), ?lcIdNotaAtual, ?oValidarAcesso.getUsuarioId(), Now(), 'visto') ")
					oSql.executar(" UPDATE notas SET qtdVistos = qtdVistos+1 WHERE idNota = ?lcIdNotaAtual ")
				else
			
					oSql.executar(" INSERT INTO historico (idHistorico, idNota, idUsuario, data, operacao) VALUES "+; 
								  " (?sys(2015), ?lcIdNotaAtual, ?oValidarAcesso.getUsuarioId(), Now(), 'visto') ")
					oSql.executar(" UPDATE notas SET qtdVistos = qtdVistos+1 WHERE idNota = ?lcIdNotaAtual ")
				endif					
			
			endif
		endif	
	endproc
	
	procedure editarNota
		
		oSql = newObject("sql","bancodedados.prg")
		
		text to lcComandoSql textmerge noshow
			SELECT idFaixa,MAX(faixaFim) AS faixa FROM faixas WHERE faixaFim >= '<<this.valorTotal>>'
		endtext 
		oSql.executar(lcComandoSql,"cFaixa")	
		
		text to lcComandoSql textmerge noshow
		
			UPDATE notas SET valorMercadoria = '<<this.valorMercadoria>>', valorDesconto = '<<this.valorDesconto>>', 
			idFaixa = '<<cFaixa.idFaixa>>' ,valorFrete = '<<this.valorFrete>>', valorTotal = '<<this.valorTotal>>',
			dataModi = now() WHERE idNota = '<<cListarNotas.idNota>>'
		
		endtext
				
		oSql.executar(lcComandoSql)	
		messagebox("Dados Atualizados",64,_screen.caption)
	
	endproc
	
	procedure cadastrarNota
				
		oSql = newObject("sql","bancodedados.prg")
		
		text to lcComandoSql textmerge noshow
			SELECT trim(idFaixa) as idFaixa,MAX(faixaFim) AS faixa FROM faixas WHERE faixaFim >= '<<this.valorTotal>>'
		endtext 
		oSql.executar(lcComandoSql,"cFaixa")	
		
		text to lcComandoSql textmerge noshow
			
			INSERT INTO notas (idNota ,idFaixa ,valorMercadoria ,valorDesconto ,valorFrete ,valorTotal ,status ,dataEmissao ,dataModi ,qtdVistos ,qtdAprovacoes) 
			VALUES ('<<sys(2015)>>', '<<cFaixa.idFaixa>>', '<<this.valorMercadoria>>', '<<this.valorDesconto>>', '<<this.valorFrete>>', '<<this.valorTOtal>>', '0', now(), now(), '0', '0'); 
		
		endtext
				
		oSql.executar(lcComandoSql)	
		messagebox("Dados Atualizados",64,_screen.caption)
	
	endproc
	
	
	procedure excluirNota
	
		if messagebox("Confirma a exlusão desse registro ? ",32+4+256,_screen.Caption) != 6
			return
		endif	
		oSql = newObject("sql","bancodedados.prg")
		oSql.executar("DELETE FROM notas WHERE idNota = ?cListarNotas.idNota")
	
	endproc
	
	procedure limparMemoria as String
	
		do case
		case used("cFiltroValoresUsuarios")
			use in cFiltroValoresUsuarios
		case used("cListarNotas")
			use in cListarNotas
		case used("cFaixa")
			use in cFaixa
		case used("cCursor") && cursor padrão da classe
			use in cCursor
		endcase
					
			
	endproc
	
enddefine

