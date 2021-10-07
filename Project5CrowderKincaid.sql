/*** Joseph Crowder & Victoria Kincaid ***/
/*** Project 5 ***/

/*
Please make sure that your database system/application is running cleanly and that you have addressed all of my concerns (if any) submitted in Project 4 Comments.
1. Add two more tables to your database application.
	- For our two tables we picked Pokemon Cards based on each Pokemon's most expensive and least expensive card in the real world. This allowed us to follow through with the stored procedures for 4. Our
	other table will be a trigger based one that helps with archival!

2. Create a database diagram to show the primary and foreign keys relationships (most of your tables should be connected to each other).
	- It is under the database diagrams :) Enjoy!

3. Create two views (one must be updatable).
4. Write two Stored Procedures based on spInvTotal1 & spInvTotal3 examples with your database (must run using EXEC statement and produce valid output using PRINT statement).
5. Write two trigger based on examples on P495 & P497.

	- For 3, 4, 5 we added that to the end of the database if you want to scroll to the bottom
*/

--------------------------------- We kept all previous comments from the previous project. ---------------------------------

/* First things first we need to set the master for all databases before creating our own*/
USE master
GO

/* We decided to have some fun with this project and make a database for pokemon! It made the project very enjoyable. So, we need to create our Pokemon database and set it up
so that it "would allow us to run the script to create the database again without having to manually drop it first". */

/****** Object:  Database Pokemon     ******/
IF DB_ID('Pokemon') IS NOT NULL
	DROP DATABASE Pokemon
GO

CREATE DATABASE Pokemon
GO 

USE [Pokemon]
GO


-- I set this up initially to how it was set up in Create_AP.sql file, BUT I kept coming up with this error that led me to the solution from this site:
-- https://dba.stackexchange.com/questions/2387/sql-server-cannot-drop-database-dbname-because-it-is-currently-in-use-but-n/2391
 

-- VERY IMPORTANT!!! Below is only to use if needs to be deleted :/
USE master;
GO
ALTER DATABASE Pokemon SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
GO
DROP DATABASE Pokemon;


/*After the database is set up, it's time to set up each of our individual tables. We are going to do the same where we set up the table so we won't have to manually drop it. This first table is our
main table that is the PokemonType. It will have a primary key that most of our tables will be referencing as foreign keys. The columns are the pokemon ID number, their name, their two types (if they
have two types, if not it will be NULL), if there is a variation in the generation then what generation there was a change in the type, and then the final column is what the new typing would be. For example: Raichu 
is the evolution of Pikachu, and has been around since the first Pokemon game. For the first six generations he was pure Electric type, BUT in generation 7 (Pokemon Sun & Moon) he gained a new Psychic type. The first 
game/generation came out in 1996, the seventh game/generation came out in 2016. That means for twenty years Raichu was pure electric type but for the past five years he has had two typings.*/

/****** Object:  Table [dbo].[PokemonType] ******/

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- TODAY I LEARNED IN ORDER TO DELETE AND REFRESH THESE TABLES YOU NEED TO HAVE USE MASTER GO IN FRONT OF ALL OF THEM!  Which makes sense! You can't delete it if you are still in the datbase using it!
IF OBJECT_ID('PokemonType') IS NOT NULL  
   DROP TABLE [Pokemon].[PokemonType];  
GO

CREATE TABLE PokemonType
(PokemonNo INT IDENTITY(1,1) PRIMARY KEY,
Name VARCHAR(25),
Type1 VARCHAR(10),
Type2 VARCHAR(10),
GenerationVariations VARCHAR(10),
NewType VARCHAR(10));
GO

/*This second table is called Championship Winners. Since 2009 there has been national championships where people have come together and battled their pokemon! Pretty fun to watch, here is a link to the site that was
used to get information on the Winners and tournaments: https://www.vgcpedia.com/world-championships-hub/ In this table we have the Year, City and State (or Province) that the tournament was held, the name of the winner
of the Senior championship (which is age 13-15, in the future I think we will include the winners for the Junior (under 12) and master (over 16) categories)), the country the winner was from, and their first
pokemon on their winning team. This table uses a foreign key and references the primary key of the pokemontype table.*/

/****** Object:  Table [dbo].[ChampionshipWinners] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID('ChampionshipWinners') IS NOT NULL  
   DROP TABLE [Pokemon].[ChampionshipWinners];  
GO

CREATE TABLE ChampionshipWinners
(ID INT PRIMARY KEY,
Year VARCHAR(4),
CityHeld VARCHAR(25),
StateHeld VARCHAR(2),
SeniorWinner VARCHAR(50),
SeniorWinnerCountry VARCHAR(50),
WinningPokemon INT FOREIGN KEY REFERENCES PokemonType(PokemonNo));
GO

/*This next table refernces several legendary pokemon. This has a similar foreign key, shows the generation the legendary is from, and the variable of which type of legendary it is for which there are three. It also has a column
of the location for the legendary pokemon.*/

/****** Object:  Table [dbo].[LegendaryPokemon] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID('LegendaryPokemon') IS NOT NULL  
   DROP TABLE [Pokemon].[LegendaryPokemon];  
GO

CREATE TABLE LegendaryPokemon
(PokemonNo INT FOREIGN KEY REFERENCES PokemonType(PokemonNo),
Generation VARCHAR(10),
Legendary VARCHAR(3),
Sublegendary VARCHAR(3),
Mythical VARCHAR(3),
Location VARCHAR(30));
GO

/*This next table is from the first game's Gym Leaders. In the game, you battle your pokemon against gym leaders and collect badges. We have listed for columns the Gym Leader ID number, their Name,
their city in the game, the type of gym they have (for instance, Misty canonically has the water type gym), and the pokemon you have to fight in their gym. In the beginning their might be only two pokemon
you need to fight (like Misty has only two pokemon), whereas at the end there is up to five pokmemon you need to fight. The last thing is the level of the pokemon in the gym you need to fight.*/

/****** Object:  Table [dbo].[GymLeaders] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID('GymLeaders') IS NOT NULL  
   DROP TABLE [Pokemon].[GymLeaders];  
GO

CREATE TABLE GymLeaders
(GLID INT PRIMARY KEY,
Name VARCHAR(20),
City VARCHAR(20),
Type VARCHAR(20),
Pkmn1 INT FOREIGN KEY REFERENCES PokemonType(PokemonNo),
Pkmn1Lvl VARCHAR(3),
Pkmn2 INT FOREIGN KEY REFERENCES PokemonType(PokemonNo),
Pkmn2Lvl VARCHAR(3),
Pkmn3 INT FOREIGN KEY REFERENCES PokemonType(PokemonNo),
Pkmn3Lvl VARCHAR(3),
Pkmn4 INT FOREIGN KEY REFERENCES PokemonType(PokemonNo),
Pkmn4Lvl VARCHAR(3),
Pkmn5 INT FOREIGN KEY REFERENCES PokemonType(PokemonNo),
Pkmn5Lvl VARCHAR(3));
GO


/*This table is for the evolution of pokemon. As one plays the game with their pokemon they can grow and evolve into new pokemon. This can be done in various formats. For the talbe we have listed the
PokemonNo referencing the PokemonType table, the name, and the format it evolves in. Level means just by leveling it up, Trade means trading it with another person, Stone means having it hold onto a stone, and Mega 
means the pokemon evolves while holding a particular mega stone, the generation shows the generation it came from.*/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID('Evolution') IS NOT NULL  
   DROP TABLE [Pokemon].[Evolution];  
GO

CREATE TABLE Evolution
(PokemonNo INT FOREIGN KEY REFERENCES PokemonType(PokemonNo),
Name VARCHAR(30),
Level VARCHAR(7),
Trade VARCHAR(20),
Stone VARCHAR(15),
Mega VARCHAR(5),
Generation VARCHAR(10));


