define class ValidarAcesso as Custom
	hidden usuarioNome
	hidden usuarioCodigo
	hidden usuarioID
	hidden usuarioSenha
	
	procedure init && construtor
		oSql = newObject("sql","bancodedados.prg")
		oSql.executar("select idUsuario, nome, codigo, senha, admin from usuarios","cUsuarios")
		
		this.usuarioNome   = ""
		this.usuarioCodigo = ""
		this.usuarioSenha  = ""
		this.usuarioAdmin  = cUsuarios.admin

	endproc	

	
	&& Setters
	function setUsuarioNome(lcUsuarioNome as String) as String
		this.usuarioNome = lcUsuarioNome
	endfunc
	
	function setUsuarioCodigo(lcUsuarioCodigo as String) as String
		this.usuarioCodigo = lcusUarioCodigo
	endfunc
	
	function setUsuarioSenha(lcUsuarioSenha as String) as String
		this.usuarioSenha = lcUsuarioSenha
	endfunc
	
	
	&& Getters
	function getUsuarioNome as String
		return this.usuarioNome
	endfunc
	
	function getUsuarioID as String
		return this.usuarioID
	endfunc
		
	function getUsusarioAdmin as String
		return this.usuarioAdmin
	endfunc
	
	&& valida o login
	function logado as Boolean
		
		locate for alltrim(cUsuarios.nome) == alltrim(this.usuarioNome);
		or alltrim(str(cUsuarios.codigo)) == alltrim(this.usuarioCodigo)
		
		if found()and alltrim(cUsuarios.senha) == hash(alltrim(this.usuarioSenha))
			this.usuarioID = cUsuarios.idUsuario
			return .t.
		else
			return .f.
		endif
		
	endfunc 
	
	procedure limparMemoria as String
	
		if used("cUsuarios")
			use in cUsuarios
		endif	
	
enddefine

