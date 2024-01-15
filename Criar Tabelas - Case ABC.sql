CREATE TABLE TIPO_PESSOA ( 			 -- criando a tabela
	
    ID_TIPO_PESSOA integer not null, -- coluna id_tipo_pessa
    DESCRICAO VARCHAR(255) not null, -- coluna que descreve cada id
	
	-- Primary Key
	constraint pk_tp_id_tipo_pessoa primary key (ID_TIPO_PESSOA),
	-- Unique
	constraint un_tp_id_tipo_pessoa unique (DESCRICAO)
);

INSERT INTO TIPO_PESSOA (ID_TIPO_PESSOA, DESCRICAO) VALUES (1, 'Pessoa Física'), (2, 'Pessoa Jurídica'); -- adicionando os valores 'Pessoa fisica' e 'Pessoa Juridica'

CREATE TABLE PESSOA (
	ID_PESSOA INT PRIMARY KEY not null, 								 -- medida adicional de segurança e organização dos dados
	NOME VARCHAR(255) not null,						 					 -- irá utlizar somente o que foi ocupado
	CPF_CNPJ VARCHAR(14) not null, 										 -- não pode ser char porque cpf so tem 11 digitos
	DATA_NASCIMENTO DATE CHECK (DATA_NASCIMENTO <= CURRENT_DATE AND DATA_NASCIMENTO <= CURRENT_DATE - INTERVAL '18 years'), -- verificação de idade <18 [V]
	ID_TIPO_PESSOA INT not null, 										 -- coluna ID_TIPO_PESSOA
	DATA_CRIACAO TIMESTAMP DEFAULT CURRENT_TIMESTAMP,					 -- Coluna de Data, coloca o dia que foi criado o dado
    DATA_ATUALIZACAO TIMESTAMP DEFAULT CURRENT_TIMESTAMP, 				 -- Coluna Data Atualização, coloca o dia que o dado foi modificado pela ultima vez
	FOREIGN KEY (ID_TIPO_PESSOA) REFERENCES TIPO_PESSOA(ID_TIPO_PESSOA), -- referenciando a chave estrangeira a tabela TIPO_PESSOA
	
	constraint un_pss_cpf_cnpj unique (CPF_CNPJ)
);

	 

-- Função que faz a atualização da Data no momento em que for modificado qualquer linha da tabela
CREATE OR REPLACE FUNCTION update_data_atualizacao()
RETURNS TRIGGER AS $$
BEGIN
	-- Define a coluna DATA_ATAULIZACAO para o tempo atual
    NEW.DATA_ATUALIZACAO = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Este bloco cria um trigger chamado "pessoa_before_update"
-- Ele é acionado antes de uma operação de atualização na tabela "PESSOA",
-- executando a função "update_data_atualizacao" para cada linha afetada.
CREATE TRIGGER pessoa_before_update
BEFORE UPDATE ON PESSOA
FOR EACH ROW
EXECUTE FUNCTION update_data_atualizacao();


select * from pessoa;

-- Casos de Teste
update pessoa set nome ='Ana' where id_pessoa = 1