/* For our final created table is the encounters. In the pokemon game you have to catch pokemon in certain areas (most of the time), so for the table we have the foreign key PokemonNo, the Name, the
locations you can find the pokemon, which game it is refering to, and the chance rate*/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID('Encounters') IS NOT NULL  
   DROP TABLE [Pokemon].[Encounters];  
GO

CREATE TABLE Encounters
(PokemonNo INT FOREIGN KEY REFERENCES PokemonType(PokemonNo),
Name VARCHAR(25),
Locations VARCHAR(255),
Game VARCHAR(30),              /* Red Yellow Blue, different spawn for each */
CatchRate VARCHAR(10)); 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID('PokemonStats') IS NOT NULL  
   DROP TABLE [Pokemon].[PokemonStats];  
GO

CREATE TABLE PokemonStats
(PokemonNo INT FOREIGN KEY REFERENCES PokemonType(PokemonNo),
Name VARCHAR(25),
HP INT,
Attack INT,
Defense INT,
SpAtk INT,
SpDef INT,
Speed INT); 
GO


--------------------------------------------------------------------------------------------------------------
-- Here are our two new created tables, one is for card prices, the other is an archival table for deleted content

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID('CardPrice') IS NOT NULL  
   DROP TABLE [Pokemon].[CardPrice];  
GO

CREATE TABLE CardPrice
(PokemonNo INT FOREIGN KEY REFERENCES PokemonType(PokemonNo),
Name VARCHAR(25),
MostExpensive SMALLMONEY,
LeastExpensive SMALLMONEY); 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID('PokemonArchive') IS NOT NULL  
   DROP TABLE [Pokemon].[PokemonArchive];  
GO

CREATE TABLE PokemonArchive
(PokemonNo INT,
Name VARCHAR(25),
Type1 VARCHAR(10),
Type2 VARCHAR(10),
GenerationVariations VARCHAR(10),
NewType VARCHAR(10));
GO


--------------------------------------------------------------------------------------------------------------

/*From here we insert and fill our tables! We have them divided by table to make it easier to read, we have first for our SET IDENTITY_INSERT is the integral PokemonType table, I went to this site
https://docs.microsoft.com/en-us/sql/t-sql/statements/set-identity-insert-transact-sql?view=sql-server-ver15 to verify what it means, it says only one table in a session can have this ON so it made sense
to have it set for this table. From there all the inserts have the IDENITTY_INSERT as OFF.*/

SET IDENTITY_INSERT [dbo].[PokemonType] ON
INSERT [dbo].[PokemonType] ([PokemonNo], [Name], [Type1], [Type2], [GenerationVariations], [NewType]) VALUES (1, N'Bulbasaur', N'Grass', N'Poison', NULL, NULL);
INSERT [dbo].[PokemonType] ([PokemonNo], [Name], [Type1], [Type2], [GenerationVariations], [NewType]) VALUES (6, 'Charizard', 'Fire', 'Flying', NULL, NULL);
INSERT [dbo].[PokemonType] ([PokemonNo], [Name], [Type1], [Type2], [GenerationVariations], [NewType]) VALUES (25, 'Pikachu', 'Electric', NULL, NULL, NULL);
INSERT [dbo].[PokemonType] ([PokemonNo], [Name], [Type1], [Type2], [GenerationVariations], [NewType]) VALUES (26, 'Raichu', 'Electric', NULL, '7, 8', 'Psychic');
INSERT [dbo].[PokemonType] ([PokemonNo], [Name], [Type1], [Type2], [GenerationVariations], [NewType]) VALUES (31, 'Nidoqueen', 'Poison', 'Ground', NULL, NULL);
INSERT [dbo].[PokemonType] ([PokemonNo], [Name], [Type1], [Type2], [GenerationVariations], [NewType]) VALUES (34, 'Nidoking', 'Poison', 'Ground', NULL, NULL);
INSERT [dbo].[PokemonType] ([PokemonNo], [Name], [Type1], [Type2], [GenerationVariations], [NewType]) VALUES (45, 'Vileplume', 'Grass', 'Poison', NULL, NULL);
INSERT [dbo].[PokemonType] ([PokemonNo], [Name], [Type1], [Type2], [GenerationVariations], [NewType]) VALUES (49, 'Venomoth', 'Bug', 'Poison', NULL, NULL);
INSERT [dbo].[PokemonType] ([PokemonNo], [Name], [Type1], [Type2], [GenerationVariations], [NewType]) VALUES (51, 'Dugtrio', 'Ground', NULL, '7,8', 'Steel');
INSERT [dbo].[PokemonType] ([PokemonNo], [Name], [Type1], [Type2], [GenerationVariations], [NewType]) VALUES (58, 'Growlithe', 'Fire', NULL, NULL, NULL);
INSERT [dbo].[PokemonType] ([PokemonNo], [Name], [Type1], [Type2], [GenerationVariations], [NewType]) VALUES (59, 'Arcanine', 'Fire', NULL, NULL, NULL);
INSERT [dbo].[PokemonType] ([PokemonNo], [Name], [Type1], [Type2], [GenerationVariations], [NewType]) VALUES (64, 'Kadabra', 'Psychic', NULL, NULL, NULL);
INSERT [dbo].[PokemonType] ([PokemonNo], [Name], [Type1], [Type2], [GenerationVariations], [NewType]) VALUES (65, 'Alakazam', 'Psychic', NULL, NULL, NULL);
INSERT [dbo].[PokemonType] ([PokemonNo], [Name], [Type1], [Type2], [GenerationVariations], [NewType]) VALUES (71, 'Victreebel', 'Grass', 'Poison', NULL, NULL);
INSERT [dbo].[PokemonType] ([PokemonNo], [Name], [Type1], [Type2], [GenerationVariations], [NewType]) VALUES (74, 'Geodude', 'Rock', 'Ground', '7', 'Electric');
INSERT [dbo].[PokemonType] ([PokemonNo], [Name], [Type1], [Type2], [GenerationVariations], [NewType]) VALUES (77, 'Ponyta', 'Fire', NULL, '8', 'Psychic');
INSERT [dbo].[PokemonType] ([PokemonNo], [Name], [Type1], [Type2], [GenerationVariations], [NewType]) VALUES (78, 'Rapidash', 'Fire', NULL, '8', 'Psychic, Fairy');
INSERT [dbo].[PokemonType] ([PokemonNo], [Name], [Type1], [Type2], [GenerationVariations], [NewType]) VALUES (89, 'Muk', 'Poison', NULL, '7', 'Dark');
INSERT [dbo].[PokemonType] ([PokemonNo], [Name], [Type1], [Type2], [GenerationVariations], [NewType]) VALUES (95, 'Onix', 'Rock', 'Ground', NULL, NULL);
INSERT [dbo].[PokemonType] ([PokemonNo], [Name], [Type1], [Type2], [GenerationVariations], [NewType]) VALUES (100, 'Voltorb', 'Electric', NULL, NULL, NULL);
INSERT [dbo].[PokemonType] ([PokemonNo], [Name], [Type1], [Type2], [GenerationVariations], [NewType]) VALUES (109, 'Koffing', 'Poison', NULL, NULL, NULL);
INSERT [dbo].[PokemonType] ([PokemonNo], [Name], [Type1], [Type2], [GenerationVariations], [NewType]) VALUES (110, 'Weezing', 'Poison', NULL, '8', 'Fairy');
INSERT [dbo].[PokemonType] ([PokemonNo], [Name], [Type1], [Type2], [GenerationVariations], [NewType]) VALUES (111, 'Rhyhorn', 'Ground', 'Rock', NULL, NULL);
INSERT [dbo].[PokemonType] ([PokemonNo], [Name], [Type1], [Type2], [GenerationVariations], [NewType]) VALUES (112, 'Rhydon', 'Ground', 'Rock', NULL, NULL);
INSERT [dbo].[PokemonType] ([PokemonNo], [Name], [Type1], [Type2], [GenerationVariations], [NewType]) VALUES (114, 'Tangela', 'Grass', NULL, NULL, NULL);
INSERT [dbo].[PokemonType] ([PokemonNo], [Name], [Type1], [Type2], [GenerationVariations], [NewType]) VALUES (120, 'Staryu', 'Water', NULL, NULL, NULL);
INSERT [dbo].[PokemonType] ([PokemonNo], [Name], [Type1], [Type2], [GenerationVariations], [NewType]) VALUES (121, 'Starmie', 'Water', 'Psychic', NULL, NULL);
INSERT [dbo].[PokemonType] ([PokemonNo], [Name], [Type1], [Type2], [GenerationVariations], [NewType]) VALUES (122, 'Mr. Mime', 'Psychic', NULL,'6,7,8', 'Fairy, Ice');
INSERT [dbo].[PokemonType] ([PokemonNo], [Name], [Type1], [Type2], [GenerationVariations], [NewType]) VALUES (144,'Articuno', 'Ice', 'Flying', NULL, NULL);
INSERT [dbo].[PokemonType] ([PokemonNo], [Name], [Type1], [Type2], [GenerationVariations], [NewType]) VALUES (145, 'Zapdos', 'Electric', 'Flying', '8', 'Fight');
INSERT [dbo].[PokemonType] ([PokemonNo], [Name], [Type1], [Type2], [GenerationVariations], [NewType]) VALUES (146, 'Moltres', 'Fire', 'Flying', NULL, NULL);
INSERT [dbo].[PokemonType] ([PokemonNo], [Name], [Type1], [Type2], [GenerationVariations], [NewType]) VALUES (150, 'MewTwo', 'Psychic', NULL, NULL, NULL);
INSERT [dbo].[PokemonType] ([PokemonNo], [Name], [Type1], [Type2], [GenerationVariations], [NewType]) VALUES (151, 'Mew', 'Psychic', NULL, NULL, NULL);
INSERT [dbo].[PokemonType] ([PokemonNo], [Name], [Type1], [Type2], [GenerationVariations], [NewType]) VALUES (272, 'Ludicolo', 'Water', 'Grass', NULL, NULL);
INSERT [dbo].[PokemonType] ([PokemonNo], [Name], [Type1], [Type2], [GenerationVariations], [NewType]) VALUES (282, 'Gardevoir', 'Psychic', NULL, '6,7,8', 'Fairy');
INSERT [dbo].[PokemonType] ([PokemonNo], [Name], [Type1], [Type2], [GenerationVariations], [NewType]) VALUES (303, 'Mawile', 'Steel', NULL, '6,7,8', 'Fairy');
INSERT [dbo].[PokemonType] ([PokemonNo], [Name], [Type1], [Type2], [GenerationVariations], [NewType]) VALUES (382, 'Kyogre', 'Water', NULL, NULL, NULL);
INSERT [dbo].[PokemonType] ([PokemonNo], [Name], [Type1], [Type2], [GenerationVariations], [NewType]) VALUES (383, 'Groudon', 'Groud', NULL, NULL, NULL);
INSERT [dbo].[PokemonType] ([PokemonNo], [Name], [Type1], [Type2], [GenerationVariations], [NewType]) VALUES (384, 'Rayquaza', 'Dragon', 'Flying', NULL, NULL);
INSERT [dbo].[PokemonType] ([PokemonNo], [Name], [Type1], [Type2], [GenerationVariations], [NewType]) VALUES (454, 'Toxicroak', 'Poison', 'Fight', NULL, NULL);
INSERT [dbo].[PokemonType] ([PokemonNo], [Name], [Type1], [Type2], [GenerationVariations], [NewType]) VALUES (642, 'Thundurus', 'Electric','Flying', NULL, NULL);
INSERT [dbo].[PokemonType] ([PokemonNo], [Name], [Type1], [Type2], [GenerationVariations], [NewType]) VALUES (785, 'Tapu Koko', 'Electric', 'Fairy', NULL, NULL);
INSERT [dbo].[PokemonType] ([PokemonNo], [Name], [Type1], [Type2], [GenerationVariations], [NewType]) VALUES (786, 'This', 'Pokemon', 'Is', 'A', 'Mistake');
GO

