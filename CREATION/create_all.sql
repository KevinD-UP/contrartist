DROP TYPE IF EXISTS type_ecole CASCADE;
DROP TYPE IF EXISTS genre CASCADE;
DROP TYPE IF EXISTS grade_etude CASCADE;
CREATE TYPE type_ecole as ENUM('Philarmonie ',
	'Conservatoire',
	'Ecole',
	'Collectif',
	'Universite',
	'Experience'
);


CREATE TYPE genre as ENUM(
	'Jazz ',
	'Rock',
	'Pop',
	'Classique',
	'Metal',
	'Techno',
	'Trapstep',
	'Comedie',
	'Drame',
	'SF',
	'Horreur',
	'Documentaire',
	'Action'
	'Thrillers',
	'Fantasy',
	'Animation',
	'Romantique',
	'Familial',
	'Sport',
	'Independant'
);

CREATE TYPE grade_etude as ENUM('AMATEUR','1ER','2E','3E',
'LICENCE','MASTER','DOCTORAT');


DROP TABLE IF EXISTS artiste CASCADE;
DROP TABLE IF EXISTS oeuvre CASCADE;
DROP TABLE IF EXISTS ecole CASCADE; 
DROP TABLE IF EXISTS formation CASCADE;
DROP TABLE IF EXISTS agent CASCADE; 
DROP TABLE IF EXISTS type_oeuvre CASCADE; 
DROP TABLE IF EXISTS assoc_formation_type_oeuvre CASCADE ;
DROP TABLE IF EXISTS assoc_oeuvre_type_oeuvre CASCADE ;
DROP TABLE IF EXISTS assoc_artiste_formation CASCADE ;
DROP TABLE IF EXISTS producteur_studio CASCADE; 
DROP TABLE IF EXISTS contrat_artiste_agence CASCADE; 
DROP TABLE IF EXISTS contrat_artiste_agence_archive CASCADE;
DROP TABLE IF EXISTS critique CASCADE; 
DROP TABLE IF EXISTS demande CASCADE; 
DROP TABLE IF EXISTS contrat_oeuvre CASCADE; 
DROP TABLE IF EXISTS paiement CASCADE; 

CREATE TABLE artiste (
	id SERIAL PRIMARY KEY,
	nom VARCHAR(256) NOT NULL,
	prenom VARCHAR(256) NOT NULL,
	adresse VARCHAR(256) NOT NULL,
	date_naissance DATE NOT NULL,
	genre VARCHAR(1) NOT NULL,
	mail VARCHAR(256) NOT NULL,
	numero_telephone VARCHAR(20) NOT NULL,
	CHECK(nom <> ''),
    CHECK(prenom <> ''),
    CHECK(adresse <> ''),
	CHECK(genre <> ''),
    CHECK(mail <> ''),
    CHECK(numero_telephone <> ''),
    CHECK(date_naissance < CURRENT_DATE)
);


CREATE TABLE oeuvre (
	id SERIAL PRIMARY KEY,
	titre VARCHAR(256) NOT NULL ,
	descript TEXT NOT NULL,
	date_sortie DATE,
	CHECK(titre <> ''),
    CHECK(descript <> '')
);


CREATE TABLE ecole (
	id SERIAL PRIMARY KEY,
	nom VARCHAR(256) NOT NULL,
	typec type_ecole NOT NULL,
	pays VARCHAR(3),
	CHECK(nom <> '')
);


CREATE TABLE formation (
	id SERIAL PRIMARY KEY,
	nom VARCHAR(256) NOT NULL,
	grade grade_etude,
	id_ecole INTEGER NOT NULL,
	FOREIGN KEY (id_ecole) REFERENCES ecole(id) ON DELETE CASCADE,
	CHECK(nom <> '')
);


CREATE TABLE type_oeuvre (
	id SERIAL PRIMARY KEY,
	nom VARCHAR(256) NOT NULL,
	descript TEXT,
	genre genre,
	CHECK(nom <> '')
);

CREATE TABLE agent (
	id SERIAL PRIMARY KEY,
	nom VARCHAR(256) NOT NULL,
	prenom VARCHAR(256) NOT NULL,
	adresse VARCHAR(256) NOT NULL,
	date_naissance DATE NOT NULL,
	genre CHAR(1) NOT NULL,
	mail VARCHAR(256) NOT NULL,
	numero_telephone VARCHAR(20) NOT NULL,
	CHECK(nom <> ''),
    CHECK(prenom <> ''),
    CHECK(adresse <> ''),
	CHECK(genre <> ''),
    CHECK(mail <> ''),
    CHECK(numero_telephone <> ''),
    CHECK(date_naissance < CURRENT_DATE)
);

CREATE TABLE producteur_studio (
	id SERIAL PRIMARY KEY,
	nom VARCHAR(256) NOT NULL,
	capital VARCHAR(256),
	CHECK(nom <> '')
);


CREATE TABLE contrat_artiste_agence (
	id SERIAL PRIMARY KEY,
	id_artiste INTEGER NOT NULL, 
	FOREIGN KEY (id_artiste) REFERENCES artiste(id) ON DELETE CASCADE,
	id_agent INTEGER NOT NULL,
	FOREIGN KEY (id_agent) REFERENCES agent(id) ON DELETE CASCADE,
	date_debut DATE NOT NULL,
	date_fin DATE NOT NULL,
	pourcentage INTEGER NOT NULL,
	CHECK (date_fin > date_debut),
	CHECK (pourcentage > 0 AND pourcentage <= 100)
);

