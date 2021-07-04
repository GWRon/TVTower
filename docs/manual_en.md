Manual for Developer Version
============================

Author: Själe

Translator: Matthew Forrester [notes in square brackets]

Foreword

Please always have in mind that this is a developer version. It's far from perfect and many things are still missing. But we try to make sure that you always have playable software.

For this we depend on your help. Tell us about mistakes, make suggestions, discuss with us whether the game makes sense or not, and lend a hand, if you have the skills to contribute. It's also great to motivate ourselves by chatting in the forum:

https://www.gamezworld.de/phpforum/

At the moment the game is playable as an endless game. The AI works, but it's not yet in it's final state.

At the end of the manual there's a list of keyboard shortcuts for this developer version.


Contents
========

* Loading and Saving
* Game Speed
* Movement of In-Game Characters
* Functionality and Features:
    * Programme Schedule
    * Archive
    * Movie Agency
    * Ad Agency
    * News Studio
    * Station Purchase
    * Script Agency
    * Studio
    * Supermarket
    * Boss-Loans-Begging
    * Terrorist
    * Room Agency
    * FSK 18 and Bailiffs
* Interface
* Chat and Cheats
* Processes in the Background
* Changes Made by the Players
* Keyboard Shortcuts for the Developer Version

Loading and Saving
==================

There are two ways to save and load the game. On the one hand, you can open up the appropriate menu by pressing the "Escape" key. By left-clicking on the respective menu entries, you can get to the corresponding sub-menu. When saving, enter a name. When loading, find a savegame and select the appropriate entry.

On the other hand, there's also the possibility of quick-saving and -loading. Simply press these keys:

* Quick Save - "F5" key
* Quick Load - "F8" key

Game Speed
==========

You can change the game's speed with the "up" and "down" arrow keys. There are also preset speeds. For this, see the end of the "Keyboard Shortcuts for the Developer Version". The "left" and "right" arrow keys alter the game speed and the movement speed of the in-game characters.

Movement of In-Game Characters
==============================

If possible, your avatar will go wherever you left-click with the mouse pointer. If you click on a door or another interaction object, then the in-game character will try to move there. If a room is occupied, then the avatar will stop in front of it.

Inside the rooms, actions are usually triggered by left-clicking. Clicking on the right mouse button leaves the current menu or the room in which you are located.

The "Esc" key will call up a menu that allows you to save the game, to terminate it or to reload.

Before you really get started, it is recommended to save the game at the beginning and wander through the building. You may discover the noticeboard with the names of all those who laboured to make this free gaming experience possible for you.


Functionality and Features
==========================

The basic things are explained in a video:

https://www.youtube.com/watch?v=9reFu18PIJg

Tom.io introduces the game with an (almost) complete explanation [in German]:

https://www.youtube.com/watch?v=LaXdh_o3HA4

For those who like to read the full story, or who have used up their data allowance, it will be briefly described below.

Programme Schedule
------------------

To get to the Programme Schedule, you must first enter the player's office. Left-click on the door or select it in the elevator plan and your in-game character will move there. Left-clicking on the computer in the office will present you with the Programme Schedule.

You will see the first day. At the beginning of the game, the Opening Show and three advertisements are already in place. In addition, an advertisement has been scheduled as an infomercial. This is only the case at the beginning of the game and should give you enough time to explore the game in peace.

As long as the programme or advertisement blocks are coloured grey, then you can move them to other broadcast slots. Other colours mean that they are already being or have been  broadcast. A red advertising block means that it did not fulfill the requirements.

Moving the mouse pointer over a programme or an advertisement displays a tooltip containing information about the selected programme.

To move a programme/advertisement simply left-click on it, then the item is picked up and is attached to the mouse pointer. To drop the item, left-click again.

If you want to place your (even already broadcast) programmes/advertisements in another slot, press the "Ctrl"-key and then left click. The existing broadcast stays where it is; the duplicate is attached to the cursor and can be placed in the current location with a fresh left-click.

If you want to place individual episodes of a series in sequence, press the "Shift"-key and left-click on it. As long as the "Shift"-key is pressed, then every left-click will place an episode.

