--Script feito para o PSET1 do professor Abrantes--
--Nome: Ricardo Ramalho Marques--
--Matricula: 202308031--

--Deleta o SCHEMA caso exista--
DROP SCHEMA     IF EXISTS lojas CASCADE

;
--Deleta o BD caso já exista--
DROP DATABASE   IF EXISTS uvv

;
--Deleta o usuário caso já exista--
DROP USER       IF EXISTS ricardo

;
--Cria o usuário do BD--
CREATE USER ricardo WITH encrypted password '115103'
CREATEROLE
CREATEDB
LOGIN

;
--Cria o BD--
CREATE DATABASE uvv
       OWNER = ricardo
       TEMPLATE = template0
       ENCODING = UTF8
       LC_COLLATE = 'pt_BR.UTF-8'
       LC_CTYPE = 'pt_BR.UTF-8'
       ALLOW_CONNECTIONS = TRUE
      
       ;
      
\c "host=localhost dbname=uvv user=ricardo password=115103"

CREATE SCHEMA lojas

;

ALTER SCHEMA lojas OWNER TO ricardo

;


SET SEARCH_PATH TO lojas, "$user", lojas

;

--Cria a tabela clientes--
CREATE TABLE lojas.clientes (
    cliente_id SERIAL PRIMARY KEY,
    email VARCHAR(255) NOT NULL,
    nome VARCHAR(255) NOT NULL,
    telefone1 VARCHAR(20),
    telefone2 VARCHAR(20),
    telefone3 VARCHAR(20)
);


--Faz os comentários das colunas da tabela Clientes--
COMMENT ON TABLE lojas.clientes             IS 'Tabela referente aos clientes cadastrados';
COMMENT ON COLUMN lojas.clientes.cliente_id IS 'ID dos clientes cadastrados';
COMMENT ON COLUMN lojas.clientes.email      IS 'E-mail dos clientes cadastrados';
COMMENT ON COLUMN lojas.clientes.nome       IS 'Nome dos clientes das lojas cadastradas';
COMMENT ON COLUMN lojas.clientes.telefone1  IS 'Telefone 1 do cliente';
COMMENT ON COLUMN lojas.clientes.telefone2  IS 'Telefone 2 do cliente';
COMMENT ON COLUMN lojas.clientes.telefone3  IS 'Telefone 3 do cliente';


--Cria a tabela Produtos--
CREATE TABLE lojas.produtos (
    produto_id SERIAL PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    preco_unitario NUMERIC(10, 2),
    detalhes BYTEA,
    imagem BYTEA,
    imagem_mime_type VARCHAR(512),
    imagem_arquivo VARCHAR(512),
    imagem_charset VARCHAR(512),
    imagem_ultima_atualizacao DATE
    );
   
   
--Faz os comentários das colunas da tabela Produtos--   
COMMENT ON TABLE lojas.produtos                            IS 'Tabela referente aos produtos das lojas cadastradas';
COMMENT ON COLUMN lojas.produtos.produto_id                IS 'ID dos produtos das lojas cadastradas';
COMMENT ON COLUMN lojas.produtos.nome                      IS 'Nome dos produtos das lojas cadastradas';
COMMENT ON COLUMN lojas.produtos.preco_unitario            IS 'Preço unitário dos produtos';
COMMENT ON COLUMN lojas.produtos.detalhes                  IS 'Detalhes do produto cadastrado';
COMMENT ON COLUMN lojas.produtos.imagem                    IS 'Imagem dos produtos cadastrados';
COMMENT ON COLUMN lojas.produtos.imagem_mime_type          IS 'MIME type da imagem dos produtos cadastrados';
COMMENT ON COLUMN lojas.produtos.imagem_arquivo            IS 'Arquivo da imagem dos produtos cadastrados';
COMMENT ON COLUMN lojas.produtos.imagem_charset            IS 'Charset da imagem dos produtos cadastrados';
COMMENT ON COLUMN lojas.produtos.imagem_ultima_atualizacao IS 'Última atualização da imagem do produto';


--Cria a tabela Lojas--
CREATE TABLE lojas.lojas (
    loja_id SERIAL    PRIMARY KEY,
    nome              VARCHAR(255) NOT NULL,
    endereco_fisico   VARCHAR(512),
    endereco_web      VARCHAR(100),
    latitude          NUMERIC,
    longitude         NUMERIC,
    logo BYTEA,
    logo_charset      VARCHAR(512),
    logo_mime_type    VARCHAR(512),
    logo_arquivo      VARCHAR(512),
    logo_ultima_atualizacao DATE
   );



