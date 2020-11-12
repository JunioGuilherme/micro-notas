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
	
	
	procedure consultarNotas
		
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
			oSql.executar(" SELECT notas.codigo, dataEmissao, valorMercadoria, valorDesconto, valorFrete, valorTotal, idNota, aprovacoes, qtdAprovacoes"+;
		   			  	  " FROM notas"+;
					      " INNER JOIN faixas ON faixas.idFaixa = notas.idFaixa"+;
					      " WHERE faixas.aprovacoes > 0"+;
					      " AND faixas.vistos >= notas.qtdVistos "+;
					      " AND idNota NOT IN (SELECT idNota FROM historico WHERE idUsuario = ?cFiltroValoresUsuarios.idUsuario)"+;
					      " and valortotal BETWEEN ?cFiltroValoresUsuarios.ValorMin and ?cFiltroValoresUsuarios.ValorMax and status = 0"+;
					      " AND dataEmissao like ?lcDataEmissaoNota ", "cConsultarNotas")
		
		endif		
	
	endproc
	
	procedure mudaStatus
		
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

define class NotaOperacoes as Custom 

	hidden notaData
	hidden notaValor
	hidden notaDesconto
	hidden notaFrete
	hidden notaTotal
	
	&& Setters
	function setUsuarioNome(lcNotaData as String) as String
		this.usuarioNome = alltrim(lcUsuarioNome)
	endfunc
	
	function setUsuarioSenha(lcUsuarioSenha as String) as String
		this.usuarioSenha = chrtran(hash(lcUsuarioSenha),['"],[a])
	endfunc
	
	function setUsuarioPapel(lcUsuarioPapel as String) as String
		this.usuarioPapel = alltrim(lcUsuarioPapel)
	endfunc
	
	function setUsuarioValorMin(lcUsuarioValorMin as String) as String
		this.usuarioValorMin = lcUsuarioValorMin
	endfunc
	
	function setUsuarioValorMax(lcUsuarioValorMax as String) as String
		this.usuarioValorMax = lcUsuarioValorMax
	endfunc
	
	function setUsuarioAdmin(lcUsuarioAdmin as String) as String
		this.usuarioAdmin = lcUsuarioAdmin
	endfunc

	
	procedure listarUsuarios
		oSql = newObject("sql","bancodedados.prg")
		oSql.executar("select codigo, trim(nome) as nome, papel, valorMin, valorMax, idUsuario, admin, senha from usuarios where idUsuario != ?oValidarAcesso.getUsuarioID() ","cListarUsuarios")
	endproc 
	
	procedure editarUsuario
		
		if empty(this.usuarioSenha)
			this.usuarioSenha = cListarUsuarios.senha
		endif	
		
		text to lcComandoSql textmerge noshow
			
		UPDATE usuarios SET nome = '<<this.usuarioNome>>', senha = '<<this.usuarioSenha>>', papel = '<<this.usuarioPapel>>',
		valorMin = '<<this.usuarioValorMin>>', valorMax = '<<this.usuarioValorMax>>', dataModi = now(), 
		admin = '<<this.usuarioAdmin>>' WHERE idUsuario = '<<cListarUsuarios.idUsuario>>'
		
		endtext
		
		oSql = newObject("sql","bancodedados.prg")
		oSql.executar(lcComandoSql)	
		messagebox("Dados Atualizados",64,_screen.caption)
	endproc
	
	procedure cadastrarUsuario
		
		if empty(this.usuarioSenha)
			messagebox("Informe uma senha",48,_screen.Caption)
			return .f.
		endif
		
		locate for alltrim(cListarUsuarios.nome) == alltrim(this.usuarioNome)
		if found()
			messagebox("J� existe um usu�rio com esse login/nome",48,_screen.Caption)
			return .f.
		endif	
		
		text to lcComandoSql textmerge noshow
			
		INSERT INTO usuarios (idUsuario, nome, senha, papel, valorMin, valorMax, dataCria, dataModi, admin) 
		VALUES ('<<sys(2015)>>','<<this.usuarioNome>>','<<this.usuarioSenha>>', 
		'<<this.usuarioPapel>>','<<this.usuarioValorMin>>','<<this.usuarioValorMax>>', now(), now(), '<<this.usuarioAdmin>>') 
		
		endtext
	
		oSql = newObject("sql","bancodedados.prg")
		oSql.executar(lcComandoSql)	
	
		messagebox("Cliente Cadastrado com sucesso",64,_screen.caption)
	
	endproc
	
	procedure excluirUsuario
		
		if messagebox("Confirma a exlus�o desse registor ? ",32+4+256,_screen.Caption) != 6
			return
		endif	
		oSql = newObject("sql","bancodedados.prg")
		oSql.executar("DELETE FROM usuarios WHERE idUsuario = ?cListarUsuarios.idUsuario" ,"cListarUsuarios")
	
	endproc

	procedure limparMemoria
		
		if used("cListarUsuarios")
			use in cListarUsuarios	
		endif	
	
	endproc

enddefine

