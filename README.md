# Übungsblatt 4
## Allgemeine Hinweise
Für diese und alle folgenden Praktikumsaufgaben gilt, dass Einsendungen, die in der jeweils mitgegebenen Testumgebung nicht laufen, mit null Punkten bewertet werden! Das beinhaltet insbesondere alle Programme, die sich nicht fehlerfrei kompilieren lassen. Als Testsystem werden wir dabei gruenau6 mit den dort installierten Compilern und Compilerwerkzeugen benutzen. Prüfen Sie bitte rechtzeitig vor der Abgabe, ob ihr Programm auch dort lauffähig ist. Wir akzeptieren keine Entschuldigungen der Form „aber bei mir Zuhause hat es funktioniert“ ;).

Ebenfalls mit null Punkten werden alle Abgaben bewertet, die sich nicht exakt an die vorgegebenen Formate halten.

> Um Ihnen die Abgabe zu erleichtern, geben wir Ihnen ein Makefile mit, welches die folgenden Ziele unterstützt:
> #### all
> Übersetzt die Quelldateien und erzeugt eine ausführbare Datei.
> #### run
> Übersetzt die Quelldateien, erzeugt eine ausführbare Datei und startet das Testprogramm.
> #### clean
> Entfernt alle Zwischendateien und räumt in Ihrem Verzeichnis auf.
> Bitte achten Sie bei Ihrer Implementation auf Speicherleckfreiheit bei korrekter Benutzung, d.h. bei paarweisem Aufruf von init() und release().

## Abgabemodus
Ihre Lösung ist in einem öffentlich verfügbaren Git-Repository abzugeben.

Zur Lösung der Aufgaben steht für Sie dieses Repository mit
- mit einem vorgegeben Makefile,
- einer Testdatei [demorgan](parser/demorgan.c1),
- einem Lexer in [minako-lexic](parser/minako-lexic.l)
- einem Parser-Template in [minako-syntax](parser/minako-syntax.y)

zur Verfügung.

## Aufgabenstellung (100 Punkte)
Der von uns verwendete Parsergenerator *bison* sollte Ihnen bereits aus der Übung bekannt sein. Da Materialien zu Bison (Handbücher, Tutorials, …) sehr zahlreich im Netz vorhanden sind, wird hier auf eine weitere Erklärung verzichtet.

Ihre Aufgabe besteht darin, einen Parser für die Sprache C1 zu erstellen. Dazu bekommen Sie von uns einen Scanner. (Sie können theoretisch auch Ihren Scanner vom Aufgabenblatt 2 benutzen – zur Korrektur werden wir jedoch den von uns vorgegebenen verwenden!)

Die Grammatik von C1 finden Sie [hier](https://amor.cms.hu-berlin.de/~kunert/lehre/material/c1-grammar.php) sowie nachfolgend:

```c
program             ::= ( declassignment ";" | functiondefinition )*

functiondefinition  ::= type id "(" ( parameterlist )? ")" "{" statementlist "}"
parameterlist       ::= type id ( "," type id )*
functioncall        ::= id "(" ( assignment ( "," assignment )* )? ")"

statementlist       ::= ( block )*
block               ::= "{" statementlist "}"
                      | statement

statement           ::= ifstatement
                      | forstatement
                      | whilestatement
                      | returnstatement ";"
                      | dowhilestatement ";"
                      | printf ";"
                      | declassignment ";"
                      | statassignment ";"
                      | functioncall ";"
statblock           ::= "{" statementlist "}"
                      | statement

ifstatement         ::= <KW_IF> "(" assignment ")" statblock ( <KW_ELSE> statblock )?
forstatement        ::= <KW_FOR> "(" ( statassignment | declassignment ) ";" expr ";" statassignment ")" statblock
dowhilestatement    ::= <KW_DO> statblock <KW_WHILE> "(" assignment ")"
whilestatement      ::= <KW_WHILE> "(" assignment ")" statblock
returnstatement     ::= <KW_RETURN> ( assignment )?
printf              ::= <KW_PRINTF> "(" (assignment | CONST_STRING) ")"
declassignment      ::= type id ( "=" assignment )?

statassignment      ::= id "=" assignment
assignment          ::= id "=" assignment
                      | expr
expr                ::= simpexpr ( "==" simpexpr | "!=" simpexpr | "<=" simpexpr | ">=" simpexpr | "<" simpexpr | ">" simpexpr )?
simpexpr            ::= ( "-" term | term ) ( "+" term | "-" term | "||" term )*
term                ::= factor ( "*" factor | "/" factor | "&&" factor )*
factor              ::= <CONST_INT>
                      | <CONST_FLOAT>
                      | <CONST_BOOLEAN>
                      | functioncall
                      | id
                      | "(" assignment ")"


type                ::= <KW_BOOLEAN>
                      | <KW_FLOAT>
                      | <KW_INT>
                      | <KW_VOID>
id                  ::= <ID>
```

Da Bison leider keine EBNF, sondern nur BNF versteht, werden Sie die Grammatik zwangsläufig umbauen müssen. 
Dabei ist im Prinzip fast alles erlaubt, nur die Sprache darf sich natürlich nicht verändern!

### Folgende Anforderungen werden an Ihre Lösung gestellt:

- die Implementation erfolgt in der Datei minako-syntax.y 
- der Parser gibt im erfolgreichen Fall nichts aus und beendet sich mit dem Rückgabewert 0 
- bei einem Parserfehler wird eine Fehlermeldung (beendet durch ein Newline) ausgegeben und das Programm mit einem Rückgabewert != 0 beendet 
- wenn Sie den Parser auf das mitgelieferte C1-Programm demorgan.c1 ansetzen, sollte er entsprechend nichts ausgeben und sich mit Rückgabewert 0 beenden 
- die Verwendung von %expect im Bison-Code ist nicht gestattet

### Zur Hilfestellung seien noch folgende Hinweise gegeben:
- Gehen Sie am Anfang alle EBNF-Konstrukte durch und überlegen Sie sich, wie man diese jeweils generisch in BNF umwandeln kann. 
- In dieser Grammatik ist eine Mehrdeutigkeit enthalten, die einem spätestens bei der Implementierung auffällt. 
- Rufen Sie sich die Bedeutung von %left, %right und %nonassoc in Erinnerung, bevor Sie die Grammatik unnötig verkomplizieren.