/* Some TODOs
How to do loops in prolog
Cuts in prolog
Learn how to write tests
Tests!
Input design, like game console design
Prevent the faults.
Show the number of tries in the end
*/
:- use_module(library(random)).

% Include the necessary predicates.
:- dynamic weapon/1.
:- dynamic colour/1.
:- dynamic age_gender/1.
:- dynamic person/3.
:- dynamic murderer/3.
:- dynamic innocent/3.
:- dynamic suspect/3.
:- dynamic latest/1.

%game instructions
instructions :-
    %print game introduction
    write('================================================================='),nl,
    write('===    Rule introduction - A person was murdered, and the     ==='),nl,
    write('===    murderer hides in the list of following people         ==='),nl,
    write('===    as a secret until the end of game.                     ==='),nl,
    write('===    Each person in the list has a unique combination       ==='),nl,
    write('===    of attributes, and in the list you can see             ==='),nl,
    write('===    those attributes. Find out who the murderer            ==='),nl,
    write('===    is and you will get a result \'suspect\' or            ==='),nl,
    write('===    \'innocent\' until you\'re ready to guess who          ==='),nl,
    write('===    the murder is. A person is considered a \'suspect\'    ==='),nl,
    write('===    if at least one attribute matches of the murderer.     ==='),nl,
    write('===    A person is considered to an \'innocent\' if at        ==='),nl,
    write('===    no attributes matches the murderer\'s                  ==='),nl,
	write('================================================================='),
    nl,
    %printing all the possible attributes
    generate_people,
    printAttributes,
    write('Clear now? '), nl,
    write('Yes, I get it! - Select 1'),nl,
    write('No, I haven\'t known the rule clearly. - Select 2'),
    nl.

list_empty([], true).
list_empty([_|_], false).


init :-
	retractall(clues(X)),
	assert(clues(0)),
	%TODO Check for incorrect input
    retractall(person(X,Y,Z)),
    retractall(innocent(X,Y,Z)),
    retractall(suspect(X,Y,Z)),
    retractall(murderer(X,Y,Z)),
    instructions,
    %ask user for choice
    read(Choice),
    %do functions upon the user choice
    start(Choice).

%start the game
start(X) :-
    X =:= 1,
    play.

%leave the game as user did not get the rules
start(X) :-
    X =:= 2,
    exit_before_start.

exit_before_start :-
    write('We can\'t continue the game for now, read the manual once again'),
    nl.

exit :-
    write('You have got '),
    clues(X),
	write(X),
    write(' number of clues'),
    nl,
    write('We are ending the game now. See you next time!'),
    nl.

count([],0).
count([H|Tail], N) :-
    count(Tail, N1),
    (  number(H)
    -> N is N1 + 1
    ;  N = N1
    ).

generate_people :-
    age_gender(Age),
    colour(Colour),
    weapon(Weapon),
    member(A, Age),
    member(B, Colour),
    member(C, Weapon),
    assert(person(A,B,C)),
    fail;
    true.

remove(latest(P)) :-
    retractall(latest(P));retract(latest(P)).


% Program selects random person from all the combinations and makes him a murderer
select_murderer :-
    %How to find person 
    findall((A,B,C), person(A,B,C), List),
    random_member((A,B,C), List),
    assertz(murderer(A,B,C)).

play :-
    select_murderer,
    menu.

% TODO TO MAKE A GUESS?
% Menu gives player an opportunity to select the right action
menu :- repeat,
	%TODO Check for incorrect input
    write('======================================'),nl,
    write('To ask for a new clue - Select 1'),nl,
    write('To guess the murderer - Select 2'),nl,
    write('To view the last clue - Select 3'),nl,
    write('To view all suspects  - Select 4'),nl,
    write('To view all innocents - Select 5'),nl,
    write('To exit the game      - Select 6'),nl,
    write('======================================'),nl,
    write('Enter your choice here: '),
    read(Choice), Choice>0, Choice =<6,
    %TODO Remove repeating of Menu for 2 and 6

    doit(Choice), Choice=2, !.
    doit(Choice), Choice=6, !.

