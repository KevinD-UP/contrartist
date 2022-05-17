/*Cette fonction permet de  savoir quelles sont les oeuvres qui ne respectent pas l'arité du modèle
à savoir 1-n avec type d'oeuvres.*/
CREATE OR REPLACE FUNCTION check_arity_intermediate_oeuvre_type_oeuvre() RETURNS SETOF RECORD AS $$
BEGIN 
	RETURN QUERY
		SELECT oeuvre.id ,oeuvre.titre, COUNT(assoc_oeuvre_type_oeuvre.id_oeuvre) 
		FROM  oeuvre
		LEFT OUTER JOIN assoc_oeuvre_type_oeuvre 
		ON oeuvre.id = assoc_oeuvre_type_oeuvre.id_oeuvre
		GROUP BY oeuvre.id HAVING COUNT(assoc_oeuvre_type_oeuvre.id_oeuvre) = 0 
		ORDER BY oeuvre.id ;
END;
$$ LANGUAGE plpgsql STABLE;


/*Cette fonction permet de  savoir qui sont les artistes qui ne respectent pas l'arité du modèlé 
à savoir 1-n avec artiste.*/
CREATE OR REPLACE FUNCTION check_arity_intermediate_formation_type_oeuvre() RETURNS SETOF RECORD AS $$
BEGIN 
	RETURN QUERY
		SELECT formation.id ,formation.nom, COUNT(assoc_formation_type_oeuvre.id_formation) 
		FROM  formation
		LEFT OUTER JOIN assoc_formation_type_oeuvre 
		ON formation.id = assoc_formation_type_oeuvre.id_formation
		GROUP BY formation.id HAVING COUNT(assoc_formation_type_oeuvre.id_formation) = 0 
		ORDER BY formation.id;
END;
$$ LANGUAGE plpgsql STABLE;

/* Ajoute un nouvel agent */
CREATE OR REPLACE FUNCTION insert_new_agent(nom VARCHAR, prenom VARCHAR, adresse VARCHAR, date_naissance DATE, genre CHAR, mail VARCHAR, numero_telephone VARCHAR) RETURNS VOID AS $$
BEGIN 
	INSERT INTO agent (nom, prenom, adresse, date_naissance, genre, mail, numero_telephone) VALUES (nom, prenom, adresse, date_naissance, genre, mail, numero_telephone);
END;
$$ LANGUAGE plpgsql STABLE;

/* Ajoute un nouvel artiste */
CREATE OR REPLACE FUNCTION insert_new_artiste(nom VARCHAR, prenom VARCHAR, adresse VARCHAR, date_naissance DATE, genre CHAR, mail VARCHAR, numero_telephone VARCHAR) RETURNS VOID AS $$
BEGIN 
	INSERT INTO artiste (nom, prenom, adresse, date_naissance, genre, mail, numero_telephone) VALUES (nom, prenom, adresse, date_naissance, genre, mail, numero_telephone);
END;
$$ LANGUAGE plpgsql STABLE;


/* Ajoute un nouveau contrat entre un artiste et l'agence */
CREATE OR REPLACE FUNCTION insert_new_contract_artist_agency(id_artiste INTEGER, id_agent INTEGER, date_debut DATE, date_fin DATE, pourcentage INTEGER) RETURNS VOID AS $$
BEGIN 
	INSERT INTO contrat_artiste_agence (id_artiste, id_agent, date_debut, date_fin, pourcentage) VALUES (id_artiste, id_agent, date_debut, date_fin, pourcentage);
END;
$$ LANGUAGE plpgsql STABLE;

/* Fait un avenant sur un contrat entre un artiste et l'agence */
CREATE OR REPLACE FUNCTION update_contract_artist_agency(id INTEGER, new_date_debut DATE, new_date_fin DATE, new_pourcentage INTEGER) RETURNS VOID AS $$
BEGIN 
	UPDATE contrat_artiste_agence 
	SET date_debut = new_date_debut, date_fin = new_date_fin, pourcentage = new_pourcentage 
	WHERE contrat_artiste_agence.id=id;
END;
$$ LANGUAGE plpgsql STABLE;

/* Ajoute une critique */
CREATE OR REPLACE FUNCTION insert_critique(id_artiste INTEGER, distributeur TEXT,descript TEXT, note INTEGER) 
RETURNS VOID AS $$
BEGIN 
	INSERT INTO critique (id_artiste, distributeur ,descript, note) VALUES (id_artiste, distributeur ,descript, note);
END;
$$ LANGUAGE plpgsql STABLE;

/* Ajoute un nouveau contrat entre un nouvel artiste et l'agence */
CREATE OR REPLACE FUNCTION insert_new_contract_with_new_artist(
	nom VARCHAR,
	prenom VARCHAR,
	adresse VARCHAR,
	date_naissance DATE,
	genre VARCHAR,
	mail VARCHAR,
	numero_telephone VARCHAR, id_agent INTEGER, date_debut DATE, date_fin DATE, pourcentage INTEGER) RETURNS VOID AS $$
DECLARE 
	id_artiste INTEGER;
