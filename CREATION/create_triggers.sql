/*Fonction pour checker à l'insertion qu'un artiste ne se fait pas couvrir par deux agent sur la même période*/
CREATE OR REPLACE FUNCTION check_contrat_artiste_agence_insert() RETURNS trigger LANGUAGE PLPGSQL AS $$
    BEGIN
		IF NEW.date_debut < 
    (SELECT contrat_artiste_agence.date_fin 
    FROM contrat_artiste_agence 
    WHERE contrat_artiste_agence.id_artiste = NEW.id_artiste 
    ORDER BY contrat_artiste_agence.date_fin DESC LIMIT 1
    ) 
    THEN
			RAISE EXCEPTION 'Un artiste ne peut-être couvert par deux agent en même temps.';
		END IF;
		RETURN NEW;
    END;
$$;

/*Trigger pour checker à l'insertion qu'un artiste ne se fait pas couvrir par deux agent sur la même période*/
CREATE OR REPLACE TRIGGER check_insert
    BEFORE INSERT ON contrat_artiste_agence
    FOR EACH ROW
    EXECUTE FUNCTION check_contrat_artiste_agence_insert();

/*Fonction pour checker à l'update qu'un artiste ne se fait pas couvrir par deux agent sur la même période et met dans l'archive, l'ancien contrat.*/
CREATE OR REPLACE FUNCTION check_contrat_artiste_agence_update() RETURNS trigger LANGUAGE PLPGSQL AS $$
    BEGIN
		IF NEW.date_debut < OLD.date_fin THEN 
			RAISE EXCEPTION 'Un artiste ne peut-être couvert par deux agent en même temps.';
		END IF;
    INSERT INTO contrat_artiste_agence_archive(id_artiste, id_agent, date_debut, date_fin) VALUES (OLD.id_artiste, OLD.id_agent, OLD.date_debut, OLD.date_fin);
		RETURN NEW;
    END;
$$;

/*Trigger pour checker à l'update qu'un artiste ne se fait pas couvrir par deux agent sur la même période*/
CREATE OR REPLACE TRIGGER check_update
    BEFORE UPDATE ON contrat_artiste_agence
    FOR EACH ROW
    EXECUTE FUNCTION check_contrat_artiste_agence_update();

/*Fait le calcul des sommes devant être versé*/
CREATE OR REPLACE FUNCTION insert_in_paiement() RETURNS trigger LANGUAGE PLPGSQL AS $$
    DECLARE
      contract_percentage contrat_artiste_agence.pourcentage%type;
    BEGIN
      SELECT contrat_artiste_agence.pourcentage 
      INTO contract_percentage 
      FROM contrat_artiste_agence 
      INNER JOIN artiste ON artiste.id = contrat_artiste_agence.id_artiste
      ORDER BY contrat_artiste_agence.date_debut DESC LIMIT 1;
      DECLARE
          paiement_pour_agence INTEGER := (NEW.cout * contract_percentage / 100);
          paiement_pour_artiste INTEGER := NEW.cout - paiement_pour_agence;
        BEGIN
          INSERT INTO paiement(id_artiste, id_contrat_oeuvre, paiement_pour_artiste, paiement_pour_agence) 
          VALUES (NEW.id_artiste, NEW.id, paiement_pour_artiste, paiement_pour_agence); 
        END;
        RETURN NEW;
    END;
$$;

/*Trigger pour insérer dans la table de paiement lorsqu'un contrat est signé */
CREATE OR REPLACE TRIGGER contract_paiement
    AFTER INSERT ON contrat_oeuvre
    FOR EACH ROW
    EXECUTE FUNCTION insert_in_paiement();


/* Fonction pour vérifier que la date de signature d'un contrat est bien dans la période de la demande */
/*CREATE OR REPLACE FUNCTION check_date_signature() RETURNS trigger LANGUAGE PLPGSQL AS $$
    DECLARE
      demande_date_debut demande.date_debut%type;
      demande_date_fin demande.date_fin%type;
    BEGIN
      SELECT date_debut, date_fin INTO demande_date_debut, demande_date_fin 
      FROM demande
      WHERE id_oeuvre=NEW.id_oeuvre AND id=NEW.id_demande;
      IF (NEW.date_signature < demande_date_debut OR NEW.date_signature > demande_date_fin) THEN
        RAISE EXCEPTION 'La date de signature du contrat ne correspond pas à la période de la demande.';
      END IF;
      RETURN NEW;
    END;
$$;*/

/*Trigger pour vérifier que la date de signature d'un contrat est bien dans la période de la demande */
/*CREATE OR REPLACE TRIGGER contract_signature
  BEFORE INSERT ON contrat_oeuvre
  FOR EACH ROW
  EXECUTE FUNCTION check_date_signature();
*/