--Faz os comentários das colunas da tabela Lojas--
COMMENT ON TABLE lojas.lojas                          IS 'Tabela que armazena informações gerais sobre a loja';
COMMENT ON COLUMN lojas.lojas.loja_id                 IS 'ID das lojas cadastradas';
COMMENT ON COLUMN lojas.lojas.nome                    IS 'Nome das lojas cadastradas';
COMMENT ON COLUMN lojas.lojas.endereco_fisico         IS 'Endereço físico das lojas';
COMMENT ON COLUMN lojas.lojas.endereco_web            IS 'Endereço web das lojas cadastradas';
COMMENT ON COLUMN lojas.lojas.latitude                IS 'Latitude das lojas';
COMMENT ON COLUMN lojas.lojas.longitude               IS 'Longitude das lojas físicas';
COMMENT ON COLUMN lojas.lojas.logo                    IS 'Logo da loja cadastrada';
COMMENT ON COLUMN lojas.lojas.logo_charset            IS 'Charset da logo da loja cadastrada';
COMMENT ON COLUMN lojas.lojas.logo_mime_type          IS 'MIME type da logo da loja cadastrada';
COMMENT ON COLUMN lojas.lojas.logo_arquivo            IS 'Arquivo da logo da loja cadastrada';
COMMENT ON COLUMN lojas.lojas.logo_ultima_atualizacao IS 'Última atualização da logo da loja cadastrada'
;

--Cria a tabela Envios--
CREATE TABLE lojas.envios (
    envio_id SERIAL               PRIMARY KEY,
    loja_id                       INT NOT NULL,
    cliente_id                    INT NOT NULL,
    endereco_entrega              VARCHAR(512) NOT NULL,
    status VARCHAR(15)            NOT NULL,
    CONSTRAINT fk_envios_lojas    FOREIGN KEY (loja_id)      REFERENCES lojas.lojas (loja_id),
    CONSTRAINT fk_envios_clientes FOREIGN KEY (cliente_id)   REFERENCES lojas.clientes (cliente_id)
);
--Faz os comentários das colunas da tabela Envios--
COMMENT ON COLUMN lojas.envios.envio_id            IS 'ID de envio do pedido';
COMMENT ON COLUMN lojas.envios.loja_id             IS 'ID da loja associada ao envio';
COMMENT ON COLUMN lojas.envios.cliente_id          IS 'ID do cliente associado ao envio';
COMMENT ON COLUMN lojas.envios.endereco_entrega    IS 'Endereço de entrega do pedido';
COMMENT ON COLUMN lojas.envios.status              IS 'Status do envio do pedido'
;


--Cria a tabela Pedidos--
CREATE TABLE lojas.pedidos (
    pedido_id SERIAL   PRIMARY KEY,
    cliente_id         INT NOT NULL,
    loja_id            INT NOT NULL,
    data_hora          TIMESTAMP NOT NULL,
    status             VARCHAR(15) NOT NULL,
    CONSTRAINT fk_pedidos_clientes   FOREIGN KEY (cliente_id)   REFERENCES lojas.clientes (cliente_id),
    CONSTRAINT fk_pedidos_lojas      FOREIGN KEY (loja_id)      REFERENCES lojas.lojas (loja_id)
);

--Faz os comentários das colunas da tabela Pedidos--
COMMENT ON COLUMN  lojas.pedidos.pedido_id   IS     'ID do pedido da loja cadastrada';
COMMENT ON COLUMN  lojas.pedidos.cliente_id  IS     'ID do cliente associado ao pedido';
COMMENT ON COLUMN  lojas.pedidos.loja_id     IS     'ID da loja associada ao pedido';
COMMENT ON COLUMN  lojas.pedidos.data_hora   IS     'Data e hora em que o pedido foi realizado';
COMMENT ON COLUMN  lojas.pedidos.status      IS     'Status do pedido'
;

--Cria a tabela Pedidos_Itens--
CREATE TABLE lojas.pedidos_itens (
    produto_id        INT NOT NULL,
    pedido_id         INT NOT NULL,
    envio_id          INT NOT NULL,
    numero_da_linha   NUMERIC NOT NULL,
    preco_unitario    NUMERIC(10, 2) NOT NULL,
    quantidade        NUMERIC(38) NOT NULL,
    CONSTRAINT   pk_pedidos_itens            PRIMARY KEY (produto_id, pedido_id),
    CONSTRAINT   fk_pedidos_itens_produtos   FOREIGN KEY (produto_id)   REFERENCES lojas.produtos (produto_id),
    CONSTRAINT   fk_pedidos_itens_pedidos    FOREIGN KEY (pedido_id)    REFERENCES lojas.pedidos (pedido_id),
    CONSTRAINT   fk_pedidos_itens_envios     FOREIGN KEY (envio_id)     REFERENCES lojas.envios (envio_id)
);

--Faz os comentários das colunas da tabela Pedidos_Itens--
COMMENT ON COLUMN lojas.pedidos_itens.produto_id        IS 'ID do produto associado ao item do pedido';
COMMENT ON COLUMN lojas.pedidos_itens.pedido_id         IS 'ID do pedido associado ao item do pedido';
COMMENT ON COLUMN lojas.pedidos_itens.envio_id          IS 'ID do envio associado ao item do pedido';
COMMENT ON COLUMN lojas.pedidos_itens.numero_da_linha   IS 'Número da linha do item do pedido';
COMMENT ON COLUMN lojas.pedidos_itens.preco_unitario    IS 'Preço unitário do item do pedido';
COMMENT ON COLUMN lojas.pedidos_itens.quantidade        IS 'Quantidade do item do pedido';