BEGIN 
	SELECT insert_new_artiste(nom, prenom, adresse, date_naissance, genre, mail, numero_telephone);
	SELECT id 
	INTO id_artiste 
	FROM artiste 
	WHERE artiste.nom=nom AND artiste.prenom=prenom AND 
	artiste.adresse=adresse AND artiste.date_naissance=date_naissance AND 
	artiste.genre=genre AND artiste.mail=mail AND artiste.numero_telephone=numero_telephone 
	ORDER BY id DESC LIMIT 1;
	SELECT insert_new_contract_artist_agency(id_artiste, id_agent, date_debut, date_fin, pourcentage);
END;
$$ LANGUAGE plpgsql STABLE;

/* Ajoute une critique en fonction du nom et prénom d'un artiste*/
CREATE OR REPLACE FUNCTION insert_critique_by_name(nom VARCHAR, prenom VARCHAR, distributeur TEXT, descript TEXT, note INTEGER) RETURNS VOID AS $$
DECLARE
	id_artiste INTEGER;
BEGIN
	SELECT id 
	INTO id_artiste 
	FROM artiste 
	WHERE artiste.nom=nom AND artiste.prenom=prenom 
	ORDER BY id DESC LIMIT 1;
	SELECT insert_critique(id_artiste, distributeur, descript, note);
END;
$$ LANGUAGE plpgsql STABLE;

/* Cherche les artiste dont la moyenne des notes est supérieur au paramètre */
CREATE OR REPLACE FUNCTION find_artiste_note_superior(note INTEGER) RETURNS SETOF RECORD AS $$
BEGIN
	RETURN QUERY
		SELECT *, AVG(critique.note) FROM artiste INNER JOIN critique ON artiste.id=critique.id_artiste
		GROUP BY artiste.id
		HAVING AVG(critique.note) > note;
END;
$$ LANGUAGE plpgsql STABLE;

/* Cherche les artistes dont la moyenne des notes est inférieur au paramètre */
CREATE OR REPLACE FUNCTION find_artiste_note_inferior(note INTEGER) RETURNS SETOF RECORD AS $$
BEGIN
	RETURN QUERY
		SELECT *, AVG(critique.note) FROM artiste INNER JOIN critique ON artiste.id=critique.id_artiste
		GROUP BY artiste.id
		HAVING AVG(critique.note) < note;
END;
$$ LANGUAGE plpgsql STABLE; 

/* Insère une demande */
CREATE OR REPLACE FUNCTION insert_demand(
	id_prod_studio INTEGER, 
	id_formation INTEGER, 
	id_oeuvre INTEGER,
	date_debut DATE,
	date_fin DATE) RETURNS VOID AS $$
BEGIN
	INSERT INTO demande (id_prod_studio, id_formation, id_oeuvre, date_debut, date_fin) VALUES (id_prod_studio, id_formation, id_oeuvre, date_debut, date_fin);
END;
$$ LANGUAGE plpgsql STABLE; 

/* Insère un producteur ou studio */
CREATE OR REPLACE FUNCTION insert_prod_studio(
	nom VARCHAR,
	capital VARCHAR) RETURNS VOID AS $$
BEGIN
	INSERT INTO producteur_studio (nom, capital) VALUES (nom, capital);
END;
$$ LANGUAGE plpgsql STABLE; 

/* Insère un producteur ou studio */
CREATE OR REPLACE FUNCTION insert_oeuvre(
	titre VARCHAR,
	descript TEXT,
	date_sortie DATE) RETURNS VOID AS $$
BEGIN
	INSERT INTO oeuvre (titre, descript, date_sortie) VALUES (titre, descript, date_sortie);
END;
$$ LANGUAGE plpgsql STABLE; 


/* Insère une nouvelle demande extérieur */
CREATE OR REPLACE FUNCTION insert_external_demand(
	nom VARCHAR,
	capital VARCHAR, 
	id_formation INTEGER, 
	titre VARCHAR,
	descript TEXT,
	date_sortie DATE,
	date_debut DATE, 
	date_fin DATE) RETURNS VOID AS $$
DECLARE
	id_prod_studio INTEGER;
	id_oeuvre INTEGER;
BEGIN
	SELECT insert_prod_studio(nom, capital);
	SELECT insert_oeuvre(titre, descript, date_sortie);
	SELECT id INTO id_prod_studio FROM production_studio WHERE production_studio.nom=nom;
	SELECT id INTO id_oeuvre FROM oeuvre WHERE oeuvre.titre=titre;
	SELECT insert_demand(id_prod_studio, id_formation, id_oeuvre, date_debut, date_fin);
END;
$$ LANGUAGE plpgsql STABLE; 

/* Insère une nouvelle demande extérieur */
CREATE OR REPLACE FUNCTION insert_contrat_oeuvre(
	id_demande INTEGER,
	id_prod_studio INTEGER,
	id_artiste INTEGER,
	id_oeuvre INTEGER,
	date_signature DATE,
	cout INTEGER) RETURNS VOID AS $$
BEGIN
	INSERT INTO contrat_oeuvre (id_demande, id_prod_studio, id_artiste, id_oeuvre, cout) VALUES (id_demande, id_prod_studio, id_artiste, id_oeuvre, cout);
END;
$$ LANGUAGE plpgsql STABLE; 
