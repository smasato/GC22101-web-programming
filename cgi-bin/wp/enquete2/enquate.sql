CREATE TABLE questions
(
    id      INTEGER PRIMARY KEY,
    title   TEXT,
    choices TEXT
);

CREATE TABLE votes
(
    id          INTEGER PRIMARY KEY,
    question_id INTEGER,
    choice      TEXT,
    foreign key (question_id) references questions (id)
);
PRAGMA
foreign_keys=true;