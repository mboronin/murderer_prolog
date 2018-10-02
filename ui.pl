/*
UI part of Murderer game
@author Mikhail
@author Wafaa Elbaghday
@author Hongyu He
*/

/*
@descr Printing game instructions, a part of start
@date 23/09/2018
@author Mikhail Boronin
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
    printAttributes,
    write('Clear now? '), nl,
    write('Yes, I get it! - Select 1'),nl,
    write('No, I haven\'t understood the rule clearly. I want to exit the game - Select 2'),
    nl.


/*
@descr Initializing the game the game
@date 23/09/2018
*/
start :-
    clean_db,
    generate_people,
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
@descr General exit function, lists the number of clues and the actual murderer
@date 23/09/2018
*/
exit :-
    write('The murderer is '),
    findall((X,Y,Z), murderer(X,Y,Z), List),
    print_list(List),
    nl,
    write('You have used '),
    clues(X),
	write(X),
    write(' clue(-s)'),
    nl,
    write('We are ending the game now. See you next time!'),
    nl.

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
@descr Implementation of all the menu actions
@param Actual selected option
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
    read_input('Type below', Param1, check_guess_reply, 'There is no such option, try again'),
    nl,
    write('Input the second parameter for your guess: '),
    nl,
    write('Available options are: '),
    colour(Colour),
    print_list(Colour),
    nl,
    read_input('Type below', Param2, check_guess_reply, 'There is no such option, try again'),
    nl,
    write('Input the third parameter for your guess: '),
    nl,
    write('Available options are: '),
    weapon(Weapon),
    print_list(Weapon),
    nl,
    read_input('Type below', Param3, check_guess_reply, 'There is no such option, try again'),
    nl,
    make_guess(person(Param1,Param2,Param3)).
doit(3) :-
    printLatest,
    menu.
doit(4) :-
    printSuspects,
    menu.
doit(5) :-
    printInnocents,
    menu.
doit(6) :-
    exit.