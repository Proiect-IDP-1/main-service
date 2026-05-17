-- Date de seed pentru tabletop_db
INSERT INTO games (name, description, price, stock, min_players, max_player, difficulty, category) VALUES
    ('Catan Big Box', 'Pachetul complet Catan cu joc de baza si mai multe extensii.', 280.0, 20, 3, 4, 'medium', 'Strategie'),
    ('Catan - Joc de Baza', 'Construieste asezari si negociaza cu adversarii in jocul clasic.', 185.0, 30, 3, 4, 'easy', 'Strategie'),
    ('Extensie Catan - Orase & Cavaleri (5-6 jucatori)', 'Extensia pentru 5-6 jucatori, Cities & Knights.', 100.0, 10, 5, 6, 'medium', 'Strategie'),
    ('Extensie Catan - Pirati & Exploratori (5-6 jucatori)', 'Extensia Pirates & Explorers pentru 5-6 jucatori.', 100.0, 10, 5, 6, 'medium', 'Strategie'),
    ('Extensie Catan - Negustori & Barbari', 'Extensia Traders & Barbarians.', 170.0, 20, 3, 4, 'medium', 'Strategie'),
    ('Extensie Catan - Navigatorii (5-6 jucatori)', 'Extensia Seafarers pentru 5-6 jucatori.', 100.0, 10, 5, 6, 'medium', 'Strategie'),
    ('Wingspan', 'Joc despre pasari, premiat Kennerspiel des Jahres 2019.', 250.0, 15, 1, 5, 'medium', 'Strategie'),
    ('Azul', 'Joc abstract de plasare placute. Spiel des Jahres 2018.', 130.0, 25, 2, 4, 'easy', 'Familie'),
    ('Codenames', 'Joc de petrecere cu indicii pentru echipa ta.', 95.0, 40, 4, 8, 'easy', 'Party'),
    ('Terraforming Mars', 'Transforma planeta rosie in una locuibila.', 320.0, 8, 1, 5, 'hard', 'Strategie'),
    ('Pandemic', 'Joc cooperativ - salvati lumea de epidemii.', 145.0, 18, 2, 4, 'medium', 'Cooperativ'),
    ('7 Wonders Duel', 'Versiunea pentru 2 jucatori a celebrului 7 Wonders.', 140.0, 22, 2, 2, 'medium', 'Strategie')
ON CONFLICT DO NOTHING;