SET IDENTITY_INSERT [dbo].[PokemonType] OFF
INSERT [dbo].[LegendaryPokemon] ([PokemonNo], [Generation], [Legendary], [Sublegendary], [Mythical], [Location]) VALUES (144, '1', 'NO', 'YES', 'NO', 'Seafoam Island');
INSERT [dbo].[LegendaryPokemon] ([PokemonNo], [Generation], [Legendary], [Sublegendary], [Mythical], [Location]) VALUES (145, '1', 'NO', 'YES', 'NO', 'Power Plant');
INSERT [dbo].[LegendaryPokemon] ([PokemonNo], [Generation], [Legendary], [Sublegendary], [Mythical], [Location]) VALUES (146, '1', 'NO', 'YES', 'NO', 'Victory Road');
INSERT [dbo].[LegendaryPokemon] ([PokemonNo], [Generation], [Legendary], [Sublegendary], [Mythical], [Location]) VALUES (150, '1', 'YES', 'NO', 'NO', 'Unknown Dungeon');
INSERT [dbo].[LegendaryPokemon] ([PokemonNo], [Generation], [Legendary], [Sublegendary], [Mythical], [Location]) VALUES (151, '1', 'NO', 'NO', 'YES', NULL);
INSERT [dbo].[LegendaryPokemon] ([PokemonNo], [Generation], [Legendary], [Sublegendary], [Mythical], [Location]) VALUES (382, '3', 'YES', 'NO', 'NO', 'Marine Cave');
INSERT [dbo].[LegendaryPokemon] ([PokemonNo], [Generation], [Legendary], [Sublegendary], [Mythical], [Location]) VALUES (383, '3', 'YES', 'NO', 'NO', 'Mountain Cave');
INSERT [dbo].[LegendaryPokemon] ([PokemonNo], [Generation], [Legendary], [Sublegendary], [Mythical], [Location]) VALUES (384, '3', 'YES', 'NO', 'NO', 'Sky Pillar');
INSERT [dbo].[LegendaryPokemon] ([PokemonNo], [Generation], [Legendary], [Sublegendary], [Mythical], [Location]) VALUES (642, '5', 'NO', 'YES', 'NO', 'Roaming');
INSERT [dbo].[LegendaryPokemon] ([PokemonNo], [Generation], [Legendary], [Sublegendary], [Mythical], [Location]) VALUES (785, '7', 'NO', 'YES', 'NO', 'Ruins of Conflict');
GO