If you place an advertisement in a schedule slot, then it becomes an infomercial. These receive a certain amount of money per viewer. But they also damage your image with the viewers.

By contrast, if you place a programme in an advertising slot, then a trailer for that programme is created. This trailer ensures that more viewers will watch the programme. However, the number of additional viewers depends on how many viewers saw the programme before the trailer. Multiple broadcasts strengthen this effect, though only up to an upper limit. Every further trailer then draws no additional viewership.

If you want to see or change the schedule for the following day or days, then use the the little arrow in the top right. Obviously you can also go back again.

Available advertisements and programmes can be seen in the respective menu options on the right. There are also more tooltips here when you move the mouse pointer over the programme/advertisement. Left-click to drag the programmes. Left-click to put them down again. "Shift" and left-click retains the programme as long as you have the "Shift"-key pressed. If necessary, a right-click will give you a free hand again.

You also find the "Finance", "Statistics" and "Achievements" items on the right of the Programme Schedule. Left-clicking on them opens the corresponding screens, which will show you more detailed information.

Archive
-------

In the Archive you meet the archivist. You need him, if you want to sell the programme rights that you own. Click on the archivist and you will be shown a list of the genres. If you own rights from a certain genre, then it is coloured black, with green lines next to it, which indicate the number of rights under ths genre. So click on a genre and select the rights that you want to move to the Movie Agency, click on them and place it in the suitcase.

But beware! If you put rights which are currently used in the Programme Schedule into the suitcase and leave the room, then the programme will be deleted from the schedule. So you will have to fill that gap again later.

Movie Agency
------------

This is used for the acquisition and sale of films, series, and so forth ('programme rights'). On the left you can see the agent behind his desk. On the right there's a bookcase. In the centre is your suitcase. If you have come straight from the archive, it may contain the rights that you've selected to sell. If you want to sell them, left-click on them and click on the movie agent with the programme rights. Then the rights are gone. But whether they will turn up in the bookcase again is uncertain.

Turning to acquisition, there are two methods. Firstly, the programme rights in the bookcase. Move the mouse pointer over the slipcases and it will bring up information about the respective rights. The price, course. It states whether or not you can afford it. More important for the audience ratings, however, are the bars for Speed, Box Office and Critics for the programmes included in the rights. And also the Topicality. This decreases with every broadcast. And with it the monetary value of the rights. If the programme isn't broadcast for a while, the Topicality will return to a certain level.

How the attributes of programmes are to be assessed, described by STARSCRazy:

"Speed: How interesting the programme is to Joe Bloggs (affects viewer evaluations).

