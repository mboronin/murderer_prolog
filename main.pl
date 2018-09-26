/*
To start the program type 'start.'
To test the program consult it, and then run consult test.pl
*/

% Random is used for murderer selection
:- use_module(library(random)).

/*
@descr Required program variables
@date 23/09/2018
*/
:- dynamic weapon/1.
:- dynamic colour/1.
:- dynamic age_gender/1.
:- dynamic person/3.
:- dynamic murderer/3.
:- dynamic innocent/3.
:- dynamic suspect/3.
:- dynamic latest/1.


/*
@descr Lists with attributes, used as people characteristics
@date 23/09/2018
*/
age_gender([youngman, youngwoman, middleagedman, middleagedwoman, oldman, oldwoman]).
colour([yellow, red,blue,green]).
weapon([knife, gun, poison]).


/*
@descr Printing game instructions, a part of start
@date 23/09/2018
*/
instructions :-
    %print game introduction
    write('============================================================='),nl,
    write('|    Rule introduction - A person was murdered, and the     |'),nl,
    write('|    murderer hides in the list of following people as a    |'),nl,
    write('|    secret until the end of game. Each person in the       |'),nl,
    write('|    list has a unique combination of attributes, and in    |'),nl,
    write('|    the list you can see those attributes. Find out who    |'),nl,
    write('|    the  murderer is and you will get a result \'suspect\'   |'),nl,
    write('|    or \'innocent\' until you\'re ready to guess who the      |'),nl,
    write('|    murderer is. A person is considered a \'suspect\' if     |'),nl,
    write('|    at least one attribute matches of the murderer. A      |'),nl,
    write('|    person is considered to an \'innocent\' if at no at-     |'),nl,
    write('|    tribttes matches the murderer\'s                        |'),nl,
	write('============================================================='),
    nl,
    % generation of all possible person combination
    generate_people,
    printAttributes,
    write('Clear now? '), nl,
    write('Yes, I get it! - Select 1'),nl,
    write('No, I haven\'t known the rule clearly. - Select 2'),
    nl.

/*
@descr check if list is empty
@date 23/09/2018
*/
list_empty([], true).
list_empty([_|_], false).

/*
@descr Initializing the game the game
@date 23/09/2018
*/
start :-
	retractall(clues(X)),
	assert(clues(0)),
    retractall(person(X,Y,Z)),
    retractall(innocent(X,Y,Z)),
    retractall(suspect(X,Y,Z)),
    retractall(murderer(X,Y,Z)),
    retractall(latest(P)),
    instructions,
    %Read and check the incorrect input
    read_input('Type your choice below', IntroReply, check_intro_reply, 'Incorrect Input, try again: '),
    init(IntroReply), !.

/*
@descr Start of the game menu
@date 23/09/2018
*/
init(1) :-
    play.
init(2) :-
    write('We can\'t continue the game for now, read the manual once again'),
    nl.

/*
@descr Checks if input in initialization is correct
@date 23/09/2018
*/
check_intro_reply(IntroReply) :-
    IntroReply is 1 ; IntroReply is 2.

/*
@descr Checks if input in the main menu is correct
@date 23/09/2018
*/
check_main_reply(MainReply) :-
    MainReply@>0,MainReply@=<6.

/*
@descr Checks if input in the guessing is correct
@date 23/09/2018
*/
check_guess_reply(GuessReply) :-
    age_gender(Age),
    colour(Colour),
    weapon(Weapon),
    (member(GuessReply,Age);member(GuessReply,Colour);member(GuessReply,Weapon)).

/*
@descr General exit function, lists the number of clues
@date 23/09/2018
*/
exit :-
    write('You have got '),
    clues(X),
	write(X),
    write(' number of clues'),
    nl,
    write('We are ending the game now. See you next time!'),
    nl.

/*
@descr Generate all possible person combinations and asserting it to the memory
@date 23/09/2018
*/
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

/*
@descr Remove latest stored info, is used to update the latest clue
@date 23/09/2018
*/
remove(latest(P)) :-
    retractall(latest(P));retract(latest(P)).

/*
@descr Selects random person from all the combinations and makes him a murderer, storing it in the memory
@date 23/09/2018
*/
select_murderer :-
    %How to find person 
    findall((A,B,C), person(A,B,C), List),
    random_member((A,B,C), List),
    assertz(murderer(A,B,C)).

/*
@descr Selects the murderer and starts the menu
@date 23/09/2018
*/
play :-
    select_murderer,
    menu.

