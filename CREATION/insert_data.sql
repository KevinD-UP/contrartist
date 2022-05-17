\copy oeuvre(titre,date_sortie,descript) FROM 'oeuvre.csv' DELIMITER ',' CSV HEADER;
\copy artiste(id,nom,prenom,adresse,date_naissance,genre,numero_telephone,mail) FROM 'artiste.csv' DELIMITER ',' CSV HEADER;
\copy producteur_studio(id,nom,capital) FROM 'producteur.csv' DELIMITER ',' CSV HEADER;
\copy agent(id,nom,prenom,adresse,date_naissance,genre,mail,numero_telephone) FROM 'agent.csv' DELIMITER ',' CSV HEADER;
\copy contrat_artiste_agence(id,id_artiste,id_agent,date_debut,date_fin, pourcentage) FROM 'gestion.csv' DELIMITER ',' CSV HEADER; 
\copy contrat_oeuvre(id, id_prod_studio, id_artiste, id_oeuvre, date_signature, cout) FROM 'contrat.csv' DELIMITER ',' CSV HEADER;