CREATE TABLE questions
(
    id      INTEGER PRIMARY KEY AUTOINCREMENT,
    title   TEXT,
    choices TEXT
);

CREATE TABLE votes
(
    id          INTEGER PRIMARY KEY AUTOINCREMENT,
    question_id INTEGER,
    choice      TEXT,
    foreign key (question_id) references questions (id)
);
PRAGMA
foreign_keys=true;