/*
@descr Menu, which gives player an opportunity to select the right action
@date 23/09/2018
*/
menu :- repeat,
    write('==================================='),nl,
    write('| To ask for a new clue - Select 1 |'),nl,
    write('| To guess the murderer - Select 2 |'),nl,
    write('| To view the last clue - Select 3 |'),nl,
    write('| To view all suspects  - Select 4 |'),nl,
    write('| To view all innocents - Select 5 |'),nl,
    write('| To exit the game      - Select 6 |'),nl,
    write('===================================='),nl,
    read_input('Enter your choice below', MainReply, check_main_reply, 'Incorrect Input, try again'),
    doit(MainReply), (Choice=6; Choice=2), !.

/*
@descr Gives a random person from memory and increases the number of received clues
@date 23/09/2018
*/
get_clue :-
    findall((X,Y,Z), person(X,Y,Z), List),
    random_member((X,Y,Z), List),
    innocent_or_suspect(X,Y,Z,Message),
    write(person(X,Y,Z)),
    write(' - '),
    write(Message),nl,
	clues(Q),
	retract(clues(Q)),
	W is Q+1,
	assert(clues(W)),
    retract(person(X,Y,Z)).

/*
@descr Checking if the person is innocent or suspect
       Murderer is considered as suspect, as it happens in real life
@param1 param2 param3 Person attributes
@param4 The message with characcteristics is printed in  get_clue.
@date 23/09/2018
*/
innocent_or_suspect(X,Y,Z, 'suspect') :-
    murderer(Q,W,E),
    (X == Q; Y == W; Z==E),
    remove(latest(P)),
    assert(latest(suspect(X,Y,Z))),
	assert(suspect(X,Y,Z)).

innocent_or_suspect(X,Y,Z, 'innocent') :-
    murderer(Q,W,E),
    X \== Q, Y \== W, Z\==E,
    remove(latest(P)),
    assert(latest(innocent(X,Y,Z))),
	assert(innocent(X,Y,Z)).


/*
@descr Implementation of all the menu actions
@date 23/09/2018
*/
doit(1) :-
    get_clue,
    menu.
doit(2) :-
    write('Input the first parameters for your guess: '),
    nl,
    write('Available options are: '),
    age_gender(Age),
    print_list(Age),
    nl,
    read_input('Type below', Param1, check_guess_reply, 'Incorrect Input, try again'),
    nl,
    write('Input the second parameter for your guess: '),
    nl,
    write('Available options are: '),
    colour(Colour),
    print_list(Colour),
    nl,
    read_input('Type below', Param2, check_guess_reply, 'Incorrect Input, try again'),
    nl,
    write('Input the third parameter for your guess: '),
    nl,
    write('Available options are: '),
    weapon(Weapon),
    print_list(Weapon),
    nl,
    read_input('Type below', Param3, check_guess_reply, 'Incorrect Input, try again'),
    nl,
    make_guess(person(Param1,Param2,Param3)).
doit(3) :-
    latest(P),
	printPredicate(P),
    nl,
    menu.
doit(4) :-
    printSuspects,
    menu.
doit(5) :-
    printInnocents,
    menu.
doit(6) :-
    exit.

/*
@descr Printing all the suspects, from the queried clues
       If no suspects so far, the message is printed
@date 23/09/2018
*/
printSuspects :-
    findall((A,B,C), suspect(A,B,C), List),
    list_empty(List, true),
    write('The were no shown suspects so far'),
    nl.

printSuspects :-
    findall((A,B,C), suspect(A,B,C), List),
    list_empty(List, false),
    write('All the checked suspects are here: '),
    write(List),
    nl.

/*
@descr Printing all the innocents from the queried clues
       If no innocents so far, the message is printed
@date 23/09/2018
*/
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
    
/*
@descr Print all the available attributes for the game
@date 23/09/2018
*/
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

/*
@descr Check if the pesron is murderer
@date 23/09/2018
*/
is_murderer(person(X,Y,Z)) :-
    murderer(X,Y,Z).
    
/*
@descr Making a guess, output depends on being right or not
@date 23/09/2018
*/
make_guess(Person) :-
    is_murderer(Person),
    write('Congratulations! You were right!'),
    nl,
    exit.

make_guess(Person) :-
    \+ is_murderer(Person),
    write('You lost!'),
    nl,
    exit.

/*
@descr Printing the lists in more natural way
@date 23/09/2018
*/
print_list([]).
print_list([X|Tail]) :-
    write(X),
    write(', '),
    print_list(Tail).

/*
@descr Printing predicates
@date 23/09/2018
*/
printPredicate(P) :-
    P =.. List,
    list_empty(List, false),
    List = [X|Tail],
    print_list(Tail),
    write(' - '),
    write(X).

/*
@descr Reading input and checking if it is correct
@date 23/09/2018
*/
read_input(Prompt, Value, CheckPred, ErrorMsg) :-
    repeat,
        format('~w:~n', [Prompt]),
        read(Value),
        (   call(CheckPred, Value)
        ->  true, !
        ;   format('ERROR: ~w.~n', [ErrorMsg]),
            fail
        ).


