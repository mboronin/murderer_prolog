/*
To start the program type 'start.'
To test the program consult this file, and then run consult test.pl
To run tests use 'test1.' 'test2.' etc.
@author Mikhail
@author Wafaa Elbaghday
@author Hongyu He
 */

% Random is used for murderer selection
:- include('ui.pl').
:- use_module(library(random)).

/*
@descr Required program variables
@date 23/09/2018
@author Mikhail Boronin
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
@author Mikhail Boronin
 */
age_gender([youngman, youngwoman, middleagedman, middleagedwoman, oldman, oldwoman]).
colour([yellow, red,blue,green]).
weapon([knife, gun, poison]).

/*
@descr check if list is empty
@date 23/09/2018
@author Mikhail Boronin
 */
list_empty([], true).
list_empty([_|_], false).

/*
@descr cleans database from all asserted values, sets clues to 0
@author Mikhail Boronin
 */
clean_db :-
    retractall(clues(X)),
    retractall(person(X,Y,Z)),
    retractall(innocent(X,Y,Z)),
    retractall(suspect(X,Y,Z)),
    retractall(murderer(X,Y,Z)),
    retractall(latest(P)),
    assert(clues(0)).

/*
@descr Reading input and checking if it is correct
@param Prompt Message before input
@param Value Input value
@param CheckPred Predicate for checking input
@aram ErrorMsg Error message
@date 23/09/2018
@author Mikhail Boronin
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

/*
@descr Checks if input in initialization is correct
@param IntroReply The value to check
@date 23/09/2018
@author Mikhail Boronin
 */
check_intro_reply(IntroReply) :-
    IntroReply is 1 ; IntroReply is 2.

/*
@descr Checks if input in the main menu is correct
@param MainReply The value to check
@date 23/09/2018
@author Mikhail Boronin
 */
check_main_reply(MainReply) :-
    MainReply@>0,MainReply@=<6.

/*
@descr Checks if input in the guessing is correct
@param GuessReply The value to check
@date 23/09/2018
@author Mikhail Boronin
 */
check_guess_reply(GuessReply) :-
    age_gender(Age),
    colour(Colour),
    weapon(Weapon),
    (member(GuessReply,Age);member(GuessReply,Colour);member(GuessReply,Weapon)).

/*
@descr Generate all possible person combinations and asserting it to the memory
@date 23/09/2018
@author Mikhail Boronin
 */
generate_people :-
    age_gender(Age),
    colour(Colour),
    weapon(Weapon),
    member(A, Age),
    member(B, Colour),
    member(C, Weapon),
    assert(person(A,B,C)),
    fail
    ;
    true.

/*
@descr Remove latest stored info, is used to update the latest clue
@param latest(P) actuall fact, which should be removed
@date 23/09/2018
@author Mikhail Boronin
 */
remove(latest(P)) :-
    retractall(latest(P))
    ;
    retract(latest(P)).

/*
@descr Selects random person from all the combinations and makes him a murderer, storing it in the memory
@date 23/09/2018
@author Mikhail Boronin
 */
select_murderer :-
    %How to find person 
    findall((A,B,C), person(A,B,C), List),
    random_member((A,B,C), List),
    assertz(murderer(A,B,C)).

/*
@descr Gives a random person from memory and increases the number of received clues
@date 23/09/2018
@author Mikhail Boronin
 */
get_clue :-
    findall((X,Y,Z), person(X,Y,Z), List),
    list_empty(List, false),
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

get_clue :-
    findall((X,Y,Z), person(X,Y,Z), List),
    list_empty(List, true),
    write('No more clues left').

/*
@descr Checking if the person is innocent or suspect
       Murderer is considered as suspect, as it happens in real life
@param1 param2 param3 Person attributes
@param4 The message with characcteristics is printed in  get_clue.
@date 23/09/2018
@author Mikhail Boronin
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

printLatest :-
    clues(X),
    X > 0,
    latest(P),
	printPredicate(P).
printLatest :-
    write('You have not used any clues so far'),
    nl.

/*
@descr Printing all the suspects, from the queried clues
       If no suspects so far, the message is printed
@date 23/09/2018
@author Mikhail Boronin
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
@author Mikhail Boronin
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
@author Mikhail Boronin
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
@author Mikhail Boronin
 */
is_murderer(person(X,Y,Z)) :-
    murderer(X,Y,Z).
    
/*
@descr Making a guess, output depends on being right or not
@param Person Actual person, which will be guessed
@date 23/09/2018
@author Mikhail Boronin
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
@param List to be printed
@date 23/09/2018
@author Mikhail Boronin
 */
print_list([]).
print_list([X|Tail]) :-
    write(X),
    write(', '),
    print_list(Tail).

/*
@descr Printing predicates
@param Predicate to be printed
@date 23/09/2018
@author Mikhail Boronin
 */
printPredicate(P) :-
    P =.. List,
    list_empty(List, false),
    List = [X|Tail],
    print_list(Tail),
    write(' - '),
    write(X),
    nl.

/*
@descr Service function to print murderer
@author Mikhail Boronin
 */
printMurderer :-
    findall((X,Y,Z), murderer(X,Y,Z),List),
    print_list(List).