Critics: How interesting the programme is to critics (affects critics' assessment).

Box Office: How successful a film was at the box office.

For all three values: the higher the better.

But each has some values that are more important than others, according to their genre:

* Critics is especially important when it comes to Culture, Live, Music, and Shows.
* Speed is important in Erotic, Sport, Gossip, pay-TV
* Box Office matters for Action, Sci-Fi, Fantasy, Comedy, Romance"

Left-click on a package of programme rights, move them over the suitcase and click once more, then they will be placed in the suitcase. That's only a pre-selection though. Although the money is immediately deducted, if you click on the rights again and move them to the bookcase, and click there again, they are placed in the bookcase and the money is back in your account. But if you leave the room with the rights in the suitcase, then the rights package unavoidably ends up in the archive and is automatically available for your programme planning. Should the suitcase be full of programmes, then leave the room, wait a while, re-enter it and you will have enough space to go shopping again. By the way: the gaps opened by your purchases will have been filled by the agent in the meantime.

The second way to acquire programme rights here is by auction. For this, click on the auctioneer's hammer on the agent's desk. This displays a menu with rights and their respective minimum bids. Mouse over it to display the information about the programme rights again. Click on it and you have made an offer. The money is immediately deducted from your account. If no other player has bid by midnight, then the rights automatically are yours and are available for programme planning.


Ad Agency
---------

This is the good fellow who keeps the wolf from the door. Well, he actually wants to flog us the stuff which ruins a film for the viewers or gives them a chance to get crisps. In a nutshell: here are the commercials which are broadcast each hour and keep the cash rolling in. You can see folders on the table and by the wall and your suitcase in the top right corner. There are usually folders in this case. Those are the advertising contracts you previously signed. You automatically get three at the start of the game. If the suitcase is full, then you can't sign new advertising contracts. You can only free up space once your adverts have finished broadcasting. Or if they pass the time limit, which, however, results in a penalty.

Move the mouse over the folders and you'll see information about the relevant advert. I don't need to explain the profit any further. The penalty is due if you don't broadcast the required commercials in the specified time with the required viewers. The tooltip also shows you how many times the advert has already been scheduled and broadcast.

Here, too, the gaps that have been torn will be filled again after leaving the room. So head straight back in to see if something attractive has come in.

There is a separate icon on the bottom left of the window. Move the mouse pointer over it and a menu pops up where the advertising contracts can be sorted by viewing figures or profit.

Please don't complain too much that the advertising payments are not yet balanced correctly. This is an open field and not so finished either. But we're working on it.

News Studio
-----------

In the News Studio the news is produced, as you'd expect. You can see the newsreader's booth on the right. That's just there to look good.

On the left, you see six coloured boards with different symbols. You can adjust the subscription levels there. The tooltip shows you which symbol belongs to which genre. The subscription levels differ in the time delay with which you receive the news. At level 0, you don't receive any news for this genre. At level 3, you receive it as soon as the news is released. Subscription level 0 costs nothing, 3 costs the most.

The game will add news bit by bit, as allowed by the predetermined level of delay. The news can entice viewers from other stations, who might then also watch the other programmes on your channel. Something to watch out for is that the billing level is always based on the highest one which was set that day. So it's worth implementing cutbacks just before midnight.
You don't need to worry if you switch through the levels. The actual change takes effect only after a few seconds.

If you click on the pinboard, then you come to the actual centrepiece: the supply of news - on the left - and those selected for transmission - on the right.

As usual, left-click an item to pick it up and move it where you want to drop it. If the target slot was not empty, dropping an item will automatically pick up the item from that slot. Reposition that item as well by left-clicking or dispose of it by right-clicking. In the latter case, however, it is no longer available.

Since the news possesses its own audience rating calculation, it can be quite interesting to try a few combinations. It is definitely possible to push the news audience higher than that of the preceding programme. Then the following programme can in turn get more viewers. In addition, the different viewer groups react differently to different news items. But find out for yourself. The sequence of the broadcast news items also has an effect.

Station Purchase
----------------
We've now obviously come to one of the strategically most important features. Should I use money for station construction or for better programmes? The menu for station construction can be found by left-clicking on the map on the far right [of your office].

If you then click on "New Station", a transmission mast symbol appears on the mouse pointer, which you can move over the map. In doing so it will display to you how many viewers you can reach at the appropriate location. That will also always indicate how many new viewers you would gain. That will be important if there are several transmission masts in metropolitans areas, which might perhaps overlap. Each possible viewer obviously only counts once. Not to be forgotten is the information in the lowest line: the expected purchase price.

When you have found a suitable place for the mast, fix it by left-clicking and confirm with the "Buy Station" button. If you like the look of somewhere else after placing, then you can remove the transmission mast again by right-clicking. If you have already clicked on the "Buy" button it's obviously too late for that. You can sell the transmission mast again. To do this, select it in the list on the right and then click the "Sell Station" button. You get less money back from the tightwads than it cost you.

The menu items "Cable Network Uplinks" and "Satellite Uplinks" at the bottom give you access to available cable networks and satellites. While the available satellites will be listed, the available cable networks will be shown by moving over the map. If you meet the specified conditions, you can rent the connections. Be aware that for each one there is a one-year contractual term. The coverage of cable and satellite is based on the real data. Therefore only partial coverage of the areas is to be expected. However, this rises in the course of the game.

For all three types of transmission, the range is extended at the beginning of the next hour.

Script Agency
-------------

Here, you can buy scripts for your in-house productions. They stand on and next to the little cupboard by the door. Hovering the mouse pointer over them lets data sheets appear, on which you can read up on the relevant information. Click on the desired script and place it in the suitcase. As soon as you leave the room, the selected script is yours.

Studio
------

Take the chosen script into the Studio. Click on the desired script in the suitcase and place it on the little cabinet on the right. Left-click the studio manager on the left and a dialogue is displayed in which you can ask for a shopping list. These appear below in the centre, after left-clicking on "I need a shopping list for this script." And off we go to the Supermarket.

Returning from the Supermarket, you can start the production if the shopping list has been completed. Simply click on the studio manager and choose whether only the first or all of the planned productions should be made.

Supermarket
-----------

Enter the Supermarket and you will be offered a dialogue which leads to buying a present for Betty or the procedure for programme pre-production.

Betty gifts are only interesting to Betty or not at all. Try out for yourself whether your assessment of her character corresponds to the in-game reality. There's nothing more to add here.

So choose programme production. Shopping lists you have been given by the studio manager are listed on the top left of the next screen. Click on the one you want.

The various required cast members (director, actor, etc.) now appear in the middle. Click on an entry and a list of possible characters is displayed. The blue bars roughly symbolize the appropriate level of experience. This changes with further productions. Move the mouse cursor over the characters and it displays a tooltip for each character with their individual attributes. The attributes in green are particularly important for the present production, those in grey are relatively uninteresting. Choose a character for each required cast member.

If you should want to undo your choice, it's possible by right-clicking on the appropriate character.

Next a production company has to be selected in the part of the screen on the right. There are three levels. Each level has its price and allows for distributing a certain number of production points. The former must be paid, the latter can be assigned to the main production areas. Or alternatively to the speed of production.

The main areas of production are each weighted differently according to their genres. For example, an action film is more in need of stunts than a romance. When all the points have been allocated, planning can be completed on the left below the information about total cost and the production time.

Ten percent of the total cost is due immediately. The the rest is automatically paid on completing the production which you will be informed about by an in-game notification. The programme is then available in the programme planner. By the way, the studio cannot be entered during production time. The studio door tooltip informs you about the production status.

Boss-Loans-Begging
------------------

The Boss' room is right of the elevator on your floor. He is a boss of the old school, please keep an eye on his exquisitely animated cigar smoke (not that it matters at all).

What there is do, or not do, here will be shown in the speech bubble. Simply click on the one that corresponds to your request, which is currently drawn only from financial choices. Pay back or ask for new loans.

The credit allocation depends on different factors. So not keeping advertising contracts or broadcasting outages changes the boss' mood, which at the moment only has implications for the line of credit.

From time to time a notification appears that the boss wants to see you. He gives you two in-game hours for this. If you let the time expire, your character will automatically move to the director's office. It just knows what's best for it. You can immediately pay a visit by left-clicking on the notification.

In addition, the boss informs you about upcoming Sammy awards. If you win the competition, the reward is a small prize in cash or a bonus to the audience ratings.

Terrorist
---------

He is a nasty piece of work. Not without controversy, he ensures that there are always enough free roooms in the building. Because free rooms are scarce and in the later course of the game needed as larger studios. The first one that you have is only size one.

The terrorist is actually a henchman of both Dubanian embassies, who are in perpetual conflict with one another. The other side is the real target. The terrorist threat is announced with a notification later in the course of events.

Shortly afterwards, the terrorist enters the building and goes to the information board. That is where you have the chance to participate. Because you can mix up the nameplates on the information board. Put the nameplate of the embassy of the country which is mentioned in the news as the target for a possible attack to place that suits you and the terrorist will direct his steps there. If you would like to see what happens, simply follow along.

By the way, the AI can also place the appropriate embasssy nameplate on your offices or studios.

Room Agency
-----------

This pleasant chap lets you rent newer and eventually bigger studios. Left-click on the pinboard and it displays the occupied rooms in the building. The potential rentable ones are highlighted. A tooltip contains the present tenant of each one and the studio size. So far, the latter has no impact on the in-house productions.

We will learn later how you can convince the tenants to give up their rooms.

'FSK18' and Bailiffs
--------------------

Programmes with the label 'FSK18' [the German equivalent of an 18 certificate or TV-MA rating] may not be broadcast between 0600 and 2200 according to the Youth Protection Law of TVTower-land. It rests with you whether you will abide by that. But there's a catch. Or, more accurately, two. The authorities could detect in the Programme Schedule that you intend to flout the law. A fine is subsequently due and the programme will be removed from the Programme Schedule. Then you must fill the gap again.

If you have managed to smuggle the programme past the censor unnoticed, there is still always a 25% chance that one of the two court bailiffs (Mr Czwink and Mr Czwank) appear after the broadcast. Since they don't know their way around TV-Tower that well, they inform themselves at the information board just like Mr Terrorist. Swap the appropriate Archive nameplate and rights might be confiscated from the competition. If programme rights have been confiscated, you will receive a notification about it.

Like real life, FSK18 broadcasts at the wrong time damage your image. Currently by 0.5 percentage points.

Interface
=========

The lower part of the game screen, which keeps you company during the whole game, is referred to as interface. On the left is the television, which displays the current programme of each station. You can turn it off. You can also  choose which station's programme you want to watch using the coloured buttons.

Moving the mouse pointer over the screen of the TV set or the buttons of the other stations, a tooltip appears with information about the current programme. In addition, your own station will hint whether a suitable commercial break is set.

The right screen shows each of the target groups that will be particularly reached by the programme. The displays in the middle are self-explanatory thanks to the tooltips.

Chat and Cheating
=================

The in-game-chat is called up with the "Enter" key. In the developer version, the chat can accept various commands. The command "/dev help" lists the applicable comands. For example, "/dev money 1 1000" will credit 1000 Euros to the account of the first player.

Processes in the Background
===========================

An example of the processes in the background is the audience rating calculation. At the moment not much explanation is possible here. So it is easier for you if you pay attention to inconsistencies and where possible report them to us. Since most of the those who find us in the vastness of the Net are probably experienced players, intuition is a factor that should not be underestimated in improving the game.

And we won't explain away the inconsistencies in advance with big words.

Keyboard Shortcuts for the Developer Version
============================================


Game Speed
----------
* Up/down arrow keys : Game speed +/-
* Left/right arrow keys : Running speed and game speed +/-
* Left-Ctrl + right arrow key : Fast forward level 1
* Right-Ctrl + right arrow key: Fast forward level 2
* 5 : Speed 60 game minutes/s
* 6 : Speed 120 game minutes/s
* 7 : Speed 180 game minutes/s
* 8 : Speed 240 game minutes/s
* 9 : Speed 1 game minute/s (standard)

Rooms
-----
[The German names are given where these explain the shortcut]
* W: Ad Agency [Werbemakler]
* A: Archive
* B: Betty
* F: Movie Agency [Filmagentur]
* O: Office
* C: Boss [Chef]
* N: News Studio
* R: Room Agency
* P: Room Plan
* Ctrl + R: Room Plan
* S: Studio (the first one found)
* L: Supermarket [Laden]
* Left-Ctrl + S: Supermarket
* D: Script Agency [Drehbuchagentur]
* Right-Ctrl + S: Script Agency
* E: Credits (employees :-))

Loading/Saving
--------------
* F5: Save game state (Quicksave)
* F8: Load game state (Quickload)

Misc
----
* 1-4: Change player (with Observer Mode players are only observed)
* Left-Ctrl + O: Observer Mode on/off
* G: Ghost Mode (scroll freely through the building with the mouse) on/off

* TAB: Dev-/debug panel show/hide
* Left-Ctrl + TAB: Room-specific debug insights on/off
* Q: Audience share debug screen on/off
* K: All characters will be kicked out of the rooms
* T: Launch the terrorist

* F1: Game manual or display room/screen-specific help if available
* F6: Play music [or new track]
* F10: (De)activate all outside characters (movements)
* F11: AI on/off

* M: Music/sound output on/off
* Shift+M: Sound effects on/off
* Ctrl+M: Music on/off