CREATE TABLE contrat_artiste_agence_archive (
	id SERIAL PRIMARY KEY,
	id_artiste INTEGER NOT NULL, 
	FOREIGN KEY (id_artiste) REFERENCES artiste(id) ON DELETE CASCADE,
	id_agent INTEGER NOT NULL,
	FOREIGN KEY (id_agent) REFERENCES agent(id) ON DELETE CASCADE,
	date_debut DATE NOT NULL,
	date_fin DATE NOT NULL,
	CHECK (date_fin > date_debut)
);


CREATE TABLE critique (
	id SERIAL,
	id_artiste INTEGER NOT NULL, 
	FOREIGN KEY (id_artiste) REFERENCES artiste(id),
	distributeur TEXT NOT NULL,
	descript TEXT,
	note INTEGER CHECK (note >= 0 AND note <= 10) NOT NULL,
	PRIMARY KEY (id, id_artiste)
);

CREATE TABLE demande (
	id SERIAL PRIMARY KEY,
	id_prod_studio INTEGER NOT NULL, 
	FOREIGN KEY (id_prod_studio) REFERENCES producteur_studio(id),
	id_formation INTEGER NOT NULL, 
	FOREIGN KEY (id_formation) REFERENCES formation(id),
	id_oeuvre INTEGER NOT NULL,
	FOREIGN KEY (id_oeuvre) REFERENCES oeuvre(id),
	date_debut DATE NOT NULL,
	date_fin DATE NOT NULL,
	CHECK (date_fin > date_debut)
);


CREATE TABLE contrat_oeuvre (
	id SERIAL PRIMARY KEY,
	/*id_demande INTEGER NOT NULL,
	FOREIGN KEY (id_demande) REFERENCES demande(id),*/
	id_prod_studio INTEGER NOT NULL,
	FOREIGN KEY (id_prod_studio) REFERENCES producteur_studio(id),
	id_artiste INTEGER NOT NULL,
	FOREIGN KEY (id_artiste) REFERENCES artiste(id),
	id_oeuvre INTEGER NOT NULL,
	FOREIGN KEY (id_oeuvre) REFERENCES oeuvre(id),
	date_signature DATE NOT NULL,
	cout INTEGER NOT NULL,
	CHECK (cout > 0)
);

CREATE TABLE paiement (
	id SERIAL PRIMARY KEY,
	id_artiste INTEGER NOT NULL,
	FOREIGN KEY (id_artiste) REFERENCES artiste(id),
	id_contrat_oeuvre INTEGER NOT NULL,
	FOREIGN KEY (id_contrat_oeuvre) REFERENCES contrat_oeuvre(id),
	paiement_pour_artiste INTEGER NOT NULL,
	paiement_pour_agence INTEGER NOT NULL,
	CHECK(paiement_pour_artiste >= 0),
	CHECK(paiement_pour_agence >= 0)
);

/*
Pour toutes les associations (ci-après)
créer une fonction qui pour chacune 
(pk pas une fonction généraliste
et fonctions spécialisés se contente de fournir les bons paramètres ? )
indique quelle relation ne respecte pas l'arité de la modélisation 
*/

/* probleme âs de clé primaires sur ces tables potentiellement très grosses*/
/*mettre les deux clés comme clé primaire  ? */

CREATE TABLE assoc_formation_type_oeuvre(
	id_formation INTEGER NOT NULL,
	FOREIGN KEY (id_formation) REFERENCES formation(id),
	id_type INTEGER NOT NULL,
	FOREIGN KEY (id_type) REFERENCES type_oeuvre(id),
	PRIMARY KEY (id_formation,id_type)
);


CREATE TABLE assoc_oeuvre_type_oeuvre(
	id_oeuvre INTEGER NOT NULL,
	FOREIGN KEY (id_oeuvre) REFERENCES oeuvre(id),
	id_type INTEGER NOT NULL,
	FOREIGN KEY (id_type) REFERENCES type_oeuvre(id),
	PRIMARY KEY (id_oeuvre,id_type)
);

CREATE TABLE assoc_artiste_formation(
	id_artiste INTEGER NOT NULL,
	FOREIGN KEY (id_artiste) REFERENCES artiste(id),
	id_formation INTEGER NOT NULL,
	FOREIGN KEY (id_formation) REFERENCES formation(id),
	PRIMARY KEY (id_artiste,id_formation)
);

/*INDEX*/

CREATE INDEX critique_index ON critique
(
    id_artiste
);

CREATE INDEX artiste_index ON artiste
(
    nom, prenom
);

CREATE INDEX agent_index ON agent
(
    nom, prenom
);

CREATE INDEX oeuvre_index ON oeuvre
(
    titre
);

CREATE INDEX ecole_index ON ecole
(
    nom
);

CREATE INDEX formation_index ON formation
(
    nom
);

CREATE INDEX type_oeuvre_index ON type_oeuvre
(
    nom
);

CREATE INDEX prod_studio_index ON producteur_studio
(
    nom
);

CREATE INDEX contrat_artiste_agence_index ON contrat_artiste_agence
(
    id_artiste, id_agent
);

CREATE INDEX contrat_artiste_agence_archive_index ON contrat_artiste_agence_archive
(
    id_artiste, id_agent
);

CREATE INDEX paiement_index ON paiement
(
    id_artiste
);

CREATE INDEX contrat_oeuvre_index ON contrat_oeuvre
(
    id_oeuvre
);

CREATE INDEX demande_index ON demande
(
    id_oeuvre
);