%Get only one person
get_clue :-
    person(X,Y,Z),
    innocent_or_suspect(X,Y,Z,Message),
    write(person(X,Y,Z)),
    write(' - '),
    write(Message),nl,
	clues(Q),
	retract(clues(Q)),
	W is Q+1,
	assert(clues(W)),
    retract(person(X,Y,Z)).


innocent_or_suspect(X,Y,Z, 'Suspect') :-
    murderer(Q,W,E),
    (X == Q; Y == W; Z==E),
    remove(latest(P)),
    assert(latest(suspect(X,Y,Z))),
	assert(suspect(X,Y,Z)).

innocent_or_suspect(X,Y,Z, 'Innocent') :-
    murderer(Q,W,E),
    X \== Q, Y \== W, Z\==E,
    remove(latest(P)),
    assert(latest(innocent(X,Y,Z))),
	assert(innocent(X,Y,Z)).


% TODO Implement all the actions
doit(1) :-
    get_clue,
    menu.
doit(2) :-
	%TODO Check for incorrect input
    % TODO Make it variable arguements
    %TODO Make go back
    write('Input the first parameters for your guess: '),
    nl,
    write('Available options are: '),
    age_gender(Age),
    print_list(Age),
    nl,
    read(Param1),
    nl,
    write('Input the second parameter for your guess: '),
    nl,
    write('Available options are: '),
    colour(Colour),
    print_list(Colour),
    nl,
    read(Param2),
    nl,
    write('Input the third parameter for your guess: '),
    nl,
    write('Available options are: '),
    weapon(Weapon),
    print_list(Weapon),
    nl,
    read(Param3), 
    nl,
    make_guess(person(Param1,Param2,Param3)).
doit(3) :-
    %TODO printPredicate funiction
    %TODO fix printing correct answer.
    latest(P),
	P =.. List,
    print_list(List),
    nl.
doit(4) :-
    printSuspects,
    menu.
doit(5) :-
    printInnocents,
    menu.
doit(6) :-
    exit.



%TODO Printing all attributes, regarding the names in the begining
printSuspects :-
    findall((A,B,C), suspect(A,B,C), List),
    list_empty(List, true),
    write('The were no shown suspects so far'),
    nl.

printSuspects :-
    findall((A,B,C), suspect(A,B,C), List),
    %how to do negation
    list_empty(List, false),
    write('All the checked suspects are here: '),
    write(List),
    nl.

printInnocents :-
    findall((A,B,C), innocent(A,B,C), List),
    list_empty(List, false),
    write('All the checked innocents are here: '),
    write(List),
    nl.

printInnocents :-
    findall((A,B,C), innocent(A,B,C), List),
    list_empty(List, true),
    write('The were no shown innocents so far'),
    nl.
    

printAttributes :-
    age_gender(Age),
    colour(Colour),
    weapon(Weapon),
    write('Available attributes are: '),
    nl,
    write('Age and gender: '),
    write(Age),
    nl,
    write('Colour: '),
    write(Colour),
    nl,
    write('Weapon: '),
    write(Weapon),
    nl.

is_murderer(person(X,Y,Z)) :-
    murderer(X,Y,Z).
    
%TODO implement make guess
make_guess(Person) :-
    is_murderer(Person),
    write('You were right!'),
    menu.

make_guess(Person) :-
    \+ is_murderer(Person),
    write('You lost!'),
    nl,
    exit.

age_gender([youngman, youngwoman, middleagedman, middleagedwoman, oldman, oldwoman]).
colour([yellow, red,blue,green]).
weapon([knife, gun, poison]).


%People generation
% TODO Redo people generation with variable number of attributes


%keep track of tries
guess(X, Answer). 
list_innocent(List).
list_suspects(List).

print_list([]).
print_list([X|Tail]) :-
    write(X),
    write(', '),
    print_list(Tail).

printPredicate(P) :-
    P =.. List,
    print_list(List).