\# Changelog - Proiect IDP (Board Game Management)



Toate schimbarile notabile pentru acest proiect vor fi documentate in acest fisier.



\## \[Etapa 2] - Progres 40%



\### Adaugat

\- \*\*Infrastructura Docker:\*\*

&#x20; - Configuratie multi-container folosind `docker-compose`.

&#x20; - Izolarea serviciilor in retele separate (`public\_net` pentru API-uri si `data\_net` pentru baze de date).

&#x20; - Persistenta datelor folosind volume Docker pentru PostgreSQL.

\- \*\*Serviciul de Autentificare (Auth Service):\*\*

&#x20; - Implementare in Node.js si Express.

&#x20; - Endpoint pentru inregistrare (`/auth/register`) cu hashing de parole (Bcrypt).

&#x20; - Endpoint pentru login (`/auth/login`) cu generare de token-uri JWT.

\- \*\*Serviciul de Gestiune (Order/IO Service):\*\*

&#x20; - Implementare in Python cu Flask.

&#x20; - Conexiune functionala cu baza de date principala pentru extragerea catalogului de jocuri.

\- \*\*Baze de date:\*\*

&#x20; - `auth\_db`: Instanta PostgreSQL dedicata securitatii.

&#x20; - `tabletop\_db`: Instanta PostgreSQL pentru datele de business.

&#x20; - Scripturi de initializare SQL pentru schemele tabelelor (`init.sql`).



\### Modificat

\- Migrarea arhitecturii de la un singur monolit la microservicii decuplate.

\- Imbunatatirea securitatii prin eliminarea stocarii parolelor in format plain-text.



\### Reparate

\- Rezolvarea erorilor de constrangere la ID-urile tabelelor prin implementarea tipului `SERIAL` in PostgreSQL.

\- Corectarea conectivitatii intre containere prin utilizarea variabilelor de mediu in `.env`.

