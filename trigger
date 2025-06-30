create table times (
  id serial primary key,
  nome varchar(30) not null,
  num_pontos integer,
  vitorias integer,
  derrotas integer,
  empates integer,
  gols_afavor integer,
  gols_sofridos integer
);

insert into times values
(1,'Sport',0,0,0,0,0,0),
(2,'Náutico',0,0,0,0,0,0),
(3,'Santa Cruz',0,0,0,0,0,0);
create table jogos (
  id_mandante integer,
  id_visitante integer,
  gols_mandante integer,
  gols_visitante integer,
  PRIMARY key
      (id_mandante, id_visitante),
  FOREIGN key (id_mandante) REFERENCES times (id),
  FOREIGN key (id_visitante) REFERENCES times (id)
);

SELECT * FROM jogos;
SELECT * from times;

CREATE or replace FUNCTION att_times ()
RETURNS TRIGGER
LANGUAGE PLPGSQL AS $$
-- DECLARE
    -- variáveis
BEGIN
    IF new.gols_mandante=NEW.gols_visitante THEN
        update times set empates=empates + 1, , num_pontos = num_pontos + 1 where id=NEW.id_mandante;
        update times set empates=empates + 1, , num_pontos = num_pontos + 1 where id=new.id_visitante;
    elseif new.gols_mandante > new.gols_visitante THEN
    	UPDATE times set vitorias = vitorias + 1, num_pontos = num_pontos + 3 where id = new.id_mandante;
        UPDATE times set derrotas = derrotas + 1 where id = new.id_visitante;
    else 
    	UPDATE times set vitorias = vitorias + 1, num_pontos = num_pontos + 3 where id = new.id_visitante;
        UPDATE times set derrotas = derrotas + 1 where id = new.id_mandante;
    end if;    
    return NEW;
END; $$

CREATE TRIGGER tg_att_times
AFTER INSERT ON JOGOS
FOR EACH ROW
EXECUTE PROCEDURE att_times ();

INSERT into jogos VALUES (2, 1, 5, 0);
UPDATE times set vitorias=0, derrotas=0, empates=0
