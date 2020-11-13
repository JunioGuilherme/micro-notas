define class ValidarAcesso as Custom
	hidden usuarioNome
	hidden usuarioCodigo
	hidden usuarioID
	hidden usuarioSenha
	hidden usuarioAdmin  
	
	procedure init && construtor
		oSql = newObject("sql","bancodedados.prg")
		oSql.executar("select idUsuario, nome, codigo, senha, admin from usuarios","cUsuarios")
		
		this.usuarioNome   = ""
		this.usuarioCodigo = ""
		this.usuarioSenha  = ""

	endproc	

	
	&& Setters
	function setUsuarioNome(lcUsuarioNome as String) as String
		this.usuarioNome = alltrim(lcUsuarioNome)
	endfunc
	
	function setUsuarioCodigo(lcUsuarioCodigo as String) as String
		this.usuarioCodigo = alltrim(lcusUarioCodigo)
	endfunc
	
	function setUsuarioSenha(lcUsuarioSenha as String) as String
		this.usuarioSenha = lcUsuarioSenha
	endfunc
	
	function setUsuarioAdmin(lcUsuarioAdmin as String) as String
		this.usuarioAdmin = lcUsuarioAdmin
	endfunc
	
	&& Getters
	function getUsuarioNome as String
		return this.usuarioNome
	endfunc
	
	function getUsuarioSenha as String
		return this.usuarioSenha
	endfunc
	
	function getUsuarioID as String
		return this.usuarioID
	endfunc
		
	function getUsuarioAdmin as String
		return this.usuarioAdmin
	endfunc

	&& valida o login
	function logar as Boolean
		
		select("cUsuarios")
		
		locate for alltrim(cUsuarios.nome) == alltrim(this.usuarioNome);
		or alltrim(str(cUsuarios.codigo)) == alltrim(this.usuarioCodigo)
			
		if found() and alltrim(cUsuarios.senha) = alltrim(this.usuarioSenha)
			this.usuarioID = cUsuarios.idUsuario
			this.usuarioAdmin = cUsuarios.Admin
			return .t.
		else
			return .f.
		endif
		
	endfunc 
	
	procedure verificarAdmin as Boolean
	
	if oValidarAcesso.getUsuarioAdmin()= 0
		messagebox("Somente um administrador tem acesso a essa fun��o",48,_screen.Caption)
		return .f.
	endif
	
	endproc
	
	
	procedure limparMemoria 
		
		if used("cUsuarios")
			use in cUsuarios
		endif
		
	endproc		
	
enddefine

define class UsuarioOperacoes as Custom 

	hidden usuarioNome
	hidden usuarioSenha
	hidden usuarioPapel
	hidden usuarioValorMin
	hidden usuarioValorMax
	hidden usuarioAdmin  
	
	&& Setters
	function setUsuarioNome(lcUsuarioNome as String) as String
		this.usuarioNome = alltrim(lcUsuarioNome)
	endfunc
	
	function setUsuarioSenha(lcUsuarioSenha as String) as String
		this.usuarioSenha = alltrim(lcUsuarioSenha)
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
	
		messagebox("Usu�rio cadastrado com sucesso",64,_screen.caption)
	
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