--Cria a tabela Estoques--
CREATE TABLE lojas.estoques (
    estoque_id SERIAL     PRIMARY KEY,
    loja_id               INT NOT NULL,
    produto_id            INT NOT NULL,
    quantidade            NUMERIC(38) NOT NULL,
    CONSTRAINT   fk_estoques_lojas      FOREIGN KEY (loja_id)      REFERENCES lojas.lojas (loja_id),
    CONSTRAINT   fk_estoques_produtos   FOREIGN KEY (produto_id)   REFERENCES lojas.produtos (produto_id)
);
--Faz os comentários das colunas da tabela Estoques--
COMMENT ON COLUMN   lojas.estoques.estoque_id   IS 'ID do estoque da loja cadastrada';
COMMENT ON COLUMN   lojas.estoques.loja_id      IS 'ID da loja associada ao estoque';
COMMENT ON COLUMN   lojas.estoques.produto_id   IS 'ID do produto associado ao estoque';
COMMENT ON COLUMN   lojas.estoques.quantidade   IS 'Quantidade em estoque do produto';

--Adiciona as restrições do código--
ALTER TABLE lojas.pedidos ADD CONSTRAINT clientes_pedidos_fk
FOREIGN KEY (cliente_id)
REFERENCES lojas.clientes (cliente_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE lojas.envios ADD CONSTRAINT clientes_envios_fk

FOREIGN KEY (cliente_id)

REFERENCES lojas.clientes (cliente_id)

ON DELETE NO ACTION

ON UPDATE NO ACTION

NOT DEFERRABLE;



ALTER TABLE lojas.estoques ADD CONSTRAINT produtos_estoques_fk

FOREIGN KEY (produto_id)

REFERENCES lojas.produtos (produto_id)

ON DELETE NO ACTION

ON UPDATE NO ACTION

NOT DEFERRABLE;



ALTER TABLE lojas.pedidos_itens ADD CONSTRAINT produtos_pedidos_itens_fk

FOREIGN KEY (produto_id)

REFERENCES lojas.produtos (produto_id)

ON DELETE NO ACTION

ON UPDATE NO ACTION

NOT DEFERRABLE;




ALTER TABLE lojas.estoques ADD CONSTRAINT lojas_estoques_fk

FOREIGN KEY (loja_id)

REFERENCES lojas.lojas (loja_id)

ON DELETE NO ACTION

ON UPDATE NO ACTION

NOT DEFERRABLE;




ALTER TABLE lojas.pedidos ADD CONSTRAINT lojas_pedidos_fk

FOREIGN KEY (loja_id)

REFERENCES lojas.lojas (loja_id)

ON DELETE NO ACTION

ON UPDATE NO ACTION

NOT DEFERRABLE;




ALTER TABLE lojas.envios ADD CONSTRAINT lojas_envios_fk

FOREIGN KEY (loja_id)

REFERENCES lojas.lojas (loja_id)

ON DELETE NO ACTION

ON UPDATE NO ACTION

NOT DEFERRABLE;




ALTER TABLE lojas.pedidos_itens ADD CONSTRAINT envios_pedidos_itens_fk

FOREIGN KEY (envio_id)

REFERENCES lojas.envios (envio_id)

ON DELETE NO ACTION

ON UPDATE NO ACTION

NOT DEFERRABLE;




ALTER TABLE lojas.pedidos_itens ADD CONSTRAINT pedidos_pedidos_itens_fk

FOREIGN KEY (pedido_id)

REFERENCES lojas.pedidos (pedido_id)

ON DELETE NO ACTION

ON UPDATE NO ACTION

NOT DEFERRABLE;




ALTER TABLE lojas.pedidos
ADD CONSTRAINT restricao1 
CHECK (status IN ( 'CANCELADO', 'COMPLETO',' ABERTO', 'PAGO', 'REEMBOLSADO',
                   'ENVIADO' ))
;

ALTER TABLE lojas.envios
ADD CONSTRAINT restricao2
CHECK (status IN('CRIADO','ENVIADO', 'TRANSITO','ENTREGUE'))
;

ALTER TABLE lojas.lojas 
ADD CONSTRAINT restricao3 
CHECK ("endereco_fisico" IS NOT NULL OR "endereco_web" IS NOT NULL)
;

ALTER TABLE lojas.produtos
ADD CONSTRAINT restricao4 
CHECK (preco_unitario >= 0)
;

ALTER TABLE lojas.estoques
ADD CONSTRAINT restricao5 
CHECK (quantidade >= 0)
;

ALTER TABLE lojas.pedidos_itens
ADD CONSTRAINT restricao6
CHECK (preco_unitario >= 0)
;

ALTER TABLE lojas.pedidos_itens
ADD CONSTRAINT restricao7
CHECK (quantidade >= 0)
;