INSERT [dbo].[GymLeaders] (GLID, Name, City, Type, Pkmn1, Pkmn1Lvl, Pkmn2, Pkmn2Lvl, Pkmn3, Pkmn3Lvl, Pkmn4, Pkmn4Lvl, Pkmn5, Pkmn5Lvl) VALUES (1, 'Brock', 'Pewter', 'Rock', 74, '12', 95, '14', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT [dbo].[GymLeaders] (GLID, Name, City, Type, Pkmn1, Pkmn1Lvl, Pkmn2, Pkmn2Lvl, Pkmn3, Pkmn3Lvl, Pkmn4, Pkmn4Lvl, Pkmn5, Pkmn5Lvl) VALUES (2, 'Misty', 'Cerulean', 'Water', 120, '18', 121, '21',  NULL, NULL, NULL, NULL, NULL, NULL);
INSERT [dbo].[GymLeaders] (GLID, Name, City, Type, Pkmn1, Pkmn1Lvl, Pkmn2, Pkmn2Lvl, Pkmn3, Pkmn3Lvl, Pkmn4, Pkmn4Lvl, Pkmn5, Pkmn5Lvl) VALUES (3, 'Lt. Surge', 'Vermillion', 'Electric', 100, '21', 25, '18', 26, '24', NULL, NULL, NULL, NULL);
INSERT [dbo].[GymLeaders] (GLID, Name, City, Type, Pkmn1, Pkmn1Lvl, Pkmn2, Pkmn2Lvl, Pkmn3, Pkmn3Lvl, Pkmn4, Pkmn4Lvl, Pkmn5, Pkmn5Lvl) VALUES (4, 'Erika', 'Celadon', 'Grass', 71, '29', 114, '24', 45, '29', NULL, NULL, NULL, NULL);
INSERT [dbo].[GymLeaders] (GLID, Name, City, Type, Pkmn1, Pkmn1Lvl, Pkmn2, Pkmn2Lvl, Pkmn3, Pkmn3Lvl, Pkmn4, Pkmn4Lvl, Pkmn5, Pkmn5Lvl) VALUES (5, 'Koga', 'Fuchsia', 'Poison', 109, '37', 89, '39', 109, '37', 110, '43', NULL, NULL);
INSERT [dbo].[GymLeaders] (GLID, Name, City, Type, Pkmn1, Pkmn1Lvl, Pkmn2, Pkmn2Lvl, Pkmn3, Pkmn3Lvl, Pkmn4, Pkmn4Lvl, Pkmn5, Pkmn5Lvl) VALUES (6, 'Sabrina', 'Saffron', 'Psychic', 64, '38', 122, '37', 49, '38', 65, '43', NULL, NULL);
INSERT [dbo].[GymLeaders] (GLID, Name, City, Type, Pkmn1, Pkmn1Lvl, Pkmn2, Pkmn2Lvl, Pkmn3, Pkmn3Lvl, Pkmn4, Pkmn4Lvl, Pkmn5, Pkmn5Lvl) VALUES (7, 'Blaine', 'Cinnabar', 'Fire', 58, '42', 77, '40', 78, '42', 59, '47', NULL, NULL);
INSERT [dbo].[GymLeaders] (GLID, Name, City, Type, Pkmn1, Pkmn1Lvl, Pkmn2, Pkmn2Lvl, Pkmn3, Pkmn3Lvl, Pkmn4, Pkmn4Lvl, Pkmn5, Pkmn5Lvl) VALUES (8, 'Giovanni', 'Viridian', 'Ground', 111, '45', 51, '42',  31, '44', 34, '45', 112, '50');
GO

INSERT [dbo].[ChampionshipWinners] (ID, Year, CityHeld, StateHeld, SeniorWinner, SeniorWinnerCountry, WinningPokemon) VALUES (1, '2009', 'San Diego', 'CA', 'Kazuyuki Tsuji', 'Japan', 454);
INSERT [dbo].[ChampionshipWinners] (ID, Year, CityHeld, StateHeld, SeniorWinner, SeniorWinnerCountry, WinningPokemon) VALUES (2, '2010', 'Waikoloa Village', 'HI','Ray Rizzo', 'USA', 382);
INSERT [dbo].[ChampionshipWinners] (ID, Year, CityHeld, StateHeld, SeniorWinner, SeniorWinnerCountry, WinningPokemon) VALUES (3, '2011', 'San Diego', 'CA', 'Kamran Jahadi', 'USA', 642);
INSERT [dbo].[ChampionshipWinners] (ID, Year, CityHeld, StateHeld, SeniorWinner, SeniorWinnerCountry, WinningPokemon) VALUES (4, '2012', 'Waikoloa Village', 'HI', 'Toler Webb', 'USA', 272);
INSERT [dbo].[ChampionshipWinners] (ID, Year, CityHeld, StateHeld, SeniorWinner, SeniorWinnerCountry, WinningPokemon) VALUES (5, '2013', 'Vancouver', 'BC', 'Hayden McTavish', 'USA', 642);
INSERT [dbo].[ChampionshipWinners] (ID, Year, CityHeld, StateHeld, SeniorWinner, SeniorWinnerCountry, WinningPokemon) VALUES (6, '2014', 'Washington', 'DC', 'Nikolai Zielinski', 'USA', 303);
INSERT [dbo].[ChampionshipWinners] (ID, Year, CityHeld, StateHeld, SeniorWinner, SeniorWinnerCountry, WinningPokemon) VALUES (7, '2015', 'Boston', 'MA', 'Mark McQuillan', 'England', 6);
INSERT [dbo].[ChampionshipWinners] (ID, Year, CityHeld, StateHeld, SeniorWinner, SeniorWinnerCountry, WinningPokemon) VALUES (8, '2016', 'San Francisco', 'CA', 'Carson Confer', 'USA', 383);
INSERT [dbo].[ChampionshipWinners] (ID, Year, CityHeld, StateHeld, SeniorWinner, SeniorWinnerCountry, WinningPokemon) VALUES (9, '2017', 'Anaheim', 'CA', 'Hong Juyoung', 'Japan', 785);
INSERT [dbo].[ChampionshipWinners] (ID, Year, CityHeld, StateHeld, SeniorWinner, SeniorWinnerCountry, WinningPokemon) VALUES (10, '2018', 'Nashville', 'TN', 'James Evans', 'USA', 282);
INSERT [dbo].[ChampionshipWinners] (ID, Year, CityHeld, StateHeld, SeniorWinner, SeniorWinnerCountry, WinningPokemon) VALUES (11, '2019', 'Washington', 'DC', 'Ko Tsukide', 'Japan', 384);
GO

INSERT [dbo].[Evolution] ([PokemonNo], [Name], [Level], [Trade], [Stone], [Mega], [Generation]) VALUES (1, 'Bulbasaur', '16', NULL,  NULL, NULL, '1');
INSERT [dbo].[Evolution] ([PokemonNo], [Name], [Level], [Trade], [Stone], [Mega], [Generation]) VALUES (25, 'Pikachu', NULL, NULL, 'Thunder', NULL, '1, 7');
INSERT [dbo].[Evolution] ([PokemonNo], [Name], [Level], [Trade], [Stone], [Mega], [Generation]) VALUES (26, 'Raichu', NULL, NULL, NULL, NULL, '1, 7');
INSERT [dbo].[Evolution] ([PokemonNo], [Name], [Level], [Trade], [Stone], [Mega], [Generation]) VALUES (31, 'Nidoqueen', NULL, NULL, NULL, NULL, '1');
INSERT [dbo].[Evolution] ([PokemonNo], [Name], [Level], [Trade], [Stone], [Mega], [Generation]) VALUES (34, 'Nidoking', NULL, NULL, NULL, NULL, '1');
INSERT [dbo].[Evolution] ([PokemonNo], [Name], [Level], [Trade], [Stone], [Mega], [Generation]) VALUES (45, 'Vileplume', NULL, NULL, NULL, NULL, '1');
INSERT [dbo].[Evolution] ([PokemonNo], [Name], [Level], [Trade], [Stone], [Mega], [Generation]) VALUES (49, 'Venomoth', NULL, NULL, NULL, NULL, '1');
INSERT [dbo].[Evolution] ([PokemonNo], [Name], [Level], [Trade], [Stone], [Mega], [Generation]) VALUES (51, 'Dugtrio', NULL, NULL, NULL, NULL, '1, 7');
INSERT [dbo].[Evolution] ([PokemonNo], [Name], [Level], [Trade], [Stone], [Mega], [Generation]) VALUES (58, 'Growlithe', NULL, NULL, 'Fire', NULL, '1');
INSERT [dbo].[Evolution] ([PokemonNo], [Name], [Level], [Trade], [Stone], [Mega], [Generation]) VALUES (59, 'Arcanine', NULL, NULL, NULL, NULL, '1');
INSERT [dbo].[Evolution] ([PokemonNo], [Name], [Level], [Trade], [Stone], [Mega], [Generation]) VALUES (64, 'Kadabra', NULL, 'Trade', NULL, NULL, '1');
INSERT [dbo].[Evolution] ([PokemonNo], [Name], [Level], [Trade], [Stone], [Mega], [Generation]) VALUES (65, 'Alakazam', NULL, NULL, NULL, 'Mega', '1');
INSERT [dbo].[Evolution] ([PokemonNo], [Name], [Level], [Trade], [Stone], [Mega], [Generation]) VALUES (71, 'Victreebel', NULL, NULL, NULL, NULL, '1');
INSERT [dbo].[Evolution] ([PokemonNo], [Name], [Level], [Trade], [Stone], [Mega], [Generation]) VALUES (74, 'Geodude', '25', NULL, NULL, NULL, '1, 7');
INSERT [dbo].[Evolution] ([PokemonNo], [Name], [Level], [Trade], [Stone], [Mega], [Generation]) VALUES (77, 'Ponyta', '40', NULL, NULL, NULL, '1, 8');
INSERT [dbo].[Evolution] ([PokemonNo], [Name], [Level], [Trade], [Stone], [Mega], [Generation]) VALUES (78, 'Rapidash', NULL, NULL, NULL, NULL, '1, 8'); 
INSERT [dbo].[Evolution] ([PokemonNo], [Name], [Level], [Trade], [Stone], [Mega], [Generation]) VALUES (89, 'Muk', NULL, NULL, NULL, NULL, '1, 7');
INSERT [dbo].[Evolution] ([PokemonNo], [Name], [Level], [Trade], [Stone], [Mega], [Generation]) VALUES (95, 'Onix', NULL, 'TradeWithMetalCoat', NULL, NULL, '1');
INSERT [dbo].[Evolution] ([PokemonNo], [Name], [Level], [Trade], [Stone], [Mega], [Generation]) VALUES (100, 'Voltorb', '30', NULL,  NULL, NULL, '1');
INSERT [dbo].[Evolution] ([PokemonNo], [Name], [Level], [Trade], [Stone], [Mega], [Generation]) VALUES (110, 'Weezing', NULL, NULL, NULL, NULL, '1, 8');
INSERT [dbo].[Evolution] ([PokemonNo], [Name], [Level], [Trade], [Stone], [Mega], [Generation]) VALUES (111, 'Rhyhorn', '42', NULL,  NULL, NULL, '1');
INSERT [dbo].[Evolution] ([PokemonNo], [Name], [Level], [Trade], [Stone], [Mega], [Generation]) VALUES (112, 'Rhydon', NULL, 'TradeWithProtector', NULL, NULL, '1');
INSERT [dbo].[Evolution] ([PokemonNo], [Name], [Level], [Trade], [Stone], [Mega], [Generation]) VALUES (114, 'Tangela', 'Random', NULL, NULL, NULL, '1');
INSERT [dbo].[Evolution] ([PokemonNo], [Name], [Level], [Trade], [Stone], [Mega], [Generation]) VALUES (120, 'Staryu', NULL, NULL, 'Water', NULL, '1');
INSERT [dbo].[Evolution] ([PokemonNo], [Name], [Level], [Trade], [Stone], [Mega], [Generation]) VALUES (121, 'Starmie', NULL, NULL, NULL, NULL, '1');
INSERT [dbo].[Evolution] ([PokemonNo], [Name], [Level], [Trade], [Stone], [Mega], [Generation]) VALUES (122, 'Mr. Mime', NULL, NULL, NULL, NULL, '1, 8'); 
INSERT [dbo].[Evolution] ([PokemonNo], [Name], [Level], [Trade], [Stone], [Mega], [Generation]) VALUES (144,'Articuno', NULL, NULL, NULL, NULL, '1, 8');
INSERT [dbo].[Evolution] ([PokemonNo], [Name], [Level], [Trade], [Stone], [Mega], [Generation]) VALUES (145, 'Zapdos', NULL, NULL, NULL, NULL, '1, 8');
INSERT [dbo].[Evolution] ([PokemonNo], [Name], [Level], [Trade], [Stone], [Mega], [Generation]) VALUES (146, 'Moltres', NULL, NULL, NULL, NULL, '1, 8');
INSERT [dbo].[Evolution] ([PokemonNo], [Name], [Level], [Trade], [Stone], [Mega], [Generation]) VALUES (150, 'MewTwo', NULL, NULL, NULL, 'Mega', '1');
INSERT [dbo].[Evolution] ([PokemonNo], [Name], [Level], [Trade], [Stone], [Mega], [Generation]) VALUES (151, 'Mew', NULL, NULL, NULL, NULL, '1');
GO

INSERT [dbo].[Encounters] ([PokemonNo], [Name], [Locations], [Game], [CatchRate]) VALUES (1, 'Bulbasaur', 'ProfessorOak', 'Red, Blue', NULL);
INSERT [dbo].[Encounters] ([PokemonNo], [Name], [Locations], [Game], [CatchRate]) VALUES (25, 'Pikachu', 'ProfessorOak, VirdianForest, PowerPlant', 'Red, Blue, Yellow', '35.2');
INSERT [dbo].[Encounters] ([PokemonNo], [Name], [Locations], [Game], [CatchRate]) VALUES (26, 'Raichu', 'Evolution, PowerPlant, CeruleanCave', 'Red, Blue', '17.5')
INSERT [dbo].[Encounters] ([PokemonNo], [Name], [Locations], [Game], [CatchRate]) VALUES (31, 'Nidoqueen', 'Evolution', 'Red, Blue, Yellow', NULL);
INSERT [dbo].[Encounters] ([PokemonNo], [Name], [Locations], [Game], [CatchRate]) VALUES (34, 'Nidoking', 'Evolution', 'Red, Blue, Yellow', NULL);
INSERT [dbo].[Encounters] ([PokemonNo], [Name], [Locations], [Game], [CatchRate]) VALUES (45, 'Vileplume', 'Evolution, Trade', 'Red, Blue, Yellow', '11.9');
INSERT [dbo].[Encounters] ([PokemonNo], [Name], [Locations], [Game], [CatchRate]) VALUES (49, 'Venomoth', 'Evolution, SafariZone, VictoryRoad, CureleanCave, Route14, Route15', 'Red, Blue, Yellow', '17.5');
INSERT [dbo].[Encounters] ([PokemonNo], [Name], [Locations], [Game], [CatchRate]) VALUES (51, 'Dugtrio', 'Evolution, DiglettsCave, TradeOnRoute11', 'Red, Blue, Yellow', '12.9');
INSERT [dbo].[Encounters] ([PokemonNo], [Name], [Locations], [Game], [CatchRate]) VALUES (58, 'Growlithe', 'Route7, Route8, PokemonMansion, Trade', 'Red, Blue, Yellow', '35.2');
INSERT [dbo].[Encounters] ([PokemonNo], [Name], [Locations], [Game], [CatchRate]) VALUES (59, 'Arcanine', 'Evolution, Trade', 'Red, Blue, Yellow', '17.5');
INSERT [dbo].[Encounters] ([PokemonNo], [Name], [Locations], [Game], [CatchRate]) VALUES (64, 'Kadabra', 'Evolution, CeruleanCave, Route8', 'Red, Blue, Yellow', '21.7');
INSERT [dbo].[Encounters] ([PokemonNo], [Name], [Locations], [Game], [CatchRate]) VALUES (65, 'Alakazam', 'Evolution', 'Red, Blue, Yellow', NULL);
INSERT [dbo].[Encounters] ([PokemonNo], [Name], [Locations], [Game], [CatchRate]) VALUES (71, 'Victreebel', 'Evolution, Trade', 'Red, Blue, Yellow', NULL);
INSERT [dbo].[Encounters] ([PokemonNo], [Name], [Locations], [Game], [CatchRate]) VALUES (74, 'Geodude', 'MountMoon, RockTunnel, VictoryRoad', 'Red, Blue, Yellow', '43.9');
INSERT [dbo].[Encounters] ([PokemonNo], [Name], [Locations], [Game], [CatchRate]) VALUES (77, 'Ponyta', 'PokemonMansion, Route17', 'Red, Blue, Yellow', '35.2');
INSERT [dbo].[Encounters] ([PokemonNo], [Name], [Locations], [Game], [CatchRate]) VALUES (78, 'Rapidash', 'Evolution, CeruleanCave', 'Red, Blue, Yellow', '14.8');
INSERT [dbo].[Encounters] ([PokemonNo], [Name], [Locations], [Game], [CatchRate]) VALUES (89, 'Muk', 'Evolution, PokemonMansion, PowerPlant, TradeAtPokeLab', 'Red, Blue, Yellow', '17.5');
INSERT [dbo].[Encounters] ([PokemonNo], [Name], [Locations], [Game], [CatchRate]) VALUES (95, 'Onix', 'RockTunnel, VictoryRoad', 'Red, Blue, Yellow', '11.9');
INSERT [dbo].[Encounters] ([PokemonNo], [Name], [Locations], [Game], [CatchRate]) VALUES (100, 'Voltorb', 'Route10, PowerPlant', 'Red, Blue, Yellow', '35.2');
INSERT [dbo].[Encounters] ([PokemonNo], [Name], [Locations], [Game], [CatchRate]) VALUES (110, 'Weezing', 'Evolution, PokemonMansion, Trade', 'Red, Blue, Yellow', '14.8');
INSERT [dbo].[Encounters] ([PokemonNo], [Name], [Locations], [Game], [CatchRate]) VALUES (111, 'Rhyhorn', 'SafariZone, CeruleanCave', 'Red, Blue, Yellow', '24.9');
INSERT [dbo].[Encounters] ([PokemonNo], [Name], [Locations], [Game], [CatchRate]) VALUES (112, 'Rhydon', 'Evolution, CeruleanCave, TradeAtPokeLab', 'Red, Blue, Yellow', '14.8');
INSERT [dbo].[Encounters] ([PokemonNo], [Name], [Locations], [Game], [CatchRate]) VALUES (114, 'Tangela', 'Route21, SafariZone, TradeAtPokeLab', 'Red, Blue, Yellow', '11.9');
INSERT [dbo].[Encounters] ([PokemonNo], [Name], [Locations], [Game], [CatchRate]) VALUES (120, 'Staryu', 'SeafoamIslands, Route19, Route20, Route21, Cinnabar Island, Pallet Town', 'Red, Blue, Yellow', '39.9');
INSERT [dbo].[Encounters] ([PokemonNo], [Name], [Locations], [Game], [CatchRate]) VALUES (121, 'Starmie', 'Evolution', 'Red, Blue, Yellow', NULL);
INSERT [dbo].[Encounters] ([PokemonNo], [Name], [Locations], [Game], [CatchRate]) VALUES (122, 'Mr. Mime', 'TradeOnRoute2', 'Red, Blue, Yellow', NULL);
INSERT [dbo].[Encounters] ([PokemonNo], [Name], [Locations], [Game], [CatchRate]) VALUES (144,'Articuno', 'SeafoamIslands', 'Red, Blue, Yellow', '1.6')
INSERT [dbo].[Encounters] ([PokemonNo], [Name], [Locations], [Game], [CatchRate]) VALUES (145, 'Zapdos', 'PowerPlant', 'Red, Blue, Yellow', '1.6')
INSERT [dbo].[Encounters] ([PokemonNo], [Name], [Locations], [Game], [CatchRate]) VALUES (146, 'Moltres', 'VictoryRoad', 'Red, Blue, Yellow', '1.6')
INSERT [dbo].[Encounters] ([PokemonNo], [Name], [Locations], [Game], [CatchRate]) VALUES (150, 'MewTwo', 'CeruleanCave', 'Red, Blue, Yellow', '1.6')
INSERT [dbo].[Encounters] ([PokemonNo], [Name], [Locations], [Game], [CatchRate]) VALUES (151, 'Mew', 'GlitchOrEventIn1999', 'Red, Blue, Yellow', '1.6')
GO



/* ------------------------------------------------------------------------------------------------------- */


/* Cards */

INSERT [dbo].[CardPrice] ([PokemonNo], [Name], [MostExpensive], [LeastExpensive]) VALUES (1, 'Bulbasaur', 24.73, 0.01)
INSERT [dbo].[CardPrice] ([PokemonNo], [Name], [MostExpensive], [LeastExpensive]) VALUES (25, 'Pikachu', 800.00, 0.02)
INSERT [dbo].[CardPrice] ([PokemonNo], [Name], [MostExpensive], [LeastExpensive]) VALUES (26, 'Raichu', 299.49, 0.31)
INSERT [dbo].[CardPrice] ([PokemonNo], [Name], [MostExpensive], [LeastExpensive]) VALUES (31, 'Nidoqueen', 199.64, 0.34)
INSERT [dbo].[CardPrice] ([PokemonNo], [Name], [MostExpensive], [LeastExpensive]) VALUES (34, 'Nidoking', 400.00, 0.63)
INSERT [dbo].[CardPrice] ([PokemonNo], [Name], [MostExpensive], [LeastExpensive]) VALUES (45, 'Vileplume', 111.80, 0.42)
INSERT [dbo].[CardPrice] ([PokemonNo], [Name], [MostExpensive], [LeastExpensive]) VALUES (49, 'Venomoth', 14.68, 0.35)
INSERT [dbo].[CardPrice] ([PokemonNo], [Name], [MostExpensive], [LeastExpensive]) VALUES (51, 'Dugtrio', 39.29, 0.07)
INSERT [dbo].[CardPrice] ([PokemonNo], [Name], [MostExpensive], [LeastExpensive]) VALUES (58, 'Growlithe', 11.52, 0.05)
INSERT [dbo].[CardPrice] ([PokemonNo], [Name], [MostExpensive], [LeastExpensive]) VALUES (59, 'Arcanine', 203.68, 0.18)
INSERT [dbo].[CardPrice] ([PokemonNo], [Name], [MostExpensive], [LeastExpensive]) VALUES (64, 'Kadabra', 13.16, 0.97)
INSERT [dbo].[CardPrice] ([PokemonNo], [Name], [MostExpensive], [LeastExpensive]) VALUES (65, 'Alakazam', 403.98, 1.29)
INSERT [dbo].[CardPrice] ([PokemonNo], [Name], [MostExpensive], [LeastExpensive]) VALUES (71, 'Victreebel', 56.92, 0.11)
INSERT [dbo].[CardPrice] ([PokemonNo], [Name], [MostExpensive], [LeastExpensive]) VALUES (74, 'Geodude', 2.52, 0.08)
INSERT [dbo].[CardPrice] ([PokemonNo], [Name], [MostExpensive], [LeastExpensive]) VALUES (77, 'Ponyta', 159.00, 0.07)
INSERT [dbo].[CardPrice] ([PokemonNo], [Name], [MostExpensive], [LeastExpensive]) VALUES (78, 'Rapidash', 52.19, 0.15)
INSERT [dbo].[CardPrice] ([PokemonNo], [Name], [MostExpensive], [LeastExpensive]) VALUES (89, 'Muk', 103.48, 0.21)
INSERT [dbo].[CardPrice] ([PokemonNo], [Name], [MostExpensive], [LeastExpensive]) VALUES (95, 'Onix', 15.36, 0.04)
INSERT [dbo].[CardPrice] ([PokemonNo], [Name], [MostExpensive], [LeastExpensive]) VALUES (100, 'Voltorb', 34.73, 0.04)
INSERT [dbo].[CardPrice] ([PokemonNo], [Name], [MostExpensive], [LeastExpensive]) VALUES (110, 'Weezing', 49.84, 0.12)
INSERT [dbo].[CardPrice] ([PokemonNo], [Name], [MostExpensive], [LeastExpensive]) VALUES (111, 'Rhyhorn', 7.24, 0.03)
INSERT [dbo].[CardPrice] ([PokemonNo], [Name], [MostExpensive], [LeastExpensive]) VALUES (112, 'Rhydon', 179.26, 0.08)
INSERT [dbo].[CardPrice] ([PokemonNo], [Name], [MostExpensive], [LeastExpensive]) VALUES (114, 'Tangela', 64.95, 0.08)
INSERT [dbo].[CardPrice] ([PokemonNo], [Name], [MostExpensive], [LeastExpensive]) VALUES (120, 'Staryu', 13.62, 0.04)
INSERT [dbo].[CardPrice] ([PokemonNo], [Name], [MostExpensive], [LeastExpensive]) VALUES (121, 'Starmie', 249.99, 0.15)
INSERT [dbo].[CardPrice] ([PokemonNo], [Name], [MostExpensive], [LeastExpensive]) VALUES (122, 'Mr. Mime', 39.34, 0.03)
INSERT [dbo].[CardPrice] ([PokemonNo], [Name], [MostExpensive], [LeastExpensive]) VALUES (144,'Articuno', 749.99, 0.82)
INSERT [dbo].[CardPrice] ([PokemonNo], [Name], [MostExpensive], [LeastExpensive]) VALUES (145, 'Zapdos', 470.00, 0.34)
INSERT [dbo].[CardPrice] ([PokemonNo], [Name], [MostExpensive], [LeastExpensive]) VALUES (146, 'Moltres', 201.16, 0.61)
INSERT [dbo].[CardPrice] ([PokemonNo], [Name], [MostExpensive], [LeastExpensive]) VALUES (150, 'MewTwo', 527.00, 0.91)
INSERT [dbo].[CardPrice] ([PokemonNo], [Name], [MostExpensive], [LeastExpensive]) VALUES (151, 'Mew', 600.49, 0.28)
GO


/* Stats */

INSERT [dbo].[PokemonStats] ([PokemonNo], [Name], [HP], [Attack], [Defense], [SpAtk], [SpDef], [Speed]) VALUES (1, 'Bulbasaur', 45, 49, 49, 65, 65, 45)
INSERT [dbo].[PokemonStats] ([PokemonNo], [Name], [HP], [Attack], [Defense], [SpAtk], [SpDef], [Speed]) VALUES (25, 'Pikachu', 35, 55, 40, 50, 50, 90)
INSERT [dbo].[PokemonStats] ([PokemonNo], [Name], [HP], [Attack], [Defense], [SpAtk], [SpDef], [Speed]) VALUES (26, 'Raichu', 60, 90, 55, 90, 80, 110)
INSERT [dbo].[PokemonStats] ([PokemonNo], [Name], [HP], [Attack], [Defense], [SpAtk], [SpDef], [Speed]) VALUES (31, 'Nidoqueen', 90, 92, 87, 75, 85, 76)
INSERT [dbo].[PokemonStats] ([PokemonNo], [Name], [HP], [Attack], [Defense], [SpAtk], [SpDef], [Speed]) VALUES (34, 'Nidoking', 81, 102, 77, 85, 75, 85)
INSERT [dbo].[PokemonStats] ([PokemonNo], [Name], [HP], [Attack], [Defense], [SpAtk], [SpDef], [Speed]) VALUES (45, 'Vileplume', 75, 80, 85, 110, 90, 50)
INSERT [dbo].[PokemonStats] ([PokemonNo], [Name], [HP], [Attack], [Defense], [SpAtk], [SpDef], [Speed]) VALUES (49, 'Venomoth', 70, 65, 60, 90, 75, 90)
INSERT [dbo].[PokemonStats] ([PokemonNo], [Name], [HP], [Attack], [Defense], [SpAtk], [SpDef], [Speed]) VALUES (51, 'Dugtrio', 35, 100, 50, 50, 70, 120)
INSERT [dbo].[PokemonStats] ([PokemonNo], [Name], [HP], [Attack], [Defense], [SpAtk], [SpDef], [Speed]) VALUES (58, 'Growlithe', 55, 70, 45, 70, 50, 60)
INSERT [dbo].[PokemonStats] ([PokemonNo], [Name], [HP], [Attack], [Defense], [SpAtk], [SpDef], [Speed]) VALUES (59, 'Arcanine', 90, 110, 80, 100, 80, 94)
INSERT [dbo].[PokemonStats] ([PokemonNo], [Name], [HP], [Attack], [Defense], [SpAtk], [SpDef], [Speed]) VALUES (64, 'Kadabra', 40, 35, 30, 120, 70, 105)
INSERT [dbo].[PokemonStats] ([PokemonNo], [Name], [HP], [Attack], [Defense], [SpAtk], [SpDef], [Speed]) VALUES (65, 'Alakazam', 55, 50, 40, 135, 95, 120)
INSERT [dbo].[PokemonStats] ([PokemonNo], [Name], [HP], [Attack], [Defense], [SpAtk], [SpDef], [Speed]) VALUES (71, 'Victreebel', 80, 105, 65, 100, 70, 70)
INSERT [dbo].[PokemonStats] ([PokemonNo], [Name], [HP], [Attack], [Defense], [SpAtk], [SpDef], [Speed]) VALUES (74, 'Geodude', 40, 80, 100, 30, 30, 20)
INSERT [dbo].[PokemonStats] ([PokemonNo], [Name], [HP], [Attack], [Defense], [SpAtk], [SpDef], [Speed]) VALUES (77, 'Ponyta', 50, 85, 55, 65, 65, 90)
INSERT [dbo].[PokemonStats] ([PokemonNo], [Name], [HP], [Attack], [Defense], [SpAtk], [SpDef], [Speed]) VALUES (78, 'Rapidash', 65, 100, 70, 80, 80, 105)
INSERT [dbo].[PokemonStats] ([PokemonNo], [Name], [HP], [Attack], [Defense], [SpAtk], [SpDef], [Speed]) VALUES (89, 'Muk', 105, 105, 75, 65, 100, 50)
INSERT [dbo].[PokemonStats] ([PokemonNo], [Name], [HP], [Attack], [Defense], [SpAtk], [SpDef], [Speed]) VALUES (95, 'Onix', 35, 45, 160, 30, 45, 70)
INSERT [dbo].[PokemonStats] ([PokemonNo], [Name], [HP], [Attack], [Defense], [SpAtk], [SpDef], [Speed]) VALUES (100, 'Voltorb', 40, 30, 50, 55, 55, 100)
INSERT [dbo].[PokemonStats] ([PokemonNo], [Name], [HP], [Attack], [Defense], [SpAtk], [SpDef], [Speed]) VALUES (110, 'Weezing', 65, 90, 120, 85, 70, 60)
INSERT [dbo].[PokemonStats] ([PokemonNo], [Name], [HP], [Attack], [Defense], [SpAtk], [SpDef], [Speed]) VALUES (111, 'Rhyhorn', 80, 85, 95, 30, 30, 25)
INSERT [dbo].[PokemonStats] ([PokemonNo], [Name], [HP], [Attack], [Defense], [SpAtk], [SpDef], [Speed]) VALUES (112, 'Rhydon', 105, 130, 120, 45, 45, 40)
INSERT [dbo].[PokemonStats] ([PokemonNo], [Name], [HP], [Attack], [Defense], [SpAtk], [SpDef], [Speed]) VALUES (114, 'Tangela', 65, 55, 115, 100, 40, 60)
INSERT [dbo].[PokemonStats] ([PokemonNo], [Name], [HP], [Attack], [Defense], [SpAtk], [SpDef], [Speed]) VALUES (120, 'Staryu', 30, 45, 55, 70, 55, 85) 
INSERT [dbo].[PokemonStats] ([PokemonNo], [Name], [HP], [Attack], [Defense], [SpAtk], [SpDef], [Speed]) VALUES (121, 'Starmie', 60, 75, 85, 100, 85, 115)
INSERT [dbo].[PokemonStats] ([PokemonNo], [Name], [HP], [Attack], [Defense], [SpAtk], [SpDef], [Speed]) VALUES (122, 'Mr. Mime', 40, 45, 65, 100, 120, 90)
INSERT [dbo].[PokemonStats] ([PokemonNo], [Name], [HP], [Attack], [Defense], [SpAtk], [SpDef], [Speed]) VALUES (144,'Articuno', 90, 85, 100, 95, 125, 85)
INSERT [dbo].[PokemonStats] ([PokemonNo], [Name], [HP], [Attack], [Defense], [SpAtk], [SpDef], [Speed]) VALUES (145, 'Zapdos', 90, 90, 85, 125, 90, 100)
INSERT [dbo].[PokemonStats] ([PokemonNo], [Name], [HP], [Attack], [Defense], [SpAtk], [SpDef], [Speed]) VALUES (146, 'Moltres', 90, 100, 90, 125, 85, 90)
INSERT [dbo].[PokemonStats] ([PokemonNo], [Name], [HP], [Attack], [Defense], [SpAtk], [SpDef], [Speed]) VALUES (150, 'MewTwo', 106, 110, 90, 154, 90, 130)
INSERT [dbo].[PokemonStats] ([PokemonNo], [Name], [HP], [Attack], [Defense], [SpAtk], [SpDef], [Speed]) VALUES (151, 'Mew', 100, 100, 100, 100, 100, 100)
GO




----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 3. Create two views (one must be updatable).
-- First view is just to see the winners of pokemon championships that hail from the country of Japan.
GO
CREATE VIEW JapanWinners AS
SELECT ID, SeniorWinner
FROM ChampionshipWinners
WHERE SeniorWinnerCountry = 'Japan';

-- The second view, which is updatable, pulls pokemon cards that can be pricey. 
GO
CREATE VIEW PriceyCards
AS
SELECT PokemonNo, Name, MostExpensive, LeastExpensive
FROM CardPrice
WHERE MostExpensive - LeastExpensive > 100
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 4. Write two Stored Procedures based on spInvTotal1 & spInvTotal3 examples with your database (must run using EXEC statement and produce valid output using PRINT statement).
-- shout out to this site for better explaining this i was very confused : https://www.w3schools.com/sql/sql_stored_procedures.asp the way it formatted it made more sense to me than the textbook
GO
CREATE PROC spPokemonCardPrice1 @PokemonNumber INT, @MostExpensive SMALLMONEY OUTPUT
AS
SELECT @MostExpensive = MAX(MostExpensive) FROM CardPrice
WHERE PokemonNo = @PokemonNumber;

-- now to test spPokemonCardPrice1
GO
DECLARE @MostExpensive SMALLMONEY;
EXEC spPokemonCardPrice1 1, @MostExpensive OUTPUT;  ------ If you change out the number it shows that there are different prices
Print 'Most Expensive Pokemon Card Cost: ' + CONVERT(varchar, @MostExpensive);


-- setting up sp3
GO
CREATE PROC spPokemonCardPrice3
@PokemonNo INT,
@MostExpensive SMALLMONEY = NULL,
@LeastExpensive SMALLMONEY OUTPUT
AS
IF @MostExpensive = NULL 
SELECT @MostExpensive = MAX(MostExpensive) FROM CardPrice;

SELECT @LeastExpensive = MIN(LeastExpensive)
FROM CardPrice JOIN PokemonType ON CardPrice.PokemonNo = PokemonType.PokemonNo
WHERE (CardPrice.PokemonNo LIKE @PokemonNo) AND (LeastExpensive >= @LeastExpensive);


-- now to test spPokemonCardPrice3
GO
DECLARE @LeastExpensive SMALLMONEY;
--EXEC spPokemonCardPrice3 '1', '800.00', @LeastExpensive OUTPUT;
EXEC @LeastExpensive = spPokemonCardPrice3 1, 1.00, @LeastExpensive OUTPUT;
PRINT 'My Card Price: ' + CONVERT(varchar, @LeastExpensive);


/*
WHY DOES THIS WORK

USE AP;
GO
CREATE PROC spInvTotal3
@InvTotal money OUTPUT,
@DateVar date = NULL,
@VendorVar varchar(40) = '%'
AS
IF @DateVar = NULL
SELECT @DateVar = MIN (InvoiceDate) FROM Invoices;

SELECT @InvTotal = SUM (InvoiceTotal)
FROM Invoices JOIN Vendors
ON Invoices.VendorID = Vendors.VendorID
WHERE (InvoiceDate >= @DateVar) AND (VendorName LIKE @VendorVar);

DECLARE @MyInvTotal money;
EXEC spInvTotal3 @MyInvTotal OUTPUT, '2020-01-01', 'R%';
PRINT 'Haha: ' + CONVERT(varchar, @MyInvTotal);
--------------------------------------------------------------------------

BUT THIS DOESN'T  IT IS VERBATIM, I MATCHED EACH WITH, LOOK INTO THIS ON WINTER BREAK

GO
CREATE PROC spPokemonCardPrice3
@PokemonNo INT,
@MostExpensive SMALLMONEY = NULL,
@LeastExpensive SMALLMONEY OUTPUT
AS
IF @MostExpensive = NULL 
SELECT @MostExpensive = MAX(MostExpensive) FROM CardPrice;

SELECT @LeastExpensive = MIN(LeastExpensive)
FROM CardPrice JOIN PokemonType ON CardPrice.PokemonNo = PokemonType.PokemonNo
WHERE (CardPrice.PokemonNo LIKE @PokemonNo) AND (LeastExpensive >= @LeastExpensive);  


GO
DECLARE @LeastExpensive SMALLMONEY;
EXEC spPokemonCardPrice3 '1', '800.00', @LeastExpensive OUTPUT;
PRINT 'My Card Price: ' + CONVERT(varchar, @LeastExpensive);


IT DOESN'T HELP THAT THE EXEC IS FOR A DIFFERENT SP ON ANOTHER PAGE, RESEARCH MORE
*/


-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 5. Write two trigger based on examples on P495 & P497.

-- p.495
GO
CREATE TRIGGER ChampionshipWinners_INSERT_UPDATE
ON ChampionshipWinners
AFTER INSERT, UPDATE
AS
UPDATE ChampionshipWinners
SET StateHeld = UPPER(StateHeld)
WHERE ID IN (SELECT ID FROM Inserted);

-- p.497 an AFTER trigger that archives deleted data (and our second table!)
GO
CREATE TRIGGER Pokemon_DELETE
	ON PokemonType
	AFTER DELETE
AS
INSERT INTO PokemonArchive
	(PokemonNo, Name, Type1, Type2, GenerationVariations, NewType)
	SELECT PokemonNo, Name, Type1, Type2, GenerationVariations, NewType
	FROM Deleted

DELETE PokemonType
WHERE PokemonNo = 786

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
