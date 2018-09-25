    :- use_module(library(random)).


/* Some TODOs
Print all the possible options for guessing in the beggining of the game
How to do loops in prolog
Cuts in prolog
If conditions in prolog
What is dynamic, how to save global variables, like murderer.


*/


% Include the necessary predicates.
:- dynamic weapon/1.
:- dynamic colour/1.
:- dynamic age_gender/1.
:- dynamic person/3.
:- dynamic murderer/3.

init :-
:- dynamic age_gender/1.
    write(‘Welcome to the game! Let’s find the murderer!’),
    generate_people(List).

instructions :-
    write('Rule introduction - A person was murdered, and the murderer hides in the list of following people as a secret until the end of game. 
            Each person in the list has a unique combination of attributes, and in the list you can see those attributes. Find out who the murderer is and
            you will get a result \'suspect\' or \'innocent\' until you\'re ready to guess who the murder is. A person is considered a \'suspect\' if at least one 
            attribute matches of the murderer. A person is considered to an ‘innocent’ if at no attributes matches the murderer’s. Clear now?'),nl,
    write('Yes, I get it! - Select 1'),nl,
    write('No, I haven\'t known the rule clearly. - Select 2'),nl,
    %TODO Print all the possible options, like three lists
start :-
    instructions,
    read(Choice),
    % we need a cut to leave the game.
    continue(Choice),


age_gender([youngman, youngwoman, middleagedman, middleagedwoman, oldman, oldwoman]).
colour([yellow, red,blue,green]).
weapon([knife, gun, poison]).


person(age_gender, colour, weapon).

%People generation
% TODO Redo people generation with variable number of attributes
generate_people(List):-
    age_gender(Age),
    colour(Colour),
    weapon(Weapon),
    member(A, Age),
    member(B, Colour),
    member(C, Weapon),
    assert(person(A,B,C)),
    fail;
    true.

% Program selects random person from all the combinations and makes him a murderer
select_murderer(List, Person) :-
    random_member(M, List),
    M = Person.


% TODO TO MAKE A GUESS?
% Menu gives player an opportunity to select the right action
menu :- repeat,
    write('=========================='),nl,
    write('To ask for a new clue - Select 1'),nl,
    write('To guess the murderer - Select 2'),nl,
    write('To view the last clue - Select 3'),nl,
    write('To view all suspects - Select 4'),nl,
    write('To view all innocents - Select 5'),nl,
    write('To exit the game - Select 6'),nl,
    write('==========================',),nl,
    write('Enter your choice here: '),
    read(Choice), Choice>0, Choice =<6,
    % What is cut doing here? is this one repeating?
    doit(Choice), Choice=6, !.


% TODO Implement all the actions
doit(1) :-
    get_clue.
doit(2) :-
    % TODO Make it variable arguements
    write('Input the first parameters for your guess: '),
    read(Param1),
    nl,
    write('Input the second parameter for your guess: '),
    read(Param2),
    nl,
    write('Input the third parameter for your guess: '),
    read(Param3), 
    nl
    make_guess(Person(Param1, Param2, Param3)).
    %TODO If make guess is true, then success
doit(3) :-
    %getlastassert
doit(4) :-
    %findall
doit(5) :-
    %findall
doit(6) :-
    %TODO Find out how to exit the game

get_new_person(X) :-

    %keep track of tries
guess(X, Answer). 
list_innocent(List).
list_suspects(List).

make_guess(Person) :-
    Person =:= Murderer.



murderer(person(age_gender, colour, weapon)) :-
    age_gender =:= murderer_age,
    colour =:= murderer_colour,
    weapon =:= murderer_weapon.

%TODO Printing all attributes, regarding the names.
printSuspects :-
    findall(X,validSuspect(X),L1),
    write_ln('Suspects in game are : '),
    write_ln(L1),
    write_ln('Possible Suspect answers as of now are : '),
    findall(Y,possibleSuspect(Y),L2),
    write_ln(L2).

printWeapons :-
    write_ln('Weapons in game are : '),
    findall(X,validWeapon(X),L1),
    write_ln(L1),
    write_ln('Possible Weapon answers as of now are : '),
    findall(Y,possibleWeapon(Y),L2),
    write_ln(L2).

printAges :-
    .

printColours :-

printInnocents :-

    

