-- Comando que cria um procedimento armazenado chamdo inserir_pessoa
CREATE PROCEDURE inserir_pessoa(
    IN p_id_pessoa INT,         -- Parâmetro ID único da pessoa
    IN p_nome VARCHAR(255),		-- Parãmetro Nome da pessoa
    IN p_cpf VARCHAR(14),		-- Parâmetro Numero do CPF ou CNPJ da pessoa
    IN p_data_nascimento DATE,  -- Parâmetro Data de Nascimento da pessoa
    IN p_id_tipo_pessoa INT		-- Parâmetro ID do tipo de pessoa
)

LANGUAGE plpgsql				-- Definição da linguagem voltada para o PostgresSQL

AS $$							-- Início do comando para inserir 

 -- Dentro do bloco BEGIN...END;, está a instrução de inserção na tabela pessoa
BEGIN
     -- Verifica se o tipo de pessoa é Pessoa Física
    IF p_id_tipo_pessoa = 1 THEN 																	--CASOS DE ERRO
        -- Garante que o CPF tem 11 caracteres														-- 1, 'Guilherme', '12345678901', '2005-12-06',1} mesmo
        IF LENGTH(p_cpf) <> 11 THEN																	-- 2, 'Matheus', '12345678901', '2004-12-06',1}      cpf  erro
            RAISE EXCEPTION 'CPF deve ter 11 caracteres.';											-- 2, 'Matheus', '15565061000173','2006-12-06',2} < 18 anos 									
        END IF;																						-- 3, 'Julia', '16565161000175', '2005-12-06',1} Vai dar erro cadastrando cpf com cnpj
    -- Verifica se o tipo de pessoa é Pessoa Jurídica												-- 3, 'Julia', '14345878701', '2005-12-06',2 } Vai dar erro cadastrando cnpj com cpf
    ELSIF p_id_tipo_pessoa = 2 THEN																	
																									-- CASOS DE ACERTO 
        -- Garante que o CNPJ tem 14 caracteres														-- 2, 'Matheus', '15565061000173','2005-12-06',2											
        IF LENGTH(p_cpf) <> 14 THEN																	-- 3, 'Julia', '16565161000175', '2005-12-06',2
																									-- 4, 'Jorge', '14345878701', '2005-12-06',1
            RAISE EXCEPTION 'CNPJ deve ter 14 caracteres.';										  
        END IF;
    ELSE
        -- Se o tipo de pessoa não for reconhecido
        RAISE EXCEPTION 'Tipo de pessoa desconhecido.';
    END IF;

    -- Inserção na tabela pessoa
    INSERT INTO pessoa (id_pessoa, nome, cpf_cnpj, data_nascimento, id_tipo_pessoa)
    VALUES (p_id_pessoa, p_nome, p_cpf, p_data_nascimento, p_id_tipo_pessoa);
END;
$$; 							-- Fim do comando

-- Chama a procedure para armazenar os dados pedidos 
CALL inserir_pessoa(4, 'Jorge', '14345878701', '2005-12-06', 1);

select * from pessoa;
