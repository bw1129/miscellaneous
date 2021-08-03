
% testarr = ZARRAY();
% testarr2 = ZARRAY(5);
% testarr3 = ZARRAY(5, [1, 2, 3, 4, 5]);

progDir = dir("logfileDir/sqlite-tools/sqlite3.exe");

db = SQLite([progDir.folder '\' progDir.name]);
db.enableDebug();

dd = dir("logfileDir").folder;
dbFileDir = [dd '\TestingSQLiteDB.db'];

db.openDB(dbFileDir);

data = db.query('select * from rret;');

printf("%s", data);

% db.query(
%     'CREATE TABLE "rret" (',
% 	'"REEE"	INTEGER',
%     ');'
%     );

% db.query(
%     'INSERT INTO "rret" ("REEE") VALUES ("2");',
%     'INSERT INTO "rret" ("REEE") VALUES ("3");',
%     'INSERT INTO "rret" ("REEE") VALUES ("4");',
%     'INSERT INTO "rret" ("REEE") VALUES ("5");',
%     'INSERT INTO "rret" ("REEE") VALUES ("6");'
%     );


t = db.query(
    "select * from rret",
    ";"
    );

printf("%s", t);